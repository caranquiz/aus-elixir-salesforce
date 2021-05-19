/******************************************************************
Description : This test class provides coverage to LTSMigrationJob and LTSMigrationHandlerJob
                that are  provided by CL to handle transactions present
                on Transaction Summary object and migrate to Loan Transaction Summary
******************************************************************/
public class TestLoan {
    public static loan__Loan_Account__c getLoanAccount(loan__Loan_Account__c loanAcc){
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
        Date currentSystemDate = dateutil.getCurrentSystemDate();
        return [SELECT Name,
                    loan__Last_Transaction_Timestamp__c, 
                    RecordTypeId, 
                    loan__ACH_On__c,
                    loan__ACH_Next_Debit_Date__c,
                    loan__ACH_debit_amount__c,
                    loan__OT_ACH_Debit_Date__c,
                    loan__OT_ACH_Fee_Amount__c,
                    loan__OT_ACH_Payment_Amount__c,
                    loan__Last_Transaction_Type__c,
                    loan__Repayment_Start_Basis__c,
                    loan__Funding_Stop_Basis__c,
                    loan__Total_Refinance_Amount_Actual__c,
                    loan__Branch__c,
                    loan__Branch__r.ID,
                    loan__Branch__r.Name,
                    loan__Interest_Paid__c,
                    loan__Principal_Paid__c,
                    loan__Total_Amount_Paid__c,
                    loan__Total_Amount_Remaining__c,
                    loan__Fees_Paid__c,
                    loan__Penalty_Paid__c,
                    loan__Invalid_Data__c,
                    loan__Interest_On_Overdue_Paid__c,
                    loan__Payment_Tolerance_Rate__c,
                    loan__Principal_Remaining__c, 
                    loan__Interest_Remaining__c,
                    loan__Fees_Remaining__c,
                    loan__Product_Type__c,
                    loan__Payoff_Fee_Indicator__c,
                    loan__Principal_Adjustment__c,
                    loan__Principal_Adjustment_Subtract__c,
                    loan__Total_Due_Charges__c,
                    loan__Next_Repayment_Amount_As_Of_Today__c,
                    loan__Overdue_Amount_As_Of_Today__c ,
                    loan__Pay_Off_Amount_As_Of_Today__c,
                    loan__Number_of_Days_Overdue__c,
                    loan__Frequency_of_Loan_Payment__c,
                    loan__Payment_Frequency_Cycle__c,
                    loan__Time_Counting_Method__c,
                    loan__Pmt_Amt_Cur__c, 
                    loan__Accrual_Start_Days__c,
                    loan__Next_Installment_Date__c , 
                    loan__Next_Due_Generation_Date__c , 
                    loan__Write_off_Tolerance_Amount__c,
                    loan__Minimum_Amount_Due__c,
                    loan__Minimum_Amount_Due_Type__c,
                    loan__Pre_Bill_Days__c ,
                    loan__Last_Accrual_Date__c, 
                    loan__Expected_Disbursal_Date__c,
                    loan__Disbursal_Date__c,
                    loan__Due_Day__c,  
                    loan__Reserve_Amount_for_Next_Due__c,
                    loan__Delinquency_Grace_Days__c,
                    loan__Delinquent_Amount__c,
                    loan__Aging__c,
                    loan__Oldest_Due_Date__c,
                    loan__Previous_Installment_Date__c,
                    loan__Last_Payment_Date__c,
                    loan__Last_Payment_Amount__c,
                    loan__Rate_Change_Dt_Next__c,
                    loan__Interest_Rate_Last__c,
                    loan__Accrual_Start_Date__c,
                    loan__Maturity_Date_Current__c,
                    loan__Term_Cur__c,
                    loan__Total_Amount_Overdue__c,
                    loan__Interest_Rate__c,
                    loan__Loan_Amount__c,
                    loan__Amount_Due_Till_Current__c,
                    loan__Excess__c,
                    loan__Capitalized_Fee__c,
                    loan__Capitalized_Interest__c,
                    loan__Payment_Application_Mode__c,
                    loan__Loan_Balance__c,
                    loan__Credit_Limit_Current__c,
                    loan__Provision_Amount__c, //Added for provision
                    loan__Reschedule_Status__c, //Added for revolving loans
                    loan__Interest_Posted__c,
                    loan__Interest_Posting_Day__c, 
                    loan__Next_Capitalization_Date__c,
                    loan__Interest_Posting_Frequency__c, 
                    loan__Is_Capitalization_Enabled__c, 
                    loan__Is_Interest_Posting_Enabled__c,
                    loan__Next_Interest_Posting_Date__c,
                    loan__Accrual_Stop_Indicator__c,
                    loan__Loan_Status__c,
                    loan__Repayments_Count__c,
                    loan__Number_of_Installments__c,
                    loan__Repayment_Procedure__c,
                    loan__Interest_Calculation_Method__c,
                    loan__Interest_Accrued_Not_Due__c,
                    loan__Interest_Waived__c,
                    loan__la_delinquency_flag__c,
                    loan__Disbursed_Amount__c, //added by Anukrati
                    loan__Grace_Period_for_Repayments__c, // added by darpan
                    loan__Remaining_Loan_Amount__c,
                    loan__Disbursal_Status__c,
                    loan__Last_Disbursal_Amount__c,
                    loan__Last_Disbursal_Date__c,
                    loan__Payment_Amount__c,
                    loan__Payment_Tolerance_Start_Date__c,
                    loan__Payment_Tolerance_End_Date__c,
                    loan__Unpaid_Bills__c,
                    loan__Interest_Rounding_Error__c,
                    loan__Scheduled_Fee_Amount_In_PayOff__c,
                    loan__Loan_Parameters__r.loan__Advance_Interest__c,
                    loan__Loan_Product_Name__c,
                    loan__Loan_Product_Name__r.Name,
                    loan__Loan_Product_Name__r.loan__Fee_Set__c,
                    loan__Loan_Product_Name__r.loan__Accrual_Based_Accounting__c,
                    loan__Loan_Product_Name__r.loan__Product_Loan_Control_Account__c,
                    loan__Loan_Product_Name__r.loan__Product_Overdue_Interest_Account__c,
                    loan__Loan_Product_Name__r.loan__Accrue_Income_On_Suspended_Account__c,
                    loan__Loan_Product_Name__r.loan__General_Rounding_Mode__c,
                    loan__Loan_Product_Name__r.loan__Digits_After_Decimals__c,
                    loan__Savings_Account__r.loan__Savings_Product_Name__c,
                    loan__Savings_Account__r.loan__Savings_Product_Name__r.loan__Interest_Expense_Account__c,
                    loan__Savings_Account__r.loan__Savings_Product_Name__r.loan__Interest_Payable_Account__c,
                    loan__Savings_Account__r.loan__Savings_Product_Name__r.loan__Savings_Product_Control_Account__c,
                    loan__Savings_Account__r.loan__Savings_Product_Name__r.loan__Savings_Product_Control_Account__r.Name,
                    loan__Savings_Account__r.loan__Savings_Product_Name__r.loan__Savings_Product_Control_Account__r.Id,
                    loan__Savings_Account__r.loan__Savings_Product_Name__r.loan__Savings_Product_Control_Account__r.loan__Account_Type__c,
                    loan__Savings_Account__r.loan__Savings_Product_Name__r.loan__Savings_Product_Control_Account__r.loan__Balance__c,
                    loan__Savings_Account__r.loan__Savings_Product_Name__r.loan__Savings_Product_Control_Account__r.loan__Branch__c,
                    loan__Savings_Account__r.loan__Savings_Product_Name__r.loan__Savings_Product_Control_Account__r.loan__Is_Master__c,
                    loan__Savings_Account__r.loan__Savings_Product_Name__r.loan__Accrued_Interest_Payable_Account__c,    
                    loan__Savings_Account__r.loan__Savings_Account_External_Id__c,
                    loan__Savings_Account__c,
                    loan__Savings_Account__r.Id,
                    loan__Uncleared_Repayment_Amount__c,
                    loan__Migration_Date__c,
                    (select Name,
                    loan__Loan_Account__r.loan__Loan_Product_Name__c,
                    loan__Due_Interest__c,
                    loan__Due_Principal__c,
                    loan__Total_Installment__c, 
                    loan__Total_Due_Fees__c,
                    loan__Total_Paid_Fees__c,
                    loan__Unpaid_Fees__c,
                    loan__isPaid__c,
                    loan__Date_Paid__c,
                    loan__Interest_Accrued_Not_Due__c,
                    loan__Due_Date__c
                    from loan__Repayment_Schedule__r
                    where loan__Due_Date__c > :currentSystemDate
                    and loan__is_Archived__c = false),
                    (select ID, 
                    loan__Fee__c,
                    loan__Overdue_Amount__c
                    from loan__Overdue_Fee__r ),
                    (select Id,
                    loan__Balance_Amount__c,
                    loan__Due_Amt__c,
                    loan__Due_Date__c,
                    loan__Due_Type_Description__c,
                    loan__Due_Type__c,
                    loan__Payment_Amt__c,
                    loan__Payment_Date__c,
                    loan__DD_Primary_Flag__c ,
                    loan__Payment_Satisfied__c,
                    loan__Tolerance__c,
                    loan__Transaction_Date__c
                    from loan__Dues_Details__r
                    where loan__DD_Primary_Flag__c = true and loan__Payment_Satisfied__c = false
                    order by loan__Due_Date__c desc),
                    (select Id,
                                 Name,
                    loan__Accrue_Interest_From__c,
                    loan__Calculated_Interest2__c, // deprecated
                    loan__Charge_Type__c,
                    loan__Date__c,
                    loan__Fee__c,
                    loan__Interest_Bearing__c,
                    loan__Interest_Rate__c,
                    loan__Original_Amount__c,
                    loan__Paid_Amount__c,
                    loan__Reference__c,
                    loan__Total_Amount_Due__c,
                    loan__Waive__c,
                    loan__Waived_Principal__c,
                    loan__Paid__c,
                    loan__Principal_Due__c,
                    loan__Interest_Due__c,
                    loan__Waived_Interest__c,
                    loan__Calculated_Interest3__c,
                    CreatedDate,
                    loan__Last_Accrual_Date__c
                    from loan__Charges__r
                    where loan__Waive__c = false
                    and loan__Paid__c = false
                    ORDER BY loan__Date__c ASC) // this order is important
                    from loan__Loan_Account__c where ID =:loanAcc.id];
    }
     
         public static void insertObjEventMapData(){
        List<loan__Object_Event_Mapping__c> objects = new List<loan__Object_Event_Mapping__c>();
        List<loan__Object_Event_Mapping__c> event = [SELECT Id from loan__Object_Event_Mapping__c];
        if(event ==null || event.size() == 0){
            //Bills
            loan__Object_Event_Mapping__c obj1 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_DUE_DETAIL_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.BILL_TYPE_DEFAULT,loan__Transaction_Type__c=loan.LoanConstants.BILL_TYPE_DEFAULT);
            objects.add(obj1);
            loan__Object_Event_Mapping__c obj2 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_DUE_DETAIL_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.BILL_TYPE_IOA,loan__Transaction_Type__c=loan.LoanConstants.BILL_TYPE_IOA);
            objects.add(obj2);
            loan__Object_Event_Mapping__c obj3 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_DUE_DETAIL_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.BILL_TYPE_PREPAYMENT,loan__Transaction_Type__c=loan.LoanConstants.BILL_TYPE_PREPAYMENT);
            objects.add(obj3);
            //Interest Posting
            loan__Object_Event_Mapping__c obj4 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.INTEREST_POSTING_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.REGULAR_INTEREST_POSTING_TYPE,loan__Transaction_Type__c=loan.LoanConstants.NORMAL_INTEREST_POSTING_TYPE);
            objects.add(obj4);
            loan__Object_Event_Mapping__c obj5 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.INTEREST_POSTING_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.EXCESS_INTEREST_POSTING_TYPE,loan__Transaction_Type__c=loan.LoanConstants.CLOSE_OFF_EXCESS_INTEREST_POSTING_TYPE);
            objects.add(obj5);
            loan__Object_Event_Mapping__c obj6 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.INTEREST_POSTING_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.ADJUSTMENT_INTEREST_POSTING_TYPE,loan__Transaction_Type__c=loan.LoanConstants.ADJUSTMENT_INTEREST_POSTING_TYPE);
            objects.add(obj6);
            loan__Object_Event_Mapping__c obj7 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.INTEREST_POSTING_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.INTEREST_POSTING_IOA_ON_IOA,loan__Transaction_Type__c=loan.LoanConstants.IOA_ON_IOA);
            objects.add(obj7);
            loan__Object_Event_Mapping__c obj8 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.INTEREST_POSTING_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.IOA_ON_UNPAID_PRINCIPAL_INTREST,loan__Transaction_Type__c=loan.LoanConstants.IOA_ON_UNPAID_PRINCIPAL_INTREST);
            objects.add(obj8);
            //Payment Transaction
            loan__Object_Event_Mapping__c obj9 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_PAYMENT_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_PAYMENT_MODE_WAIVED,loan__Transaction_Type__c=loan.LoanConstants.LOAN_PAYMENT_MODE_WAIVED);
            objects.add(obj9);
            loan__Object_Event_Mapping__c obj10 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_PAYMENT_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_PAYMENT_STATUS_SETTLED,loan__Transaction_Type__c=loan.LoanConstants.LOAN_PAYMENT_STATUS_SETTLED);
            objects.add(obj10);
            loan__Object_Event_Mapping__c obj11 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_PAYMENT_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_PAYMENT_STATUS_SOLD,loan__Transaction_Type__c=loan.LoanConstants.LOAN_PAYMENT_STATUS_SOLD);
            objects.add(obj11);
            loan__Object_Event_Mapping__c obj12 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_PAYMENT_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_PAYMENT_REGULAR,loan__Transaction_Type__c=loan.LoanConstants.LOAN_PAYMENT_STATUS_REGULAR);
            objects.add(obj12);
            loan__Object_Event_Mapping__c obj13 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_PAYMENT_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_REBATE,loan__Transaction_Type__c=loan.LoanConstants.LOAN_PAYMENT_STATUS_REBATE);
            objects.add(obj13);
            loan__Object_Event_Mapping__c obj14 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_PAYMENT_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_PAYMENT_STATUS_CLOSURE_TOLERANCE,loan__Transaction_Type__c=loan.LoanConstants.LOAN_PAYMENT_STATUS_CLOSURE_TOLERANCE);
            objects.add(obj14);
            loan__Object_Event_Mapping__c obj15 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_PAYMENT_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_PRINCIPAL_SUB,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_PRINCIPAL_SUB);
            objects.add(obj15);
            loan__Object_Event_Mapping__c obj16 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_PAYMENT_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.EXCESS_LOAN_PAYMENT,loan__Transaction_Type__c=loan.LoanConstants.LOAN_PAYMENT_MODE_EXCESS);
            objects.add(obj16);
            loan__Object_Event_Mapping__c obj17 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_PAYMENT_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_PAYMENT_STATUS_WRITEOFF_RECOVERY,loan__Transaction_Type__c=loan.LoanConstants.LOAN_PAYMENT_STATUS_WRITEOFF_RECOVERY);
            objects.add(obj17);
            loan__Object_Event_Mapping__c obj18 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_PAYMENT_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.PAYMENT_REFINANCE,loan__Transaction_Type__c=loan.LoanConstants.LOAN_PAYMENT_STATUS_REFINANCE);
            objects.add(obj18);
            loan__Object_Event_Mapping__c obj19 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_PAYMENT_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_PAYMENT_STATUS_DEPOSIT_PAYMENT,loan__Transaction_Type__c=loan.LoanConstants.LOAN_PAYMENT_STATUS_DEPOSIT_PAYMENT);
            objects.add(obj19);
            loan__Object_Event_Mapping__c obj20 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_PAYMENT_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.PAYMENT_CANCELLED,loan__Transaction_Type__c=loan.LoanConstants.LOAN_PAYMENT_STATUS_CANCELLED);
            objects.add(obj20);
            //Other Loan Transaction   
            loan__Object_Event_Mapping__c obj21 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_RESCHEDULE,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_RESCHEDULE);
            objects.add(obj21);
            loan__Object_Event_Mapping__c obj22 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_EXTENSION,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_EXTENSION);
            objects.add(obj22);
            loan__Object_Event_Mapping__c obj23 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_PRINCIPAL_ADD,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_PRINCIPAL_ADD);
            objects.add(obj23);
            loan__Object_Event_Mapping__c obj24 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_REFUND,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_REFUND);
            objects.add(obj24);
            loan__Object_Event_Mapping__c obj25 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_ADDITIONAL_REPAYMENT,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_ADDITIONAL_REPAYMENT);
            objects.add(obj25);
            loan__Object_Event_Mapping__c obj26 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_RATE_CHANGE,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_RATE_CHANGE);
            objects.add(obj26);
            loan__Object_Event_Mapping__c obj27 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_TOLERANCE_CHANGE,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_TOLERANCE_CHANGE);
            objects.add(obj27);
            loan__Object_Event_Mapping__c obj28 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_CHARGE_OFF,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_CHARGE_OFF);
            objects.add(obj28);
            loan__Object_Event_Mapping__c obj29 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_PayOff_Quote_Generation,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_PayOff_Quote_Generation);
            objects.add(obj29);
            loan__Object_Event_Mapping__c obj30 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_DUE_DAY_CHANGE,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_DUE_DAY_CHANGE);
            objects.add(obj30);
            loan__Object_Event_Mapping__c obj31 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_CREDIT_LIMIT_CHANGE,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_CREDIT_LIMIT_CHANGE);
            objects.add(obj31);
            loan__Object_Event_Mapping__c obj32 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_INDEX_RATE_CHANGE,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_INDEX_RATE_CHANGE);
            objects.add(obj32);
            loan__Object_Event_Mapping__c obj33 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_DELINQUENT_PMT_PLAN_REV,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_DELINQUENT_PMT_PLAN_REV);
            objects.add(obj33);
            loan__Object_Event_Mapping__c obj34 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_CONTINGENCY_STATUS_CHANGE,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_CONTINGENCY_STATUS_CHANGE);
            objects.add(obj34);
            loan__Object_Event_Mapping__c obj35 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_RATE_CHANGE_REV,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_RATE_CHANGE_REV);
            objects.add(obj35);
            loan__Object_Event_Mapping__c obj36 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_CHARGE_OFF_REV,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_CHARGE_OFF_REV);
            objects.add(obj36);
            loan__Object_Event_Mapping__c obj37 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_CHANGE,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_CHANGE);
            objects.add(obj37);
            loan__Object_Event_Mapping__c obj38 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_CHANGE_REV,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_CHANGE_REV);
            objects.add(obj38);
            loan__Object_Event_Mapping__c obj39 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_REFUND_REV,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_REFUND_REV);
            objects.add(obj39);
            loan__Object_Event_Mapping__c obj40 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_DELINQUENT_PMT_PLAN,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_DELINQUENT_PMT_PLAN);
            objects.add(obj40);
            loan__Object_Event_Mapping__c obj41 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_EXTENSION_REV,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_EXTENSION_REV);
            objects.add(obj41);
            //Charge
            loan__Object_Event_Mapping__c obj42 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_CHARGE_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_CHARGE,loan__Transaction_Type__c=loan.LoanConstants.LOAN_CHARGE);
            objects.add(obj42);
            //Disbursal
            loan__Object_Event_Mapping__c obj43 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_DISBURSAL_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.DISBURSAL_TYPE_PRINCIPAL_ADD,loan__Transaction_Type__c=loan.LoanConstants.DISBURSAL_TYPE_PRINCIPAL_ADD);
            objects.add(obj43);
            loan__Object_Event_Mapping__c obj44 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.LOAN_DISBURSAL_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.REGULAR_DISBURSAL_TYPE,loan__Transaction_Type__c=loan.LoanConstants.DISBURSAL_TYPE_REGULAR);
            objects.add(obj44);
            //Disbursal Reversal
            loan__Object_Event_Mapping__c obj45 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.DISBURSAL_REVERSAL_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_DISBURSAL_REVERSAL,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_DISBURSAL_REVERSAL);
            objects.add(obj45);
            //Payment Reversal
            loan__Object_Event_Mapping__c obj46 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.REPAYMET_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_REVERSAL,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_REVERSAL);
            objects.add(obj46);
            //OLT
            loan__Object_Event_Mapping__c obj47 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_DDC,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_DDC);
            objects.add(obj47);
            
            loan__Object_Event_Mapping__c obj49 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.INTEREST_POSTING_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.ADDITIONAL_INTEREST_INTEREST_POSTING_TYPE,loan__Transaction_Type__c=loan.LoanConstants.ADDITIONAL_INTEREST_INTEREST_POSTING_TYPE);
            objects.add(obj49); //ND-3760
            //ND-3759
            loan__Object_Event_Mapping__c obj50 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.ADDITIONAL_INTEREST_RATE_CHANGE,loan__Transaction_Type__c=loan.LoanConstants.ADDITIONAL_INTEREST_RATE_CHANGE);
            objects.add(obj50); 
            loan__Object_Event_Mapping__c obj51 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.ADDITIONAL_INTEREST_RATE_CHANGE_REV,loan__Transaction_Type__c=loan.LoanConstants.ADDITIONAL_INTEREST_RATE_CHANGE_REV);
            objects.add(obj51); 
            //End ND-3759
            loan__Object_Event_Mapping__c obj52 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_LOAN_AMOUNT_ADD,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_LOAN_AMOUNT_ADD);
            objects.add(obj52); 
            loan__Object_Event_Mapping__c obj53 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.OTHER_LOAN_TXN_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.LOAN_TRANSACTION_LOAN_AMOUNT_SUB,loan__Transaction_Type__c=loan.LoanConstants.LOAN_TRANSACTION_LOAN_AMOUNT_SUB);
            objects.add(obj53); 
            //ND-3852
            loan__Object_Event_Mapping__c obj54 = new loan__Object_Event_Mapping__c(loan__API_Name__c=loan.LoanConstants.INTEREST_POSTING_LOOKUP,loan__Transaction_Name__c=loan.LoanConstants.ADJUSTMENT_ENTRY_INTEREST_POSTING_TYPE,loan__Transaction_Type__c=loan.LoanConstants.ADJUSTMENT_ENTRY_INTEREST_POSTING_TYPE);
            objects.add(obj54); 

            Database.insert(objects); 
        }

    }
}