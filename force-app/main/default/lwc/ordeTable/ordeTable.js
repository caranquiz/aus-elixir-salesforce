/**
 * Created by Ethan Sargent on 23/07/2021.
 */

import {LightningElement, api, track} from 'lwc';

import smallScreenTemplate from './mobileOrdeTable.html';
import defaultTemplate from './ordeTable.html';

export default class OrdeTable extends LightningElement
{
    emptyTable;

    get colSpan()
    {
        let headers = this.tableData.headers.length;
        let actions = this.rowLevelActions ? 1 : 0;
        return headers + actions;
    }

    get mobileTableSize()
    {
        return this.rowLevelActions ? "10" : "12"
    }

    @api
    allowEdit;

    @api
    allowDelete;

    @api
    allowDownload;

    @api
    fieldMap;

    smallScreenQuery;

    connectedCallback()
    {
        this.smallScreenQuery = window.matchMedia('(max-width: 500px)');
        this.handleScreenFormat(this.smallScreenQuery);
        this.smallScreenQuery.addEventListener('change',this.handleScreenFormat);
    }

    disconnectedCallback()
    {
        this.smallScreenQuery.removeEventListener('change',this.handleScreenFormat);
    }

    render()
    {
        if (this.showSmallScreen) return smallScreenTemplate;
        return defaultTemplate;
    }

    handleScreenFormat(mediaQuery)
    {
        console.log('hit query listener')
        console.log(mediaQuery.matches);
        this.dispatchEvent(new CustomEvent('sizererender'))
        this.showSmallScreen = mediaQuery.matches;
        console.log(this.showSmallScreen);

    }

    @track
    showSmallScreen = false;


    get rowLevelActions()
    {
        return this.allowEdit || this.allowDelete || this.allowDownload;
    }

    _tableData;
    @api
    set tableData(v)
    {
        this._tableData = v;
        this.emptyTable = !(v.body && v.body.length);
    }

    get tableData()
    {
        return this._tableData;
    }

    handleEdit(e)
    {
        let recordId = e.currentTarget.dataset.recordId;
        console.log('editing ' + recordId);
        let additionalConditions = e.currentTarget.dataset.additionalConditions;
        if (additionalConditions) additionalConditions = JSON.parse(additionalConditions);
        console.log('conditions: ' + JSON.stringify(additionalConditions))
        this.dispatchEvent(new CustomEvent('recordedit',
            {
                detail : {
                    recordId : recordId,
                    isDelete: false,
                    additionalConditions: additionalConditions,
                    isRecurring: additionalConditions.isRecurring
                }
            }))
    }

    handleDelete(e)
    {
        let recordId = e.currentTarget.dataset.recordId;
        console.log('deleting ' + recordId)
        let additionalConditions = e.currentTarget.dataset.additionalConditions;
        if (additionalConditions) additionalConditions = JSON.parse(additionalConditions);
        console.log('conditions: ' + JSON.stringify(additionalConditions))
        this.dispatchEvent(new CustomEvent('recorddelete',
            {
                detail : {
                    recordId : recordId,
                    isDelete: true,
                    additionalConditions: additionalConditions,
                    isRecurring: additionalConditions.isRecurring
                }
            }))
    }

    handleDownload(e)
    {
        let recordId = e.currentTarget.dataset.recordId;
        console.log('bottom event -> recordId = ' + recordId);
        this.dispatchEvent(new CustomEvent('filedownload',
            {
                detail : {
                    recordId : recordId
                }
            }))
    }
}