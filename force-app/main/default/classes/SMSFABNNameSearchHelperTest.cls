/****************************************************************************************************
Description          : This test class mostly covers SMSFABNNameSearchHelper class.
Testing Scenario 1   : (testMethod1) This test method will test with a valid response from the
static resource and checks if successfully parsed. 
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Pratik Agarwal
Development Date : 2/09/2020
Last Modified Date : 14/10/2020
****************************************************************************************************/

@isTest
class SMSFABNNameSearchHelperTest {
  @isTest
  static void testMethod1() {
    //Querying already saved XML file
    List<StaticResource> srList = [
      SELECT Id, Name, Body
      FROM StaticResource
      WHERE Name = 'ABNNameSearchDummyXML'
    ];
    System.assertEquals(srList.size(), 1, 'Static Resource not found');
    dom.Document doc = new dom.Document();
    doc.load(srList[0].Body.toString());
    Map<String, Object> responseMap = intframework.XmlToJson.parseDocumentToMap(doc);
    System.assert(responseMap != null, 'Parse document to Map failed');

    String json = System.JSON.serialize(responseMap);
    System.assert(json != null, 'Parse document to JSON failed');

    Test.startTest();
    SMSFABNNameSearchHelper obj = SMSFABNNameSearchHelper.parse(json);
    System.assert(obj != null, 'Response Helper returned null');
    Test.stopTest();    
  }
}