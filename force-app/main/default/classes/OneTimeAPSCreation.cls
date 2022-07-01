/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Ariz Mazhary
Development Date : 12/04/2022
Last Modified By : Ariz Mazhary
Last Modified Date : 12/04/2022
Description : This class is used to update APS Transaction Amount.

***********************************************************************************************************************************************************/

public class OneTimeAPSCreation {
@InvocableMethod(
    label='Create APS For P&I Loan with Flat Repayment Amount'
    description='Create APS For P&I Loan when Flat Repayment Amount is not null'
    )
    public static void oneTimeAPSCreationPILoan(List<Id> apsIdList){
        Date currentSysDate =(Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
        try{
            String myString='loan__Automated_Payment_Setup__c';
            String queryString='SELECT ';
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(myString).getDescribe().fields.getMap();
            for(String s : objectFields.keySet()) {
                queryString+=  s + ',';
            }
            queryString=queryString.removeEnd(',');
            queryString+=' FROM loan__Automated_Payment_Setup__c WHERE id IN: apsIdList';
            
            List<loan__Automated_Payment_Setup__c> objAPSList=Database.query(queryString);
            List<loan__Automated_Payment_Setup__c> objAPSRecordList=new List<loan__Automated_Payment_Setup__c>();
            List<Id> contractIdList=new List<Id>();
            List<Id> loanIdList=new List<Id>();
            for(loan__Automated_Payment_Setup__c objAPS:objAPSList){
                contractIdList.add(objAPS.loan__CL_Contract__c);
            }
            List<loan__Loan_Account__c> objLoanAccountList=[SELECT id,
                                                                Name,
                                                                New_Interest_Rate__c,
                                                                New_Interest_Rate_Effective_Date__c,
                                                                loan__Next_Installment_Date__c,
                                                                Calculated_Upcoming_Repayment_Amount__c,
                                                                loan__Interest_Rate__c,
                                                                Repayment_Type__c ,
                                                                Remaining_Loan_Term__c,
                                                                Remaining_Term_from_Schedule__c,
                                                                Remaining_IO_Period__c,
                                                                loan__Due_Day__c,
                                                                loan__Frequency_of_Loan_Payment__c,
                                                                Interest_Rate_Change_Notification_Date__c,
                                                                First_Repayment_Date_After_IR_Change__c,
                                                                Second_Repayment_Date_After_IR_Change__c,
                                                                loan__Pmt_Amt_Cur__c,
                                                                loan__Interest_Rate_Last__c,
                                                                loan__Uncleared_Repayment_Amount__c,
                                                                APS_Status__c,
                                                                Flat_Repayment_Amount__c,
                                                                First_Repayment_Date__c,
                                                                Second_Repayment_Date__c
                                                                FROM loan__Loan_Account__c 
                                                                WHERE id in: contractIdList];

            Map<Id,Decimal> flatRepaymentAmount=new Map<Id,Decimal>();
            Map<Id,Date> firstRepaymentDate=new Map<Id,Date>();
            Map<Id,Date> secondRepaymentDate=new Map<Id,Date>();
            for(loan__Loan_Account__c objLoanAccount:objLoanAccountList){
                flatRepaymentAmount.put(objLoanAccount.id,objLoanAccount.Flat_Repayment_Amount__c);
                firstRepaymentDate.put(objLoanAccount.id,objLoanAccount.First_Repayment_Date__c);
                secondRepaymentDate.put(objLoanAccount.id,objLoanAccount.Second_Repayment_Date__c);

            }
            for(loan__Loan_Account__c loanAcc : objLoanAccountList){
                for(loan__Automated_Payment_Setup__c objAPS:objAPSList){
                    if(objAPS.loan__CL_Contract__c==loanAcc.id){
                        if(loanAcc.loan__Interest_Rate__c < loanAcc.loan__Interest_Rate_Last__c){
                            loanAcc.APS_Status__c=ConstantValues.APS_DIDNT_CHANGE;
                        }else{
                            if((loanAcc.Remaining_IO_Period__c > 0 || 
                                (loanAcc.Interest_Rate_Change_Notification_Date__c !=null &&
                                loanAcc.First_Repayment_Date__c!=null && 
                                (loanAcc.Interest_Rate_Change_Notification_Date__c).daysBetween(loanAcc.First_Repayment_Date__c) >= 
                                Integer.ValueOf(System.Label.Min_No_of_Notice_Period_for_IR_change) &&
                                loanAcc.Remaining_IO_Period__c == 0)) && 
                                objAPS.loan__Amount_Type__c==ConstantValues.FIXED_AMOUNT &&
                                flatRepaymentAmount.containsKey(objAPS.loan__CL_Contract__c) &&
                                flatRepaymentAmount.get(objAPS.loan__CL_Contract__c)!=null &&
                                (loanAcc.loan__Pmt_Amt_Cur__c!=null &&
                                objAPS.loan__Transaction_Amount__c < flatRepaymentAmount.get(objAPS.loan__CL_Contract__c) &&
                                objAPS.loan__Type__c!=ConstantValues.ONE_TIME) && 
                                objAPS.loan__Debit_Date__c!=null &&
                                (loanAcc.Interest_Rate_Change_Notification_Date__c).daysBetween(objAPS.loan__Debit_Date__c) <= 33
                            ){
                                
                                loanAcc.APS_Status__c=ConstantValues.APS_updated_Successfully;
                                if(objAPS.loan__Frequency__c==ConstantValues.weekly && 
                                    loanAcc.loan__Pmt_Amt_Cur__c!=null &&
                                    ((loanAcc.Remaining_IO_Period__c > 0 &&
                                    objAPS.loan__Transaction_Amount__c <loanAcc.loan__Pmt_Amt_Cur__c/4) ||
                                    (loanAcc.Remaining_IO_Period__c == 0 &&
                                    objAPS.loan__Transaction_Amount__c < flatRepaymentAmount.get(objAPS.loan__CL_Contract__c)/4))){
                                    objAPS.loan__Amount_Type__c=ConstantValues.CURRENT_PAYMENT_AMOUNT;
                                    objAPS.loan__Amount_Type_Split_Factor__c=4;
                                    if(loanAcc.Remaining_IO_Period__c > 0){
                                    objAPS.loan__Transaction_Amount__c=loanAcc.loan__Pmt_Amt_Cur__c/4;
                                    }else{
                                        objAPS.loan__Transaction_Amount__c=flatRepaymentAmount.get(objAPS.loan__CL_Contract__c)/4;
                                    }
                                    objAPS.Created_after_reschedule__c=true;

                                }else if(objAPS.loan__Frequency__c==ConstantValues.biWeekly && 
                                    loanAcc.loan__Pmt_Amt_Cur__c!=null &&
                                    (loanAcc.Remaining_IO_Period__c > 0 &&
                                    objAPS.loan__Transaction_Amount__c <loanAcc.loan__Pmt_Amt_Cur__c/2) ||
                                    (loanAcc.Remaining_IO_Period__c == 0 &&
                                    objAPS.loan__Transaction_Amount__c < flatRepaymentAmount.get(objAPS.loan__CL_Contract__c)/2)){
                                    objAPS.loan__Amount_Type__c=ConstantValues.CURRENT_PAYMENT_AMOUNT;
                                    objAPS.loan__Amount_Type_Split_Factor__c=2;
                                    if(loanAcc.Remaining_IO_Period__c > 0){
                                        objAPS.loan__Transaction_Amount__c=loanAcc.loan__Pmt_Amt_Cur__c/2;
                                    }else{
                                        objAPS.loan__Transaction_Amount__c=flatRepaymentAmount.get(objAPS.loan__CL_Contract__c)/2;
                                    }
                                    objAPS.Created_after_reschedule__c=true;
                                }else if((objAPS.loan__Frequency__c==ConstantValues.monthly || 
                                        objAPS.loan__Frequency__c==ConstantValues.Billing_Frequency) && 
                                        loanAcc.loan__Pmt_Amt_Cur__c!=null &&
                                        ((loanAcc.Remaining_IO_Period__c > 0 &&
                                        objAPS.loan__Transaction_Amount__c < loanAcc.loan__Pmt_Amt_Cur__c) ||
                                        (loanAcc.Remaining_IO_Period__c == 0 &&
                                        objAPS.loan__Transaction_Amount__c < flatRepaymentAmount.get(objAPS.loan__CL_Contract__c)))){
                                    objAPS.loan__Amount_Type_Split_Factor__c=1;
                                    if(loanAcc.Remaining_IO_Period__c > 0){
                                        objAPS.loan__Amount_Type__c=ConstantValues.LAST_BILLED_AMOUNT;
                                        objAPS.loan__Transaction_Amount__c=loanAcc.loan__Pmt_Amt_Cur__c;

                                    }else{
                                        objAPS.loan__Amount_Type__c=ConstantValues.CURRENT_PAYMENT_AMOUNT;
                                        objAPS.loan__Transaction_Amount__c=flatRepaymentAmount.get(objAPS.loan__CL_Contract__c);
                                    }
                                    objAPS.Created_after_reschedule__c=true;
                                }else{
                                    loanAcc.APS_Status__c=ConstantValues.APS_DIDNT_CHANGE;
                                }
                            }else if(loanAcc.Interest_Rate_Change_Notification_Date__c !=null &&
                                loanAcc.First_Repayment_Date__c!=null &&
                                (loanAcc.Interest_Rate_Change_Notification_Date__c).daysBetween(loanAcc.First_Repayment_Date__c) < 
                                Integer.ValueOf(System.Label.Min_No_of_Notice_Period_for_IR_change) &&
                                loanAcc.Remaining_IO_Period__c == 0 && 
                                objAPS.loan__Amount_Type__c==ConstantValues.FIXED_AMOUNT &&
                                objAPS.loan__Transaction_Amount__c!=null &&
                                flatRepaymentAmount.containsKey(objAPS.loan__CL_Contract__c) &&
                                flatRepaymentAmount.get(objAPS.loan__CL_Contract__c)!=null &&
                                objAPS.loan__Transaction_Amount__c < flatRepaymentAmount.get(objAPS.loan__CL_Contract__c) &&
                                objAPS.loan__Type__c!=ConstantValues.ONE_TIME && 
                                objAPS.loan__Debit_Date__c !=null &&
                                (loanAcc.Interest_Rate_Change_Notification_Date__c).daysBetween(objAPS.loan__Debit_Date__c) <= 33
                            ){
                                loanAcc.APS_Status__c=ConstantValues.APS_updated_Successfully;
                                if(objAPS.loan__Frequency__c==ConstantValues.weekly && 
                                        objAPS.loan__Transaction_Amount__c < (flatRepaymentAmount.get(objAPS.loan__CL_Contract__c)/4)){
                                    objAPS.loan__Transaction_Amount__c=flatRepaymentAmount.get(objAPS.loan__CL_Contract__c)/4;
                                    objAPS.loan__Amount_Type_Split_Factor__c=4;
                                    objAPS.loan__Amount_Type__c=ConstantValues.CURRENT_PAYMENT_AMOUNT;
                                    objAPS.Created_after_reschedule__c=true;
                                }else if(objAPS.loan__Frequency__c==ConstantValues.biWeekly && 
                                    objAPS.loan__Transaction_Amount__c < (flatRepaymentAmount.get(objAPS.loan__CL_Contract__c)/2)
                                ){
                                    objAPS.loan__Transaction_Amount__c = flatRepaymentAmount.get(objAPS.loan__CL_Contract__c)/2;
                                    objAPS.loan__Amount_Type_Split_Factor__c = 2;
                                    objAPS.loan__Amount_Type__c = ConstantValues.CURRENT_PAYMENT_AMOUNT;
                                    objAPS.Created_after_reschedule__c=true;
                                }else if(objAPS.loan__Frequency__c==ConstantValues.monthly || 
                                    objAPS.loan__Frequency__c==ConstantValues.Billing_Frequency
                                ){
                                    if(objAPS.loan__Debit_Date__c==firstRepaymentDate.get(objAPS.loan__CL_Contract__c)){
                                        if(secondRepaymentDate.containsKey(objAPS.loan__CL_Contract__c) &&
                                            secondRepaymentDate.get(objAPS.loan__CL_Contract__c)!=null 
                                        ){
                                            objAPS.loan__Debit_Date__c=secondRepaymentDate.get(objAPS.loan__CL_Contract__c);
                                            objAPS.loan__Debit_Day__c=(secondRepaymentDate.get(objAPS.loan__CL_Contract__c)).day();
                                            objAPS.loan__Actual_Date__c=secondRepaymentDate.get(objAPS.loan__CL_Contract__c);
                                        }
                                        objAPS.loan__Amount_Type__c=ConstantValues.CURRENT_PAYMENT_AMOUNT;
                                        objAPS.loan__Amount_Type_Split_Factor__c=1;
                                        objAPS.Created_after_reschedule__c=true;
                                        objAPSRecordList.add(objAPS);
                                    }else{
                                        loanAcc.APS_Status__c=ConstantValues.FAIL_TO_UPDATE_APS;
                                    }
                                }else{
                                    loanAcc.APS_Status__c=ConstantValues.APS_DIDNT_CHANGE;
                                }
                            }else if(loanAcc.Interest_Rate_Change_Notification_Date__c !=null &&
                                loanAcc.First_Repayment_Date__c!=null &&
                                (loanAcc.Interest_Rate_Change_Notification_Date__c).daysBetween(loanAcc.First_Repayment_Date__c) < 
                                Integer.ValueOf(System.Label.Min_No_of_Notice_Period_for_IR_change) &&
                                loanAcc.Remaining_IO_Period__c == 0 &&
                                objAPS.loan__Amount_Type__c!=ConstantValues.FIXED_AMOUNT &&
                                objAPS.loan__Type__c!=ConstantValues.ONE_TIME &&
                                flatRepaymentAmount.containsKey(objAPS.loan__CL_Contract__c) &&
                                flatRepaymentAmount.get(objAPS.loan__CL_Contract__c)!=null && 
                                objAPS.loan__Debit_Date__c !=null &&
                                (loanAcc.Interest_Rate_Change_Notification_Date__c).daysBetween(objAPS.loan__Debit_Date__c) <= 33
                            ){
                                if(objAPS.loan__Frequency__c==ConstantValues.monthly || objAPS.loan__Frequency__c==ConstantValues.Billing_Frequency){
                                    if(objAPS.loan__Debit_Date__c==firstRepaymentDate.get(objAPS.loan__CL_Contract__c)){
                                        loanAcc.APS_Status__c=ConstantValues.APS_updated_Successfully;
                                        if(secondRepaymentDate.containsKey(objAPS.loan__CL_Contract__c) &&
                                            secondRepaymentDate.get(objAPS.loan__CL_Contract__c)!=null 
                                        ){
                                            objAPS.loan__Debit_Date__c=secondRepaymentDate.get(objAPS.loan__CL_Contract__c);
                                            objAPS.loan__Debit_Day__c=(secondRepaymentDate.get(objAPS.loan__CL_Contract__c)).day();
                                            objAPS.loan__Actual_Date__c=secondRepaymentDate.get(objAPS.loan__CL_Contract__c);
                                        }
                                        
                                        objAPS.loan__Amount_Type__c=ConstantValues.CURRENT_PAYMENT_AMOUNT;
                                        objAPS.loan__Amount_Type_Split_Factor__c=1;
                                        objAPS.Created_after_reschedule__c=true;
                                        objAPSRecordList.add(objAPS);
                                    }else{
                                        loanAcc.APS_Status__c=ConstantValues.FAIL_TO_UPDATE_APS;
                                    }
                                }else{
                                    loanAcc.APS_Status__c=ConstantValues.APS_DIDNT_CHANGE;
                                }
                            }else{
                                if(objAPS.loan__Type__c==ConstantValues.ONE_TIME){
                                    if(flatRepaymentAmount.containsKey(objAPS.loan__CL_Contract__c) &&
                                        flatRepaymentAmount.get(objAPS.loan__CL_Contract__c)!=null 
                                    ){
                                        objAPS.loan__Transaction_Amount__c=flatRepaymentAmount.get(objAPS.loan__CL_Contract__c);
                                    }
                                    if(firstRepaymentDate.containsKey(objAPS.loan__CL_Contract__c) &&
                                        firstRepaymentDate.get(objAPS.loan__CL_Contract__c)!=null 
                                    ){
                                        objAPS.loan__Debit_Date__c=firstRepaymentDate.get(objAPS.loan__CL_Contract__c);
                                        objAPS.loan__Debit_Day__c=(firstRepaymentDate.get(objAPS.loan__CL_Contract__c)).day();
                                        objAPS.loan__Actual_Date__c=firstRepaymentDate.get(objAPS.loan__CL_Contract__c);
                                    }
                                    loanIdList.add(objAPS.loan__CL_Contract__c);
                                }else{
                                    loanAcc.APS_Status__c=ConstantValues.APS_DIDNT_CHANGE;
                                }
                            }
                        }
                    }
                }
                loanAcc.Flat_Repayment_Amount__c=null;
            }
            if(objAPSRecordList.isEmpty() == FALSE){
                List<loan__Automated_Payment_Setup__c> cloneAPSList=objAPSRecordList.deepClone();
                List<loan__Automated_Payment_Setup__c> cloneAPSRecordList=new List<loan__Automated_Payment_Setup__c>();
                for(loan__Automated_Payment_Setup__c cloneAPS:cloneAPSList){
                    if(!loanIdList.contains(cloneAPS.loan__CL_Contract__c)){
                        cloneAPS.loan__Type__c=ConstantValues.ONE_TIME;
                        cloneAPS.loan__Amount_Type__c=null;
                        cloneAPS.loan__Frequency__c=null;
                        if(flatRepaymentAmount.containsKey(cloneAPS.loan__CL_Contract__c) &&
                            flatRepaymentAmount.get(cloneAPS.loan__CL_Contract__c)!=null 
                        ){
                            cloneAPS.loan__Transaction_Amount__c=flatRepaymentAmount.get(cloneAPS.loan__CL_Contract__c);
                        }
                        if(firstRepaymentDate.containsKey(cloneAPS.loan__CL_Contract__c) &&
                            firstRepaymentDate.get(cloneAPS.loan__CL_Contract__c)!=null 
                        ){
                            cloneAPS.loan__Debit_Date__c=firstRepaymentDate.get(cloneAPS.loan__CL_Contract__c);
                            cloneAPS.loan__Debit_Day__c=(firstRepaymentDate.get(cloneAPS.loan__CL_Contract__c)).day();
                            cloneAPS.loan__Actual_Date__c=firstRepaymentDate.get(cloneAPS.loan__CL_Contract__c);
                        }
                        cloneAPS.Created_after_reschedule__c=true;
                        cloneAPSRecordList.add(cloneAPS);
                    }
                    
                }
                if(cloneAPSRecordList.size()>0){
                    Database.insert(cloneAPSRecordList,false);
                }
            }
            if(objAPSList.size()>0){
                Database.update(objAPSList,false); 
            }
            
            if(objLoanAccountList.size()>0){
                Database.update(objLoanAccountList,false);
            }
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'OneTimeAPSCreation :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
        
    }
}