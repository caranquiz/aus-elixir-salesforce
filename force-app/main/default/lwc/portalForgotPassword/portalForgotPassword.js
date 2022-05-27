/**
 * Created by Ethan Sargent on 20/09/2021.
 */

import {LightningElement, track, api} from 'lwc';

import sendForgotPasswordRequest from '@salesforce/apex/CustomerPortalUserController.forgotPassword'

export default class PortalForgotPassword extends LightningElement
{
    // ----- Class variables -----

    emailSent;
    username;
    // ----- Setup / Teardown -----

    connectedCallback()
    {

    }

    renderedCallback()
    {

    }

    // ----- Helper Functions -----
    handleUsernameChange(e)
    {
        this.username = e.currentTarget.value;
    }

    async handleSendResetEmail(e)
    {
        let forgotPasswordRequest = {
            username: this.username
        }
        console.log(forgotPasswordRequest);
        let result = await sendForgotPasswordRequest(forgotPasswordRequest);
        console.log('result = ' + result);
        this.emailSent = true;
    }
}