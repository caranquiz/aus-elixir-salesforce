/****************************************************************************************************/
/* Class Name: JsonObjectToArrayTest */
/* Developed By: Souvik Dey */
/* Description : This is the Test class for JsonObjectToArray */
/* Testing Scenario 1   : (testWithNullQuery) tests with single null query provided in the parameter */
/* Testing Scenario 2   : (testWithNullQueries) tests with multiple null queries provided in the
parameter */
/* Testing Scenario 3   : (testWithEmptyQueries) tests with empty query list of strings */
/* Testing Scenario 4   : (testWithOneData) tests with a single key (provided in the parameter) is
present in the response */
/* Testing Scenario 5   : (testWithOneRepeatData) tests with repeated key (provided in the parameter)
are present in the response */
/* Testing Scenario 6   : (testWithMultipleData) tests with multiple queries provided in the parameter */
/* Testing Scenario 7   : (testWithMultipleRepeatData) tests with multiple queries provided in the
parameter and repeated key present in the response */
/* Testing Scenario 8   : (testWithIrrelevantData) tests with irrelevant key and response string */
/* Testing Scenario 9   : (testWithMultipleIrrelevantData) tests with multiple irrelevant keys and
response string */
/****************************************************************************************************/

@isTest
private class JsonObjectToArrayTest {
  @isTest
  static void testWithNullQuery() {
    String response = '"pKey":{"cKey":"cKeyValue"}';
    JsonObjectToArray obj = new JsonObjectToArray();
    obj.modifyRecur(response, null);
    String newResult = obj.root;
    System.assertEquals(
      newResult,
      '',
      'Testing with null query mismatched with the expected value'
    );
  }
  @isTest
  static void testWithNullQueries() {
    String response = '"pKey":{"cKey":"cKeyValue"}';
    JsonObjectToArray obj = new JsonObjectToArray();
    String newResult = obj.modifyAllByRecur(response, null);
    System.assertEquals(
      newResult,
      response,
      'Testing with null query mismatched with the expected value'
    );
  }
  @isTest
  static void testWithEmptyQueries() {
    String response = '"pKey":{"cKey":"cKeyValue"}';
    JsonObjectToArray obj = new JsonObjectToArray();
    String newResult = obj.modifyAllByRecur(response, new List<String>());
    System.assertEquals(
      newResult,
      response,
      'Testing with null query mismatched with the expected value'
    );
  }
  @isTest
  static void testWithOneData() {
    String query = '"pKey1":';
    String response = '"pKey0":{}, "pKey1":{{}}, "pKey2":{{{}}}';
    String modifiedResponse = '"pKey0":{}, "pKey1":[{{}}], "pKey2":{{{}}}';

    JsonObjectToArray obj = new JsonObjectToArray();
    obj.modifyRecur(response, query);
    String newResult = obj.root;
    System.assertEquals(
      modifiedResponse,
      newResult,
      'Testing with one data mismatched with the expected value'
    );
  }
  @isTest
  static void testWithOneRepeatData() {
    String query = '"pKey1":';
    String response = '"pKey0":{},"pKey1":{{}},"pKey2":{{{}}},"pKey1":{{}}';
    String modifiedResponse = '"pKey0":{},"pKey1":[{{}}],"pKey2":{{{}}},"pKey1":[{{}}]';

    JsonObjectToArray obj = new JsonObjectToArray();
    obj.modifyRecur(response, query);
    String newResult = obj.root;
    System.assertEquals(
      modifiedResponse,
      newResult,
      'Testing with one repeat data mismatched with the expected value'
    );
  }
  @isTest
  static void testWithMultipleData() {
    List<String> queries = new List<String>();
    queries.add('"pKey1":');
    queries.add('"pKey2":');
    queries.add('"pKey3":');
    queries.add('"pKey4":');

    String testData = '[';

    String data1 = '{"pParam1":{"cParam1":"data1"},"pParam2":"data2"}';
    testData += '"pKey1":' + data1 + ',';
    String data2 = '{{{}}}';
    testData += '"pKey2":' + data2 + ',';
    String data3 = '[{}]';
    testData += '"pKey3":' + data3 + ',';
    String data4 = '{{}[{},{}]{}}';
    testData += '"pKey4":' + data4 + ']';
    String expectedModifiedResponse =
      '["pKey1":[' +
      data1 +
      '],"pKey2":[' +
      data2 +
      '],"pKey3":' +
      data3 +
      ',"pKey4":[' +
      data4 +
      ']]';
    JsonObjectToArray obj = new JsonObjectToArray();
    String newResult = obj.modifyAllByRecur(testData, queries);
    System.assertEquals(
      expectedModifiedResponse,
      newResult,
      'Modified response of Testing with multiple repeat data didn\'t match with the expected value'
    );
  }

  @isTest
  static void testWithMultipleRepeatData() {
    List<String> queries = new List<String>();
    queries.add('"pKey1":');
    queries.add('"pKey2":');
    queries.add('"pKey3":');
    queries.add('"pKey4":');
    String testData = '[';
    String data1 = '{"pParam1":{"cParam1":"data1"},"pParam2":"data2"}';
    testData += '"pKey1":' + data1 + ',';
    String data2 = '{{{}}}';
    testData += '"pKey2":' + data2 + ',';
    String data3 = '[{}]';
    testData += '"pKey3":' + data3 + ',';
    String data4 = '{{}[{},{}]{}}';
    testData += '"pKey4":' + data4 + ']';
    testData += '"pKey2":' + data2;
    String expectedModifiedResponse =
      '["pKey1":[' +
      data1 +
      '],"pKey2":[' +
      data2 +
      '],"pKey3":' +
      data3 +
      ',"pKey4":[' +
      data4 +
      ']]' +
      '"pKey2":[' +
      data2 +
      ']';
    JsonObjectToArray obj = new JsonObjectToArray();
    String newResult = obj.modifyAllByRecur(testData, queries);
    System.assertEquals(
      expectedModifiedResponse,
      newResult,
      'Modified response of Testing with multiple repeat data didn\'t match with the expected value'
    );
  }
  @isTest
  static void testWithIrrelevantData() {
    String query = 'DATA';
    String response = 'INVALID DATA';
    String modifiedResponse = '';
    JsonObjectToArray obj = new JsonObjectToArray();
    obj.modifyRecur(response, query);
    String newResult = obj.root;
    System.assertEquals(
      modifiedResponse,
      newResult,
      'Modified response of Testing with multiple irrelevant data didn\'t match with the expected value'
    );
  }
  @isTest
  static void testWithMultipleIrrelevantData() {
    List<String> queries = new List<String>();
    queries.add('IN');
    queries.add('VALID');
    String response = 'INVALID DATA';
    String modifiedResponse = 'INVALID DATA';
    JsonObjectToArray obj = new JsonObjectToArray();
    String newResult = obj.modifyAllByRecur(response, queries);
    System.assertEquals(
      modifiedResponse,
      newResult,
      'Modified response of Testing with multiple irrelevant data didn\'t match with the expected value'
    );
  }
}