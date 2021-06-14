/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class helps in updatting Contact detail on existing apps according to defined rules/scenarios
Development Date : 01/06/2021
Last Modified Date : 01/06/2021
****************************************************************************************************/
public class ContactDetailUpdateBatch implements DataBase.StateFul,DataBase.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT id,
                                               MobilePhone,
                                               Phone,
                                               Is_this_the_Postal_Address__c,
                                               OtherStreet,
                                               OtherState,
                                               OtherCity,
                                               OtherPostalCode,
                                               OtherCountry,
                                               MailingStreet,
                                               MailingState,
                                               MailingCity,
                                               MailingPostalCode,
                                               MailingCountry,
                                               Opt_Out_of_Marketing__c,
                                               PEP__c
                                           FROM Contact]);
    }
    public void execute(Database.BatchableContext bc, List<Contact> objContactList) {
        try{
            List<Telephone_Contact_Number__c> objTelephoneList1=new List<Telephone_Contact_Number__c>();
            List<clcommon__Address__c> objAddressList1=new List<clcommon__Address__c>();
            List<Telephone_Contact_Number__c> objTelephoneList2=new List<Telephone_Contact_Number__c>();
            List<clcommon__Address__c> objAddressList2=new List<clcommon__Address__c>();
            List<clcommon__Party__c> objPartiesList=new List<clcommon__Party__c>();
            if(objContactList.size()>0){
                objTelephoneList1=[SELECT Id,
                                        Contact__c,
                                        Phone_Type__c,
                                        Phone_Number__c 
                                    FROM Telephone_Contact_Number__c 
                                    WHERE Contact__c IN: objContactList  
                                    AND Phone_Type__c =: ConstantValues.MOBILE_TAG
                                    AND Phone_Number__c != NULL
                                    ORDER BY CreatedDate];
                
                objTelephoneList2=[SELECT Id,
                                        Contact__c,
                                        Phone_Type__c,
                                        Phone_Number__c 
                                    FROM Telephone_Contact_Number__c 
                                    WHERE Contact__c IN: objContactList  
                                    AND Phone_Type__c =: ConstantValues.Home_Phone
                                    AND Phone_Number__c != NULL
                                    ORDER BY CreatedDate];

                objAddressList1=[SELECT Id,
                                      clcommon__County__c,
                                      Street_No__c,
                                      Street_Name__c,
                                      Street_Type__c,
                                      clcommon__City__c,
                                      State__c,
                                      clcommon__Zip_Code__c,
                                      clcommon__Contact__c,
                                      clcommon__Country__c
                                  FROM clcommon__Address__c 
                                  WHERE clcommon__Contact__c IN:objContactList  
                                  AND Mail_At__c = True];

                objAddressList2=[SELECT Id,
                                       clcommon__County__c,
                                       Street_No__c,
                                       Street_Name__c,
                                       Street_Type__c,
                                       clcommon__City__c,
                                       State__c,
                                       clcommon__Zip_Code__c,
                                       clcommon__Contact__c,
                                       clcommon__Country__c 
                                 FROM clcommon__Address__c 
                                 WHERE clcommon__Contact__c IN:objContactList  
                                 AND Other_At__c = True];

                objPartiesList=[SELECT id,
                                      Politically_Exposed_Person__c,
                                      genesis__Application__c,
                                      genesis__Application__r.Allow_Direct_Marketing__c,
                                      clcommon__Contact__c
                                  FROM clcommon__Party__c 
                                  WHERE clcommon__Contact__c IN: objContactList];
            }
            for(Contact objContact:objContactList){
                for(Telephone_Contact_Number__c objtelephone1:objTelephoneList1){
                    if(objtelephone1.Contact__c==objContact.Id){
                        objContact.MobilePhone=objtelephone1.Phone_Number__c;
                    }
                }
                for(Telephone_Contact_Number__c objtelephone2:objTelephoneList2){
                    if(objtelephone2.Contact__c==objContact.Id){
                        objContact.Phone=objtelephone2.Phone_Number__c;
                    }
                }
                objContact.OtherStreet = null;
                objContact.OtherState = null;
                objContact.OtherCity = null;
                objContact.OtherPostalCode = null;
                objContact.OtherCountry = null;
                for(clcommon__Address__c objAddress1:objAddressList1){
                    if(objAddress1.clcommon__Contact__c==objContact.Id){
                        if(objAddress1.clcommon__County__c!=null)
                            objContact.OtherStreet = ''+objAddress1.clcommon__County__c;
                        if(objAddress1.Street_No__c!=null){
                            if(objContact.OtherStreet!=null){
                                objContact.OtherStreet =objContact.OtherStreet+' '+objAddress1.Street_No__c;
                            }else{
                                objContact.OtherStreet =objAddress1.Street_No__c;
                            }
                        }
                        if(objAddress1.Street_Name__c!=null){
                            if(objContact.OtherStreet!=null){
                                objContact.OtherStreet =objContact.OtherStreet+' '+objAddress1.Street_Name__c;
                            }else{
                                objContact.OtherStreet =objAddress1.Street_Name__c;
                            }
                        }
                        if(objAddress1.Street_Type__c!=null){
                            if(objContact.OtherStreet!=null){
                                objContact.OtherStreet =objContact.OtherStreet+' '+objAddress1.Street_Type__c;
                            }else{
                                objContact.OtherStreet =objAddress1.Street_Type__c;
                            }
                        }
                        if(objAddress1.State__c != null && objAddress1.State__c != ''){
                            objContact.OtherState = objAddress1.State__c;
                        }
                        if(objAddress1.clcommon__City__c != null && objAddress1.clcommon__City__c != ''){
                            objContact.OtherCity = objAddress1.clcommon__City__c;
                        }
                        if(objAddress1.clcommon__Zip_Code__c != null && objAddress1.clcommon__Zip_Code__c != ''){
                            objContact.OtherPostalCode = objAddress1.clcommon__Zip_Code__c;
                        }
                        if( objAddress1.clcommon__Country__c != null && objAddress1.clcommon__Country__c != ''){
                            objContact.OtherCountry = objAddress1.clcommon__Country__c;
                        }
                    }
                }
                if(objContact.Is_this_the_Postal_Address__c== ConstantValues.YES_TAG || objContact.Is_this_the_Postal_Address__c ==ConstantValues.None_Tag){
                    objContact.MailingStreet = null;
                    objContact.MailingState = null;
                    objContact.MailingCity = null;
                    objContact.MailingPostalCode = null;
                    objContact.MailingCountry = null;
                }else{
                    for(clcommon__Address__c objAddress2:objAddressList2){
                        if(objAddress2.clcommon__Contact__c==objContact.Id){
                            objContact.MailingStreet = '';
                            objContact.MailingState = '';
                            objContact.MailingCity = '';
                            objContact.MailingPostalCode = '';
                            objContact.MailingCountry = '';
                            if(objAddress2.clcommon__County__c != null && objAddress2.clcommon__County__c != ''){
                                objContact.MailingStreet = objAddress2.clcommon__County__c;
                            }
                            if(objAddress2.Street_No__c != null && objAddress2.Street_No__c != ''){
                                if(objContact.MailingStreet != null && objContact.MailingStreet != ''){
                                    objContact.MailingStreet = objContact.MailingStreet+' '+objAddress2.Street_No__c;
                                }
                                else{
                                    objContact.MailingStreet = objAddress2.Street_No__c;
                                }
                            }
                            if(objAddress2.Street_Name__c != null && objAddress2.Street_Name__c != ''){
                                if(objContact.MailingStreet != null && objContact.MailingStreet != ''){
                                    objContact.MailingStreet = objContact.MailingStreet+' '+objAddress2.Street_Name__c;
                                }
                                else{
                                    objContact.MailingStreet = objAddress2.Street_Name__c;
                                }
                            }
                            if(objAddress2.Street_Type__c != null && objAddress2.Street_Type__c != ''){
                                if(objContact.MailingStreet != null && objContact.MailingStreet != ''){
                                    objContact.MailingStreet = objContact.MailingStreet+' '+objAddress2.Street_Type__c;
                                }
                                else{
                                    objContact.MailingStreet = objAddress2.Street_Type__c;
                                }
                            }
                            if(objAddress2.State__c != null && objAddress2.State__c != ''){
                                objContact.MailingState = objAddress2.State__c;
                            }
                            if(objAddress2.clcommon__City__c != null && objAddress2.clcommon__City__c != ''){
                                objContact.MailingCity = objAddress2.clcommon__City__c;
                            }
                            if(objAddress2.clcommon__Zip_Code__c != null && objAddress2.clcommon__Zip_Code__c != ''){
                                objContact.MailingPostalCode = objAddress2.clcommon__Zip_Code__c;
                            }
                            if(objAddress2.clcommon__Country__c != null && objAddress2.clcommon__Country__c != ''){
                                objContact.MailingCountry = objAddress2.clcommon__Country__c;
                            }
                        }
                    }
                }
                for(clcommon__Party__c party:objPartiesList){
                    if(party.clcommon__Contact__c==objContact.Id){
                        if(party.Politically_Exposed_Person__c == ConstantValues.YES_TAG){
                            objContact.PEP__c = true;
                        }else{
                            objContact.PEP__c = false;
                        }
                        if(party.genesis__Application__r.Allow_Direct_Marketing__c== ConstantValues.NO_TAG){
                            objContact.Opt_Out_of_Marketing__c = true;
                        }else{
                            objContact.Opt_Out_of_Marketing__c = false;
                        }
                    }
                }
            }
            if(objContactList.size()>0){
                Database.update(objContactList,false);
            }

        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'ContactDetailUpdateBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
    public void finish(Database.BatchableContext bc){
    }
}