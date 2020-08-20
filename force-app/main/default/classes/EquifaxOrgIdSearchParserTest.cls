/****************************************************************************************************/
/* Description          : This test class mostly covers EquifaxOrgIdSearchParser class. */
/* Testing Scenario 1   : (testMethod1) This test method will test with a valid response from the
 static resource and checks if successfully parsed. */
/****************************************************************************************************/

@isTest
class EquifaxOrgIdSearchParserTest {
  @isTest
  static void testMethod1() {
    //Querying already saved XML file
    List<StaticResource> srList = [
      SELECT Id, Name, Body
      FROM StaticResource
      WHERE Name = 'EquifaxMockResponse'
    ];
    System.assertEquals(srList.size(), 1, 'Static Resource not found');
    dom.Document doc = new dom.Document();
    doc.load(srList[0].Body.toString());
    Map<String, Object> responseMap = intframework.XmlToJson.parseDocumentToMap(doc);
    System.assert(responseMap != null, 'Parse document to Map failed');

    String json = System.JSON.serialize(responseMap);
    System.assert(json != null, 'Parse document to JSON failed');

    Test.startTest();
    EquifaxOrgIdSearchParser obj = EquifaxOrgIdSearchParser.parse(json);
    System.assert(obj != null, 'Response Helper returned null');
    Test.stopTest();    
  }
}