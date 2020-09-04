/******************************************************************************************************************/
/* Description          : This class is the controller class of the DE_Return_Processing Visualforce page */
/******************************************************************************************************************/

public class DEReturnFileProcessor {
    public Blob returnFileBody { get; set; }
    public string returnFileAsString { get; set; }
    public List<peer__Bank_Recon_Exception__c> exceptionList { get; set; }
  
    public void processReturns() {
      try {
        if (returnFileBody == null) {
          throw new CustomException(ConstantValues.UPLOAD_RETURN_VF_NULL_ERROR);
        }
        returnFileAsString = returnFileBody.toString();
        // Calling LoanPaymentReturnFileHandler class to process the return file
        LoanPaymentReturnFileHandler fileHandlerObj = new LoanPaymentReturnFileHandler();
        exceptionList = fileHandlerObj.parse(returnFileAsString);
        // Showing message if successfully processed
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.severity.CONFIRM,
            ConstantValues.RETURN_FILE_PROCESSED
          )
        );
      } catch (Exception e) {
        GenericUtility.insertLog(ConstantValues.RETURN_FILE_PROCESS_VF_EXCEP, e);
        // Showing message if any exception occurred
        ApexPages.addMessage(
          new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage())
        );
      }
    }
  }