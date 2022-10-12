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
                                collect__External_ID__c,
                                collect__Contact__c,
                                collect__Days_Past_Due__c,
                                collect__Delinquent_Amount__c,
                                CL_Contract__c,
                                CL_Contract__r.Name
                            FROM collect__Loan_Account__c 
                            WHERE id = :ApexPages.currentPage().getParameters().get('id')];
        
        Id loanId=collectAccount.CL_Contract__c;
        
        List<loan__Loan_Payment_Transaction__c> objTransactionList=[SELECT id,loan__Transaction_Amount__c,loan__Transaction_Date__c FROM loan__Loan_Payment_Transaction__c WHERE loan__Rejected__c=true and Dishonour_Override__c='No' and loan__Loan_Account__c=:loanId ORDER BY LastModifiedDate DESC LIMIT 1];

        Datetime dT=(Datetime) objTransactionList[0].loan__Transaction_Date__c;
        Date dToday=(Date) date.newinstance(dT.year(), dT.month(), dT.day());
        String strDate = dToday.day() + '/' + dToday.month() + '/' + dToday.year();
        MobileNumber  = '' ; 
        textMessage = 'Dear '+collectAccount.collect__Account__r.Name+', your direct debit loan repayment of $'+objTransactionList[0].loan__Transaction_Amount__c+' made on '+strDate+' for the loan account '+collectAccount.CL_Contract__r.Name+' was dishonoured by your financial institution. Please call ORDE Financial on 03 8657 2575 to rectify the missed loan repayment. Thanks. DO NOT REPLY BY SMS.' ;
    }
    
    public void SendSMS(){
        try{
            //cnotify__SMS_Detail__c smsDet = cnotify.SMSUtil.createSmsDetailrecord();
			//cnotify.SMSUtil.sendSMS(MobileNumber,textMessage,smsDet);
            CongaTest.sendSMS(MobileNumber,textMessage);
            collect__Collection_Activity__c collectionActivityList=new collect__Collection_Activity__c();
            collectionActivityList.collect__Account__c=collectAccount.collect__Account__c;
            collectionActivityList.collect__Action__c='Message';
            collectionActivityList.collect__Dev_Contract__c=collectAccount.id;
            collectionActivityList.collect__Contact__c=collectAccount.collect__Contact__c;
            collectionActivityList.collect__Activity_Date__c=Date.today();
            collectionActivityList.collect__Days_Past_Due__c=collectAccount.collect__Days_Past_Due__c;
            collectionActivityList.collect__Loan_Account_Id__c=collectAccount.collect__External_ID__c;
            //collectionActivityList.collect__Delinquent_Amount__c=collectAccount.collect__Delinquent_Amount__c;
            collectionActivityList.Body__c=textMessage;
            collectionActivityList.collect__Completed__c=true;
            collectionActivityList.collect__Completion_Date__c=Date.today();
            collectionActivityList.Mail_Sent__c = True;
            insert collectionActivityList;
        }catch(Exception exe){
            ApexPages.addMessages(exe);
            GenericUtility.insertLog('SendSMSControllerClass', exe);       
        }
    }
    

}