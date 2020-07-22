/****************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : GenericUtility */
/* Created Date         : 20/07/2020 */
/* Developed By         : Rameswari Barman */
/* Description          : This class contains some common methods to use. */
/* Last Modified Date   : 20/07/2020 */
/* Last Modified By     : Rameswari Barman */
/****************************************************************************************************/
public with sharing class GenericUtility {
  /*** This method is used to insert logs, for debug purpose ***/
  public static void insertLog(String name, Exception ex) {
    Database.insert(
      new clcommon__Log__c(
        Name = name,
        clcommon__Message__c = name +
          '|::Exception occured in::' +
          ex.getStackTraceString() +
          '|::Error::' +
          ex.getMessage() +
          ' at Line Number::' +
          ex.getLineNumber(),
        clcommon__Time__c = System.Now()
      )
    );
  }
}