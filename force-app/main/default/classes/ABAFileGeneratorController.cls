/******************************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : ABAFileGeneratorController */
/* Created Date         : 13/10/2020 */
/* Developed By         : Souvik */
/* Description          : This class is the controller class of the ABA File Generator Visualforce page */
/* Last Modified Date   : 13/10/2020 */
/* Last Modified By     : Souvik */
/******************************************************************************************************************/

public with sharing class ABAFileGeneratorController {
  public void nothing() {
  }
  public void runLPTFileGen() {
    Database.executeBatch(new loan.LoanPaymentFilegenJob(), 200);
    ApexPages.addMessage(
      new ApexPages.Message(
        ApexPages.severity.CONFIRM,
        'Loan Payment ABA File Generation has been started successfully'
      )
    );
  }
  public void runLDTFileGen() {
    Database.executeBatch(new loan.LoanDisbursalFilegenJob(), 200);
    ApexPages.addMessage(
      new ApexPages.Message(
        ApexPages.severity.CONFIRM,
        'Loan Disbursal ABA File Generation has been started successfully'
      )
    );
  }
}