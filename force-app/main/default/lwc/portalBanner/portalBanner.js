/**
 * Created by Ethan Sargent on 17/08/2021.
 */

import {LightningElement, track, api} from 'lwc';

import portalBannerImage from '@salesforce/contentAssetUrl/LinkedIn_image'

export default class PortalBanner extends LightningElement
{

    // ----- API/Tracked variables -----

    @api
    bannerText = 'Banner text! Wow!'
    portalBannerImage = portalBannerImage;

    // ----- Class variables -----


    // ----- Wires -----

    // ----- Setup / Teardown -----
    connectedCallback()
    {

    }

    renderedCallback()
    {

    }


    // ----- Setup Helpers -----


    // ----- Event Handlers -----


    // ----- Helper Functions -----
}