/**
 * Created by Ethan Sargent on 3/08/2021.
 */

import {LightningElement, track, api} from 'lwc';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import {portalHelper} from "c/portalHelper";

const directDebitDetails = [
    "Type",
    "Amount Type",
    "Transaction Amount",
    "Frequency",
    'Debit Date'
]

export default class ClDirectDebitView extends LightningElement
{

    // ----- API/Tracked variables -----
    _directDebitDetails = {heading: "Payment Setup", headers: directDebitDetails, body: []};
    @api
    set directDebitDetails(v)
    {
        this.buildTableInfo(v);
    }

    get directDebitDetails()
    {
        return this._directDebitDetails;
    }

    buildTableInfo(body)
    {
        this.directDebitTableInfo = {heading: "Payment Setup", headers: directDebitDetails, body: body};
    }


    @track
    directDebitTableInfo;

    @api
    directDebitFieldMap;

    @api
    loanAccountId;

    showEdit = false;
    showDelete = false;
    showNew = false;

    recordId;
    // additionalConditions;

    isDelete;
    directDebitType;
    amountType;
    debitDate;
    transactionAmount;
    frequency;
    // ----- Class variables -----


    // ----- Wires -----

    // ----- Setup / Teardown -----
    connectedCallback()
    {
        console.log('fieldMap: ' + JSON.stringify(this.directDebitFieldMap));
    }


    renderedCallback()
    {

    }


    // ----- Setup Helpers -----

    resetConditions()
    {
        this.additionalConditions.remainingIoGreaterThanZero = parseInt(this.loanRemainingIo) > 0;
        this.additionalConditions.isRecurring = false;
    }

    // ----- Event Handlers -----


    handleRecordEdit(e)
    {
        this.resetConditions();
        this.showEdit = true;
        this.isDelete = false;

        this.mapDirectDebitFields(e.detail);
    }

    handleRecordDelete(e)
    {
        this.resetConditions();
        this.showDelete = true;
        this.isDelete = true;
        this.mapDirectDebitFields(e.detail);
    }

    handleCreateNew()
    {
        this.resetConditions();
        console.log(JSON.stringify(this.additionalConditions))
        this.showDelete = false;
        this.isDelete = false;
        this.showNew = true;
    }

    get isModalActive()
    {
        return this.showNew || this.showDelete || this.showEdit
    }

    quitModalOnEscape(e)
    {
        if (this.isModalActive && e.keyCode == 27)
        {
            this.handleCancel();
        }
    }

    @api
    loanRemainingIo;

    get remainingIoGreaterThanZero()
    {
        if (!this.loanRemainingIo) return false;
        return parseInt(this.loanRemainingIo) > 0;
    }

    get newButtonText()
    {
        if (this.remainingIoGreaterThanZero) return 'Create new One Time Payment'
        else return 'Create new Payment Plan'
    }

    additionalConditions = {};

    isRecurring;

    handleCancel()
    {
        this.handleCancelDelete();
        this.handleCancelEdit();
        this.handleCancelNew();
    }

    mapDirectDebitFields(details)
    {
        console.log(JSON.stringify(details));
        for (let key in details)
        {
            this[key] = details[key];
        }
        let directDebit;
        this.directDebitFieldMap.forEach(ddInfo =>
        {
            if (ddInfo.recordId === this.recordId)
            {
                directDebit = ddInfo;
            }
        })

        this.directDebitType = directDebit.fields.loan__Type__c?.value;
        this.amountType = directDebit.fields.loan__Amount_Type__c?.value;
        this.debitDate = directDebit.fields.loan__Debit_Date__c?.value;
        this.frequency = directDebit.fields.loan__Frequency__c?.value;
        // this.conditionInformation = directDebit.additionalConditions;
        this.transactionAmount = directDebit.fields.loan__Transaction_Amount__c?.value;
        if (this.transactionAmount && this.transactionAmount !== "-")
        {
            this.transactionAmount = portalHelper.getNumberFromCurrencyString(this.transactionAmount);
        }
    }

    handleCancelEdit()
    {
        this.showEdit = false;
    }

    handleCancelDelete()
    {
        this.showDelete = false;
    }

    handleCancelNew()
    {
        this.showNew = false;
    }

    handleSuccess()
    {
        this.showNew = false;
        this.showDelete = false;
        this.showEdit = false;
        this.dispatchEvent(new CustomEvent('refreshdirectdebitinfo'));
    }

    // ----- Helper Functions -----

}