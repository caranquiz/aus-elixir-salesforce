/**
 * Created by Ethan Sargent on 9/08/2021.
 */

import {LightningElement, track, api} from 'lwc';

const statementHeaders =
    [
        'File Name',
    ]

export default class ClStatementView extends LightningElement
{

    // ----- API/Tracked variables -----

    _statementDetails = { heading: "Statements", headers: statementHeaders, body: []};
    @api
    get statementDetails()
    {
        return this._statementDetails;
    }

    set statementDetails(v)
    {
        this._statementDetails.body = v;
    }

    // ----- Class variables -----


    // ----- Wires -----

    // ----- Setup / Teardown -----
    connectedCallback()
    {

    }

    renderedCallback()
    {

    }

    handleFileDownload(e)
    {
        this.dispatchEvent(new CustomEvent('statementdownload',
            {
                detail: {
                    statementId: e.detail.recordId
                }
            }));
    }


    // ----- Setup Helpers -----


    // ----- Event Handlers -----


    // ----- Helper Functions -----
}