/**
 * Created by Ethan Sargent on 22/07/2021.
 */

import {api, LightningElement, track} from 'lwc';
const paymentFields =
    [
        'Date',
        'Transaction Amount'
    ];

const transactionFields =
    [
        'Date',
        'Transaction Type',
        'Debit',
        'Credit',
        'Loan Balance'
    ]

const fieldNameMap = [
    {loan__Transaction_Date__c: 'Date'},
    {Transaction_Type__c: 'Transaction Type'},
    {Debit__c: 'Debit'},
    {Credit__c: 'Credit'},
    {loan__Consolidated_Loan_Balance__c: 'Loan Balance'},
    {Transaction_Amount__c : 'Transaction Amount'}
];

export default class ClTransactionHistory extends LightningElement
{

    summaryFields = transactionFields;
    paymentFields = paymentFields;

    // @track
    // _transactionHistory;
    // @track
    // _dishonouredPayments;
    // @track
    // _unclearedPayments;

    @track
    transactionData;

    @api
    startDate;
    @api
    endDate;

    defaultStartDate;
    defaultEndDate;

    connectedCallback()
    {
        this.defaultStartDate = this.startDate;
        this.defaultEndDate = this.endDate;
    }

    handleStartDateChange(e)
    {
        this.startDate = e.currentTarget.value;
    }

    handleEndDateChange(e)
    {
        this.endDate = e.currentTarget.value;
    }

    handleSearch(e)
    {
        console.log('search dispatched');
        this.dispatchEvent(new CustomEvent('search', {
            detail: {
                startDate: this.startDate,
                endDate: this.endDate
            }
        }))
    }

    @api
    set transactions(v)
    {
        console.log('setter hit');
        this.buildTemplateObject(v)
    }
    get transactions()
    {
        return null;
    }

    buildTemplateObject(v)
    {
        let list = [];
        list.push({heading: 'Loan Transaction History', headers: this.summaryFields, body: v.transactionHistory, shouldDisplay: v.transactionHistory.length > 0 });
        list.push({heading: 'Uncleared Payments', headers: this.paymentFields, body: v.unclearedPayments });
        list.push({heading: 'Dishonored Payment', headers: this.paymentFields, body: v.dishonouredPayments });
        this.transactionData = list;
    }

    handleReset(e)
    {
        this.startDate = this.defaultStartDate;
        this.endDate = this.defaultEndDate;
        this.handleSearch();
    }
}