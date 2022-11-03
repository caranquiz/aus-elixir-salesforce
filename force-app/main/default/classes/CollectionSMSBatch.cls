/****************************************************************************************************
Description:    This is a Batch Class to Send Dishonour SMS Automatically 
Developer:      Sayak Mukhopadhyay
Created Date:   22/09/2022
*****************************************************************************************************/

public class CollectionSMSBatch implements DataBase.StateFul,DataBase.Batchable<sObject> ,Database.AllowsCallouts{
    Map<String,List<Id> > contractAccountMap = new Map<String,List<Id> >();
    List<Id> collActivityIdSMSList = new List<Id>();
    List<Id> allAccountIdList = new List<Id>();
    Map<Id,Id> accountContactMap = new Map<Id,Id>();
    Map<Id,Boolean> accountSMSDeliveryMap = new Map<Id,Boolean>();
    Map<String,Boolean> contractAccountSMSMap = new Map<String,Boolean>();
    public CollectionSMSBatch(List<Id> allAccountIdList,List<Id> collActivityIdSMSList,Map<String,List<Id> > contractAccountMap,Map<Id,Id> accountContactMap){
        this.contractAccountMap = contractAccountMap;
        this.collActivityIdSMSList = collActivityIdSMSList;
        this.allAccountIdList = allAccountIdList;
        this.accountContactMap = accountContactMap;
        for(String key : contractAccountMap.keySet()){
            List<Id> accountIdList = contractAccountMap.get(key);
            for(Id accountId : accountIdList){
                String keyForSMS = key + String.valueOf(accountId);
                contractAccountSMSMap.put(keyForSMS,True);
            }
        }
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT id,
                                            Name,
                                            FirstName,
                                            PersonMobilePhone 
                                            FROM Account 
                                            WHERE id in: allAccountIdList]);
    }
    public void execute(Database.BatchableContext bc, List<Account> allAccountList){
        try{
            String contractName;
            Datetime dT;
            Date dToday;
            String strDate;
            for(String key : contractAccountMap.keySet()){
                List<Id> accountIdList = contractAccountMap.get(key);
                if(allAccountList.size()>0 && accountIdList.contains(allAccountList[0].id)){
                    String keyForSMS = key + String.valueOf(allAccountList[0].id);
                    if(contractAccountSMSMap.containsKey(keyForSMS) && contractAccountSMSMap.get(keyForSMS) == True){
                        contractName = key;
                        contractAccountSMSMap.put(keyForSMS,False);
                        break;
                    }
                }
            }
            String msgBody = System.label.Dishonour_SMS;
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
                                                                AND Dishonour_Override__c =: ConstantValues.NO_TAG
                                                                ORDER BY LastModifiedDate DESC LIMIT 1
                                                            )
                                                            FROM loan__Loan_Account__c
                                                            WHERE Name =: contractName];
            if(objContractList.size()>0){
                msgBody = msgBody.replace(ConstantValues.LAI_NAME,objContractList[0].Name);
                if(allAccountList.size()>0){
                    msgBody = msgBody.replace(ConstantValues.PERSON_ACCOUNT_NAME,allAccountList[0].FirstName);
                }
                if(objContractList[0].loan__Loan_Payment_Transactions__r.size()>0){
                    if(objContractList[0].loan__Loan_Payment_Transactions__r[0].loan__Transaction_Amount__c != null){
                        msgBody = msgBody.replace(ConstantValues.LOAN_CURRENT_PAYMENT_AMOUNT,String.valueOf(objContractList[0].loan__Loan_Payment_Transactions__r[0].loan__Transaction_Amount__c));
                    }
                    if(objContractList[0].loan__Loan_Payment_Transactions__r[0].loan__Transaction_Date__c != null){
                        dT = (Datetime) objContractList[0].loan__Loan_Payment_Transactions__r[0].loan__Transaction_Date__c;
                        dToday = (Date) date.newinstance(dT.year(), dT.month(), dT.day());
                        // String dtDay = String.valueOf(dToday.day());
                        // if(dtDay.length() == 1){
                        //     dtDay = '0' + dt;
                        // }
                        // String dtMonth = String.valueOf(dToday.month());
                        // if(dtMonth.length() == 1){
                        //     dtMonth = '0' + dt;
                        // }
                        //strDate = dtDay + '/' + dtMonth + '/' + dToday.year();
                        strDate = dToday.day() + '/' + dToday.month() + '/' + dToday.year();
                        if(strDate != null){
                            msgBody = msgBody.replace(ConstantValues.NEXT_DUE_DATE,strDate);
                        }
                    }
                }
            }       
            if(allAccountList.size()>0){
                Boolean sendSMS = CollectionBatchHandler.sendSMS(allAccountList[0].PersonMobilePhone,msgBody);
                if(sendSMS){
                    accountSMSDeliveryMap.put(allAccountList[0].id,true);
                }else{
                    accountSMSDeliveryMap.put(allAccountList[0].id,false);
                }
            }
            System.debug('accountSMSDeliveryMap --> ' + accountSMSDeliveryMap);
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'CollectionSMSBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
    public void finish(Database.BatchableContext bc){
        CollectionBatchHandler.cloneCollectionActivity(collActivityIdSMSList,contractAccountMap,accountContactMap,accountSMSDeliveryMap);
    }
}