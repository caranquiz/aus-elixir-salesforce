/**
 * Created by Ethan Sargent on 15/07/2021.
 */

import {LightningElement, api} from 'lwc';

export default class ClContractDetailsView extends LightningElement
{

    _displayFields;

    @api
    set displayFields(v)
    {
        this._displayFields = v;
    }

    get displayFields()
    {
        return this._displayFields;
    }


    validFieldType(e)
    {
        return (e.currentTarget.dataset.typeCheck === e.currentTarget.dataset.field.type)
    }
}