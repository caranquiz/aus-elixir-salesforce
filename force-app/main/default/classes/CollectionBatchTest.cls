/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Sayak Mukhopadhyay
Description:    This is the Test Class for CollectionSMSBatch,CollectionEmailBatch,CollectionBatchHandler,CustomGatewayClass
Development Date : 28/09/2022
Last Modified Date : 28/09/2022
****************************************************************************************************/
@isTest(SeeAllData = false)
public class CollectionBatchTest {
    @TestSetup
    static void initialize(){

        loan__Org_Parameters__c checkTrigger = GenericUtilityTestHelper.returnOrgParameter();
        checkTrigger = loan__Org_Parameters__c.getInstance();
        System.AssertEquals(
            checkTrigger.loan__Disable_Triggers__c,
            true,
            'Org Parameter error'
        );

        clcommon__Legal_Entity__c objLegEntity = GenericUtilityTestHelper.returnLegalEntity();
        System.AssertNotEquals(
            objLegEntity.Id,
            null,
            'Legal Entity inserted successfully.'
        );

        clcommon__Party_Type__c objBorrowerPartyType = GenericUtilityTestHelper.returnBorrowerPartyType();
        System.AssertNotEquals(
            objBorrowerPartyType.Id,
            null,
            'Party Type inserted successfully.'
        );

        List<Account> testAccountList = new List<Account>();
        Account testAccount = GenericUtilityTestHelper.insertPersonAccount();
        testAccount.PersonMobilePhone = '+61482086733';
        testAccount.PersonEmail = 'test@email.com';
        testAccount.clcommon__Legal_Entity_Type__c = objLegEntity.id;
        testAccountList.add(testAccount);

        Account testAccountTwo = GenericUtilityTestHelper.insertPersonAccount();
        testAccountTwo.MiddleName = 'Test';
        testAccountTwo.PersonMobilePhone = '+614820867353';
        testAccountTwo.PersonEmail = 'test@email.co.in';
        testAccountTwo.clcommon__Legal_Entity_Type__c = objLegEntity.id;
        testAccountList.add(testAccountTwo);

        Account testAccountThree = GenericUtilityTestHelper.insertPersonAccount();
        testAccountThree.MiddleName = 'Testing';
        testAccountList.add(testAccountThree);

        Account testAccountFour = GenericUtilityTestHelper.insertPersonAccount();
        testAccountThree.MiddleName = 'UnitTest';
        testAccountList.add(testAccountFour);

        if(testAccountList.size() == 4){
            DataBase.update(testAccountList,false);
            System.assertEquals(
                testAccountList[0].clcommon__Legal_Entity_Type__c,
                objLegEntity.id,
            'Account inserted successfully.'
            );
            System.assertEquals(
                testAccountList[1].clcommon__Legal_Entity_Type__c,
                objLegEntity.id,
            'Account inserted successfully.'
            );
            System.assertEquals(
                testAccountList[1].clcommon__Legal_Entity_Type__c,
                objLegEntity.id,
            'Account inserted successfully.'
            );
            System.AssertNotEquals(
                testAccountList[2].id,
                null,
            'Account inserted successfully.'
            );
            System.AssertNotEquals(
                testAccountList[3].id,
                null,
            'Account inserted successfully.'
            );
        }
        Contact testContact = [SELECT id FROM Contact WHERE AccountId =: testAccount.id LIMIT 1];
        System.AssertNotEquals(
            testContact,
            null,
        'Contact inserted successfully.'
        );

        Contact testContactTwo = [SELECT id FROM Contact WHERE AccountId =: testAccountTwo.id LIMIT 1];
        System.AssertNotEquals(
            testContactTwo,
            null,
        'Contact inserted successfully.'
        );

        Contact testContactThree = [SELECT id FROM Contact WHERE AccountId =: testAccountThree.id LIMIT 1];
        System.AssertNotEquals(
            testContactThree,
            null,
        'Contact inserted successfully.'
        );

        Contact testContactFour = [SELECT id FROM Contact WHERE AccountId =: testAccountFour.id LIMIT 1];
        System.AssertNotEquals(
            testContactFour,
            null,
        'Contact inserted successfully.'
        );

        AccountContactRelation accountContactRelOne = GenericUtilityTestHelper.insertAccountContactRelation(testAccountThree.id, testContactFour.id, ConstantValues.DIRECTOR);
        System.AssertNotEquals(
            accountContactRelOne,
            null,
        'AccountContactRelation inserted successfully.'
        );

        AccountContactRelation accountContactRelTwo = GenericUtilityTestHelper.insertAccountContactRelation(testAccountFour.id, testContactThree.id, ConstantValues.TRUSTEE);
        System.AssertNotEquals(
            accountContactRelTwo.id,
            null,
        'AccountContactRelation inserted successfully.'
        );

        genesis__applications__c testApplication = GenericUtilityTestHelper.returnApplication(testAccount.id);
        System.AssertNotEquals(
            testApplication.Id,
            null,
            'Application inserted successfully.'
        );
        
        loan__Loan_Account__c testLoanAccount = GenericUtilityTestHelper.returnLoan(
            testAccount.id,
            testApplication.id
        );
        update testLoanAccount;
        System.AssertNotEquals(
            testLoanAccount.Id,
            null,
            'Contract inserted successfully.'
        );

        //Inserting Warehouse
        Warehouse__c ware = GenericUtilityTestHelper.returnWarehouse();
        System.assertEquals(ware.Institution_Name__c, 'Warehouse');
        WarehouseFunding.executeFun(testLoanAccount.id, ware.Id);

        String contractName = [SELECT id,Name FROM loan__Loan_Account__c WHERE id =: testLoanAccount.id].Name;

        List<loan__Coborrower__c> testContractPartyList = new List<loan__Coborrower__c>();
        loan__Coborrower__c objBorrowerContractParty = GenericUtilityTestHelper.insertContractParty(testAccount,testContact,testLoanAccount);
        objBorrowerContractParty.loan__Party_Type__c = ConstantValues.BORROWER;
        testContractPartyList.add(objBorrowerContractParty);

        loan__Coborrower__c objBorrowerContractPartyTwo = GenericUtilityTestHelper.insertContractParty(testAccountTwo,testContactTwo,testLoanAccount);
        objBorrowerContractPartyTwo.loan__Party_Type__c = ConstantValues.CO_APPLICANT;
        testContractPartyList.add(objBorrowerContractPartyTwo);

        loan__Coborrower__c objBorrowerContractPartyThree = GenericUtilityTestHelper.insertContractParty(testAccountThree,testContactThree,testLoanAccount);
        objBorrowerContractPartyThree.loan__Contact__c = null;
        objBorrowerContractPartyThree.loan__Party_Type__c = ConstantValues.CO_APPLICANT;
        testContractPartyList.add(objBorrowerContractPartyThree);

        loan__Coborrower__c objBorrowerContractPartyFour = GenericUtilityTestHelper.insertContractParty(testAccountFour,testContactFour,testLoanAccount);
        objBorrowerContractPartyFour.loan__Contact__c = null;
        objBorrowerContractPartyFour.loan__Party_Type__c = ConstantValues.CO_APPLICANT;
        testContractPartyList.add(objBorrowerContractPartyFour);

        if(testContractPartyList.size() == 4){
            DataBase.update(testContractPartyList,false);
            System.AssertEquals(
                testContractPartyList[0].loan__Party_Type__c,
                ConstantValues.BORROWER,
                'Contract Party inserted successfully.'
            );
            System.AssertEquals(
                testContractPartyList[1].loan__Party_Type__c,
                ConstantValues.CO_APPLICANT,
                'Contract Party inserted successfully.'
            );
            System.AssertNotEquals(
                testContractPartyList[2].id,
                null,
                'Contract Party inserted successfully.'
            );
            System.AssertNotEquals(
                testContractPartyList[3].id,
                null,
                'Contract Party inserted successfully.'
            );
        }

        //loan__Loan_Payment_Transaction__c testLpt = GenericUtilityTestHelper.insertLPT(testLoanAccount.id);

        List<collect__Collection_Activity__c> testCollectionActivityList = new List<collect__Collection_Activity__c>();
        collect__Collection_Activity__c testCollectionActivity = GenericUtilityTestHelper.insertCollectionActivity(contractName);
        testCollectionActivity.collect__Action__c = ConstantValues.EMAIL;
        testCollectionActivity.Mail_Sent__c = False;
        testCollectionActivity.CL_Contract__c = testLoanAccount.id;
        testCollectionActivityList.add(testCollectionActivity);

        collect__Collection_Activity__c testCollectionActivityTwo = GenericUtilityTestHelper.insertCollectionActivity(contractName);
        testCollectionActivity.collect__Action__c = ConstantValues.EMAIL;
        testCollectionActivity.Mail_Sent__c = False;
        testCollectionActivity.CL_Contract__c = testLoanAccount.id;
        testCollectionActivityList.add(testCollectionActivityTwo);

        if(testCollectionActivityList.size() == 2){
            DataBase.update(testCollectionActivityList,false);
            System.assert(testCollectionActivityList[0].collect__Action__c == ConstantValues.EMAIL);
            System.assert(testCollectionActivityList[1].Mail_Sent__c == False);
        }

        clcommon__TwilioConfig__c twilioConfig = new clcommon__TwilioConfig__c();
        twilioConfig.Name = 'SMS Config';
        twilioConfig.clcommon__AccountSid__c = 'ehu32ei23ei';
        twilioConfig.clcommon__AuthToken__c = 'ugi3rtye1ty';
        twilioConfig.clcommon__Use_Short_Code__c = True;
        twilioConfig.clcommon__CallerId__c = '4944006401';
        insert twilioConfig;
        System.AssertNotEquals(
            twilioConfig.Id,
            null,
            'Twilio Settings inserted successfully.'
        );

        clcommon__GatewayConfiguration__c testGatewayConfig = new clcommon__GatewayConfiguration__c();
        testGatewayConfig.clcommon__Daily_Limit_Counter__c = 99;
        testGatewayConfig.clcommon__Max_Daily_Limit__c = 100;
        testGatewayConfig.clcommon__Mode_Of_Communication__c = ConstantValues.MESSAGE;
        testGatewayConfig.clcommon__Implementation_Class__c = 'TestImplementationClass';
        insert testGatewayConfig;
        System.AssertNotEquals(
            testGatewayConfig.Id,
            null,
            'Gateway Configuration inserted successfully.'
        );

        clcommon__Template_Configuration__c testTemplateConfig = new clcommon__Template_Configuration__c();
        testTemplateConfig.clcommon__To__c = '0123321123';
        testTemplateConfig.clcommon__Template_Type__c = ConstantValues.MESSAGE;
        testTemplateConfig.clcommon__CallbackCallerClass__c = 'TestCallBackCallerClass';
        insert testTemplateConfig;
        System.AssertNotEquals(
            testTemplateConfig.Id,
            null,
            'Template Configuration inserted successfully.'
        );

        // Inserting Delivery Details //
        clcommon__Gateway__c testGateway = new clcommon__Gateway__c(); 
        testGateway.clcommon__Template_Name__c = testTemplateConfig.id;
        testGateway.clcommon__Mode_Of_Communication__c = ConstantValues.MESSAGE;
        testGateway.clcommon__To__c = '0123321123';
        testGateway.clcommon__Content__c = 'Test Content';
        insert testGateway;
        System.AssertNotEquals(
            testGateway.Id,
            null,
            'Gateway inserted successfully.'
        );

    }
    @isTest
    static void collectionBatchTestOne(){
        List<collect__Collection_Activity__c> objCollActivityList = [SELECT id,
                                                                        Name 
                                                                        FROM collect__Collection_Activity__c 
                                                                        WHERE Mail_Sent__c = False];
        System.debug('objCollActivityList.size() --> ' + objCollActivityList.size());
        System.assertEquals(objCollActivityList.size() > 0, true, 'Collection Activity found successfully!');
        for(collect__Collection_Activity__c obj : objCollActivityList){
            System.debug('obj.Name --> ' + obj.Name);
        }
        test.startTest(); 
        clcommon.DynamicJobAPI2 apiHandle = clcommon.APIFactory.getDynamicJobAPI2();
        String name = 'MyDag';
        Map<String, List<Object>> jobs = new Map<String, List<Object>>();
        String query = 'SELECT id, Name, collect__Loan_Account_Name__c, collect__Action__c FROM collect__Collection_Activity__c WHERE Mail_Sent__c = False';
        jobs.put('j1', new List<Object>{'CollectionEmailBatch', 1, query, 'Logging', 200});
        Map<String, Set<String>> dependencyList = new Map<String,Set<String>>();
        dependencyList.put('j1', new Set<String>());
        apiHandle.addDag(name, jobs, dependencyList);
        CollectionEmailBatch obj = new CollectionEmailBatch();
        String runtimeQuery = obj.getRuntimeQuery();
        System.debug('runtimeQuery received: ' + Database.query(runtimeQuery));
        System.assert(Database.query(runtimeQuery).size()>0);
        List<clcommon__DAG_Schedule__c> dagScheduler=[SELECT id,
                                                        clcommon__Cron_Expression__c,
                                                        clcommon__DAG_Name__c
                                                        FROM clcommon__DAG_Schedule__c
                                                        WHERE clcommon__DAG_Name__c =: name];
        if(dagScheduler.size()>0){
            System.debug('dagScheduler found');
            clcommon.DynamicJobRoot objJob = new clcommon.DynamicJobRoot(dagScheduler[0]);
            objJob.execute(null);
        }
        test.stopTest();
    }
    @isTest
    static void collectionBatchTestTwo(){
        List<Account> objAccoutList = [SELECT id FROM Account WHERE PersonMobilePhone != null];
        System.assertEquals(objAccoutList.size() > 0, true, 'Account found successfully!');
        List<collect__Collection_Activity__c> objCollActivitySMSList = [SELECT id,
                                                                            Name,
                                                                            collect__Action__c
                                                                            FROM collect__Collection_Activity__c];
        System.assertEquals(objCollActivitySMSList.size() > 0, true, 'Collection Activity found successfully!');
        for(collect__Collection_Activity__c obj : objCollActivitySMSList){
            System.debug('obj.Name --> ' + obj.Name + ' Action --> ' + obj.collect__Action__c);
            if(obj.collect__Action__c == ConstantValues.EMAIL){
                obj.collect__Action__c = ConstantValues.MESSAGE;
            }
        }
        if(objCollActivitySMSList.size()>0){
            DataBase.update(objCollActivitySMSList,false);
            System.assertEquals(objCollActivitySMSList[0].collect__Action__c, ConstantValues.MESSAGE, 'Collection Activity updated successfully!');
        }
        for(collect__Collection_Activity__c obj : objCollActivitySMSList){
            System.debug('obj.Name --> ' + obj.Name + ' Action --> ' + obj.collect__Action__c);
        }                                                                   
        List<Id> allAccountIdList = new List<Id>();
        List<Id> collActivityIdSMSList = new List<Id>();
        Map<String,List<Id> > contractAccountMap = new Map<String,List<Id> >();
        Map<Id,Id> accountContactMap = new Map<Id,Id>();
        Map<Id,Boolean> accountMailDeliveryMap = new Map<Id,Boolean>();
        for(Account objAccount : objAccoutList){
            allAccountIdList.add(objAccount.id);
        }
        for(collect__Collection_Activity__c objCollActivity : objCollActivitySMSList){
            collActivityIdSMSList.add(objCollActivity.id);
        }
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
                                                            AND loan__Account__r.PersonMobilePhone != null
                                                            AND loan__Account__c != null
                                                            AND loan__Contact__c != null
                                                        )
                                                        FROM loan__Loan_Account__c];
        System.assertEquals(objContractList.size() > 0, true, 'Collection Activity found successfully!');
        for(loan__Loan_Account__c objContract : objContractList){
            List<Id> accountIdList = new List<Id>();
            for(loan__Coborrower__c objCoborrower : objContract.loan__Coborrowers__r){
                accountIdList.add(objCoborrower.loan__Account__c);
                accountMailDeliveryMap.put(objCoborrower.loan__Account__c,True);
                accountContactMap.put(objCoborrower.loan__Account__c,objCoborrower.loan__Contact__c);
            }
            contractAccountMap.put(objContract.Name, accountIdList);
        }
        test.startTest();
        if(allAccountIdList != null && collActivityIdSMSList != null && contractAccountMap != null && accountContactMap != null){
            CollectionSMSBatch obj = new CollectionSMSBatch(allAccountIdList,collActivityIdSMSList,contractAccountMap,accountContactMap);
            Database.executeBatch(obj, 100);
        }
        if(collActivityIdSMSList != null && contractAccountMap != null && accountContactMap != null && accountMailDeliveryMap != null){
            CollectionBatchHandler.cloneCollectionActivity(collActivityIdSMSList,contractAccountMap,accountContactMap,accountMailDeliveryMap);
        }
        test.stopTest();
    }
    @isTest
    static void customGatewayClassTestOne(){ 
        String phNumber = '0876678876';
        String smsBody = 'Testing SMS Body';
        CustomGatewayClass objGatewayClass = new CustomGatewayClass();
        Http http = new Http();
        String implementationClassName = 'TestImplementationClass';
        String className = 'className';
        List<HttpResponse> results = new List<HttpResponse>();
        List<clcommon__Gateway__c> gatewayList = [SELECT id,
                                                    clcommon__Template_Name__c,
                                                    clcommon__Mode_Of_Communication__c,
                                                    clcommon__To__c,
                                                    clcommon__Content__c 
                                                    FROM clcommon__Gateway__c];
        System.assertEquals(gatewayList.size() > 0, true, 'Gateway Configuration found successfully!');
        test.startTest();
        HttpRequest request = objGatewayClass.buildWebServiceRequest(phNumber,smsBody);
        HttpResponse response = objGatewayClass.invokeWebService(http,request);
        System.debug('response --> ' + response);
        results.add(response);
        request = objGatewayClass.buildWebServiceRequest(null,smsBody);
        objGatewayClass.GatewaySend(gatewayList,className,implementationClassName);
        objGatewayClass.handleWebServiceResponse(results,gatewayList,className,implementationClassName);
        test.stopTest();
    }
    @isTest
    static void customGatewayClassTestTwo(){ 
        CustomGatewayClass objGatewayClass = new CustomGatewayClass();
        String implementationClassName = 'TestImplementationClass';
        String className = 'className';
        List<clcommon__Gateway__c> gatewayList = [SELECT id,
                                                    clcommon__Template_Name__c,
                                                    clcommon__Mode_Of_Communication__c,
                                                    clcommon__To__c,
                                                    clcommon__Content__c 
                                                    FROM clcommon__Gateway__c];
        System.assertEquals(gatewayList.size() > 0, true, 'Gateway Configuration found successfully!');
        gatewayList[0].clcommon__To__c = 'null';
        update gatewayList[0];
        System.assertEquals(gatewayList[0].clcommon__To__c, 'null', 'Gateway updated successfully!');
        List<clcommon__GatewayConfiguration__c> gatewayConfigList = [SELECT id,
                                                                        clcommon__Daily_Limit_Counter__c,
                                                                        clcommon__Max_Daily_Limit__c
                                                                        FROM clcommon__GatewayConfiguration__c];
        System.assertEquals(gatewayConfigList.size() > 0, true, 'Gateway Configuration found successfully!'); 
        gatewayConfigList[0].clcommon__Daily_Limit_Counter__c = 100;
        gatewayConfigList[0].clcommon__Max_Daily_Limit__c = 99;
        update gatewayConfigList[0];
        System.assertEquals(gatewayConfigList[0].clcommon__Max_Daily_Limit__c, 99, 'Gateway Configuration updated successfully!');                             
        test.startTest();
        objGatewayClass.GatewaySend(gatewayList,className,implementationClassName);
        test.stopTest();
    }
}