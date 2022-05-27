/**
 * Created by Ethan Sargent on 17/09/2021.
 */

import {LightningElement, track, api} from 'lwc';
import getUserSecurityQuestionInfo from '@salesforce/apex/CustomerPortalUserController.getSecurityQuestionInfo'

export default class PortalSecurityQuestionChallenge extends LightningElement
{

    // ----- API/Tracked variables -----
    @api action = 'setting up your account';

    @api availableActions = [];

    // ----- Class variables -----

    securityInfoLoaded = false;


    // ----- Wires -----



    // ----- Setup / Teardown -----
    async connectedCallback()
    {
        let securityInfo = await getUserSecurityQuestionInfo();
        console.log(securityInfo);
        this.securityInfoLoaded = true;
    }

    renderedCallback()
    {

    }


    // ----- Setup Helpers -----


    // ----- Event Handlers -----


    // ----- Helper Functions -----
}