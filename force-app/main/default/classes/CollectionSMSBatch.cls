public class CollectionSMSBatch implements DataBase.StateFul,DataBase.Batchable<sObject> ,Database.AllowsCallouts{
    Map<String,List<Id> > contractAccountMap = new Map<String,List<Id> >();
    List<Id> collActivityIdSMSList = new List<Id>();
    List<Id> allAccountIdList = new List<Id>();
    Map<Id,Id> accountContactMap = new Map<Id,Id>();
    Map<Id,Boolean> accountSMSDeliveryMap = new Map<Id,Boolean>();
    public CollectionSMSBatch(List<Id> allAccountIdList,List<Id> collActivityIdSMSList,Map<String,List<Id> > contractAccountMap,Map<Id,Id> accountContactMap){
        this.contractAccountMap = contractAccountMap;
        this.collActivityIdSMSList = collActivityIdSMSList;
        this.allAccountIdList = allAccountIdList;
        this.accountContactMap = accountContactMap;
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT id,
                                            Name,
                                            PersonMobilePhone 
                                            FROM Account 
                                            WHERE id in: allAccountIdList]);
    }
    public void execute(Database.BatchableContext bc, List<Account> allAccountList){
        System.debug('SMS For Account --> ' + allAccountList[0].Name);
        String contractName;
        for(String key : contractAccountMap.keySet()){
            List<Id> accountIdList = contractAccountMap.get(key);
            if(accountIdList.contains(allAccountList[0].id)){
                contractName = key;
                break;
            }
        }
        System.debug('contractName FOR SMS --> ' + contractName);
        String msgBody = 'Dear {Account.Name}, your direct debit loan repayment of ${Current Payment Amount} made on {Next Due Date} for the loan account {LAI XXXX} was dishonoured by your financial institution. Please call ORDE Financial on 03 8657 2575 to rectify the missed loan repayment. Thanks. DO NOT REPLY BY SMS.';
        List<loan__Loan_Account__c> objContractList = [SELECT id,
                                                        Name,
                                                        loan__Pmt_Amt_Cur__c,
                                                        loan__Next_Installment_Date__c,
                                                        (
                                                            SELECT id,
                                                            loan__Transaction_Amount__c,
                                                            loan__Transaction_Date__c 
                                                            FROM loan__Loan_Payment_Transactions__r 
                                                            WHERE loan__Rejected__c = true 
                                                            AND Dishonour_Override__c = 'No' 
                                                            ORDER BY LastModifiedDate DESC LIMIT 1
                                                        )
                                                        FROM loan__Loan_Account__c
                                                        WHERE Name =: contractName];
        System.debug('SMS Batch objContractList.size() --> ' + objContractList.size());
        if(objContractList.size()>0 && objContractList[0].loan__Pmt_Amt_Cur__c != null && objContractList[0].loan__Next_Installment_Date__c != null){
            System.debug('SMS Batch objContractList[0].Name --> ' + objContractList[0].Name);
            msgBody = msgBody.replace('{Current Payment Amount}',String.valueOf(objContractList[0].loan__Pmt_Amt_Cur__c));
            msgBody = msgBody.replace('{Next Due Date}',String.valueOf(objContractList[0].loan__Next_Installment_Date__c));
            msgBody = msgBody.replace('{Account.Name}',allAccountList[0].Name);
            msgBody = msgBody.replace('{LAI XXXX}',objContractList[0].Name);
        }       
        // cnotify__SMS_Detail__c smsDet = cnotify.SMSUtil.createSmsDetailrecord();
        // Boolean res = cnotify.SMSUtil.sendSMS(allAccountList[0].PersonMobilePhone,allAccountList[0].PersonMobilePhone,smsDet);
        System.debug('msgBody --> ' + msgBody);
        Boolean sendSMS = CongaTest.sendSMS(allAccountList[0].PersonMobilePhone,msgBody);
        if(sendSMS){
            System.debug('SMS Sent --> ' + allAccountList[0].Name+' '+allAccountList[0].id);
            accountSMSDeliveryMap.put(allAccountList[0].id,true);
        }else{
            System.debug('SMS Not Sent --> ' + allAccountList[0].Name+' '+allAccountList[0].id);
            accountSMSDeliveryMap.put(allAccountList[0].id,false);
        }
    }
    public void finish(Database.BatchableContext bc){
        System.debug('accountSMSDeliveryMap --> ' + accountSMSDeliveryMap);
        CongaTest.cloneCollectionActivity(collActivityIdSMSList,contractAccountMap,accountContactMap,accountSMSDeliveryMap);
    }
}