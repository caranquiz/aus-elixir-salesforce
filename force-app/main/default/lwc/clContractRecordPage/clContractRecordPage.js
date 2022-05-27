/**
 * Created by Ethan Sargent on 8/07/2021.
 */

import {LightningElement, track} from 'lwc';
import getLoanAccountData from '@salesforce/apex/CustomerPortalController.getLoanAccountDetails'
import getTransactionHistory from '@salesforce/apex/CustomerPortalController.getTransactionHistory'
import getDirectDebitInformation from '@salesforce/apex/CustomerPortalController.getDirectDebitInformation'
import getStatementInfo from '@salesforce/apex/CustomerPortalController.getStatementDetails'
// import getStatementData from '@salesforce/apex/CustomerPortalController.getStatementFile'
import {ShowToastEvent} from "lightning/platformShowToastEvent";

import {portalHelper} from "c/portalHelper";
import {downloadJs} from "c/downloadJs";


// NOT used for security. Only used to control system-fields for conditional formatting vs
// the fields we actually want to display on the page.
const fieldApiNameFilter = [
    "Name",
    "loan__Next_Installment_Date__c",
    "loan__Pmt_Amt_Cur__c",
    "Current_Loan_Balance_Excluding_Deposit__c",
    "loan__Interest_Rate__c",
    "loan__Delinquent_Amount__c",
    "clcommon__Current_Deposit_Amount__c",
    "loan__Disbursal_Date__c",
    "loan__Maturity_Date_Current__c",
    "loan__Loan_Amount__c"
];

const summaryApiNameFilter = [
    "Current_Loan_Balance_Excluding_Deposit__c",
    "loan__Next_Installment_Date__c",
    "loan__Pmt_Amt_Cur__c"
];

const transactionHistoryFilter =
    [
        'loan__Transaction_Date__c',
        'Transaction_Type__c',
        'Debit__c',
        'Credit__c',
        'loan__Consolidated_Loan_Balance__c'
    ]

const paymentFilter =
    [
        'loan__Transaction_Date__c',
        'loan__Transaction_Amount__c'
    ]

const directDebitFields =
    [
        'loan__Type__c',
        'loan__Amount_Type__c',
        'loan__Transaction_Amount__c',
        'loan__Frequency__c',
        'loan__Debit_Date__c'
    ]

const statementFields =
    [
        'Name'
    ]

export default class ClContractRecordPage extends LightningElement
{

    // ----- INPUT/OUTPUT VARIABLES -----

    // ----- TRACKED VARIABLES -----

    @track
    loanAccount;

    remainingIoPeriod;

    loanAccountTitle = "Loan Account ";

    @track
    showSearchSpinner = false;

    defaultStartDate;
    defaultEndDate = new Date().toISOString();

    // @track
    // loanAccountSummaryFields = [];

    @track
    displayFields = [];

    @track displayTransactions = {
        transactionHistory: [],
        unclearedPayments: [],
        dishonouredPayments: [],
        key: 'displayTransactionsData'
    };

    directDebitInformation;
    @track displayDirectDebitInfo = {
        ddInfo: [],
        key: 'displayDirectDebitInfoKey'
    };

    // contains defaults for selected tabs
    @track
    tabStatus = {
        transactionHistory: true,
        redrawRequest: false,
        directDebit: false,
        statements: false,
        details: false
    }


    @track
    transactionHistory = [];

    @track
    dataPopulated = false;


    statementDetails = [];

    @track
    displayStatementDetails;
    

    // ----- CLASS VARIABLES, GETTERS AND SETTERS -----
    recordId;

    lastSelectedTab = 'transactionHistory';

    redrawAllowed = true;

    reloadingView = false;

    get detailsSelected()
    {
        return this.tabStatus.details;
    }

    get transactionHistorySelected()
    {
        return this.tabStatus.transactionHistory;
    }

    get redrawRequestSelected()
    {
        return this.tabStatus.redrawRequest;
    }

    get directDebitSelected()
    {
        return this.tabStatus.directDebit;
    }

    get statementsSelected()
    {
        return this.tabStatus.statements;
    }

    // ----- Connected/RenderedCallbacks

    async connectedCallback()
    {
        let params = this.getQueryParameters();
        this.recordId = params.recordId;
        let request = {
            request: {
                loanAccountId: this.recordId
            }
        };
        let accountDataPromise = this.fetchLoanAccountData(request);
        let transactionDataPromise = this.fetchTransactionHistory(request);
        let directDebitDataPromise = this.fetchDirectDebitInfo(request);
        let statementDetailsPromise = this.fetchStatementInfo(request);
        let dataRequests = [accountDataPromise, transactionDataPromise, directDebitDataPromise, statementDetailsPromise];
        Promise.all(dataRequests).then(() =>
        {
            this.dataPopulated = true
        });
    }

    async fetchLoanAccountData(request)
    {
        this.loanAccount = await getLoanAccountData(request);
        //console.log('Loan Account:' + JSON.stringify(this.loanAccount));
        this.handleLoanAccountRetrieved(this.loanAccount);
    }

    async fetchTransactionHistory(request)
    {
        this.transactionHistory = await getTransactionHistory(request)
        //console.log('transaction History:' + JSON.stringify(this.transactionHistory));
        this.handleTransactionsRetrieved(this.transactionHistory);
    }

    async fetchDirectDebitInfo(request)
    {
        //console.log('>> fetchDirectDebitInfo(' + JSON.stringify(request) + ')');
        this.directDebitInformation = await getDirectDebitInformation(request);
        //console.log('Direct Debit info: ' + JSON.stringify(this.directDebitInformation));
        this.handleDirectDebitInformationReceived(this.directDebitInformation);
        //console.log('<< fetchDirectDebitInfo')
    }

    async fetchStatementInfo(request)
    {
        this.statementDetails = await getStatementInfo(request);
        //console.log('Statement info: ' + JSON.stringify(this.statementDetails));
        this.handleStatementInfoReceived(this.statementDetails);
    }

    renderedCallback()
    {
        //console.log('rerendered');
    }

    getQueryParameters()
    {

        let params = {};
        let search = window.location.search.substring(1);

        if (search)
        {
            params = JSON.parse('{"' + decodeURI(search).replace(/"/g, '\\"').replace(/&/g, '","').replace(/=/g, '":"') + '"}')
        }

        return params;
    }

    // ----- Conditional Formatting Functionality -----

    // Maps API Names to conditional functions to be evaluated as a group.
    fieldConditions = {
        'loan__Pmt_Amt_Cur__c': this.minimumPaymentDisplayCondition,
        'clcommon__Current_Deposit_Amount__c': this.currentDepositAmountDisplayCondition,
        'loan__Delinquent_Amount__c': this.arrearsDisplayCondition,
    }


    minimumPaymentDisplayCondition(loanAccount)
    {
        return loanAccount.fields.Remaining_IO_Period__c?.value === '0';
    }

    currentDepositAmountDisplayCondition(loanAccount)
    {
        let displayRedrawField;


        let restrictRedraw = loanAccount.fields.Restrict_Redraw__c?.value.toLowerCase() === "false";
        let contractStatus = loanAccount.fields?.loan__Loan_Status__c?.value === 'Active - Good Standing'
        let redrawValue = parseFloat(loanAccount.fields.clcommon__Current_Deposit_Amount__c?.rawValue) > 5;
        displayRedrawField = restrictRedraw && contractStatus && redrawValue;
        return displayRedrawField;
    }

    arrearsDisplayCondition(loanAccount)
    {
        let delinquentAmountNumber = portalHelper.getNumberFromCurrencyString(loanAccount?.fields?.loan__Delinquent_Amount__c?.value);
        return delinquentAmountNumber > 5;
    }

    evaluateEnabledFunctionality()
    {
        let restrictRedraw = this.loanAccount.fields.Restrict_Redraw__c?.value.toLowerCase() === "false";
        let redrawValue = parseFloat(this.loanAccount.fields.clcommon__Current_Deposit_Amount__c?.rawValue) > 5;
        let contractStatus = this.loanAccount.fields.loan__Loan_Status__c?.value === 'Active - Good Standing'
        this.redrawAllowed = restrictRedraw && contractStatus && redrawValue;
    }

    // ----- Data retrieval handlers ------

    handleLoanAccountRetrieved()
    {
        this.populateHeaders();
        this.populateDefaults();
        this.evaluateEnabledFunctionality();
        //console.log('evaluating fields');
        this.displayFields = portalHelper.processFieldsFromFilter(this.loanAccount, fieldApiNameFilter, {
            conditions: this.fieldConditions,
            context: this
        });
        //console.log(JSON.stringify(this.displayFields));

        this.remainingIoPeriod = this.loanAccount.fields?.Remaining_IO_Period__c?.value;
    }

    populateHeaders()
    {
        this.loanAccountTitle += this.loanAccount.fields.Name.value;
    }

    populateDefaults()
    {
        this.defaultStartDate = this.loanAccount.fields.loan__Disbursal_Date__c.value;
    }

    handleTransactionsRetrieved(transactionHistory)
    {
        let myDisplayTransactions = {};

        myDisplayTransactions.transactionHistory = this.processTransactionHistories(transactionHistory.transactionHistory, transactionHistoryFilter);
        myDisplayTransactions.unclearedPayments = this.processTransactionHistories(transactionHistory.unclearedPayments, paymentFilter);
        myDisplayTransactions.dishonouredPayments = this.processTransactionHistories(transactionHistory.dishonouredPayments, paymentFilter);
        myDisplayTransactions.key = this.displayTransactions.key;
        this.displayTransactions = myDisplayTransactions;
        //console.log('displayTransactions: ' + JSON.stringify(this.displayTransactions));
    }

    processTransactionHistories(transactions, filter)
    {
        let tableFieldList = [];
        transactions.forEach(transaction =>
        {
            let fieldList = portalHelper.processFieldsFromFilter({fields: transaction}, filter);
            tableFieldList.push({fields: fieldList});
        });
        return tableFieldList;
    }

    processTableFields(tableEntries, filter)
    {
        let tableFieldList = [];
        tableEntries.forEach(tableEntry =>
        {
            let fieldList = portalHelper.processFieldsFromFilter(tableEntry, filter);
            tableFieldList.push({
                fields: fieldList,
                recordId: tableEntry.recordId,
                loanAccountId: tableEntry.loanAccountId
            });
        });
        return tableFieldList;
    }

    processDirectDebitFields(tableEntries, filter)
    {
        let tableFieldList = [];
        tableEntries.forEach(paymentInfo =>
        {
            let restrictEdit = this.evalRestrictDDEdit(paymentInfo);
            let restrictDelete = this.evalRestrictDDDelete(paymentInfo)
            let additionalConditions = this.evalAdditionalDDConditions(paymentInfo);
            //console.log('conditions in builder: ' + JSON.stringify(additionalConditions));
            let fieldList = portalHelper.processFieldsFromFilter(paymentInfo, filter);
            tableFieldList.push({
                fields: fieldList,
                recordId: paymentInfo.recordId,
                loanAccountId: paymentInfo.loanAccountId,
                restrictEdit,
                restrictDelete,
                additionalConditions: JSON.stringify(additionalConditions)
            });
        });
        return tableFieldList;
    }

    evalRestrictDDEdit(paymentInfo)
    {
        let isRecurring = paymentInfo.fields?.loan__Type__c?.value.toLowerCase() === 'recurring';
        let remainingIO = paymentInfo.remainingIoPeriod > 0;
        return remainingIO && isRecurring;
    }

    evalRestrictDDDelete(paymentInfo)
    {
        //console.log(JSON.stringify(paymentInfo.fields.loan__Type__c));
        let isRecurring = paymentInfo.fields?.loan__Type__c?.value.toLowerCase() === 'recurring';
        let remainingIO = paymentInfo.remainingIoPeriod > 0;
        return remainingIO && isRecurring;
    }

    evalAdditionalDDConditions(paymentInfo)
    {
        return {
            remainingIoGreaterThanZero: paymentInfo.remainingIoPeriod > 0,
            isRecurring: paymentInfo.fields?.loan__Type__c?.value.toLowerCase() === 'recurring'
        }
    }

    handleDirectDebitInformationReceived(directDebitInfo)
    {
        //console.log('processing direct debit info');
        let myDisplayDirectDebitInfo = {};
        myDisplayDirectDebitInfo.key = this.displayDirectDebitInfo.key;

        directDebitInfo.forEach(ddInfo =>
        {
            let newFields = {};
            for (let key in ddInfo.fields)
            {
                let field = Object.assign({}, ddInfo.fields[key]);
                if (field.fieldType === 'string')
                {
                    field.value = portalHelper.toTitleCase(field.value);
                }
                newFields[key] = field;
            }
            ddInfo.fields = newFields;
        })
        myDisplayDirectDebitInfo.ddInfo = this.processDirectDebitFields(directDebitInfo, directDebitFields);

        this.displayDirectDebitInfo = myDisplayDirectDebitInfo;
        //console.log('displayDirectDebitInfo = ' + JSON.stringify(this.displayDirectDebitInfo));
    }

    handleStatementInfoReceived(statementDetails)
    {
        //console.log('processing statement info');
        let statementTableRows = this.processTableFields(statementDetails, statementFields);let currentUrl = window.location.href;
        let statementUrl = currentUrl.replace(/ordeportal\/s\/.*/, 'ordeportal/sfc/servlet.shepherd/document/download/');

        statementTableRows.forEach(tableRow =>
        {
            tableRow.downloadUrl = statementUrl + tableRow.recordId;
        })
        this.displayStatementDetails = statementTableRows;

    }


// ---- EVENT HANDLERS -----

    handleTabChange(e)
    {
        let tab = e.currentTarget.value;
        if (tab === this.lastSelectedTab) return;
        //console.log('tab = ' + tab);

        let newTab = this.template.querySelector('.tab-button[value="' + tab + '"]');
        let oldTab = this.template.querySelector('.tab-button[value="' + this.lastSelectedTab + '"]');

        if (newTab && oldTab)
        {
            oldTab.classList.remove('selected-tab');
            oldTab.classList.add('orde-border-bottom');
            newTab.classList.add('selected-tab');
            newTab.classList.remove('orde-border-bottom');
        }

        this.tabStatus[tab] = true;
        this.tabStatus[this.lastSelectedTab] = false;
        this.lastSelectedTab = tab;

    }

    handleMouseInput(e)
    {
        e.preventDefault();
    }

    async handleTransactionSearch(e)
    {
        this.showSearchSpinner = true;
        //console.log('search event received')
        let request =
            {
                request: {
                    loanAccountId: this.recordId,
                    startDate: e.detail.startDate,
                    endDate: e.detail.endDate
                }
            };
        //console.log(JSON.stringify(request));
        this.transactionHistory = await getTransactionHistory(request)
        //console.log(JSON.stringify(this.transactionHistory));
        this.handleTransactionsRetrieved(this.transactionHistory);
        this.showSearchSpinner = false;
    }

    handleUploadFinished(e)
    {
        this.uploadFinished = true;
        this.dispatchEvent(new ShowToastEvent({
            "title": "Success!",
            "variant": 'success',
            "message": "Success! Your redraw request was successfully uploaded. The team will reach out within a couple of days."
        }));
    }

    async handleStatementDownloadRequest(e)
    {
        // let statementId = e.detail.statementId;
        // //console.log('ContentDocumentId:' + statementId);
        // let request = {
        //     request: {
        //         loanAccountId: this.recordId,
        //         statementId: statementId
        //     }
        // }
        // // let statementData = await getStatementData(request);
        // // let fileName = statementData[0];
        // // let fileData = statementData[1];
        // // let dataUrl = this.createDataUrl(fileData);
        // // //console.log(dataUrl);
        //
        // // let element = document.createElement('a');
        // // a.href = dataUrl;
        // // a.download = 'Statement ' + this.loanAccount.fields.Name.value;
        // // document.body.appendChild(element);
        // // element.click();
        // // document.body.removeChild(element)
        // let currentUrl = window.location.href;
        // let statementUrl = currentUrl.replace(/ordeportal\/s\/.*/, 'ordeportal/sfc/servlet.shepherd/document/download/' + statementData[1]);
        // let a = document.createElement("a");
        // a.href = statementUrl;
        // a.target = '_blank';
        // document.body.appendChild(a);
        // a.click();
        // setTimeout(function ()
        // {
        //     document.body.removeChild(a);
        //     // window.URL.revokeObjectURL(url);
        // }, 0);

    }

    createDataUrl(base64Data)
    {
        return 'data:application/octet-stream;base64,' + base64Data;
    }

    async refreshDirectDebitInformation()
    {
        //console.log('Reloading dd Info');
        this.reloadingView = true;
        let request = {
            request: {
                loanAccountId: this.recordId
            }
        };
        await this.fetchDirectDebitInfo(request);
        this.reloadingView = false;
    }

}