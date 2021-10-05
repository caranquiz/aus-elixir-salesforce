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
  
  public void runLPTFileGen() {

    loan.GlobalLoanUtilFacade glutil = new loan.GlobalLoanUtilFacade();
    String loanIdList;
    Set<Id> apsList=new Set<Id>();
    Date systemDate=!Test.isRunningTest()?glutil.getCurrentSystemDate():Date.today();
    List<loan__Automated_Payment_Setup__c> objAPSList=[SELECT id,
                                                              loan__CL_Contract__c,
                                                              loan__Debit_Date__c,
                                                              loan__CL_Contract__r.Name
                                                            FROM loan__Automated_Payment_Setup__c
                                                            WHERE loan__Debit_Date__c=:systemDate];
    List<ProcessInstance> objProcessInstance =[SELECT Id,
                                                      Status,
                                                      TARGETOBJECTID
                                                    FROM ProcessInstance 
                                                    WHERE TARGETOBJECTID in:objAPSList 
                                                    AND Status=: ConstantValues.PENDING];
    
    for(ProcessInstance objProcess:objProcessInstance){
      apsList.add(objProcess.TARGETOBJECTID);
    }
    for(loan__Automated_Payment_Setup__c objAPS:objAPSList){
      if(apsList.contains(objAPS.id)){
        if(loanIdList==null){
          loanIdList=objAPS.loan__CL_Contract__r.Name;
        }else{
          loanIdList=loanIdList+' '+objAPS.loan__CL_Contract__r.Name;
        }
      }
    }
    if(objProcessInstance.size()>0){
      ApexPages.addMessage(
        new ApexPages.message(
          ApexPages.severity.WARNING,
          loanIdList+ConstantValues.APPROVAL_PENDING
        )
      );
    }else{
      List<clcommon__DAG_Schedule__c> dagScheduler=[SELECT id,
                                                          clcommon__Cron_Expression__c,
                                                          clcommon__DAG_Name__c 
                                                        FROM clcommon__DAG_Schedule__c 
                                                        WHERE clcommon__DAG_Name__c=:ConstantValues.DAG_NAME];
      if(dagScheduler.size()>0){
        clcommon.DynamicJobRoot obj=new clcommon.DynamicJobRoot(dagScheduler[0]);
        obj.execute(null);
      }
      
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.severity.CONFIRM,
          'Loan Payment ABA File Generation has been started successfully'
        )
      );
    }
    
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