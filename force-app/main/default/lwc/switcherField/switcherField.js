/**
 * Created by Ethan Sargent on 29/07/2021.
 */

import {LightningElement, track, api} from 'lwc';

export default class SwitcherField extends LightningElement
{

    // ----- API/Tracked variables -----

    @api
    fieldLabel;
    @api
    fieldValue;
    @api
    lineBreak;
    @api
    isDate;

}