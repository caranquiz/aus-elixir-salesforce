public class CollectionEmailBatch implements DataBase.StateFul,DataBase.Batchable<sObject> ,Database.AllowsCallouts{
    Map<String,List<Id> > contractAccountMap = new Map<String,List<Id> >();
    Map<Id,String> accountIdMobileMap = new Map<Id,String>();
    List<Id> collActivityIdSMSList = new List<Id>();
    List<Id> allAccountIdList = new List<Id>();
    Map<Id,Id> accountContactMap = new Map<Id,Id>();
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT id,
                                            Name,
                                            collect__Loan_Account_Name__c,
                                            collect__Action__c 
                                            FROM collect__Collection_Activity__c 
                                            WHERE Mail_Sent__c = False]);
    }
    public void execute(Database.BatchableContext bc, List<collect__Collection_Activity__c> objCollActivityList) {
        List<String> contractNameList = new List<String>();
        List<Id> collActivityIdList = new List<Id>();
        Map<Id,String> accountIdEmailMap = new Map<Id,String>();
        Map<Id,Boolean> accountMailDeliveryMap = new Map<Id,Boolean>();
        List<String> partyTypeList = new String[]{ConstantValues.BORROWER,ConstantValues.CO_APPLICANT,ConstantValues.DIRECTOR,ConstantValues.TRUSTEE}; // Custom level;
        for(collect__Collection_Activity__c objCollActivity : objCollActivityList){
            System.debug('objCollActivity.Name --> ' + objCollActivity.Name);
            if(!String.isBlank(objCollActivity.collect__Loan_Account_Name__c)){
                contractNameList.add(objCollActivity.collect__Loan_Account_Name__c);
            }
            if(objCollActivity.collect__Action__c == 'Email'){
                collActivityIdList.add(objCollActivity.id);
            }
            if(objCollActivity.collect__Action__c != 'Email'){
                collActivityIdSMSList.add(objCollActivity.id);
            }
        }
        System.debug('contractNameList --> ' + contractNameList);
        System.debug('collActivityIdSMSList -> ' + collActivityIdSMSList);
        List<loan__Loan_Account__c> objContractList = [SELECT id,
                                                        Name,
                                                        (
                                                            SELECT id,
                                                            loan__Contact__c,
                                                            loan__Account__c,
                                                            loan__Contact__r.Email,
                                                            loan__Account__r.PersonEmail,
                                                            loan__Account__r.PersonMobilePhone
                                                            FROM loan__Coborrowers__r
                                                            WHERE loan__Party_Type__c in: partyTypeList
                                                            AND loan__Party_Type__c != 'Broker' 
                                                            AND loan__Contact__c != null
                                                            AND loan__Account__r.PersonEmail != null
                                                        )
                                                        FROM loan__Loan_Account__c
                                                        WHERE Name in: contractNameList];
        System.debug('objContractList --> ' + objContractList);
        for(loan__Loan_Account__c objContract : objContractList){
            if(objContract.loan__Coborrowers__r.size() > 0){
                System.debug('objContract.loan__Coborrowers__r.size() --> ' + objContract.loan__Coborrowers__r.size());
                List<Id> accountIdList = new List<Id>(); 
                for(loan__Coborrower__c objCoborrower : objContract.loan__Coborrowers__r){
                    accountIdList.add(objCoborrower.loan__Account__c);
                    allAccountIdList.add(objCoborrower.loan__Account__c);
                    accountContactMap.put(objCoborrower.loan__Account__c,objCoborrower.loan__Contact__c);
                    accountIdEmailMap.put(objCoborrower.loan__Account__c,objCoborrower.loan__Account__r.PersonEmail);
                    accountIdMobileMap.put(objCoborrower.loan__Account__c,objCoborrower.loan__Account__r.PersonMobilePhone);
                }
                contractAccountMap.put(objContract.Name, accountIdList);
            }
        }
        System.debug('contractAccountMap --> ' + contractAccountMap);
        System.debug('accountContactMap --> ' + accountContactMap);
        System.debug('accountIdEmailMap --> '+ accountIdEmailMap);
        System.debug('accountIdMobileMap --> ' + accountIdMobileMap);
        if(objCollActivityList.size() > 0 && objCollActivityList[0].collect__Action__c == 'Email'){
            accountMailDeliveryMap = CongaTest.sendEmail(contractAccountMap,accountIdEmailMap,accountContactMap);
            System.debug('accountMailDeliveryMap --> ' + accountMailDeliveryMap);
            CongaTest.cloneCollectionActivity(collActivityIdList,contractAccountMap,accountContactMap,accountMailDeliveryMap);
        }
    }
    public void finish(Database.BatchableContext bc){
        CollectionSMSBatch obj = new CollectionSMSBatch(allAccountIdList,collActivityIdSMSList,contractAccountMap,accountContactMap);
        Database.executeBatch(obj, 1);
    }
}