/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Sayak Mukhopadhyay 
Description : This class give coverage to NextGen apex classes.
Development Date : 17/05/2022
Last Modified Date : 20/05/2022
****************************************************************************************************/

@isTest(SeeAllData = false)
public class NextGenAuthenticationTest{
    @TestSetup
    static void initialize(){

        intframework__Integration_Family__c family = GenericUtilityTestHelper.getFamily(
            'NextGen BCM'
        );
        
        List<intframework__Integration_Family__c> familyList=[SELECT id 
                                                                    FROM intframework__Integration_Family__c 
                                                                    WHERE Name='NextGen BCM'];
        System.assertEquals(
            familyList.size(),
            1
        );

        // Configuration of Apply Individual API Integration
        intframework__Integration_API_Type__c apiType = GenericUtilityTestHelper.getIntegrationAPIType(
            family.Id,
            'NextGen BCM API'
        );
        List<intframework__Integration_API_Type__c> apiTypeList=[SELECT id 
                                                                    FROM intframework__Integration_API_Type__c 
                                                                    WHERE Name='NextGen BCM API'];
        System.assertEquals(
            apiTypeList.size(),
            1
        );
        
        intframework__Integration_Provider__c provider = GenericUtilityTestHelper.getIntegrationProvider(
            family.Id,
            'NextGen BCM'
        );

        List<intframework__Integration_Provider__c> providerList=[SELECT id 
                                                                    FROM intframework__Integration_Provider__c 
                                                                    WHERE Name='NextGen BCM'];
        System.assertEquals(
            providerList.size(),
            1
        );

        intframework__Integration_Configuration__c config = GenericUtilityTestHelper.getIntegrationConfiguration(
            provider.Id,
            'NextGen BCM AppId config'
        );
        List<intframework__Integration_Configuration__c> configList=[SELECT id 
                                                                    FROM intframework__Integration_Configuration__c 
                                                                    WHERE Name='NextGen BCM AppId config'];
        System.assertEquals(
            configList.size(),
            1
        );

        intframework__Integration_API_Configuration__c integrationAPIConfig=GenericUtilityTestHelper.getIntegrationAPIConfiguration(
            family.Id,
            apiType.Id,
            provider.Id,
            config.Id,
            'NextGenBCMAdapter',
            'POST',
            'NextGenBCM',
            'https://ordetest.xgate.com.au/xGate/ORDE/Webservices/WSI/LenderResponse.asp',
            '{"thirdPartySystem": {"name": "NextGenBCM","dynamicDataParameters": [{"externalField": "nextGenXMLRequestBody"},{"externalField": "messageBatch"},{"externalField": "message"},{"externalField": "appStatus"}],'+
                    '"filters": [{"objectAPI": "genesis__Applications__c","objectAlias": "appInfo",'+
                    '"fields": [{"externalField": "name","fieldAPI": "Name"},{"externalField": "appId","fieldAPI": "Id"},'+
                    '{"externalField": "originatorId","fieldAPI": "Originator_ID__c"}],"whereClause": "Id = :appId"}]}}'
        );
        List<intframework__Integration_API_Configuration__c> integrationAPIConfigList=[SELECT id 
                                                                    FROM intframework__Integration_API_Configuration__c 
                                                                    WHERE Name='test_API_Config'];
        System.assertEquals(
            integrationAPIConfigList.size(),
            1
        );

        //Inserting Legal Entity
        clcommon__Legal_Entity__c legEntity = GenericUtilityTestHelper.returnLegalEntity();
        List<clcommon__Legal_Entity__c> legEntityList=[SELECT id 
                                                        FROM clcommon__Legal_Entity__c 
                                                        WHERE Name='Individual'];
        System.assertEquals(
            legEntityList.size(),
            1
        );
    
        //Inserting Account
        Account acc = GenericUtilityTestHelper.returnBorrowerAccount(legEntity.Id);
        List<Account> accList=[SELECT id 
                                            FROM Account 
                                            WHERE Name='Dummy Account'];
        System.assertEquals(
            accList.size(),
            1
        );
    
        //Inserting CL Product
        clcommon__CL_Product__c clProductName = GenericUtilityTestHelper.insertClProduct();
        List<clcommon__CL_Product__c> clProductList=[SELECT id 
                                            FROM clcommon__CL_Product__c 
                                            WHERE clcommon__Product_Name__c='Residential'];
        System.assertEquals(
            clProductList.size(),
            1
        );

        //Inserting Application
        genesis__applications__c app = GenericUtilityTestHelper.returnApplication(
            acc.Id
        );
        List<genesis__applications__c> appList=[SELECT id 
                                            FROM genesis__applications__c 
                                            WHERE genesis__account__c=:acc.Id];
        System.assertEquals(
            appList.size(),
            1
        );
    
        List<StaticResource> staticResourceList = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXMLOne'
                                            OR Name = 'NextGenApplicationXMLTwo'
                                            OR Name = 'NextGenApplicationXMLThree'
                                            OR Name = 'NextGenApplicationXMLFour'
                                            OR Name = 'NextGenApplicationXMLFive'
                                            OR Name = 'NextGenApplicationXMLSix'
                                            OR Name = 'NextGenApplicationXMLSeven'
                                            OR Name = 'NextGenApplicationXMLEight' 
                                            OR Name='NextGenXMLNine'
                                            OR Name = 'NextGenApplicationXMLNine'
                                            OR Name = 'NextGenApplicationXMLTen'
                                            OR Name = 'NextGenApplicationXML11'
                                            OR Name = 'NextGenApplicationXML12'
                                            OR Name = 'NextGenApplicationXML13'
                                            OR Name = 'NextGenApplicationXML14'
                                            OR Name = 'NextGenApplicationXML15'
                                            OR Name = 'NextGenApplicationXML16'];
        System.assert(
            staticResourceList.size()>0,
            'Static Resource Should not be Empty'
        );

        //Insert Borrower Party Type
        clcommon__Party_Type__c partyType = GenericUtilityTestHelper.insertPartyType(
            ConstantValues.BORROWER
        );
        List<clcommon__Party_Type__c> partyTypeList=[SELECT id 
                                            FROM clcommon__Party_Type__c 
                                            WHERE name=:ConstantValues.BORROWER];
        System.assertEquals(
            partyTypeList.size(),
            1
        );
        
        //Inserting Borrower Party
        clcommon__Party__c party = GenericUtilityTestHelper.createBorowerParty(
            acc,
            partyType.Id,
            app.Id
        );
        List<clcommon__Party__c> partyList=[SELECT id 
                                            FROM clcommon__Party__c 
                                            WHERE clcommon__Account__c=:acc.Id];
        System.assertEquals(
            partyList.size(),
            1
        );
        
        //Insert Application Collaterals
        genesis__Application_Collateral__c appCollateral = GenericUtilityTestHelper.returnAppCollateral(
            app.Id,
            acc.Id
        );
        List<genesis__Application_Collateral__c> appCollateralList=[SELECT id 
                                            FROM genesis__Application_Collateral__c 
                                            WHERE genesis__Application__c=:app.Id];
        System.assertEquals(
            appCollateralList.size(),
            1
        );
        
        //Insert Collateral Type
        clcommon__Collateral_Type__c collateralType = GenericUtilityTestHelper.returnCollType();
        List<clcommon__Collateral_Type__c> collateralTypeList=[SELECT id 
                                            FROM clcommon__Collateral_Type__c 
                                            WHERE Name=: ConstantValues.PROPERTY];
        System.assertEquals(
            collateralTypeList.size(),
            1
        );
    }
    @isTest
    static void createApplicationTestEighteen(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXMLOne'];
        System.assert(
            applicationXML != null, 
            'Static Resource Should not be Empty'
        );
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(
            responseModel.status=='Error found', 
            'SUCCESS'
        );

        List<genesis__applications__c> appList =[SELECT id FROM genesis__applications__c];
        System.assert(
            appList.size()>0, 
            'Application Should not be Empty'
        );
        List<Id> appIdList=new List<Id>();
        appIdList.add(appList[0].id);
        NextGenApplicationPlatformEvent.publishApplicationPlatformEvent(appIdList);
        NextGenBCMCallout.nextGenBCMCallout(appIdList);
        test.stopTest();                                      
    }
    @isTest
    static void createApplicationTestTwo(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXMLTwo'];
        System.assert(
            applicationXML != null, 
            'Static Resource Should not be Empty'
        );
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');

        List<genesis__applications__c> appList =[SELECT id,Solicitor_Status__c FROM genesis__applications__c];
        System.assert(
            appList.size()>0, 
            'Application Should not be Empty'
        );
        appList[0].Solicitor_Status__c =ConstantValues.READY_TO_BOOK;
        update appList;
        System.assertEquals(
            appList[0].Solicitor_Status__c, 
            ConstantValues.READY_TO_BOOK
        );
        List<Id> appIdList=new List<Id>();
        appIdList.add(appList[0].id);
        NextGenApplicationSolicitorStatusChange.publishApplicationPlatformEvent(appIdList);
        NextGenBCMCallout.nextGenBCMCallout(appIdList);
        
        test.stopTest(); 
    }
    @isTest
    static void createApplicationTestThree(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXMLThree'];
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');
        test.stopTest();         
    }
    @isTest
    static void createApplicationTestFour(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXMLFour'];
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');
        test.stopTest();         
    }
    @isTest
    static void createApplicationTestFive(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXMLFive'];
        System.assert(
            applicationXML != null, 
            'Static Resource Should not be Empty'
        );
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');
        test.stopTest();         
    }
    @isTest
    static void createApplicationTestSix(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXMLSix'];
        System.assert(
            applicationXML != null, 
            'Static Resource Should not be Empty'
        );
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');
        test.stopTest();         
    }
    @isTest
    static void createApplicationTestSeven(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXMLSeven'];
        System.assert(
            applicationXML != null, 
            'Static Resource Should not be Empty'
        );
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');
        test.stopTest();         
    }
    @isTest
    static void createApplicationTestEight(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXMLEight'];
        System.assert(
            applicationXML != null, 
            'Static Resource Should not be Empty'
        );
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');
        test.stopTest();         
    }
    @isTest
    static void createApplicationTestNine(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenXMLNine'];
        System.assert(
            applicationXML != null, 
            'Static Resource Should not be Empty'
        );
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');
        test.stopTest();         
    }
    @isTest
    static void createApplicationTestTen(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXMLNine'];
        System.assert(
            applicationXML != null, 
            'Static Resource Should not be Empty'
        );
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');
        test.stopTest();         
    }
    @isTest
    static void createApplicationTestEleven(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXMLTen'];
        System.assert(
            applicationXML != null, 
            'Static Resource Should not be Empty'
        );
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');
        test.stopTest();         
    }
    @isTest
    static void createApplicationTestTwelve(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXML11'];
        System.assert(
            applicationXML != null, 
            'Static Resource Should not be Empty'
        );
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');
        test.stopTest();         
    }
    @isTest
    static void createApplicationTestThirteen(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXML12'];
        System.assert(
            applicationXML != null, 
            'Static Resource Should not be Empty'
        );
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');
        test.stopTest();         
    }
    @isTest
    static void createApplicationTestFourteen(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXML13'];
        System.assert(
            applicationXML != null, 
            'Static Resource Should not be Empty'
        );
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');
        test.stopTest();         
    }
    @isTest
    static void createApplicationTestFifteen(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXML14'];
        System.assert(
            applicationXML != null, 
            'Static Resource Should not be Empty'
        );
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');
        test.stopTest();         
    }
    @isTest
    static void createApplicationTestSixteen(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXML15'];
        System.assert(
            applicationXML != null, 
            'Static Resource Should not be Empty'
        );
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');
        test.stopTest();         
    }
    @isTest
    static void createApplicationTestSeventeen(){
        test.startTest();
        StaticResource applicationXML = [SELECT Id,
                                            Name, Body
                                            FROM StaticResource
                                            WHERE Name = 'NextGenApplicationXML16'];
        System.assert(
            applicationXML != null, 
            'Static Resource Should not be Empty'
        );
        RestRequest req = new RestRequest();        
        req.requestURI = '/services/apexrest/nextgen/Application'; 
        req.requestBody = Blob.valueOf(applicationXML.Body.toString());
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/xml'); 
        RestContext.request = req;
        NextGenResponseDetailHelper responseModel=NextGenAuthetication.createApplication();
        System.assert(responseModel.status=='Error found', 'SUCCESS');
        test.stopTest();         
    }
}