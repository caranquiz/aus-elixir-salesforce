/****************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : CategoryAttachmentUtility */
/* Created Date         : 08/03/2021 */
/* Developed By         : Rameswari Barman */
/* Description          : This class is used to create Category Attachment Association object record when files are uploaded
                          This class also helps in deleting attachments and category attachment association records*/
/* Last Modified Date   : 11/03/2021 */
/* Last Modified By     : Rameswari Barman */
/****************************************************************************************************/

global with sharing class CategoryAttachmentUtility {
    Webservice static String categoryAttachmentCheckAndCreation(Id documentCategoryId,List <Id> attachIdList){
        try{
            if(attachIdList.size() > 0 == false){
                return null;
            }
            if(String.isBlank(documentCategoryId)){
                return null;
            }
            List <Id> createdAttList = new List<Id>();
            //Selecting out the document category that is associated with the Skuid tab from where the attachment has been uploaded
            List <clcommon__Category_Attachment_Association__c> categoryList = [SELECT Id,
                                                                                    clcommon__Attachment_Id__c
                                                                                    FROM clcommon__Category_Attachment_Association__c 
                                                                                    WHERE clcommon__Attachment_Id__c  =: attachIdList 
                                                                                    AND clcommon__Document_Category__c =: documentCategoryId
                                                                                ];
            if(categoryList.size() > 0){
                for(clcommon__Category_Attachment_Association__c cat : categoryList){
                    createdAttList.add(cat.clcommon__Attachment_Id__c);
                }
            }
            List <Attachment> newAttachmentList = [SELECT Id,
                                                    Name 
                                                    FROM Attachment where Id in : attachIdList
                                                    AND  ID not in : createdAttList
                                                  ];
            List <clcommon__Category_Attachment_Association__c> newCategoryList = new List<clcommon__Category_Attachment_Association__c>();
            if(newAttachmentList.size() > 0){
                for(Attachment attach : newAttachmentList){
                    clcommon__Category_Attachment_Association__c category = new clcommon__Category_Attachment_Association__c();
                    category.Name = attach.Name;
                    category.clcommon__Attachment_Id__c = attach.Id;
                    category.clcommon__Status__c = ConstantValues.SUBMITTED;
                    category.clcommon__Document_Category__c = documentCategoryId;
                    newCategoryList.add(category);
                }
                if(newCategoryList.size() > 0){
                    Database.insert(newCategoryList,false);
                    //Database.insert(list,false) is used so that faulty attachemnts can be skipped and good rexord data is attached
                }
            }
            return ConstantValues.SUCCESS_STATUS;
        }
        catch (Exception ex) {
            GenericUtility.insertLog('CategoryAttachmentUtility.categoryAttachmentCheckAndCreation', ex);
            return ConstantValues.GENERAL_ERROR;
        }
    }
    //This method helps in deleting attachements and its respective category attachment record
    Webservice static String deleteAttachment(Id attachId){
        Savepoint sp;
        try{
            //Access level of party object is checked since the attachments are related to party and
            //access level of party should thus flow to the access level of the specific attachment
            if(!(clcommon__Category_Attachment_Association__c.sObjectType.getDescribe().isDeletable() == true && 
                clcommon__Party__c.sObjectType.getDescribe().isDeletable() == true &&
                clcommon__Category_Attachment_Association__c.sObjectType.getDescribe().isAccessible() == true && 
                clcommon__Party__c.sObjectType.getDescribe().isAccessible() == true
            )){
                return ConstantValues.USER_DOES_NOT_HAVE_ACCESS;
            }
            if(String.isBlank(attachId)){
                return null;
            }
            sp = Database.setSavepoint();
            List <clcommon__Category_Attachment_Association__c> categoryList = [SELECT Id,
                                                                                    clcommon__Attachment_Id__c
                                                                                    FROM clcommon__Category_Attachment_Association__c 
                                                                                    WHERE clcommon__Attachment_Id__c  =: attachId limit 1
                                                                                ];
            List <Attachment> attachmentList;
            if(categoryList.size() > 0){
                attachmentList = [SELECT Id,
                                        Name
                                        FROM Attachment
                                        WHERE Id =: attachId limit 1
                                 ];
                delete categoryList;
                if(attachmentList.size() > 0){
                    delete attachmentList;
                    return ConstantValues.ATT_DELETION_MESSAGE;
                }
                else{
                    Database.rollback(sp);
                    return ConstantValues.GENERAL_ERROR;
                }
            }
            else {
                Database.rollback(sp);
                return ConstantValues.GENERAL_ERROR;
            }
        }
        catch (Exception ex) {
            Database.rollback(sp);
            GenericUtility.insertLog('CategoryAttachmentUtility.deleteAttachment', ex);
            return ConstantValues.GENERAL_ERROR;
        }
    }
}