/**
 * Created by Ethan Sargent on 19/08/2021.
 */

import {LightningElement, track, api} from 'lwc';


import submitPasswords from '@salesforce/apex/CustomerPortalUserController.changePassword'
import getUserEmail from '@salesforce/apex/CustomerPortalUserController.getUserEmail'
import getCommunityBaseUrl from '@salesforce/apex/CustomerPortalUserController.getCommunityBaseUrl'
import isPasswordExpired from '@salesforce/apex/CustomerPortalUserController.isPasswordExpired'
import getPasswordPolicyStatement from '@salesforce/apex/CustomerPortalUserController.getPasswordPolicy'
import getSecurityQuestionInfo from '@salesforce/apex/CustomerPortalUserController.getSecurityQuestionInfo';
import changePasswordStrongAuth from '@salesforce/apex/CustomerPortalUserController.changePasswordStrongAuth';
import userId from '@salesforce/user/Id';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import {NavigationMixin} from "lightning/navigation";


export default class PortalChangePassword extends NavigationMixin(LightningElement)
{

    // ----- API/Tracked variables -----


    // ----- Class variables -----


    oldPasswordLabel = 'Old Password';
    oldPasswordValue;
    passwordLabel = 'New Password';
    passwordValue;
    confirmPasswordLabel = 'Confirm Password';
    confirmPasswordValue;
    securityQuestionAnswer;

    lockedOut;
    userSecurityQuestion;
    startingAttempts;
    currentAttempts;


    errorFeedback = '';

    isPasswordExpired;

    specialChars = "! \" # $ % & ' ( ) * + , - . / : ; \< = \> ? @ [ \\ ] ^ _ ` { | } ~"

    passwordPolicy = '';

    loaded = false;

    _userEmail;
    get userEmail()
    {
        return this._userEmail;
    }

    set userEmail(v)
    {
        this._userEmail = v;
    }

    // ----- Wires -----

    // ----- Setup / Teardown -----
    async connectedCallback()
    {
        let securityInfo = this.fetchSecurityQuestionInfo();
        let passwordExpired = this.fetchPasswordExpired();
        let fetchUserEmail = this.fetchUserEmail();
        let fetchPasswordPolicy = this.fetchPasswordPolicyStatement();
        let fetchBaseUrl = this.fetchBaseUrl();
        Promise.all([passwordExpired, fetchUserEmail, fetchPasswordPolicy, fetchBaseUrl]).then(() =>
            {
                this.loaded = true;
            }
        )
    }

    renderedCallback()
    {

    }


    // ----- Setup Helpers -----

    async fetchSecurityQuestionInfo()
    {
        let securityInfo = await getSecurityQuestionInfo()
        console.log(JSON.stringify(securityInfo));
        this.updateSecurityQuestionInfo(securityInfo, true);
    }

    updateSecurityQuestionInfo(securityInfo, isFirst)
    {
        this.lockedOut = securityInfo.lockedOut;
        this.userSecurityQuestion = securityInfo.question;
        this.currentAttempts = securityInfo.attemptsLeft;
        if (isFirst)
        {
            this.startingAttempts = securityInfo.attemptsLeft;
        }
    }

    async fetchPasswordExpired()
    {
        this.isPasswordExpired = await isPasswordExpired();
    }

    async fetchUserEmail()
    {
        this.userEmail = await getUserEmail();
        console.log('userEmail : ' + this.userEmail);

    }
    async fetchPasswordPolicyStatement()
    {
        this.passwordPolicy = await getPasswordPolicyStatement();
        console.log('passwordPolicy:' + this.passwordPolicy);

    }
    async fetchBaseUrl()
    {

    }


    // ----- Event Handlers -----

    handlePasswordChange(e)
    {
        this.passwordValue = e.detail.value;
    }

    handleConfirmPasswordChange(e)
    {
        this.confirmPasswordValue = e.detail.value;
    }

    handleSecurityQuestionAnswerChange(e)
    {
        this.securityQuestionAnswer = e.detail.value;
    }

    handleConfirmPasswordBlur(e)
    {
        if (this.confirmPasswordValue !== this.passwordValue)
        {
            e.currentTarget.setCustomValidity('Passwords do not match')
        } else
        {
            e.currentTarget.setCustomValidity("");
        }
        e.currentTarget.reportValidity();
    }


    async handlePasswordSetClicked()
    {
        let valid = this.checkFormValidity();
        if (valid)
        {

            let req = this.buildPasswordChangeRequest();
            console.dir(req);
            let result = await changePasswordStrongAuth(req);
            let success = result.isSuccess;
            let errorMessage = result.errorMessage;
            let securityInfo = result.securityInfo;
            if (success)
            {
                this.dispatchEvent(new ShowToastEvent({
                    "title": "Success!",
                    "variant": 'success',
                    "message": "Your password was successfully changed."
                }));


                let baseUrl = await getCommunityBaseUrl();
                console.dir(baseUrl);

                setTimeout(() =>
                {
                    window.location = baseUrl + '/profile/' + userId
                }, 1500);

            } else
            {
                this.updateSecurityQuestionInfo(securityInfo, false);
                this.dispatchEvent(new ShowToastEvent({
                    "title": "Error",
                    "variant": 'error',
                    "message": errorMessage
                }));
            }
        }
    }

    checkFormValidity()
    {
        return [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) =>
            {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
    }


    buildPasswordChangeRequest()
    {
        return {
            password: this.passwordValue,
            confirmPassword: this.confirmPasswordValue,
            oldPassword: this.oldPasswordValue,
            securityQuestionAnswer: this.securityQuestionAnswer
        }
    }

    handleOldPasswordChange(e)
    {
        this.oldPasswordValue = e.detail.value;
    }

    handleCancel(e)
    {

    }


    // ----- Helper Functions -----

    setError(errorLabel)
    {
        this.errorFeedback = errorLabel;
    }
}