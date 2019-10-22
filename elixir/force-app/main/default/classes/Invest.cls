/********************************************************************************
Description : This class is used for creating investment orders for invesment booking
               and also their disbursal distributions
Developer : Rameswari Barman
*********************************************************************************/

Global with sharing class Invest{
    //Method used to create investment orders
    static Date currentSystemDate =(Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
    Webservice static String makeAllInvestment(Id iden){
        Savepoint sp=Database.setSavepoint();
        try{
            Decimal amount = 0;
            String loans,loanId;
            List<loan__Investor_Loan__c> objList = new List<loan__Investor_Loan__c>();
            genesis__Applications__c app = [SELECT id,
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
                                                         And peer__Stage__c =: ConstantValues.inFunding
                                                         And Invest__c = True];
        
            Date currentSystemDate = (Test.isRunningTest() ?  Date.today() : (new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
            loan__Loan_Account__c loanAcc = new loan__Loan_Account__c();            
            loanAcc.Id=app.Loan_Application__r.peer__Loan__c;
            loanAcc.loan__Application_Date__c=currentSystemDate;
            System.debug('Hi 1');
            loanAcc.loan__Expected_Disbursal_Date__c=currentSystemDate;
            loanAcc.loan__Accrual_Start_Date__c=currentSystemDate;
            loanAcc.loan__Disbursal_Date__c=currentSystemDate;
            loanAcc.loan__Draw_Period_End_Date__c=currentSystemDate;
            loanAcc.Fixed_Rate_Term__c = app.Fixed_Rate_Term__c;
            if(app.Loan_Application__r.peer__Loan__r.loan__Frequency_of_Loan_Payment__c.equals(ConstantValues.biWeekly)){
                loanAcc.loan__Expected_Repayment_Start_Date__c=currentSystemDate.addDays(14);
                loanAcc.loan__First_Installment_Date__c=loanAcc.loan__Expected_Repayment_Start_Date__c;
                loanAcc.loan__Due_Day__c=loanAcc.loan__Expected_Repayment_Start_Date__c.day();
                loanAcc.loan__Contractual_Due_Day__c=loanAcc.loan__Expected_Repayment_Start_Date__c.day();
                loanAcc.loan__Maturity_Date_Current__c=null;
            }
            else if(app.Loan_Application__r.peer__Loan__r.loan__Frequency_of_Loan_Payment__c.equals(ConstantValues.weekly)){
                loanAcc.loan__Expected_Repayment_Start_Date__c=currentSystemDate.addDays(7);
                loanAcc.loan__First_Installment_Date__c=loanAcc.loan__Expected_Repayment_Start_Date__c;
                loanAcc.loan__Due_Day__c=loanAcc.loan__Expected_Repayment_Start_Date__c.day();
                loanAcc.loan__Contractual_Due_Day__c=loanAcc.loan__Expected_Repayment_Start_Date__c.day();
                loanAcc.loan__Maturity_Date_Current__c=null;
            }
            else if(app.Loan_Application__r.peer__Loan__r.loan__Frequency_of_Loan_Payment__c.equals(ConstantValues.monthly)){
                loanAcc.loan__Expected_Repayment_Start_Date__c=currentSystemDate.addMonths(1);
                loanAcc.loan__First_Installment_Date__c=loanAcc.loan__Expected_Repayment_Start_Date__c;
                loanAcc.loan__Due_Day__c=loanAcc.loan__Expected_Repayment_Start_Date__c.day();
                loanAcc.loan__Contractual_Due_Day__c=loanAcc.loan__Expected_Repayment_Start_Date__c.day();
                loanAcc.loan__Maturity_Date_Current__c=null;
            }
            try{
                update loanAcc;
                loan.RegenerateAmortizationScheduleCtrl.regenerateAmortizationSchedule(loanAcc.Id);
            }
            catch(Exception e){
                throw e;
            }
            if(ibList.size() == 0){
                return ConstantValues.noActiveInvestmentFound;
            }
            for(peer__Investment_Booking__c iBook : ibList){
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
                //obj.peer__Credit_Band_Allocation__c = iBook.peer__Credit_Band_Allocation__c;
            }
            //****check if Funding in tranches activated on loan*****
            if(app.genesis__CL_Product__r.loan__Lending_Product__r.loan__Funding_in_Tranches__c!=null && app.genesis__CL_Product__r.loan__Lending_Product__r.loan__Funding_in_Tranches__c==false){
                if(amount<app.Loan_Application__r.peer__Requested_Loan_Amount__c){
                    return ConstantValues.investmentAmountCannotBeLess;
                }else if(amount>app.Loan_Application__r.peer__Requested_Loan_Amount__c){
                    return ConstantValues.investmentAmountCannotBeGreater;
                }
            }
            //************Creating Disbursal and Distributions******************************
            if(!(Test.isRunningTest())){
                System.debug('===========>'+loans+'==='+amount+'==='+loanId+'==='+app);
                loan__Loan_Disbursal_Transaction__c ldt= createDisbursalwithDist(loans,amount,loanId,app);
            }
            //******************************************************************************
            
            AggregateResult[] groupedResults = [SELECT SUM(loan__Investment_Amount__c)aver FROM loan__Investor_Loan__c where loan__Loan__c =: loans and loan__Status__c =: System.label.Active];
            Decimal avgAmount = Integer.valueOf(groupedResults[0].get('aver'));
            
            Decimal totalInvested = (avgAmount==null?0:avgAmount) + amount;
            
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
             for(loan__Investor_Loan__c io : ioList){
               io.loan__Share__c = (io.loan__Investment_Amount__c / totalInvested) * 100;
            }
            update ioList;
            
            loan.InvestorAPI invAPI = loan.APIFactory.getInvestorAPI();
            list<loan__Investor_Loan__c> inorList = invAPI.createInvestmentOrders(objList); 
            update ibList;
            peer__Loan_Application__c loanApp= new peer__Loan_Application__c(id=app.Loan_Application__c, peer__Stage__c=System.label.Funded);
            update loanApp;
            //app.genesis__Status__c=System.label.COMPLETED;
            app.First_Drawdown_Complete__c = True;
            update app;
            return ConstantValues.fundingSuccessful;                                                                              
            
        }
        catch(Exception e){
            Database.rollback(sp);
            return ('Unable to fund!'+e.getMessage()+' at Line:'+e.getLineNumber());
        }
    }
    //******Method to create Distribution*****************
    global static loan__Loan_Disbursal_Transaction__c createDisbursalwithDist(ID loans,Decimal totalDisbursal,String loanId,genesis__Applications__c app){
        loan__Payment_Mode__c mode = [Select id,Name from loan__Payment_Mode__c where Name =: system.label.ACH limit 1];
        List<loan__Loan_Disbursal_Transaction__c> ldtList = new List<loan__Loan_Disbursal_Transaction__c>([Select id,
                                                                                                                  loan__Loan_Account__c
                                                                                                           From loan__Loan_Disbursal_Transaction__c
                                                                                                           Where loan__Loan_Account__c =: loans]);
        loan__Loan_Disbursal_Transaction__c ldt= new loan__Loan_Disbursal_Transaction__c();
        ldt.loan__Loan_Disbursal_Transaction_Type__c = ConstantValues.regular;
        ldt.loan__Disbursed_Amt__c = totalDisbursal;
        ldt.loan__Disbursal_Date__c = currentSystemDate;
        ldt.loan__Mode_of_Payment__c = mode.id;
        ldt.loan__Loan_Account__c = loans;
        AggregateResult[] groupedResults = [SELECT SUM(loan__Amount__c)feeAmnt 
                                            FROM loan__Contract_Pre_Paid_Fee__c 
                                            Where loan__Amount__c>0 
                                                  AND loan__Contract__c =:loans 
                                                  AND loan__Loan_Disbursal_Transaction__c=null];
        Decimal feeAmount = Double.valueOf(groupedResults[0].get('feeAmnt'));            
        ldt.loan__Financed_Amount__c = (feeAmount!=null?totalDisbursal-feeAmount:totalDisbursal);
        insert ldt;
        //map<String,Fee_Structure_mappings__c> feeMappingSet= Fee_Structure_mappings__c.getAll();
        list< loan__Disbursal_Txn_Distribution__c > ddtList= new list< loan__Disbursal_Txn_Distribution__c >();
        loan__Disbursal_Txn_Distribution__c ddtObj;
        list<loan__Contract_Pre_Paid_Fee__c> ppfList=[select id, Name , 
                                                             loan__Loan_Disbursal_Transaction__c ,
                                                             loan__Fee_Type__r.Name, 
                                                             loan__Fee_Type__c,
                                                             loan__Amount__c 
                                                      from loan__Contract_Pre_Paid_Fee__c 
                                                      Where loan__Amount__c>0 AND loan__Contract__c =:loans];
        for(loan__Contract_Pre_Paid_Fee__c ppf: ppfList){
            if(ppf.loan__Amount__c!=null && ppf.loan__Amount__c>0 && ppf.loan__Loan_Disbursal_Transaction__c==null){
                ddtObj= new loan__Disbursal_Txn_Distribution__c();
                //ddtObj.loan__Distribution_Type__c=feeMappingSet.get(ppf.loan__Fee_Type__r.Name).Distribution_Type__c;
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
        //*****creating DDT for Borrower distribution...
        ddtObj= new loan__Disbursal_Txn_Distribution__c();
        ddtObj.loan__Distribution_Type__c=ConstantValues.disbursement;
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
        ddtList.add(ddtObj);
        
        insert ddtList;
        update ppfList;
        return ldt;
    }
}