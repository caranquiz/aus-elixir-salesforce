/**
 * Created by Ethan Sargent on 1/07/2021.
 */

import {LightningElement, wire} from 'lwc';

import testgetData from '@salesforce/apex/CloudLendingArgoDebug.getData'

export default class CloudLendingArgoTest extends LightningElement {

    @wire(testgetData, {})
    getCLData(result) {
        console.log('wired stuff');
        console.log('Results:' + JSON.stringify(result));
    }
}