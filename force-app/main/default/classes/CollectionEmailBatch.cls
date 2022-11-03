/****************************************************************************************************
Description:    This is a Batch Class to Send Dishonour Email Automatically
Developer:      Sayak Mukhopadhyay
Created Date:   19/09/2022
*****************************************************************************************************/

global class CollectionEmailBatch extends clcommon.DynamicJob implements DataBase.StateFul,DataBase.Batchable<sObject> ,Database.AllowsCallouts{
    Map<String,List<Id> > contractAccountMap = new Map<String,List<Id> >();
    Map<Id,String> accountIdMobileMap = new Map<Id,String>();
    List<Id> collActivityIdSMSList = new List<Id>();
    List<Id> allAccountIdList = new List<Id>();
    Map<Id,Id> accountContactMap = new Map<Id,Id>();
    global CollectionEmailBatch(){
        //BLANK CONSTRUCTOR
    }
    global override String getRuntimeQuery(){
        return      'SELECT id, ' +
                    'Name, ' + 
                    'collect__Loan_Account_Name__c, ' +
                    'collect__Action__c ' +
                    'FROM collect__Collection_Activity__c ' +
                    'WHERE Mail_Sent__c = False';
    }

    global override void doStart(Database.BatchableContext bc) {}

    global override void doExecute(System.SchedulableContext sc) {
        CollectionEmailBatch obj = new CollectionEmailBatch();
        Integer size = 1;  
        database.executebatch(obj,size);
    }

    public override void doexecute(Database.BatchableContext bc, List<sobject> objCAList) {
        try{
            List<collect__Collection_Activity__c> objCollActivityList = objCAList;
            List<String> contractNameList = new List<String>();
            List<Id> collActivityIdList = new List<Id>();
            Map<Id,String> accountIdEmailMap = new Map<Id,String>();
            Map<Id,Boolean> accountMailDeliveryMap = new Map<Id,Boolean>();
            List<String> partyTypeList = new String[]{ConstantValues.BORROWER,ConstantValues.CO_APPLICANT}; 
            List<String> roleList = new String[]{'Director','Trustee'}; 
            for(collect__Collection_Activity__c objCollActivity : objCollActivityList){
                System.debug('Collection Activity --> ' + objCollActivityList[0].Name);
                if(!String.isBlank(objCollActivity.collect__Loan_Account_Name__c)){
                    contractNameList.add(objCollActivity.collect__Loan_Account_Name__c);
                }
                if(objCollActivity.collect__Action__c == ConstantValues.EMAIL){
                    collActivityIdList.add(objCollActivity.id);
                }
                if(objCollActivity.collect__Action__c != ConstantValues.EMAIL){
                    collActivityIdSMSList.add(objCollActivity.id);
                }
            }
            List<Id> contactIdList=new List<Id>();

            List<loan__Coborrower__c> objCoborrowerList=[SELECT id,
                                                        loan__Contact__c,
                                                        loan__Account__c,
                                                        loan__Contact__r.id,
                                                        loan__Account__r.id,
                                                        loan__Account__r.PersonMobilePhone
                                                        FROM loan__Coborrower__c
                                                        WHERE loan__Party_Type__c in: partyTypeList
                                                        AND loan__Party_Type__c !=: ConstantValues.BROKER_PARTY_TYPE
                                                        AND Contract_Name__c in: contractNameList];
            System.debug('objCoborrowerList.size() --> ' + objCoborrowerList.size());
            List<Id> objAccountIdList = new List<Id>();
            for(loan__Coborrower__c objCoborrower:objCoborrowerList){
                System.debug('objCoborrower.loan__Contact__r.id --> ' + objCoborrower.loan__Contact__r.id);
                if(objCoborrower.loan__Contact__c!=null){
                    contactIdList.add(objCoborrower.loan__Contact__r.id);
                }else{
                    objAccountIdList.add(objCoborrower.loan__Account__r.id);
                }
            }
            List<AccountContactRelation> objAccountContactRelList=[SELECT id,
                                                                    AccountId,
                                                                    ContactId,
                                                                    Account.Name,
                                                                    Contact.Name,
                                                                    Roles
                                                                    FROM AccountContactRelation 
                                                                    WHERE AccountId in: objAccountIdList 
                                                                    AND Roles in : roleList];

            for(AccountContactRelation objAccountContactRel:objAccountContactRelList){
                contactIdList.add(objAccountContactRel.ContactId);
            }
            Map<Id,String> objContactAccountMap=new Map<Id,String>();
            Map<Id,String> objContactAccountRoleMap=new Map<Id,String>();
            for(AccountContactRelation objAccountContactRel:objAccountContactRelList){
                if(objContactAccountMap.containsKey(objAccountContactRel.ContactId) &&
                objContactAccountMap.get(objAccountContactRel.ContactId)!=null){
                    objContactAccountMap.put(objAccountContactRel.ContactId,
                    objContactAccountMap.get(objAccountContactRel.ContactId) +' & '+objAccountContactRel.Account.Name);
                }else{
                    objContactAccountMap.put(objAccountContactRel.ContactId,objAccountContactRel.Account.Name);
                }
                objContactAccountRoleMap.put(objAccountContactRel.ContactId,objAccountContactRel.Roles);
            }
            
            List<loan__Coborrower__c> objCoborrowerList2=[SELECT id,
                                                                    loan__Contact__c,
                                                                    loan__Account__c,
                                                                    loan__Contact__r.id,
                                                                    loan__Contact__r.Name,
                                                                    loan__Account__r.id,
                                                                    Customer_Capacity__c,
                                                                    loan__Account__r.PersonMobilePhone
                                                                    FROM loan__Coborrower__c
                                                                    WHERE  loan__Party_Type__c !=: ConstantValues.BROKER_PARTY_TYPE
                                                                    AND Contract_Name__c in: contractNameList
                                                                    AND loan__Contact__c!=null];

            for(loan__Coborrower__c objCoborrower:objCoborrowerList2){
                if(objContactAccountMap.containsKey(objCoborrower.loan__Contact__r.id) &&
                objContactAccountMap.get(objCoborrower.loan__Contact__r.id) !=null &&
                objContactAccountRoleMap.containsKey(objCoborrower.loan__Contact__r.id) &&
                objContactAccountRoleMap.get(objCoborrower.loan__Contact__r.id) !=null){
                    objCoborrower.Customer_Capacity__c='In capacity as '+objContactAccountRoleMap.get(objCoborrower.loan__Contact__r.id)+' for '+objContactAccountMap.get(objCoborrower.loan__Contact__r.id);
                }
            }
            if(objCoborrowerList2.size()>0){
                update objCoborrowerList2;
            }
            System.debug('contractNameList --> ' + contractNameList);
            List<loan__Loan_Account__c> objContractList = [SELECT id,
                                                            Name,
                                                            (
                                                                SELECT id,
                                                                Name,
                                                                loan__Contact__c,
                                                                loan__Account__c,
                                                                loan__Contact__r.Email,
                                                                loan__Account__r.PersonEmail,
                                                                loan__Account__r.PersonMobilePhone
                                                                FROM loan__Coborrowers__r
                                                                WHERE loan__Party_Type__c !=: ConstantValues.BROKER_PARTY_TYPE 
                                                                AND loan__Contact__c != null
                                                                AND loan__Contact__c in: contactIdList
                                                                AND loan__Account__r.PersonEmail != null
                                                            )
                                                            FROM loan__Loan_Account__c
                                                            WHERE Name in: contractNameList];
            for(loan__Loan_Account__c objContract : objContractList){
                System.debug('objContract.Name --> ' + objContract.Name);
                if(objContract.loan__Coborrowers__r.size() > 0){
                    List<Id> accountIdList = new List<Id>();
                    for(loan__Coborrower__c objCoborrower : objContract.loan__Coborrowers__r){
                        System.debug('objCoborrower.Name --> ' + objCoborrower.Name);
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
            System.debug('accountIdEmailMap --> ' + accountIdEmailMap);
            System.debug('accountContactMap --> ' + accountContactMap);
            /// only the fisrt element of objCollActivityList is used because the Batch size is One ///
            System.debug(objCollActivityList.size());
            System.debug(objCollActivityList[0].collect__Action__c);
            if(objCollActivityList.size() > 0 && objCollActivityList[0].collect__Action__c == ConstantValues.EMAIL){
                System.debug('----Email ----' + objCollActivityList[0].Name);
                accountMailDeliveryMap = CollectionBatchHandler.sendEmail(contractAccountMap,accountIdEmailMap,accountContactMap);
                System.debug('accountMailDeliveryMap --> ' + accountMailDeliveryMap);
                CollectionBatchHandler.cloneCollectionActivity(collActivityIdList,contractAccountMap,accountContactMap,accountMailDeliveryMap);
            }
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'CollectionEmailBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }

    global override void doInitialize() {}

    global override void doFinish(Database.BatchableContext bc){
        if(Test.isRunningTest() == False){
            CollectionSMSBatch obj = new CollectionSMSBatch(allAccountIdList,collActivityIdSMSList,contractAccountMap,accountContactMap);
            Database.executeBatch(obj, 1);
        }
    }
}