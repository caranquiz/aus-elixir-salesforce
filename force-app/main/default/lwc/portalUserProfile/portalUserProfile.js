/**
 * Created by Ethan Sargent on 19/08/2021.
 */

import {LightningElement, track, api} from 'lwc';

import getPortalUserInfo from '@salesforce/apex/CustomerPortalController.getPortalUserInfo'
import updateAccountDetails from '@salesforce/apex/CustomerPortalController.updatePortalUserInfo'
import {portalHelper} from "c/portalHelper";
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import {NavigationMixin} from "lightning/navigation";

export default class PortalUserProfile extends NavigationMixin(LightningElement)
{

    ausStates = [{label: "ACT", value: "ACT"},
        {label: "NSW", value: "NSW"},
        {label: "NT", value: "NT"},
        {label: "QLD", value: "QLD"},
        {label: "SA", value: "SA"},
        {label: "TAS", value: "TAS"},
        {label: "VIC", value: "VIC"},
        {label: "WA", value: "WA"}];
    yesNoOptions = [{label: "Yes", value: "yes"}, {label: "No", value: "no"}]


    userFullNameField = {label: 'Full Name', value: 'Test Name', isDefault: true};
    userEmailField = {label: 'Email', value: 'test@example.com', isDefault: true};
    userMobileField = {label: 'Mobile Phone', value: '0400111222', isDefault: true};

    userPhone;

    changePasswordLink;

    _userMarketingPreference = true;
    get userMarketingPreference()
    {
        return this._userMarketingPreference;
    }


    get changePasswordUrl()
    {

    }

    set userMarketingPreference(v)
    {
        let el = this.template.querySelector('lightning-input[name="userMarketingPreference"]')
        if (el)
        {
            v ? el.checked = true : el.removeAttribute('checked');
        }
        this._userMarketingPreference = v;
    }

    _userIsPostal = true;
    get userIsPostal()
    {
        return this._userIsPostal;
    }

    set userIsPostal(v)
    {
        let userIsPostal;
        if (typeof v == 'boolean')
            userIsPostal = v;
        else userIsPostal = (v.toLowerCase() === "yes");
        this._userIsPostal = userIsPostal
        if (userIsPostal) this.userIsPostalPicklistValue = 'yes';
        else this.userIsPostalPicklistValue = 'no';
    }

    userIsPostalPicklistValue;
    // get userIsPostalPicklistValue()
    // {
    //     return this.userIsPostal ? "yes" : "no";
    // }


    @track
    userOtherAddress;
    @track
    userPostalAddress;

    get userOtherStreet()
    {
        return this.userOtherAddress?.street;
    }

    get userOtherCity()
    {
        return this.userOtherAddress?.city;
    }

    get userOtherCountry()
    {
        return this.userOtherAddress?.country;
    }

    get userOtherProvince()
    {
        return this.userOtherAddress?.state;
    }

    get userOtherPostalCode()
    {
        return this.userOtherAddress?.postalCode;
    }


    get userMailingStreet()
    {
        return this.userPostalAddress?.street;
    }

    get userMailingCity()
    {
        return this.userPostalAddress?.city;
    }

    get userMailingCountry()
    {
        return this.userPostalAddress?.country;
    }

    get userMailingProvince()
    {
        return this.userPostalAddress?.state;
    }

    get userMailingPostalCode()
    {
        return this.userPostalAddress?.postalCode;
    }


    // ----- Setup / Teardown -----
    async connectedCallback()
    {
        this[NavigationMixin.GenerateUrl]({
            type: 'comm__namedPage',
            attributes:
                {
                    name: 'Change_Password__c'
                }
        }).then(url =>
        {
            console.log('generateURL: ' + url);
            this.changePasswordLink = url;
        })
        let userDetails = await getPortalUserInfo();
        this.processUserDetails(userDetails);
    }

    processUserDetails(details)
    {
        this.userFullNameField = this.processField(details.fullName);
        this.userMobileField = this.processField(details.mobilePhone);
        this.userEmailField = this.processField(details.emailAddress);
        this.userPhone = details.phone;
        this.userMarketingPreference = details.marketingOptOut;
        this.userIsPostal = details.isPostalAddress;
        this.userOtherAddress = details.otherAddress;
        this.userPostalAddress = details.postalAddress;
    }

    processField(field)
    {
        field.isDefault = portalHelper.isDefault(field);
        field.isDate = portalHelper.isDate(field);
        return field
    }

    renderedCallback()
    {

    }

    // ----- Setup Helpers -----


    // ----- Event Handlers -----

    handleAddressChange(e)
    {
        let addressObj = this.buildAddressObject(e.detail);
        if (e.currentTarget.name == 'mailingAddress')
        {
            this.userPostalAddress = addressObj;
        } else if (e.currentTarget.name == "residentialAddress")
        {
            this.userOtherAddress = addressObj;
        }
    }

    handleUserInputChange(e)
    {
        let fieldName = e.currentTarget.name;
        let fieldValueRef = e.currentTarget.type === "checkbox" ? 'checked' : 'value'
        this[fieldName] = e.currentTarget[fieldValueRef];
    }

    _submitting = false
    get submitting()
    {
        return this._submitting;
    }

    set submitting(v)
    {
        let el = this.template.querySelector(".submit-button");
        if (el)
        {
            el.disabled = !!v;
        }
    }

    async handleSubmit(e)
    {

        e.preventDefault();
        if (!this.submitting)
        {
            this.submitting = true;
            let request = this.buildUpdateRequest();
            let response = await updateAccountDetails(request);
            if (response)
            {
                await this.dispatchEvent(new ShowToastEvent({
                    "title": "Success!",
                    "variant": 'success',
                    "message": "Your details were successfully updated."
                }));
            }
            this.submitting = false;
        }

    }

    // ----- Helper Functions -----

    buildUpdateRequest()
    {
        let postalAddress = this.userIsPostal ? this.userOtherAddress : this.userPostalAddress;
        let request = {
            request: {
                phone: this.userPhone,
                marketingOptOut: this.userMarketingPreference,
                isPostalAddress: this.userIsPostal,
                postalAddressJson: JSON.stringify(postalAddress),
                otherAddressJson: JSON.stringify(this.userOtherAddress)
            }
        }
        console.dir(request);
        return request;
    }

    buildAddressObject(details)
    {
        let result = {
            city: details.city,
            street: details.street,
            state: details.province,
            country: details.country,
            postalCode: details.postalCode,
        }
        console.dir(result);
        return result;
    }
}