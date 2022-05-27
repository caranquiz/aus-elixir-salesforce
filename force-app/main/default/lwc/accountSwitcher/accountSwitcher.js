/**
 * Created by Ethan Sargent on 27/07/2021.
 */

import {LightningElement, track, api} from 'lwc';

import getAccounts from '@salesforce/apex/CustomerPortalController.getAccounts'

import {portalHelper} from "c/portalHelper";
import {NavigationMixin} from "lightning/navigation";

export default class AccountSwitcher extends NavigationMixin(LightningElement)
{

    // ----- API/Tracked variables -----
    accounts;
    accountFields =
        [
            'relationship',
            'loanCount'
        ];

    accountsRetrieved = false;

    @track displayAccounts = [];

    // ----- Class variables -----


    // ----- Wires -----

    // ----- Setup / Teardown -----
    async connectedCallback()
    {
        this.accounts = await getAccounts();
        console.log(JSON.stringify(this.accounts));
        this.processAccounts();
    }

    renderedCallback()
    {

    }

    // ----- Setup Helpers -----

    processAccounts()
    {
        let display = []
        this.accounts.forEach((account, index, array) =>
        {
            let fields = portalHelper.processFieldsFromFilter(account, this.accountFields);
            let newAccount =
                {
                    fields,
                    recordId: account.recordId,
                    name: account.fields.Name.value
                }
            if (account.isPrimary)
            {
                display.unshift(newAccount);
            } else
            {
                display.push(newAccount);
            }
        });
        this.displayAccounts = display;
        console.log(JSON.stringify(this.accounts));
        this.accountsRetrieved = true;
    }

    // ----- Event Handlers -----

    viewLoans(e)
    {
        e.preventDefault();
        e.stopPropagation();

        this.navigateToMyLoans(e.currentTarget.dataset.accountId);
    }

    // ----- Helper Functions -----

    navigateToMyLoans(recordId)
    {

        this[NavigationMixin.GenerateUrl]({
            type: 'comm__namedPage',
            attributes: {
                name: 'My_Loans__c'
            },
            state: {
                accountId: recordId
            }
        }).then(url =>
            window.open(url, "_self")
        );

    }
}