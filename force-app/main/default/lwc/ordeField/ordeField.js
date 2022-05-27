/**
 * Created by Ethan Sargent on 26/07/2021.
 */

import {LightningElement, track, api} from 'lwc';

import defaultTemplate from './ordeField.html'
import bottomAlignTemplate from './bottomAlignValueTemplate.html'

import { loadStyle } from 'lightning/platformResourceLoader';
import style from './ordeField.css'

export default class OrdeField extends LightningElement
{

    // ----- API variables -----
    @api field;
    @api displaySeparator = false;
    @api alignValuesToBottom = false;
    @api inline = false;

    get labelClass()
    {
        return 'switcherLabel fieldLabel';
    }

    // ----- Tracked variables -----

    // ----- Wires -----


    // ----- Setup / Teardown -----
    connectedCallback()
    {

    }

    render()
    {
        if (this.alignValuesToBottom) return bottomAlignTemplate;
        return defaultTemplate;
    }


    // ----- Setup Helpers -----


    // ----- Event Handlers -----


    // ----- Helper Functions -----
}