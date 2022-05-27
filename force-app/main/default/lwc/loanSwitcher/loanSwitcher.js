/**
 * Created by Ethan Sargent on 29/07/2021.
 */

import {LightningElement, track, api} from 'lwc';
import getLoans from '@salesforce/apex/CustomerPortalController.getLoans';
import {NavigationMixin} from "lightning/navigation";
import {portalHelper} from "c/portalHelper";



const previewApiNameFilter = [
    "loan__Next_Installment_Date__c",
    "Current_Loan_Balance_Excluding_Deposit__c"
];

export default class LoanSwitcher extends NavigationMixin(LightningElement)
{

    // ----- Tracked/API variables -----

    @track loansGroupedByAccount = [];

    // ----- Class variables -----

    loans;

    loanFields = previewApiNameFilter;

    loansRetrieved = false;

    recordId;

    // ----- Wires -----

    // ----- Setup / Teardown -----
    async connectedCallback()
    {
        let params = this.getQueryParameters();
        this.recordId = params.accountId;
        let request = this.buildRequest();
        console.log(JSON.stringify(request));
        this.loans = await getLoans(request);

        console.log(JSON.stringify(this.loans));
        this.processLoans();
    }


    // ----- Setup Helpers -----

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

    buildRequest()
    {
        return {request : {
                requestedAccountId: this.recordId
            }}
    }

    processLoans()
    {
        let loans = {}
        this.loans.forEach(loan =>
        {
            const accountId = loan.accountId;
            const accountName = loan.accountName;
            const partyType = loan.partyType;
            let list = loans[accountId]?.loans;
            if (!list)
            {
                list = [];
                loans[accountId] = {
                    loans : list,
                    accountName,
                    partyType
                };
            }
            console.log(JSON.stringify(loan));
            let newLoan = {
                fields:  portalHelper.processFieldsFromFilter(loan, this.loanFields),
                recordId: loan.recordId,
                name: loan.fields.Name.value
            }
            list.push(newLoan);
        })
        let displayLoans = []
        for (const key in loans)
        {
            let loanGroup =
                {
                    loans: loans[key].loans,
                    partyType: loans[key].partyType,
                    accountName: loans[key].accountName,
                    accountId: key
                }
                displayLoans.push(loanGroup);
        }
        this.loansGroupedByAccount = displayLoans;
        console.log(JSON.stringify(this.loansGroupedByAccount));
        this.loansRetrieved = true;
    }



    // ----- Event Handlers -----

    viewLoan(e)
    {
        e.preventDefault();
        e.stopPropagation();

        this.navigateToMyLoan(e.currentTarget.dataset.loanId);
    }

    // ----- Helper Functions -----

    navigateToMyLoan(recordId) {
        this[NavigationMixin.GenerateUrl]({
            type: 'comm__namedPage',
            attributes: {
                name: 'CL_Contract_Detail__c'
            },
            state: {
                recordId: recordId
            }
        }).then( url =>
            window.open(url, "_self")
        );

    }
}