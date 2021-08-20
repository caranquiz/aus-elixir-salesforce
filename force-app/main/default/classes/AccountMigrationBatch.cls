/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class update Account Record Type if party Legal Entity type is INDIVIDUAL.
Development Date : 05/06/2021
Last Modified Date : 06/08/2021
****************************************************************************************************/

public class AccountMigrationBatch implements DataBase.StateFul,DataBase.Batchable<sObject>{

    Date startDate = Date.newInstance(Integer.valueOf(Label.Transaction_Start_Date.split('-').get(2)),Integer.valueOf(Label.Transaction_Start_Date.split('-').get(1)),Integer.valueOf(Label.Transaction_Start_Date.split('-').get(0)));
    Date endDate = Date.newInstance(Integer.valueOf(Label.Transaction_End_Date.split('-').get(2)),Integer.valueOf(Label.Transaction_End_Date.split('-').get(1)),Integer.valueOf(Label.Transaction_End_Date.split('-').get(0)));

    //Query Party whose Legal Entity type is INDIVIDUAL and Account and Contact is not Null.
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String queryString='SELECT id,clcommon__Contact__c,clcommon__Account__c';
        for(Schema.FieldSetMember fieldMember : SObjectType.Contact.FieldSets.Contact_to_Person_Account_Utility_Field.getFields()){
            queryString+=',clcommon__Contact__r.'+fieldMember.getFieldPath();
        }
        queryString+=' FROM clcommon__Party__c WHERE clcommon__Account__c!=NULL AND clcommon__Contact__c!=NULL AND Legal_Entity_Type__c=\'Individual\' AND createdDate >=:startDate AND createdDate <=: endDate';
        return Database.getQueryLocator(queryString);
    }
    public void execute(Database.BatchableContext bc, List<clcommon__Party__c> objPartyList) {
        try{
            List<Account> objAccountList=new List<Account>();
            Set<Id> objAccountSet=new Set<Id>();
            List<Contact> objContactList=new List<Contact>();
            String RecTypeId= [SELECT Id 
                                FROM RecordType 
                                WHERE Name='Person Account' 
                                AND SobjectType='Account'].Id;
            
            for(clcommon__Party__c objParty:objPartyList){
                objAccountSet.add(objParty.clcommon__Account__c);
            }
            objAccountList=[SELECT id,RecordTypeID FROM Account WHERE id=:objAccountSet AND ParentId=Null];
            for(Account account:objAccountList){
                account.RecordTypeID=RecTypeId;
            }
            if(objAccountList.size()>0){
                update objAccountList;
            }
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'AccountMigrationBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
    public void finish(Database.BatchableContext bc){
    }
}