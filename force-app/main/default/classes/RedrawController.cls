/***********************************************
Developer - Khalid Fazlullah
Development Date - 12/11/2019
Description -  Controller class for withrawing deposit amount - used during redraw when the respective button is clicked in CL contratc
************************************************/

public class RedrawController {
  public loan__Loan_Account__c acct { get; set; }
  public String redrawAmount { get; set; }
  public String message { get; set; }
  public class MyException extends Exception {
  }
  public RedrawController() {
    acct = [
      SELECT Id, Name
      FROM loan__Loan_Account__c
      WHERE Id = :ApexPages.currentPage().getParameters().get('loanId')
    ];
  }
  public PageReference doRedraw() {
    try {
      if (redrawAmount != null && Decimal.valueOf(redrawAmount) <= 0) {
        throw new MyException(System.label.Redraw_Error_Msg);
      }
      clcommon__Deposit__c dep = [
        SELECT id, clcommon__Parent_Deposit__c, loan__Loan_Account__c
        FROM clcommon__Deposit__c
        WHERE
          clcommon__Parent_Deposit__c = null
          AND loan__Loan_Account__c = :ApexPages.currentPage()
            .getParameters()
            .get('loanId')
      ];
      List<loan.LoanAccountParameters.Deposit> depositParametersList1 = new List<loan.LoanAccountParameters.Deposit>();
      loan.LoanAccountParameters.Deposit deposit2 = new loan.LoanAccountParameters.Deposit(
        dep.Id,
        false,
        true,
        false
      );
      deposit2.setDepositAdjustmentAmount(-Decimal.valueOf(redrawAmount));
      depositParametersList1.add(deposit2);
      loan.LoanAccountParameters loanAccountParams = new loan.LoanAccountParameters(
        ApexPages.currentPage().getParameters().get('loanId')
      );
      loanAccountParams.setDepositList(depositParametersList1);
      List<loan.LoanAccountParameters> loanAccountParamList = new List<loan.LoanAccountParameters>();
      loanAccountParamList.add(loanAccountParams);
      loan.LoanActionFactory lAFactory = new loan.LoanActionFactory();
      loan.AbstractLoanActions loanActions = lAFactory.getLoanActionsAPI();
      loanActions.changeDepositAction(loanAccountParamList, null);
      message = System.label.Redraw_Success_Msg;
      return new Pagereference(
        '/' + ApexPages.currentPage().getParameters().get('loanId')
      );
    } catch (Exception e) {
      insert new clcommon__Batch_Process_Log__c(
        clcommon__Message__c = 'RedrawController :' +
          e.getStackTraceString() +
          ':Error::' +
          e.getMessage(),
        clcommon__Timestamp__c = System.Now(),
        clcommon__Log_Level__c = 'ERROR'
      );
      return null;
    }
  }
  public PageReference cancel() {
    return new Pagereference(
      '/' + ApexPages.currentPage().getParameters().get('loanId')
    );
  }
}
