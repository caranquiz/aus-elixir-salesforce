/****************************************************************************************************/
/* Description          : This test class mostly covers DEReturnFileProcessor visualforce
 page controller class. */
/* Testing Scenario 1   : (testWithValidFile) tests with some valid return file. */
/* Testing Scenario 2   : (testWithNoFileSet) tests with no return file provided. */
/****************************************************************************************************/

@isTest
private class DEReturnFileProcessorTest {
  @isTest
  static void testWithValidFile() {
    List<StaticResource> sr = new List<StaticResource>(
      [
        SELECT Id, Name, Body
        FROM StaticResource
        WHERE Name = 'deReturnSampleReport'
        LIMIT 1
      ]
    );
    System.assertEquals(sr.size(), 1, 'Static Resource not found');
    Test.startTest();
    DEReturnFileProcessor deReturnFileProcessObject = new DEReturnFileProcessor();
    deReturnFileProcessObject.returnFileBody = Blob.valueOf(
      sr[0].Body.toString()
    );
    deReturnFileProcessObject.processReturns();
    Test.stopTest();
    ApexPages.Message[] pageMessages = ApexPages.getMessages();
    System.assertNotEquals(
      0,
      pageMessages.size(),
      'Page messages size is not zero'
    );
    Boolean messageFound = false;
    for (ApexPages.Message message : pageMessages) {
      if (
        message.getSummary() == ConstantValues.RETURN_FILE_PROCESSED &&
        message.getDetail() == ConstantValues.RETURN_FILE_PROCESSED &&
        message.getSeverity() == ApexPages.severity.CONFIRM
      ) {
        messageFound = true;
      }
    }
    System.assert(messageFound, 'Expected message not found');
  }
  @isTest
  static void testWithNoFileSet() {
    Test.startTest();
    DEReturnFileProcessor deReturnFileProcessObject = new DEReturnFileProcessor();
    deReturnFileProcessObject.processReturns();
    Test.stopTest();
    ApexPages.Message[] pageMessages = ApexPages.getMessages();
    System.assertNotEquals(
      0,
      pageMessages.size(),
      'Page messages size is not zero'
    );
    Boolean messageFound = false;
    for (ApexPages.Message message : pageMessages) {
      if (
        message.getSummary() == 'Argument cannot be null.' &&
        message.getDetail() == 'Argument cannot be null.' &&
        message.getSeverity() == ApexPages.severity.ERROR
      ) {
        messageFound = true;
      }
    }
    System.assert(messageFound, 'Expected message not found');
  }
}
