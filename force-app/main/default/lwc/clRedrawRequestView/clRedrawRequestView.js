/**
 * Created by Ethan Sargent on 26/07/2021.
 */

import {LightningElement, track, api} from 'lwc';
import redrawForm from '@salesforce/resourceUrl/RedrawRequestForm';
import redrawFormImg from '@salesforce/contentAssetUrl/ORDE_Redraw_Request_Authoritypdf';
import communityUrl from '@salesforce/community/basePath';

const redrawRequestUrl = communityUrl + '/redrawRequestForm.pdf';

export default class clRedrawRequestView extends LightningElement
{

    // ----- API variables -----

    @api recordId;

    // ----- Tracked variables -----


    // ----- Class Variables -----
    redrawRequestForm = redrawForm;
    redrawRequestImg = redrawFormImg;

    showFirstPage = true;
    showSecondPage = false;


    // ----- Wires -----


    // ----- Setup / Teardown -----
    connectedCallback()
    {
        console.log(redrawForm);
        console.log(redrawRequestUrl);
    }

    renderedCallback()
    {

    }

    // ----- Setup Helpers -----


    // ----- Event Handlers -----

    handleUploadFinished()
    {
        this.dispatchEvent(new CustomEvent('uploadfinished', {
        }));
        this.showFirstPage = true;
        this.showSecondPage = false;
    }

    handleNext()
    {
        this.showFirstPage = false;
        this.showSecondPage = true;
    }

    handlePrevious()
    {
        this.showFirstPage = true;
        this.showSecondPage = false;
    }

    // ----- Helper Functions -----
}