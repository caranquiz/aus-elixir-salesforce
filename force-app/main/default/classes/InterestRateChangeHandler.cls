/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Rameswari Barman
Development Date : 12/04/2022
Last Modified By : Rameswari Barman
Last Modified Date : 12/04/2022
Description : This class is used to update stored interest rates when processing of rates 
              needs to be in future or a huge number of loans at once
 
***********************************************************************************************************************************************************/
public with sharing class InterestRateChangeHandler {
    public static void updateRate(List< loan__Loan_Account__c> loanList) {
        Date currentSysDate =(Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
        List< loan__Loan_Account__c> updatedLoanList = new List< loan__Loan_Account__c>();
        Integer interestOnlyPeriod,noOfInstallments,noOfFlexPmnts = 1;
        Savepoint sp = Database.setSavepoint();
        List <clcommon__Repayment_Plan__c> repList = [SELECT Id 
                                                        FROM clcommon__Repayment_Plan__c 
                                                        WHERE loan__Loan_Account__c In : loanList];
        if(repList.isEmpty() == FALSE){
            Database.delete(repList,false);
        }
        if(loanList.isEmpty() == FALSE){
            for(loan__Loan_Account__c loanAcc : loanList){
                try{
                    if(loanAcc.New_Interest_Rate__c != loanAcc.loan__Interest_Rate__c){
                        Date systemDate = currentSysDate;
                        ID loanID = loanAcc.Id;
                        Date transactionDate = systemDate;
                        if(loanAcc.Remaining_Term_from_Schedule__c != NULL){
                            noOfInstallments = Integer.ValueOf(loanAcc.Remaining_Term_from_Schedule__c);
                        }
                        else{
                            throw new CustomException(ConstantValues.TOTAL_NO_OF_INSTALLMENTS_MISSING);
                        }
                        if(loanAcc.Remaining_IO_Period__c != NULL){
                            interestOnlyPeriod = Integer.ValueOf(loanAcc.Remaining_IO_Period__c);
                        }
                        else{
                            throw new CustomException(ConstantValues.INTEREST_ONLY_PERIOD_MISSING);
                        }
                        if(loanAcc.loan__Due_Day__c == NULL){
                            throw new CustomException(ConstantValues.NEW_DUE_DAY_MISSING);
                        }
                        String frequencyOfPayment = loanAcc.loan__Frequency_of_Loan_Payment__c;
                        Boolean actualInterestOnlyPayments = true;
                        Map<String, Object> rescheduleParametersmap = new Map<String, Object>();
                        rescheduleParametersmap.put('Loan_Account__c', loanID);
                        rescheduleParametersmap.put('Txn_Date__c', loanAcc.New_Interest_Rate_Effective_Date__c);
                        if(loanAcc.First_Repayment_Date_After_IR_Change__c != NULL){
                            rescheduleParametersmap.put('Repayment_Start_Date__c',Date.newInstance(loanAcc.First_Repayment_Date_After_IR_Change__c.year(),
                                    loanAcc.First_Repayment_Date_After_IR_Change__c.month(),
                                    Integer.ValueOf(loanAcc.loan__Due_Day__c)));
                        }
                        rescheduleParametersmap.put('Interest_Rate__c', loanAcc.New_Interest_Rate__c);
                        rescheduleParametersmap.put('Maintain_Delinquency__c', true);
                        if(noOfInstallments >= 0){
                            rescheduleParametersmap.put('Number_of_Installments__c', noOfInstallments);
                        }
                        else{
                            throw new CustomException(ConstantValues.TOTAL_NO_OF_INSTALLMENTS_MISSING);
                        }
                        if(interestOnlyPeriod >= 0){
                            rescheduleParametersmap.put('Interest_Only_Period__c', interestOnlyPeriod);
                        }
                        else{
                            throw new CustomException(ConstantValues.INTEREST_ONLY_PERIOD_MISSING);
                        }
                        if(loanAcc.loan__Frequency_of_Loan_Payment__c != NULL){
                            rescheduleParametersmap.put('Frequency_of_Loan_Payment__c', loanAcc.loan__Frequency_of_Loan_Payment__c);
                        }
                        else{
                            throw new CustomException(ConstantValues.LOAN_FREQUENCY_IS_MISSING);
                        }
                        rescheduleParametersmap.put('Reschedule_Balance__c', ConstantValues.PRINCIPAL_REMAINING);
                        rescheduleParametersmap.put('New_Due_Day__c', Integer.ValueOf(loanAcc.loan__Due_Day__c));
                        loan.LoanRescheduleParameters rescheduleParams = new loan.LoanRescheduleParameters(rescheduleParametersmap);
                        if(loanAcc.Remaining_IO_Period__c > 0 || (loanAcc.New_Interest_Rate__c < loanAcc.loan__Interest_Rate__c)){
                            //Might need to put in IO Period logic in future releases so keeping this block
                        }
                        else if((loanAcc.Interest_Rate_Change_Notification_Date__c).daysBetween(loanAcc.First_Repayment_Date_After_IR_Change__c) < 
                            Integer.ValueOf(System.Label.Min_No_of_Notice_Period_for_IR_change)){
                            List<loan.LoanRescheduleParameters.ProposedRepaymentPlan> repaymentPlanList = new list<loan.LoanRescheduleParameters.ProposedRepaymentPlan>();
                            List<clcommon__Repayment_Plan__c> repaymentPlan = new List<clcommon__Repayment_Plan__c>();
                            if(noOfInstallments > 120 && (loanAcc.Remaining_Term_from_Schedule__c >= 5)){
                                noOfFlexPmnts = Integer.ValueOf(loanAcc.Remaining_Term_from_Schedule__c-5);
                            }
                            else if(loanAcc.Remaining_Term_from_Schedule__c >= 2){
                                noOfFlexPmnts = Integer.ValueOf(loanAcc.Remaining_Term_from_Schedule__c-2);
                            }
                            repaymentPlan.add(new clcommon__Repayment_Plan__c(clcommon__Sequence_Number__c = 1,
                                clcommon__Payment_Type__c = ConstantValues.EQUAL_MONTHLY_INSTALLMENTS,
                                clcommon__Number_Of_Payments__c = 1,
                                clcommon__Effective_Date__c = loanAcc.New_Interest_Rate_Effective_Date__c,
                                clcommon__Payment_Start_Date__c = Date.newInstance(loanAcc.First_Repayment_Date_After_IR_Change__c.year(),
                                    loanAcc.First_Repayment_Date_After_IR_Change__c.month(),
                                    Integer.ValueOf(loanAcc.loan__Due_Day__c)),
                                clcommon__Payment_Amount__c = loanAcc.loan__Pmt_Amt_Cur__c,
                                clcommon__Frequency__c = frequencyOfPayment,
                                clcommon__Due_Day__c = Integer.ValueOf(loanAcc.loan__Due_Day__c)));
                            if(loanAcc.Second_Repayment_Date_After_IR_Change__c != NULL){
                                repaymentPlan.add(new clcommon__Repayment_Plan__c(clcommon__Sequence_Number__c = 2,
                                clcommon__Payment_Type__c = ConstantValues.EQUAL_MONTHLY_INSTALLMENTS,
                                clcommon__Number_Of_Payments__c = noOfFlexPmnts,
                                clcommon__Effective_Date__c = loanAcc.New_Interest_Rate_Effective_Date__c,
                                clcommon__Payment_Start_Date__c = Date.newInstance(loanAcc.Second_Repayment_Date_After_IR_Change__c.year(),
                                    loanAcc.Second_Repayment_Date_After_IR_Change__c.month(),
                                    Integer.ValueOf(loanAcc.loan__Due_Day__c)),
                                clcommon__Payment_Amount__c = loanAcc.Calculated_Upcoming_Repayment_Amount__c,
                                clcommon__Frequency__c = frequencyOfPayment,
                                clcommon__Due_Day__c = Integer.ValueOf(loanAcc.loan__Due_Day__c)));
                            }
                            for (clcommon__Repayment_Plan__c eachRepaymentPlan : repaymentPlan) {
                                loan.LoanRescheduleParameters.ProposedRepaymentPlan repayPlan = 
                                    new loan.LoanRescheduleParameters.ProposedRepaymentPlan(eachRepaymentPlan,true,null,null);
                                repaymentPlanList.add(repayPlan);
                            }
                            rescheduleParams.setRepaymentPlan(repaymentPlanList); 
                            loanAcc.Flat_Repayment_Amount__c= loanAcc.loan__Pmt_Amt_Cur__c;
                            loanAcc.First_Repayment_Date__c  = loanAcc.First_Repayment_Date_After_IR_Change__c;
                            loanAcc.Second_Repayment_Date__c= loanAcc.Second_Repayment_Date_After_IR_Change__c;
                        }
                        else if((loanAcc.Interest_Rate_Change_Notification_Date__c).daysBetween(loanAcc.First_Repayment_Date_After_IR_Change__c) >= 
                            Integer.ValueOf(System.Label.Min_No_of_Notice_Period_for_IR_change)){
                            List<loan.LoanRescheduleParameters.ProposedRepaymentPlan> repaymentPlanList = new list<loan.LoanRescheduleParameters.ProposedRepaymentPlan>();
                            List<clcommon__Repayment_Plan__c> repaymentPlan = new List<clcommon__Repayment_Plan__c>();
                            if(noOfInstallments > 120 && (loanAcc.Remaining_Term_from_Schedule__c >= 4)){
                                noOfFlexPmnts = Integer.ValueOf(loanAcc.Remaining_Term_from_Schedule__c-4);
                            }
                            else if(loanAcc.Remaining_Term_from_Schedule__c >= 1){
                                noOfFlexPmnts = Integer.ValueOf(loanAcc.Remaining_Term_from_Schedule__c-1);
                            }
                            repaymentPlan.add(new clcommon__Repayment_Plan__c(clcommon__Sequence_Number__c = 1,
                                clcommon__Payment_Type__c = ConstantValues.EQUAL_MONTHLY_INSTALLMENTS,
                                clcommon__Number_Of_Payments__c = noOfFlexPmnts,
                                clcommon__Effective_Date__c = loanAcc.New_Interest_Rate_Effective_Date__c,
                                clcommon__Payment_Start_Date__c = Date.newInstance(loanAcc.First_Repayment_Date_After_IR_Change__c.year(),
                                    loanAcc.First_Repayment_Date_After_IR_Change__c.month(),
                                    Integer.ValueOf(loanAcc.loan__Due_Day__c)),
                                clcommon__Payment_Amount__c = loanAcc.Calculated_Upcoming_Repayment_Amount__c,
                                clcommon__Frequency__c = frequencyOfPayment,
                                clcommon__Due_Day__c = Integer.ValueOf(loanAcc.loan__Due_Day__c)));
                            for (clcommon__Repayment_Plan__c eachRepaymentPlan : repaymentPlan) {
                                loan.LoanRescheduleParameters.ProposedRepaymentPlan repayPlan = 
                                    new loan.LoanRescheduleParameters.ProposedRepaymentPlan(eachRepaymentPlan,true,null,null);
                                repaymentPlanList.add(repayPlan);
                            }
                            rescheduleParams.setRepaymentPlan(repaymentPlanList);  
                        }
                        loan.LoanActionFactory factory = new loan.LoanActionFactory();
                        loan.LoanAction10 loanAction = factory.getLoanAction10API();
                        loanAction.rescheduleALoan(rescheduleParams);
                        loan__Loan_Account__c objLoanAccount = new loan__Loan_Account__c();
                        objLoanAccount.Id = loanAcc.Id;
                        objLoanAccount.New_Interest_Change_Status__c = ConstantValues.RATE_CHANGED_SUCCESS+loanAcc.New_Interest_Rate__c+ConstantValues.SUCCESSFULLY;
                        if(loanAcc.Remaining_IO_Period__c > 0){
                            objLoanAccount.Flat_Repayment_Amount__c= loanAcc.loan__Pmt_Amt_Cur__c;
                        }else if((loanAcc.Interest_Rate_Change_Notification_Date__c).daysBetween(loanAcc.First_Repayment_Date_After_IR_Change__c) > 
                            Integer.ValueOf(System.Label.Min_No_of_Notice_Period_for_IR_change) &&
                            loanAcc.Remaining_IO_Period__c == 0){
                                objLoanAccount.Flat_Repayment_Amount__c= loanAcc.Calculated_Upcoming_Repayment_Amount__c;
                        }else{
                            objLoanAccount.Flat_Repayment_Amount__c= loanAcc.loan__Pmt_Amt_Cur__c;
                        }
                        objLoanAccount.First_Repayment_Date__c  = loanAcc.First_Repayment_Date_After_IR_Change__c;
                        objLoanAccount.Second_Repayment_Date__c= loanAcc.Second_Repayment_Date_After_IR_Change__c;
                        objLoanAccount.New_Interest_Rate__c = NULL;
                        objLoanAccount.New_Interest_Rate_Effective_Date__c = NULL;
                        objLoanAccount.First_Repayment_Date_After_IR_Change__c = NULL;
                        objLoanAccount.Second_Repayment_Date_After_IR_Change__c = NULL;
                        objLoanAccount.Scheduled_Balance_As_at_IR_change_date__c = NULL;
                        updatedLoanList.add(objLoanAccount);
                    }
                }
                catch(Exception e){
                    Database.rollback(sp);
                    GenericUtility.insertLog('InterestRateChangeHandler',e);
                    loan__Loan_Account__c objLoanAccount = new loan__Loan_Account__c();
                    objLoanAccount.Id = loanAcc.Id;
                    objLoanAccount.New_Interest_Change_Status__c = ConstantValues.RATE_CHANGE_FAILURE_MSG+e.getMessage() ;
                    updatedLoanList.add(objLoanAccount);
                }
            }
            update updatedLoanList;
        }
    }
}