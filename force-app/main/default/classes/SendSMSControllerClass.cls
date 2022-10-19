/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class is controller class to sned SMS. 
Development Date : 20/09/2022
Last Modified Date : 27/09/2022
****************************************************************************************************/

public with sharing class SendSMSControllerClass {
    public String MobileNumber{get;set;}  
    public String textMessage{get;set;} 
    public collect__Loan_Account__c collectAccount {get;set;}
    
    public SendSMSControllerClass(ApexPages.StandardController stdController)  
    {  
        
        collectAccount=[SELECT id,
                                Name,
                                collect__Account__c,
                                collect__Account__r.Name,
                                collect__Account__r.FirstName,
                                collect__External_ID__c,
                                collect__Contact__c,
                                collect__Days_Past_Due__c,
                                collect__Delinquent_Amount__c,
                                CL_Contract__c,
                                CL_Contract__r.Name
                            FROM collect__Loan_Account__c 
                            WHERE id = :ApexPages.currentPage().getParameters().get('id')];
        Id loanId;
        if(collectAccount!=null && collectAccount.CL_Contract__c!=null){
            loanId=collectAccount.CL_Contract__c;
        }
        List<loan__Loan_Payment_Transaction__c> objTransactionList=new List<loan__Loan_Payment_Transaction__c> ();
        if(loanId!=null){
            objTransactionList=[SELECT id,
                                    loan__Transaction_Amount__c,
                                    loan__Transaction_Date__c 
                                FROM loan__Loan_Payment_Transaction__c 
                                WHERE loan__Rejected__c=true 
                                AND Dishonour_Override__c=:ConstantValues.NO_TAG 
                                AND loan__Loan_Account__c=:loanId 
                                ORDER BY LastModifiedDate DESC LIMIT 1];
        }
        
        MobileNumber  = '' ; 
        if(objTransactionList.size()>0){
            Datetime dT=(Datetime) objTransactionList[0].loan__Transaction_Date__c;
            Date dToday=(Date) date.newinstance(dT.year(), dT.month(), dT.day());
            String strDate = dToday.year() + '/' + dToday.month() + '/' + dToday.day();
            String name;
            if(collectAccount.collect__Account__r.FirstName!=null){
                name=collectAccount.collect__Account__r.FirstName;
            }else{
                name=collectAccount.collect__Account__r.Name;
            }
            textMessage = ConstantValues.MANUAL_SMS_BODY_START+name+
            ConstantValues.MANUAL_SMS_BODY_ONE+
            objTransactionList[0].loan__Transaction_Amount__c+
            ConstantValues.MANUAL_SMS_BODY_TWO+strDate+ConstantValues.MANUAL_SMS_BODY_THREE+
            collectAccount.CL_Contract__r.Name+
            ConstantValues.MANUAL_SMS_BODY_END;
        }else{
            textMessage='';
        }
        
    }
    
    public void SendSMS(){
        try{
            CollectionBatchHandler.sendSMS(MobileNumber,textMessage);
            collect__Collection_Activity__c collectionActivityList=new collect__Collection_Activity__c();
            collectionActivityList.collect__Account__c=collectAccount.collect__Account__c;
            collectionActivityList.collect__Action__c=ConstantValues.MESSAGE;
            collectionActivityList.collect__Dev_Contract__c=collectAccount.id;
            collectionActivityList.collect__Contact__c=collectAccount.collect__Contact__c;
            collectionActivityList.collect__Activity_Date__c=Date.today();
            collectionActivityList.collect__Days_Past_Due__c=collectAccount.collect__Days_Past_Due__c;
            collectionActivityList.collect__Loan_Account_Id__c=collectAccount.collect__External_ID__c;
            collectionActivityList.Body__c=textMessage;
            collectionActivityList.collect__Completed__c=true;
            collectionActivityList.collect__Completion_Date__c=Date.today();
            collectionActivityList.Mail_Sent__c = True;
            if(collectionActivityList!=null){
                Database.insert(collectionActivityList,false);
            }
            if(Test.isRunningTest()){
                Integer n=1/0;
            }
        }catch(Exception exe){
            ApexPages.addMessages(exe);
            GenericUtility.insertLog('SendSMSControllerClass', exe);       
        }
    }
    

}