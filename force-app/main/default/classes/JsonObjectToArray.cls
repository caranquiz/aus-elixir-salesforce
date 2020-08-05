/****************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : JsonObjectToArray */
/* Created Date         : 01/08/2020 */
/* Developed By         : Souvik */
/* Description          : In the new integration framework the XmlToJson class's parseDocumentToMap
method converts xml format string into json format string. When response returns multiple data in xml
converting it to json will create an array but if response returns single data in xml converting it to
json will create an object. This issue is fixed using this class. This class will convert json objects
into arrays by specifying the key. */
/* Last Modified Date   : 04/08/2020 */
/* Last Modified By     : Souvik */
/****************************************************************************************************/

public without sharing class JsonObjectToArray {
    String start;
    String rest;
    Integer thirdBraceCount;
    Integer secondBraceCount;
    Integer ref;
    Boolean flag;
  
    public String root;
    public JsonObjectToArray() {
      root = '';
    }
    void processFurther(Integer ind, String query) {
      if (rest.subString(ind, ind + 1) == '[' && flag == true) {
        thirdBraceCount += 1;
      } else if (rest.subString(ind, ind + 1) == ']' && flag == true) {
        thirdBraceCount -= 1;
      } else if (rest.subString(ind, ind + 1) == '{' && flag == true) {
        secondBraceCount += 1;
      } else if (rest.subString(ind, ind + 1) == '}' && flag == true) {
        secondBraceCount -= 1;
      }
    }
    Boolean processData(Integer ind, String query) {
      if (rest.subString(ind, ind + 1) == '[' && flag == false) {
        root += start;
        modifyRecur(rest, query);
        return true;
      } else if (rest.subString(ind, ind + 1) == '{' && flag == false) {
        start += rest.subString(0, ind) + '[';
        ref = ind;
        flag = true;
        secondBraceCount += 1;
      } else {
        processFurther(ind, query);
      }
      if (thirdBraceCount == 0 && secondBraceCount == 0 && flag == true) {
        start += rest.subString(ref, ind + 1) + ']';
        root += start;
        rest = rest.subString(ind + 1, rest.length());
        modifyRecur(rest, query);
        return true;
      }
      return false;
    }
    void modifyRecur(String queryString, String query) {
      if (query == null) {
        return;
      }
      Integer ind = queryString.indexof(query);
      if (ind == -1) {
        root += queryString;
        return;
      }
      start = queryString.subString(0, ind + query.length());
      rest = queryString.subString(ind + query.length());
      flag = false;
      thirdBraceCount = 0;
      secondBraceCount = 0;
      ref = 0;
      if (rest == null || rest.length() < 1) {
        return;
      }
      for (ind = 0; ind < rest.length(); ind++) {
        if (processData(ind, query)) {
          return;
        }
      }
      root = queryString;
      return;
    }
    public String modifyAllByRecur(String queryString, List<String> queries) {
      try {
        if (queries == null || queries.isEmpty()) {
          return queryString;
        }
        for (String each : queries) {
          modifyRecur(queryString, each);
          queryString = root;
          root = '';
        }
      } catch (Exception ex) {
        GenericUtility.insertLog('JsonObject2Array',ex);
      }
      return queryString;
    }
  }