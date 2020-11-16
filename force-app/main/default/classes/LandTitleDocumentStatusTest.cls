/****************************************************************************************************/
/* Class Name: LandTitleDocumentStatusTest */
/* Developed By: Souvik Dey */
/* Description : This is the Test class for LandTitleDocumentStatus */
/* Testing Scenario 1   : (testRest) tests with Apex rest API request */
/****************************************************************************************************/

@isTest
private with sharing class LandTitleDocumentStatusTest {
    @TestSetup
    static void initialize(){
        GenericUtilityTestHelper.getCollateral('', '155A', 'CRANEBROOK', 'ROAD', 'NORTH SYDNEY', 'NSW', '2060');
        List<clcommon__Collateral__c> collList = [SELECT Id FROM clcommon__Collateral__c];
        System.assertEquals(collList.size(), 1, 'Collateral not inserted');
    }
    @isTest
    static void testRest() {
        List<clcommon__Collateral__c> collList = [SELECT Id, Name
            FROM clcommon__Collateral__c];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/DocumentStatus/';
        List <StaticResource> srList = [SELECT Id, Name, Body
            FROM StaticResource WHERE Name = 'Land_Title_Document_Status'];
        System.assertEquals(srList.size() > 0, true, 'Static Resource is present!');
        String postData = srList[0].Body.toString();
        postData = postData.replace('Collateral_Ref', collList[0].Name);
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        LandTitleDocumentStatus.createRecord();
        Test.stopTest();
        collList = [SELECT Id, Document_Status__c, Document_Enquiry_Id__c
            FROM clcommon__Collateral__c];
        System.assertEquals(collList[0].Document_Status__c, 'READY', 'Collateral status is not as Expected');
        System.assertEquals(collList[0].Document_Enquiry_Id__c, '140805-MFDUX-0000Q', 'Document Enquiry Id is not as Expected');
    }
}