/********************************************************************************
Description : This class is used for creating investment orders for invesment booking
               and also their disbursal distributions
Developer : Rameswari Barman
Implementation Code : peer__Loan_Application__c loanApp = [select id from peer__Loan_Application__c where id = 'XXX'];
       Invest.makeAllInvestment(loanApp.id);
*********************************************************************************/

Global with sharing class Invest{
    //Method used to create investment orders
    static Date currentSystemDate =(Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
    Webservice static String makeAllInvestment(Id iden){
        Savepoint sp=Database.setSavepoint();
        try{
            Decimal amount = 0;
            String loans,
                   loanId,
                   retCheck='',
                   ret = '';
            List<loan__Investor_Loan__c> objList = new List<loan__Investor_Loan__c>();
            
            if(iden != null){
                genesis__Applications__c app = [SELECT id,
                                                          genesis__Status__c,
                                                          genesis__Fees_Amount__c,
                                                          Loan_Application__c, 
                                                          Loan_Application__r.peer__Loan__c,
                                                          Loan_Application__r.peer__Loan__r.loan__Frequency_of_Loan_Payment__c,
                                                          Loan_Application__r.peer__Loan__r.loan__Maturity_Date_Current__c,
                                                          genesis__Expected_Start_Date__c,
                                                          genesis__Expected_Close_Date__c,
                                                          genesis__Expected_First_Payment_Date__c,
                                                          genesis__Maturity_Date__c,
                                                          genesis__Description__c,
                                                          Loan_Application__r.peer__Requested_Loan_Amount__c,
                                                          genesis__CL_Product__c, 
                                                          Fixed_Rate_Term__c,
                                                          Utilised_Subsequent_Drawdown_Prepaid_Fee__c,
                                                          Paid_Subsequent_Drawdown_PrepaidInterest__c,
                                                          Paid_Subsequent_Drawdown__c,
                                                          Construction_Progress_Payment_Fee__c,
                                                          genesis__CL_Product_Name__c,
                                                          genesis__Initial_Advance__c,
                                                          First_Tranche_Prepaid_Interest__c,
                                                          First_Drawdown_Complete__c,
                                                          Subsequent_Drawdown__c,
                                                          Drawdown_Prepaid_Interest__c,
                                                          genesis__Interest_Rate__c,
                                                          genesis__Loan_Amount__c,
                                                          genesis__CL_Product__r.loan__Lending_Product__r.loan__Funding_in_Tranches__c
                                                          FROM genesis__Applications__c WHERE Loan_Application__c =: iden];
                
                List<peer__Investment_Booking__c> ibList = [Select id,
                                                                    Invest__c, 
                                                                    peer__Stage__c,
                                                                    peer__Investment_Amount__c, 
                                                                    peer__Loan_Application__c,
                                                                    peer__Credit_Band_Allocation__c,
                                                                    peer__Loan_Application__r.peer__Loan__c, 
                                                                    peer__Loan_Application__r.peer__Loan__r.Name,
                                                                    peer__Certificate_Rate__c, 
                                                                    peer__Booking_Order__r.peer__Investor__c,
                                                                    peer__Booking_Order__r.peer__Investor__r.Name, 
                                                                    peer__Service_Rate__c 
                                                             From peer__Investment_Booking__c where peer__Loan_Application__c =: iden
                                                             And peer__Stage__c =: System.label.InFunding
                                                             And Invest__c = True];
                //Mapping of application fields to CL Contract
                //Date currentSystemDate = (Test.isRunningTest() ?  Date.today() : (new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
                loan__Loan_Account__c loanAcc = new loan__Loan_Account__c();            
                loanAcc.Id=app.Loan_Application__r.peer__Loan__c;
                loanAcc.loan__Application_Date__c=currentSystemDate;
                loanAcc.loan__Expected_Disbursal_Date__c=currentSystemDate;
                loanAcc.loan__Accrual_Start_Date__c=currentSystemDate;
                loanAcc.loan__Disbursal_Date__c=currentSystemDate;
                loanAcc.loan__Draw_Period_End_Date__c=currentSystemDate;
                loanAcc.Fixed_Rate_Term__c = app.Fixed_Rate_Term__c;
                loanAcc.loan__Last_Installment_Date__c = app.genesis__Maturity_Date__c;
                //Maping of dates
                //Since bill generation is always in Monthly frequency 1 month is added to repayment start date
                loanAcc.loan__Expected_Repayment_Start_Date__c=currentSystemDate.addMonths(1);
                loanAcc.loan__First_Installment_Date__c=loanAcc.loan__Expected_Repayment_Start_Date__c;
                loanAcc.loan__Due_Day__c=loanAcc.loan__Expected_Repayment_Start_Date__c.day();
                loanAcc.loan__Contractual_Due_Day__c=loanAcc.loan__Expected_Repayment_Start_Date__c.day();
                loanAcc.loan__Maturity_Date_Current__c=null;
                try{
                    if(loanAcc != null){
                        update loanAcc;
                    }
                    //generating of schedule
                    loan.RegenerateAmortizationScheduleCtrl.regenerateAmortizationSchedule(loanAcc.Id);
                    
                    ret = retCheck; 

                }
                catch(Exception e){
                    throw e;
                }
                if(ibList.size() == 0){
                    return ConstantValues.noActiveInvestmentFound;
                }
                if(ibList != null && ibList.size() > 0){
                    for(peer__Investment_Booking__c iBook : ibList){
                        //Updating the investment booking record after the funding
                        amount = iBook.peer__Investment_Amount__c + amount;
                        loans = iBook.peer__Loan_Application__r.peer__Loan__c;
                        loanId=iBook.peer__Loan_Application__r.peer__Loan__r.Name;
                        loan__Investor_Loan__c obj = new loan__Investor_Loan__c();
                        obj.loan__Account__c = iBook.peer__Booking_Order__r.peer__Investor__c;
                        obj.loan__Certificate_Rate__c = iBook.peer__Certificate_Rate__c;
                        obj.loan__Service_Rate__c = iBook.peer__Service_Rate__c;
                        obj.loan__Loan__c = iBook.peer__Loan_Application__r.peer__Loan__c;
                        obj.loan__Loan_Principal_Remaining__c = iBook.peer__Investment_Amount__c;
                        obj.loan__Investment_Amount__c = iBook.peer__Investment_Amount__c;
                        objList.add(obj);
                        iBook.peer__Stage__c = System.label.Funded;
                    }
                }
                //****check if Funding in tranches activated on loan*****
                if(app.genesis__CL_Product__r.loan__Lending_Product__r.loan__Funding_in_Tranches__c!=null && app.genesis__CL_Product__r.loan__Lending_Product__r.loan__Funding_in_Tranches__c==false){
                    if(amount<app.Loan_Application__r.peer__Requested_Loan_Amount__c){
                        return ConstantValues.INVESTMENT_AMT_CANNOT_BE_LESS_MSG;
                    }else if(amount>app.Loan_Application__r.peer__Requested_Loan_Amount__c){
                        return ConstantValues.investmentAmountCannotBeGreater;
                    }
                }
                //************Creating Disbursal and Distributions******************************
                /*if(!(Test.isRunningTest())){
                    //loan__Loan_Disbursal_Transaction__c ldt= createDisbursalwithDist(loans,amount,loanId,app);
                    createDisbursalwithDist(loans,amount,loanId,app);
                }
                //******************************************************************************/
                if((app.genesis__CL_Product_Name__c == System.label.Construction_Development || app.genesis__CL_Product_Name__c == System.label.Residential_Construction) && app.First_Drawdown_Complete__c == false){  
                        retCheck = createDisbursalwithDist(loanAcc.Id,(app.genesis__Initial_Advance__c+app.First_Tranche_Prepaid_Interest__c),loanAcc.Name,app);    
                        app.Paid_Subsequent_Drawdown__c = 0;    
                        app.Paid_Subsequent_Drawdown_PrepaidInterest__c = 0;    
                        app.Utilised_Subsequent_Drawdown_Prepaid_Fee__c = 0;    
                    }   
                    else if((app.genesis__CL_Product_Name__c == System.label.Construction_Development || app.genesis__CL_Product_Name__c == System.label.Residential_Construction) && app.First_Drawdown_Complete__c == true){  
                        retCheck = createDisbursalwithDist(loanAcc.Id,(app.Subsequent_Drawdown__c+app.Drawdown_Prepaid_Interest__c+app.Construction_Progress_Payment_Fee__c),loanAcc.Name,app); 
                        app.Paid_Subsequent_Drawdown__c = app.Paid_Subsequent_Drawdown__c+app.Subsequent_Drawdown__c;   
                        app.Paid_Subsequent_Drawdown_PrepaidInterest__c=app.Paid_Subsequent_Drawdown_PrepaidInterest__c+app.Drawdown_Prepaid_Interest__c;   
                        app.Utilised_Subsequent_Drawdown_Prepaid_Fee__c = app.Utilised_Subsequent_Drawdown_Prepaid_Fee__c+app.Construction_Progress_Payment_Fee__c; 
                        app.Subsequent_Drawdown__c = 0; 
                        app.Drawdown_Prepaid_Interest__c = 0;   
                    }   
                    else if(app.genesis__CL_Product_Name__c == System.label.Residential_Construction || app.genesis__CL_Product_Name__c == System.label.Residential || app.genesis__CL_Product_Name__c == System.label.Commercial){ 
                        clcommon__Deposit__c dep = new clcommon__Deposit__c();  
                        dep.loan__Loan_Account__c = loanAcc.Id; 
                        dep.clcommon__Deposit_Rate__c = app.genesis__Interest_Rate__c;  
                        dep.clcommon__Deposit_Amount__c=0;  
                        dep.clcommon__Current_Deposit_Rate__c=app.genesis__Interest_Rate__c;    
                        dep.clcommon__Transaction_Date__c = currentSystemDate;  
                        dep.clcommon__Deposit_Interest_Accrued__c = 0;  
                        dep.clcommon__Sequence__c=1;    
                        insert dep; 
                        retCheck = createDisbursalwithDist(loanAcc.Id,app.genesis__Loan_Amount__c,loanAcc.Name,app);    
                    }   
                    else{   
                        retCheck = createDisbursalwithDist(loanAcc.Id,app.genesis__Loan_Amount__c,loanAcc.Name,app);    
                    }   
                AggregateResult[] groupedResults = [SELECT SUM(loan__Investment_Amount__c)aver FROM loan__Investor_Loan__c where loan__Loan__c =: loans and loan__Status__c =: System.label.Active];
                Decimal avgAmount = Integer.valueOf(groupedResults[0].get(ConstantValues.AVER));
                
                Decimal totalInvested = (avgAmount==null?0:avgAmount) + amount;//Calculates the total amount invested on the loan
                
                List<loan__Investor_Loan__c> ioList = new List<loan__Investor_Loan__c>([Select id,
                                                                                            loan__Loan__c,
                                                                                            loan__Status__c,
                                                                                            loan__Investment_Amount__c,
                                                                                            loan__Certificate_Rate__c,
                                                                                            loan__Interest_Amount_Paid__c,
                                                                                            loan__Principal_Amount_Paid__c,
                                                                                            loan__Loan_Principal_Remaining__c,
                                                                                            loan__Loan_Start_Date__c,
                                                                                            loan__Loan__r.loan__Last_Installment_Date__c,
                                                                                            loan__Share__c
                                                                                            From loan__Investor_Loan__c
                                                                                        Where loan__Loan__c =: loans 
                                                                                        And loan__Status__c =: System.label.Active]);
                if(ioList.size() > 0 && ioList != null){
                    for(loan__Investor_Loan__c io : ioList){
                        io.loan__Share__c = (io.loan__Investment_Amount__c / totalInvested) * 100;
                    }
                }
                if(ioList != null && ioList.size() > 0 && Schema.sObjectType.loan__Investor_Loan__c.fields.loan__Share__c.isUpdateable()){
                    update ioList;
                }
                if(ibList.size() > 0 && ibList != null){
                    update ibList;
                }
                loan.InvestorAPI invAPI = loan.APIFactory.getInvestorAPI();
                list<loan__Investor_Loan__c> inorList = invAPI.createInvestmentOrders(objList); 
                if(ibList != null && ibList.size() > 0){
                    update ibList;
                }
                peer__Loan_Application__c loanApp= new peer__Loan_Application__c(id=iden, peer__Stage__c=System.label.Funded);
                if(loanApp != null && Schema.sObjectType.peer__Loan_Application__c.fields.peer__Stage__c.isUpdateable()){
                    update loanApp;
                }
                loan__Loan_Account__c loanRec = [select id,name,Loan_Application__c,loan__Account__c,APS_Created__c,Application__r.genesis__Payment_Frequency__c,loan__Last_Installment_Date__c,loan__Next_Installment_Date__c,loan__Last_Disbursal_Amount__c,Warehouse__c from loan__Loan_Account__c where Loan_Application__c =: iden];
                if(app.First_Drawdown_Complete__c == false){
                    WarehouseFunding.createAPS(loanRec);
                }
                app.First_Drawdown_Complete__c = True;
                app.genesis__Status__c = System.label.Loan_Settled;
                if(app != null && Schema.sObjectType.genesis__Applications__c.fields.First_Drawdown_Complete__c.isUpdateable() && Schema.sObjectType.genesis__Applications__c.fields.genesis__Status__c.isUpdateable()){
                    update app;
                }
                return ConstantValues.fundingSuccessful; 
            }
            else {
                throw new CustomException(System.label.Invest_Error);
            }                                                                             
            
        }
        catch(Exception e){
            Database.rollback(sp);
            return ('Unable to fund!'+e.getMessage()+' at Line:'+e.getLineNumber());
        }
    }
    //******Method to create Distribution*****************
    global static String createDisbursalwithDist(ID loans,Decimal totalDisbursal,String loanId,genesis__Applications__c app){
        String ret = '';
        Savepoint sp1 = Database.setSavepoint();
        try{
            loan__Payment_Mode__c mode = [Select id,Name from loan__Payment_Mode__c where Name =: system.label.ACH limit 1];
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
            Decimal feeAmount;
            if(groupedResults.size() > 0){  
                    feeAmount = Double.valueOf(groupedResults[0].get(ConstantValues.FEE_AMNT));     
            }
            ldt.loan__Financed_Amount__c = (feeAmount!=null?totalDisbursal-feeAmount:totalDisbursal);
            if(ldt != null){
                insert ldt;
            }
            list< loan__Disbursal_Txn_Distribution__c > ddtList= new list< loan__Disbursal_Txn_Distribution__c >();
            loan__Disbursal_Txn_Distribution__c ddtObj;
            list<loan__Contract_Pre_Paid_Fee__c> ppfList=[select id, Name , 
                                                                 loan__Loan_Disbursal_Transaction__c ,
                                                                 loan__Fee_Type__r.Name, 
                                                                 loan__Fee_Type__c,
                                                                 loan__Amount__c 
                                                          from loan__Contract_Pre_Paid_Fee__c 
                                                          Where loan__Amount__c>0 AND loan__Contract__c =:loans];                                                                           
            if(ppfList != null && ppfList.size() > 0){
                for(loan__Contract_Pre_Paid_Fee__c ppf: ppfList){
                    if(ppf.loan__Amount__c!=null && ppf.loan__Amount__c>0 && ppf.loan__Loan_Disbursal_Transaction__c==null){
                        ddtObj= new loan__Disbursal_Txn_Distribution__c();
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
            ddtObj.loan__Distribution_Type__c=ConstantValues.DISBURSEMENT;
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
                if((cont.Application__r.genesis__CL_Product_Name__c == System.label.Construction_Development || cont.Application__r.genesis__CL_Product_Name__c == System.label.Residential_Construction) && cont.Application__r.First_Drawdown_Complete__c == true){           
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
                else if((cont.Application__r.genesis__CL_Product_Name__c == System.label.Construction_Development || cont.Application__r.genesis__CL_Product_Name__c == System.label.Residential_Construction) && cont.Application__r.First_Drawdown_Complete__c == false){ 
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
                Database.rollback(sp1);
                insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'WarehouseFunding :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = System.Now(),clcommon__Log_Level__c = 'ERROR');   
                ret = e.getMessage();   
                System.debug(ret);        
        }   
        return ret;
    }
}