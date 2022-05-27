/**
 * Created by Ethan Sargent on 11/08/2021.
 */

import {LightningElement, track, api} from 'lwc';

import manageDirectDebits from '@salesforce/apex/CustomerPortalController.manageDirectDebitInfo'
import getNumActiveRecurringDirectDebits
    from '@salesforce/apex/CustomerPortalController.getNumActiveRecurringDirectDebits'


import newTemplate from './newTemplate.html'
import deleteTemplate from './deleteTemplate.html'
import editTemplate from './editTemplate.html'

const MODE = {};

export default class ClDirectDebitManager extends LightningElement
{

    // ----- API/Tracked variables -----

    directDebitTypeOptionsValues = ['Recurring', 'One Time'];
    frequencyOptionsValues = ["Weekly", "Bi-Weekly", "Monthly"];
    amountTypeOptionsValues = ['Fixed Amount', 'Current Payment Amount'];

    get directDebitTypeOptions()
    {
        let result = this.generatePicklistOptions(this.directDebitTypeOptionsValues);
        console.log(JSON.stringify(result));
        return result;
    }

    get amountTypeOptions()
    {
        return this.generatePicklistOptions(this.amountTypeOptionsValues);
    }

    get frequencyOptions()
    {
        return this.generatePicklistOptions(this.frequencyOptionsValues);
    }

    selectedFields = []

    @track
    buttonProgressCounter = 1;

    get showBack()
    {
        return this.buttonProgressCounter > 1;
    }

    get showNext()
    {
        return (this.buttonProgressCounter < 3 && this.showAmountType) || (!this.showAmountType && this.buttonProgressCounter < 2);
    }

    get showSubmit()
    {
        return this.buttonProgressCounter >= 3 || (!this.showAmountType && this.buttonProgressCounter >= 2);
    }

    get formPageOne()
    {
        return this.buttonProgressCounter === 1;
    }

    get formPageTwo()
    {
        let amountType = this.showAmountType
        return (amountType) && this.buttonProgressCounter === 2;
    }

    get formPageThree()
    {
        let skipPageTwo = !this.showAmountType;
        return (this.buttonProgressCounter === 3 || this.buttonProgressCounter === 2 && skipPageTwo);
    }

    get showAmountType()
    {
        return (this.directDebitType === 'Recurring');
    }

    get showTransactionAmount()
    {
        return this.directDebitType === 'One Time' || this.directDebitType === 'Recurring' && this.amountType === 'Fixed Amount';
    }

    get showFrequency()
    {
        return this.directDebitType === 'Recurring';
    }

    get today()
    {
        let today = new Date();
        return today.toISOString();
    }


    toTitleCase(str)
    {
        let upper = true
        let newStr = ""
        if (!str) return str;
        for (let i = 0, l = str.length; i < l; i++)
        {
            // Note that you can also check for all kinds of spaces  with
            // str[i].match(/\s/)
            if (str[i] == " " || str[i] == "-")
            {
                upper = true
                newStr += str[i]
                continue
            }
            newStr += upper ? str[i].toUpperCase() : str[i].toLowerCase()
            upper = false
        }
        return newStr
    }


    @api
    loanAccountId;
    @api
    recordId;

    @api
    isDelete = false;

    @api
    directDebitType;
    @api
    amountType;
    @api
    debitDate;
    @api
    transactionAmount;
    @api
    frequency;

    @api
    set conditionInformation(v)
    {
        let conditions = {};
        if (v.remainingIoGreaterThanZero && v.isRecurring)
        {
            conditions.remainingIORestriction = true;
        }
        this.conditions = conditions;
    }
    get conditionInformation()
    {
        return this.conditions;
    }


    @track
    conditions;

    // ----- Class variables -----

    requestInProgress = false;

    // ----- Wires -----

    // ----- Setup / Teardown -----

    get currentMode()
    {
        if (this.recordId && !this.isDelete) return 'edit';
        if(this.recordId && this.isDelete) return 'delete';
        if(!this.recordId && !this.isDelete) return 'new';
    }



    connectedCallback()
    {
        this.directDebitType = this.toTitleCase(this.directDebitType);
        this.amountType = this.toTitleCase(this.amountType)
        this.frequency = this.toTitleCase(this.frequency);
        console.log('recordId: ' + this.recordId)
        console.log('loanAccountId: ' + this.loanAccountId)
        console.log('isDelete: ' + this.isDelete)
        console.log('directDebitType: ' + this.directDebitType)
        console.log('debitDate: ' + this.debitDate)
        console.log('transactionAmount: ' + this.transactionAmount)
        console.log('amountType: ' + this.amountType)
        console.log('frequency: ' + this.frequency)
        console.log('transactionAmount: ' + this.transactionAmount)

    }

    applyConditions(conditions)
    {

    }

    renderedCallback()
    {

    }

    get cardTitle()
    {
        if (this.recordId) return 'Edit Payment Setup Information'
        else return 'Create new Payment Plan'
    }

    render()
    {
        switch (this.currentMode)
        {
            case 'delete':
                return deleteTemplate;

            case 'edit':
                return editTemplate;

            case 'new':
                return newTemplate;
        }
    }

    // ----- Setup Helpers -----

    generatePicklistOptions(array)
    {
        return array.reduce((o, element) => ([...o, {label: element, value: element}]), []);
    }

    // ----- Event Handlers -----

    handleInputChange(e)
    {
        let newValue = e.detail.value;
        let fieldName = e.currentTarget.name;
        this[fieldName] = newValue;
        this.selectedFields[fieldName] = true;
        e.currentTarget.reportValidity();
    }

    handleDebitDateChange(e)
    {
        let inputCmp = e.currentTarget;

        let newValue = e.detail.value;
        let newValDayOfWeek = new Date(newValue).getDay();
        if (newValDayOfWeek === 0 || newValDayOfWeek === 6)
        {
            inputCmp.setCustomValidity("Debit date cannot be a weekend. Please select a weekday that is later than today.");
            inputCmp.reportValidity();
            return;
        } else
        {
            inputCmp.setCustomValidity("");
            inputCmp.reportValidity();
        }
        let fieldName = e.currentTarget.name;
        this[fieldName] = newValue;
        this.selectedFields[fieldName] = true;
    }

    handleSubmit()
    {
        let valid = this.checkCurrentFormValidity();
        if (valid)
        {
            this.buttonError = '';
            let promise = this.sendDirectDebitRequest();
        } else
        {
            this.buttonError = 'Please resolve the above to continue';
        }
    }

    async sendDirectDebitRequest()
    {
        let request = this.buildDirectDebitRequest();
        await this.sendRequest(request);
    }

    handleNext()
    {
        let valid = this.checkCurrentFormValidity();
        if (valid)
        {
            this.buttonError = '';
            this.buttonProgressCounter = this.buttonProgressCounter + 1;
        } else
        {
            this.buttonError = 'Please resolve the above to continue';
        }
    }

    buttonError;

    checkCurrentFormValidity()
    {
        return [...this.template.querySelectorAll('.direct-debit-input')]
            .reduce((validSoFar, inputCmp) =>
            {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
    }

    handleBack()
    {
        this.buttonProgressCounter = this.buttonProgressCounter - 1;
    }

    handleDelete()
    {
        let promise = this.sendDeleteRequest()
    }

    async sendDeleteRequest()
    {
        let deleteRequest = this.buildDeleteRequest();
        await this.sendRequest(deleteRequest);
    }

    async sendRequest(deleteRequest)
    {
        this.requestInProgress = true;
        console.log(JSON.stringify(deleteRequest));
        let deleteResult;
        try
        {
            deleteResult = await manageDirectDebits(deleteRequest);
        } catch (e)
        {
            console.dir(e)
            this.buttonError = e.body.message;
        }
        if (deleteResult)
        {
            this.sendCloseEvent();
        }

        this.requestInProgress = false;

        console.log('Result: ' + JSON.stringify(deleteResult));
    }

    handleCancel()
    {
        this.sendCancelEvent();
    }

    sendCloseEvent()
    {
        this.dispatchEvent(new CustomEvent('flowsuccess'));
    }

    sendCancelEvent()
    {
        this.dispatchEvent(new CustomEvent('flowcancel'))
    }

    // ----- Helper Functions -----

    buildDeleteRequest()
    {
        return {
            request:
                {
                    isDelete: this.isDelete,
                    recordId: this.recordId
                }
        }
    }

    // validateCreateEdit()
    // {
    //     this.validateDebitDate();
    //     this.validateMinimumPayment();
    //     this.validate
    // }

    // async validateDelete()
    // {
    //     return await this.validateActiveRecurring();
    // }
    //
    // async validateActiveRecurring()
    // {
    //     let numActiveRecurring = await getNumActiveRecurringDirectDebits();
    //     if (numActiveRecurring === -1) return false;
    // }

    buildDirectDebitRequest()
    {
        let frequency = this.showFrequency ? this.frequency : null;
        let amountType = this.showAmountType ? this.amountType : null;
        let transactionAmount = this.showTransactionAmount ? this.transactionAmount : null;
        let isDelete = this.isDelete;

        return {
            request:
                {
                    recordId: this.recordId,
                    loanAccountId: this.loanAccountId,
                    isDelete: isDelete,
                    directDebitType: this.directDebitType,
                    amountType: amountType,
                    debitDate: this.debitDate,
                    transactionAmount: transactionAmount,
                    frequency: frequency
                }
        }
    }


}