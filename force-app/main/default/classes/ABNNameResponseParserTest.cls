/***** Description : Acts as a test class for ABNNameReponseParserTest
Developer - Soumik Sarkar
*******/
@IsTest
public class ABNNameResponseParserTest {
    
    static testMethod void testParse() {
        StaticResource ABNNameResponse = [SELECT Body
                                  FROM StaticResource 
                                  WHERE Name = 'ABNNameResponseParser'
                                  LIMIT 1];
        String json = JSON.serialize(ABNNameResponse);

        ABNNameResponseParser obj = ABNNameResponseParser.parse(json);
        System.assert(obj != null);
    }
}