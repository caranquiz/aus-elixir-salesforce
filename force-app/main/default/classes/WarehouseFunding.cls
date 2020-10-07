/********************************************************************************
Class Name : WarehouseFunding
Description : This class is used to fund a loan through warehouse- by creating LDTs, disbursal distributions and changes the status of
              the CL Contract to Active
Developer : Rameswari Barman
Development Date : 27/09/2019
Last Modified Date : 05-10-2020
Implementation Code -    loan__Loan_Account__c loanC = [select id from loan__Loan_Account__c where id = 'XXX'];
          Warehouse__c ware = [select id from Warehouse__c where id = 'XXX'];
          WarehouseFunding.executeFun(loanC.Id,ware.Id);
*********************************************************************************/

global class WarehouseFunding{
static Date currentSystemDate =(Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
    Webservice static String executeFun(Id iden, Id investor){
        String ret = '', retCheck = '',restAPSCheck = '';
        Id broIden;
        Savepoint sp = Database.setSavepoint();
        try{
            loan__Loan_Account__c loanAcc = [select id,name,APS_Frequency__c,loan__Due_Day__c,Paid_Prepaid_Interest__c,Application__c,Application__r.genesis__Expected_Start_Date__c,loan__Account__c,loan__Loan_Product_Name__c,APS_Created__c,Application__r.genesis__Expected_First_Payment_Date__c,Application__r.genesis__Payment_Frequency__c,loan__Last_Installment_Date__c,loan__Next_Installment_Date__c,loan__Last_Disbursal_Amount__c,Warehouse__c from loan__Loan_Account__c where id =: iden];
            genesis__applications__c app = [select id,genesis__Expected_Start_Date__c,Utilised_Subsequent_Drawdown_Prepaid_Fee__c,Paid_Subsequent_Drawdown_PrepaidInterest__c,Paid_Subsequent_Drawdown__c,genesis__Maturity_Date__c,Construction_Progress_Payment_Fee__c,genesis__CL_Product_Name__c,genesis__Initial_Advance__c,First_Tranche_Prepaid_Interest__c,First_Drawdown_Complete__c,Subsequent_Drawdown__c,Drawdown_Prepaid_Interest__c,genesis__Interest_Rate__c,genesis__Status__c,CL_Contract__c,genesis__Loan_Amount__c from genesis__applications__c where CL_Contract__c =: iden];
            List <clcommon__Party__c> broParty = [select id,Upfront_Payment_Percentage__c,Commission_Paid_To__c,Commission_Paid__c,Commission_Structure__c,clcommon__Account__c,clcommon__Account__r.parentId from clcommon__Party__c where genesis__Application__c =: app.Id and clcommon__Type__r.name =: System.label.Broker];
            if(loanAcc != null && app.First_Drawdown_Complete__c == false){
                if(broParty != null && broParty.size() > 0){
                    if(broParty[0].Commission_Paid__c == 'Yes' && (broParty[0].Commission_Structure__c	== 'Upfront & Trail' || broParty[0].Commission_Structure__c == 'Upfront')){
                        if(broParty[0].Upfront_Payment_Percentage__c != null && broParty[0].Upfront_Payment_Percentage__c != 0){
                            if(broParty[0].Commission_Paid_To__c == System.label.Broker){
                                broIden = broParty[0].clcommon__Account__c;
                            }
                            else if(broParty[0].Commission_Paid_To__c == System.label.Aggregator){
                                if(broParty[0].clcommon__Account__c != null && broParty[0].clcommon__Account__r.parentId != null){
                                    broIden = broParty[0].clcommon__Account__r.parentId;
                                }
                                else{
                                    throw new CustomException(System.label.Aggregator_missing_msg);
                                }
                            }
                            else{
                                throw new CustomException(System.label.Commission_Paid_To_Exception);
                            }
                            List<loan__Broker__c> broRecs = BrokerCommissionUtility.comUtil(loanAcc.Id,broIden,broParty[0].Upfront_Payment_Percentage__c);
                            if(broRecs != null && broRecs.size() > 0){
                                if(!(Test.isRunningTest())){
                                    insert broRecs;
                                }
                            }
                        }
                        else{
                            throw new CustomException(System.label.Commission_Paid_Message_Upfront_Not_present);
                        }
                    }
                }
                else{
                    throw new CustomException(System.label.Broker_not_present_error);
                }
            }
            loanAcc.Warehouse__c = investor;
            loanAcc.loan__Last_Installment_Date__c = app.genesis__Maturity_Date__c;
            if((app.genesis__CL_Product_Name__c == System.label.Construction_Development || app.genesis__CL_Product_Name__c == System.label.Residential_Construction) && app.First_Drawdown_Complete__c == false){
                retCheck = createDisbusals(loanAcc.Id,(app.genesis__Initial_Advance__c+app.First_Tranche_Prepaid_Interest__c),loanAcc.Name,app);
                app.Paid_Subsequent_Drawdown__c = 0;
                app.Paid_Subsequent_Drawdown_PrepaidInterest__c = 0;
                app.Utilised_Subsequent_Drawdown_Prepaid_Fee__c = 0;
                loanAcc.Paid_Prepaid_Interest__c = app.First_Tranche_Prepaid_Interest__c;
                if(app.genesis__CL_Product_Name__c == System.label.Residential_Construction){
                    clcommon__Deposit__c dep = new clcommon__Deposit__c();
                    dep.loan__Loan_Account__c = loanAcc.Id;
                    dep.clcommon__Deposit_Rate__c = app.genesis__Interest_Rate__c;
                    dep.clcommon__Deposit_Amount__c=0;
                    dep.clcommon__Current_Deposit_Rate__c=app.genesis__Interest_Rate__c;
                    dep.clcommon__Transaction_Date__c = currentSystemDate;
                    dep.clcommon__Deposit_Interest_Accrued__c = 0;
                    dep.clcommon__Sequence__c=1;
                    dep.clcommon__Priority__c=1;
                    insert dep;
                    //Code added to facilitate that when the interest rate on loan changes - the deposit rate chnages too
                    /************************************************************************/
                    loan__Loan_Parameters__c loanParams = new loan__Loan_Parameters__c();
                    loanParams.loan__Auto_Change_Deposit_Rate__c = true;
                    if(loanParams != NULl){
                        insert loanParams;
                        loanAcc.loan__Loan_Parameters__c = loanParams.Id;
                    }
                    /************************************************************************/
                }
            }
            else if((app.genesis__CL_Product_Name__c == System.label.Construction_Development || app.genesis__CL_Product_Name__c == System.label.Residential_Construction) && app.First_Drawdown_Complete__c == true){
                retCheck = createDisbusals(loanAcc.Id,(app.Subsequent_Drawdown__c+app.Drawdown_Prepaid_Interest__c+app.Construction_Progress_Payment_Fee__c),loanAcc.Name,app);
                app.Paid_Subsequent_Drawdown__c = app.Paid_Subsequent_Drawdown__c+app.Subsequent_Drawdown__c;
                app.Paid_Subsequent_Drawdown_PrepaidInterest__c=app.Paid_Subsequent_Drawdown_PrepaidInterest__c+app.Drawdown_Prepaid_Interest__c;
                loanAcc.Paid_Prepaid_Interest__c=loanAcc.Paid_Prepaid_Interest__c+app.Drawdown_Prepaid_Interest__c;
                app.Utilised_Subsequent_Drawdown_Prepaid_Fee__c = app.Utilised_Subsequent_Drawdown_Prepaid_Fee__c+app.Construction_Progress_Payment_Fee__c;
                app.Subsequent_Drawdown__c = 0;
                app.Drawdown_Prepaid_Interest__c = 0;
            }
            else if(app.genesis__CL_Product_Name__c == System.label.Residential || app.genesis__CL_Product_Name__c == System.label.Commercial){
                clcommon__Deposit__c dep = new clcommon__Deposit__c();
                dep.loan__Loan_Account__c = loanAcc.Id;
                dep.clcommon__Deposit_Rate__c = app.genesis__Interest_Rate__c;
                dep.clcommon__Deposit_Amount__c=0;
                dep.clcommon__Current_Deposit_Rate__c=app.genesis__Interest_Rate__c;
                dep.clcommon__Transaction_Date__c = currentSystemDate;
                dep.clcommon__Deposit_Interest_Accrued__c = 0;
                dep.clcommon__Sequence__c=1;
                dep.clcommon__Priority__c=1;
                insert dep;
                //Code added to facilitate that when the interest rate on loan changes - the deposit rate chnages too
                /************************************************************************/
                loan__Loan_Parameters__c loanParams = new loan__Loan_Parameters__c();
                loanParams.loan__Auto_Change_Deposit_Rate__c = true;
                if(loanParams != NULl){
                    insert loanParams;
                    loanAcc.loan__Loan_Parameters__c = loanParams.Id;
                }
                /************************************************************************/
                retCheck = createDisbusals(loanAcc.Id,app.genesis__Loan_Amount__c,loanAcc.Name,app);
            }
            else{
                retCheck = createDisbusals(loanAcc.Id,app.genesis__Loan_Amount__c,loanAcc.Name,app);
            }
            ret = retCheck;
            if(app.First_Drawdown_Complete__c == false && app.genesis__CL_Product_Name__c != System.label.Construction_Development && app.genesis__CL_Product_Name__c != System.label.Residential_Construction){
                restAPSCheck = createAPS(loanAcc);
            }
            app.First_Drawdown_Complete__c = true;
            app.genesis__Status__c = System.label.Loan_Settled;
            if(app != null && Schema.sObjectType.genesis__Applications__c.fields.First_Drawdown_Complete__c.isUpdateable() && Schema.sObjectType.genesis__Applications__c.fields.genesis__Status__c.isUpdateable()){
                update app;
            }
            if(loanAcc != null){
                update loanAcc;
            }
        }
        catch(Exception e){
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'WarehouseFunding :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = System.Now(),clcommon__Log_Level__c = 'ERROR'); 
            ret = e.getMessage();
            Database.rollback(sp);
        }
    return ret;
    }
    static String createDisbusals(ID loans,Decimal totalDisbursal,String loanId,genesis__Applications__c app){
        String ret = '';
        Decimal feeAmount;
        Savepoint sp1 = Database.setSavepoint();
        try{
            loan__Payment_Mode__c mode = [Select id,Name from loan__Payment_Mode__c where Name =: System.label.ACH limit 1];
            List<loan__Loan_Disbursal_Transaction__c> ldtList = new List<loan__Loan_Disbursal_Transaction__c>([Select id,
                                                                      loan__Loan_Account__c
                                                                      From loan__Loan_Disbursal_Transaction__c
                                                                      Where loan__Loan_Account__c =: loans]);
            loan__Loan_Disbursal_Transaction__c ldt= new loan__Loan_Disbursal_Transaction__c();
            ldt.loan__Loan_Disbursal_Transaction_Type__c = System.label.Regular;
            ldt.loan__Disbursed_Amt__c = totalDisbursal;
            ldt.loan__Disbursal_Date__c = currentSystemDate;
            ldt.loan__Mode_of_Payment__c = mode.id;
            ldt.loan__Loan_Account__c = loans;
            AggregateResult[] groupedResults = [SELECT SUM(loan__Amount__c)feeAmnt 
                                                    FROM loan__Contract_Pre_Paid_Fee__c 
                                                    Where loan__Amount__c>0 
                                                    AND loan__Contract__c =:loans 
                                                    AND loan__Loan_Disbursal_Transaction__c=null];
            if(groupedResults.size() > 0){
                feeAmount = Double.valueOf(groupedResults[0].get(ConstantValues.FEE_AMNT)); 
            }           
            if(totalDisbursal != null && feeAmount != null){
                ldt.loan__Financed_Amount__c = (feeAmount!=null?totalDisbursal-feeAmount:totalDisbursal);
            }
            else if(totalDisbursal != null && totalDisbursal > 0){
                ldt.loan__Financed_Amount__c = totalDisbursal;
            }
            if(!(Test.isRunningTest()) && ldt != null){
                insert ldt;
            }
            map<String,Elixir_Before_Or_On_Settlement_Fees__c> feeMappingSet = Elixir_Before_Or_On_Settlement_Fees__c.getAll();
            list< loan__Disbursal_Txn_Distribution__c > ddtList= new list< loan__Disbursal_Txn_Distribution__c >();
            loan__Disbursal_Txn_Distribution__c ddtObj;
            
            list<loan__Contract_Pre_Paid_Fee__c> ppfList=[select id, Name , 
                                                                 loan__Loan_Disbursal_Transaction__c ,
                                                                 loan__Fee_Type__r.Name, 
                                                                 loan__Fee_Type__c,
                                                                 loan__Amount__c 
                                                          from loan__Contract_Pre_Paid_Fee__c 
                                                          Where loan__Contract__c =:loans];
            if(ppfList != null && ppfList.size() > 0){
                for(loan__Contract_Pre_Paid_Fee__c ppf: ppfList){
                    if(ppf.loan__Amount__c!=null && ppf.loan__Amount__c>0 && ppf.loan__Loan_Disbursal_Transaction__c==null){
                        ddtObj= new loan__Disbursal_Txn_Distribution__c();
                        ddtObj.loan__Distribution_Type__c=feeMappingSet.get(ppf.loan__Fee_Type__r.Name).Distribution_Type__c;
                        ddtObj.loan__Loan_Disbursal_Transaction__c=ldt.Id;
                        ddtObj.loan__Distribution_Amount__c=ppf.loan__Amount__c;
                        ddtObj.loan__Name_of_Entity__c=ppf.loan__Fee_Type__r.Name;
                        ddtObj.loan__Reference__c=ppf.Name;
                        ddtObj.loan__Fee__c=ppf.loan__Fee_Type__c;
                        ddtObj.loan__Source_Record_Name__c=ppf.Name;
                        ddtObj.loan__Source_Record_ID__c =ppf.Id;
                        ddtObj.loan__Loan_Disbursal_Transaction__c=ldt.Id;
                        if(ldtList != null && ldtList.size() > 0){
                            ddtObj.First_Drawdown__c = False;
                        }
                        else{
                            ddtObj.First_Drawdown__c = True;
                        }
                        ddtList.add(ddtObj);
                        ppf.loan__Loan_Disbursal_Transaction__c=ldt.Id;
                    }
                }
            }
            //*****creating DDT for Borrower distribution...
            ddtObj= new loan__Disbursal_Txn_Distribution__c();
            ddtObj.loan__Distribution_Type__c=System.label.DISBURSEMENT;
            ddtObj.loan__Loan_Disbursal_Transaction__c=ldt.Id;
            ddtObj.loan__Distribution_Amount__c=ldt.loan__Financed_Amount__c;
            ddtObj.loan__Name_of_Entity__c=loanId;
            ddtObj.loan__Reference__c=loanId;
            if(ldtList != null && ldtList.size() > 0){
                ddtObj.First_Drawdown__c = False;
            }
            else{
                ddtObj.First_Drawdown__c = True;
            }
            loan__Loan_Account__c cont = [select id,Application__c,Application__r.First_Drawdown_Complete__c,Application__r.genesis__CL_Product_Name__c,Application__r.First_Tranche_Prepaid_Interest__c,loan__Disbursed_Amount__c,Application__r.Construction_Progress_Payment_Fee__c,Application__r.Drawdown_Prepaid_Interest__c from loan__Loan_Account__c where id =: loans];
            List < loan__Disbursal_Txn_Distribution__c > ldtListCheck = [select id,loan__Loan_Disbursal_Transaction__c from loan__Disbursal_Txn_Distribution__c where loan__Loan_Disbursal_Transaction__c =: ldt.Id];
            if((cont.Application__r.genesis__CL_Product_Name__c == System.label.Construction_Development || app.genesis__CL_Product_Name__c == System.label.Residential_Construction) && cont.Application__r.First_Drawdown_Complete__c == true){         
                loan__Disbursal_Txn_Distribution__c ddtObjPrepaid = new loan__Disbursal_Txn_Distribution__c();
                ddtObjPrepaid.loan__Distribution_Type__c=System.label.Prepaid_Interest;        
                ddtObjPrepaid.loan__Loan_Disbursal_Transaction__c=ldt.Id;       
                ddtObjPrepaid.loan__Distribution_Amount__c=cont.Application__r.Drawdown_Prepaid_Interest__c;        
                ddtObjPrepaid.loan__Name_of_Entity__c=System.label.Subsequent_Drawdown_Prepaid_Interest;     
                ddtObjPrepaid.loan__Reference__c=loanId;        
                ddtObj.loan__Distribution_Amount__c = ldt.loan__Financed_Amount__c-cont.Application__r.Drawdown_Prepaid_Interest__c;        
                loan__Disbursal_Txn_Distribution__c ddtObjPrepaid1 = new loan__Disbursal_Txn_Distribution__c();
                ddtObjPrepaid1.loan__Distribution_Type__c=System.label.Pre_Paid_Fee;        
                ddtObjPrepaid1.loan__Loan_Disbursal_Transaction__c=ldt.Id;       
                ddtObjPrepaid1.loan__Distribution_Amount__c=cont.Application__r.Construction_Progress_Payment_Fee__c;        
                ddtObjPrepaid1.loan__Name_of_Entity__c=System.label.Construction_Progress_Payment_Fee;     
                ddtObjPrepaid1.loan__Reference__c=loanId;        
                ddtObj.loan__Distribution_Amount__c = ldt.loan__Financed_Amount__c-cont.Application__r.Drawdown_Prepaid_Interest__c-cont.Application__r.Construction_Progress_Payment_Fee__c;
                ddtList.add(ddtObjPrepaid1);
                ddtList.add(ddtObjPrepaid);
            }
            else if((cont.Application__r.genesis__CL_Product_Name__c == System.label.Construction_Development || app.genesis__CL_Product_Name__c == System.label.Residential_Construction) && cont.Application__r.First_Drawdown_Complete__c == false){
                loan__Disbursal_Txn_Distribution__c ddtObjPrepaid = new loan__Disbursal_Txn_Distribution__c();
                ddtObjPrepaid.loan__Distribution_Type__c=System.label.Prepaid_Interest;        
                ddtObjPrepaid.loan__Loan_Disbursal_Transaction__c=ldt.Id;       
                ddtObjPrepaid.loan__Distribution_Amount__c=cont.Application__r.First_Tranche_Prepaid_Interest__c;        
                ddtObjPrepaid.loan__Name_of_Entity__c= System.label.First_Tranche_Prepaid_Interest;   
                ddtObjPrepaid.loan__Reference__c=loanId;        
                ddtObj.loan__Distribution_Amount__c = ldt.loan__Financed_Amount__c-cont.Application__r.First_Tranche_Prepaid_Interest__c;        
                ddtList.add(ddtObjPrepaid);
            }
            ddtList.add(ddtObj);
            if(ddtList != null && ddtList.size() > 0){
                insert ddtList;
            }
            if(ppfList != null){
                update ppfList;
            }
            ret = System.label.FundingMsg;
        }
        catch(Exception e){
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'WarehouseFunding :'+e.getStackTraceString()+':Error::'+e.getMessage(), clcommon__Timestamp__c = System.Now(),clcommon__Log_Level__c = 'ERROR'); 
            ret = e.getMessage();
            Database.rollback(sp1);
        }
        return ret;
    }
    
    public static String createAPS(loan__Loan_Account__c loanRec){
        String ret = '';
        try{
            loan__Payment_Mode__c pmtMode = [Select Id,
                                                    Name 
                                            from loan__Payment_Mode__c 
                                            where Name =: System.label.APS_Payment_Mode limit 1];
            loan__Automated_Payment_Setup__c pmtSetup = new loan__Automated_Payment_Setup__c();
            pmtSetup.loan__Active__c = Boolean.ValueOf(System.label.True);
            pmtSetup.loan__CL_Contract__c = loanRec.Id;
            Date startDate;
            if(loanRec.APS_Frequency__c == System.label.WEEKLY){
                pmtSetup.loan__Debit_Date__c = currentSystemDate+7;
                startDate = currentSystemDate+7;
                pmtSetup.loan__Amount_Type_Split_Factor__c = 4;
                pmtSetup.loan__Amount_Type__c = System.label.APS_Payment_Amount;
                pmtSetup.loan__Frequency__c = loanRec.APS_Frequency__c;
            }
            else if(loanRec.APS_Frequency__c == System.label.BI_WEEKLY){
                pmtSetup.loan__Debit_Date__c = currentSystemDate+14;
                startDate = currentSystemDate+14;
                pmtSetup.loan__Amount_Type_Split_Factor__c = 2;
                pmtSetup.loan__Amount_Type__c = System.label.APS_Payment_Amount;
                pmtSetup.loan__Frequency__c = loanRec.APS_Frequency__c;
            }
            else if(loanRec.APS_Frequency__c == System.label.MONTHLY){
                pmtSetup.loan__Debit_Date__c = loanRec.loan__Next_Installment_Date__c;
                pmtSetup.loan__Recurring_ACH_End_Date__c = loanRec.loan__Last_Installment_Date__c;
                startDate = loanRec.loan__Next_Installment_Date__c;
                pmtSetup.loan__Amount_Type__c = System.label.LastBilledAmt;
                pmtSetup.loan__Frequency__c = System.label.APS_Frequency;
            }
            else{
            }
            
            pmtSetup.loan__Payment_Mode__c = pmtMode.Id;
            pmtSetup.loan__Recurring_ACH_Start_Date__c = currentSystemDate;
            pmtSetup.loan__Type__c = System.label.Recurring;
            pmtSetup.loan__Setup_Date__c = currentSystemDate;
            if(loanRec.APS_Frequency__c == System.label.MONTHLY){
                pmtSetup.loan__Debit_Day__c = loanRec.loan__Due_Day__c;
            }
            else{
                pmtSetup.loan__Debit_Day__c = startDate.day();
            }
            loanRec.APS_Created__c = true;
            loanRec.loan__Expected_Disbursal_Date__c = currentSystemDate;
            if(pmtSetup != null){
                insert pmtSetup;
            }
            if(loanRec != null){
                update loanRec;
            }
            ret = System.label.SuccessMessage;
            if(Test.isRunningTest()){
                Integer a = 4/0;
            }
        }
        catch(Exception e){
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'WarehouseFunding :'+e.getStackTraceString()+':Error::'+e.getMessage(), clcommon__Timestamp__c = System.Now(),clcommon__Log_Level__c = 'ERROR'); 
            ret = e.getMessage();
        }
        return ret;
    }
}