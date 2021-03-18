/****************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : UpdateNewOrExistingBorrower */
/* Created Date         : 15/03/2021 */
/* Developed By         : Rameswari Barman */
/* Description          : */
/* Last Modified Date   : 15/03/2021 */
/* Last Modified By     : Rameswari Barman */
/****************************************************************************************************/

global with sharing class UpdateNewOrExistingBorrower{
    Webservice static String updateValues(Id appId){
        try{
            if(String.isBlank(appId)){
                return null;
            }
            List <clcommon__Party__c> borrowerPartyList = [SELECT Id,
                                                            clcommon__Account__c,
                                                            clcommon__Account__r.Name,
                                                            NewExisting__c
                                                            FROM clcommon__Party__c 
                                                            WHERE genesis__Application__c =: appId
                                                            AND Party_Type_Name__c in (:ConstantValues.GUARANTOR,:ConstantValues.CO_APPLICANT,:ConstantValues.BORROWER)
                                                          ];
            if(borrowerPartyList.size() > 0 == false){
                return null;
            }
            List <Id> accountIds = new List<Id>();
            for(clcommon__Party__c eachParty : borrowerPartyList){
                accountIds.add(eachParty.clcommon__Account__c);
            }
            List <clcommon__Party__c> allBorrowerPartyList = [SELECT Id,
                                                                clcommon__Account__c,
                                                                clcommon__Account__r.Name
                                                                FROM clcommon__Party__c 
                                                                WHERE Party_Type_Name__c in (:ConstantValues.GUARANTOR,:ConstantValues.CO_APPLICANT,:ConstantValues.BORROWER)
                                                                AND genesis__Application__c NOT IN (:appId)
                                                                AND genesis__Application__c != NULL
                                                                AND clcommon__Account__c =: accountIds
                                                            ];
            for(clcommon__Party__c eachParty : borrowerPartyList){
                eachParty.NewExisting__c = 'New';
                for(clcommon__Party__c eachRemainingParty : allBorrowerPartyList){
                    if(eachParty.clcommon__Account__c == eachRemainingParty.clcommon__Account__c){
                        eachParty.NewExisting__c = 'Existing';
                    }
                }
            }
            update borrowerPartyList;                               
        }
        catch (Exception ex) {
            GenericUtility.insertLog('UpdateNewOrExistingBorrower.updateValues', ex);
            return ConstantValues.GENERAL_ERROR;
        }
        return ConstantValues.SUCCESS;
    }
 }