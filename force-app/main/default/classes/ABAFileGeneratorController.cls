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
    loan.GlobalLoanUtilFacade glutil = new loan.GlobalLoanUtilFacade();
    Date systemDate=!Test.isRunningTest()?glutil.getCurrentSystemDate():Date.today();
    List<loan__Automated_Payment_Setup__c> objAPSList=[SELECT id,
                                                              Name,
                                                              loan__CL_Contract__c,
                                                              loan__Debit_Date__c,
                                                              loan__CL_Contract__r.Name
                                                            FROM loan__Automated_Payment_Setup__c
                                                            WHERE loan__Debit_Date__c=:systemDate 
                                                            OR Debit_Date_Change__c=:systemDate];
    List<ProcessInstance> objProcessInstance =[SELECT Id,
                                                      Status,
                                                      TARGETOBJECTID
                                                    FROM ProcessInstance 
                                                    WHERE TARGETOBJECTID in:objAPSList 
                                                    AND Status='Pending'];
    String loanIdList;
    Set<Id> apsList=new Set<Id>();
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
          loanIdList+' is Pending for Approval'
        )
      );
    }else{
      List<clcommon__DAG_Schedule__c> dagScheduler=[SELECT id,
                                                          clcommon__Cron_Expression__c,
                                                          clcommon__DAG_Name__c 
                                                        FROM clcommon__DAG_Schedule__c 
                                                        WHERE clcommon__DAG_Name__c='Generate LPTs, create bank files and run payment clearing job'];
      
      clcommon.DynamicJobRoot obj=new clcommon.DynamicJobRoot(dagScheduler[0]);
      obj.execute(null);
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.severity.CONFIRM,
          'Loan Payment ABA File Generation has been started successfully'
        )
      );
      /*Datetime startTime;
      Datetime endTime=Datetime.now();
      startTime=endTime.addMinutes(-10);
      List<loan__Batch_Process_Log__c> batchLogList=[SELECT id,
                                                      loan__Message__c,
                                                      loan__Time__c,
                                                      loan__Type__c 
                                                    FROM loan__Batch_Process_Log__c 
                                                    WHERE loan__Type__c='Exception' 
                                                    AND loan__Time__c>=:startTime 
                                                    AND loan__Time__c<:endTime];
      system.debug('BatchLog-->'+batchLogList);
      List<String> apsListId=new List<String>();
      for(loan__Automated_Payment_Setup__c objAPS:objAPSList){
        apsListId.add(objAPS.id);
      }
      String apsId1,message;
      for(loan__Batch_Process_Log__c batchLog:batchLogList){
        System.debug('hiii'+apsListId);
          System.debug('hello'+batchLog.loan__Message__c);
          if(batchLog.loan__Message__c.contains('Exception while commiting the Payment transactions.')){
            String str=batchLog.loan__Message__c;
            String separator='; first error:';
            String separator1=' with id ';
            String separator2='Cause: null';
            Integer sepPos = str.indexOf(separator);
            Integer sepPos1 = str.indexOf(separator1);
            Integer sepPos2 = str.indexOf(separator2);
            apsId1=str.substring(sepPos1+separator1.length(),sepPos);
            message=str.substring(sepPos+separator.length(),sepPos2);
          }
      
      }
      List<loan__Automated_Payment_Setup__c> automatedPayment=[SELECT id,
                                                                      Name,
                                                                      loan__CL_Contract__r.Name
                                                                    FROM loan__Automated_Payment_Setup__c 
                                                                    WHERE id=:apsId1];
      if(message!=null){
        ApexPages.addMessage(
          new ApexPages.message(
            ApexPages.severity.WARNING,
            message+' for '+automatedPayment[0].Name+' ('+automatedPayment[0].loan__CL_Contract__r.Name+')'
          )
        );
      }*/
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