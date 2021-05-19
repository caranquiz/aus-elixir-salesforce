/******************************************************************
Description : This test class provides coverage to LTSMigrationJob and LTSMigrationHandlerJob
                that are  provided by CL to handle transactions present
                on Transaction Summary object and migrate to Loan Transaction Summary
******************************************************************/
@isTest
public with sharing class TestMigrationForLTS {
    
    @testSetup
    public static void createSeedData() {
        
        Test.startTest();
        loan.TestHelper.systemDate = Date.newInstance(2010, 04, 06);
        loan.TestHelper.createSeedDataForTesting();
        loan__Payment_Mode__c dummyPM = new loan__Payment_Mode__c(name= 'WRITE OFF');
        Database.insert(dummyPM);
        //Update Org Parameter to generate schedule
        loan__Org_Parameters__c orgParams = loan.CustomSettingsUtil.getOrgParameters();
        orgparams.loan__Draw_Amortization_Schedule__c = true;
        orgParams.loan__Zeroise_Provision_Amt_On_Good_Standing__c = true;
        Database.update(orgParams);

        //Setup approval config
        loan.TestHelper.setupApprovalProcessForTxnFilegen();

        //Currency
        loan__Currency__c  curr = loan.TestHelper.createCurrency();

        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest','30000 - INCOME');

        //Create a Fee Set
       loan__Fee__c dummyFee = loan.TestHelper.createFee(curr,dummyIncAccount ,dummyAccount,'Dis Fee','Late Fees');

        Database.insert(dummyFee);
        
       loan__Fee__c lateFee = new loan__Fee__c(Name='LateFee',
                                    loan__State__c = 'Active',
                                    loan__Fee_Calculation_Method__c = 'Fixed',
                                    loan__Amount__c = 100.0,
                                    loan__Currency__c = curr.ID,
                                    loan__Fee_Category__c = 'Loan',
                                    loan__Time_Of_Charge__c = 'Late Fees');

        Database.insert(lateFee);

        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);

        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();

        loan__Loan_Product__c lp= loan.TestHelper.createLoanProductwithProductType('Loan Product',
                                                               dummyOffice,
                                                               dummyAccount,
                                                               curr,
                                                               dummyFeeSet,
                                                               'Fixed',
                                                               12,
                                                               12.00,
                                                               'Same for all loans',
                                                               loan.LoanConstants.Loan);
        lp.loan__Create_Summaries__C = false;
        Database.update(lp);
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();
        
        Contact borrower = new Contact(LastName = 'TestBorrower');
        Database.insert(borrower);
        loan__Loan_Account__c loanAcc = loan.TestHelper.createLoanAccountForContactObj(lp,
                                                                            borrower,
                                                                            dummyFeeSet,
                                                                            dummyLoanPurpose,
                                                                            dummyOffice);
        Database.update(loanAcc);
        loanAcc.loan__Interest_Rate__c = 5;
        loanAcc.loan__Number_of_Installments__c = 12;
        Database.update(loanAcc);
        loan__Client__c dummyClient = loan.TestHelper.createClient(dummyOffice);

        Contact cont = new Contact(FirstName = 'Dummy', Lastname = 'Contact');
        Database.insert(cont);

        loan.BorrowerAPI1 bAPI = loan.APIFactory.getBorrowerAPI1();
        loan__Loan_Account__c newLoanAccount = bAPI.createContract(loanAcc, null, null);
        Test.stopTest();
        TestLoan.insertObjEventMapData();
        List<loan__Object_Event_Mapping__c> objList = [SELECT Id,loan__Enable_Tracking__C FROM loan__Object_Event_Mapping__C];
        for(loan__Object_Event_Mapping__C obj:objList){
            obj.loan__Enable_Tracking__c = true;
        }
        Database.update(objList);

    }
    private static loan__Loan_Product__c getLoanProduct(String name) {
        loan__Loan_Product__c retVal;

        //Get loan Product
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache loanOC = ec.getObject('LoanProduct');
        if(loanOC != null) {
            ec.deleteObject('LoanProduct');
        }

        String namespacePrefix = '';
        if(loan.CustomSettingsUtil.getOrgParameters().loan__Namespace_Prefix__c != null && 
!String.isEmpty(loan.CustomSettingsUtil.getOrgParameters().loan__Namespace_Prefix__c)) {
            namespacePrefix += loan.CustomSettingsUtil.getOrgParameters().loan__Namespace_Prefix__c + '__';
        }
        loanOC = ec.createObject('LoanProduct', namespacePrefix+'Loan_Product__c');

        String fields = null;
        loanOC.addFields(fields);
        loanOC.addNamedParameter('loanProductName', name);
        loanOC.setWHEREClause('Name = :loanProductName');

        loanOC.executeQuery();

        if(!loanOC.getRecords().isEmpty()) {
            retVal = (loan__Loan_Product__c)loanOC.getRecords().get(0);
        }

        return retVal;
    }

    private static List<loan__Loan_Account__c> getLoanAccount(Id loanIds) {
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache loanOC = ec.getObject('LoanAccount');
        if (loanOC != null) {
            ec.deleteObject('LoanAccount');
        }

        loanOC = ec.createObject('LoanAccount', 'Loan_Account__c', 'loan');
        String fields = loan.ObjectCacheQueryUtil.getLoanSnapshotFields();
        fields += ', Minimum_Amount_Due__c,  Minimum_Amount_Due_Type__c ';
        loanOC.addFields(fields);
        loanOC.addNamedParameter('loanIds', loanIds);
        loanOC.setWhereClause('ID = :loanIds');

        mfiflexUtil.ObjectCache bills = ec.createRelationship('Dues_Details__r')
                .addFields(loan.ObjectCacheQueryUtil.getDueDetailsFields())
                .setWhereClause('DD_Primary_Flag__c = true AND Late_Charge_Applied__c = false');
        loanOC.addRelationship(bills);

        List<loan__Loan_Account__c> retVal = (List<loan__Loan_Account__c>)loanOC.buildQuery().executeQuery().getRecords();
        return retVal;
    }


//It will cover disbursal , payment , payment rev and dis rev
   public static testMethod void TestSummaryCreationDisbursalAndPayment(){
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
        List<String> trans = new List<String>();
        Date currentSystemDate = dateutil.getCurrentSystemDate();
        Date startDate = currentSystemDate;
        List<loan__Loan_Account__c> loanAccountList = new List<loan__Loan_Account__c>();
        loan__Loan_Product__c lp = getLoanProduct('Loan Product');
        loan__Payment_Mode__c pMode = [SELECT Id, Name FROM loan__Payment_Mode__c WHERE Name = 'Cash'];
        loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
        
        loan__Loan_Account__C loanAcc = [SELECT id,
                                                loan__Provision_Amount__C ,
                                                loan__Loan_Status__c
                                         FROM loan__Loan_Account__c 
                                         WHERE loan__Product_Type__c =:loan.LoanConstants.LOAN 
                                         LIMIT 1];
        Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = new loan__Loan_Disbursal_Transaction__c();
        disTxn.loan__Loan_Account__c = loanAcc.Id;
        disTxn.loan__Disbursal_Date__c = currentSystemDate;
        disTxn.loan__Transaction_Creation_Date__c = currentSystemDate;
        distxn.loan__Disbursed_Amt__c=10000;
        disTxn.loan__Mode_Of_Payment__c = pMode.Id;
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        disTxn = [SELECT Id, 
                       Name, 
                       loan__Transaction_Creation_Date__c,
                       loan__Bank_Account__c ,
                       loan__Disbursed_Amt__c  
                FROM loan__Loan_Disbursal_Transaction__c ];
        System.assertEquals(disTxn.loan__Transaction_Creation_Date__c,dateutil.getCurrentSystemDate());
        Test.stopTest();
        loan__Loan_Payment_Transaction__c pmt = new loan__Loan_Payment_Transaction__c();
        pmt.loan__Loan_Account__c = loanAcc.Id;
        pmt.loan__Transaction_Date__c = currentSystemDate;
        pmt.loan__Transaction_Creation_Date__c = currentSystemDate;
        pmt.loan__Transaction_Amount__c =100;
        pmt.loan__Principal__c = 90;
        pmt.loan__Interest__c = 10;
        pmt.loan__Manual_Payment__c = true;
        pmt.loan__Payment_Mode__c = pMode.Id;
        Database.insert(pmt);

        pmt.loan__Cleared__c = true;
       
        Database.update(pmt);
       
        List<loan__Loan_Payment_Transaction__c> payment = [SELECT Id ,loan__Transaction_Amount__c FROM loan__Loan_Payment_Transaction__c limit 1];
        
        loan__Repayment_Transaction_Adjustment__c reversalTxn = new loan__Repayment_Transaction_Adjustment__c();
        reversalTxn.loan__Adjustment_Txn_Date__c = currentSystemDate;
        reversalTxn.loan__Transaction_Creation_Date__c = currentSystemDate;
        reversalTxn.loan__Loan_Payment_Transaction__c = payment[0].Id;
        reversalTxn.loan__Refund_To_Borrower__c = false;
        Database.insert(reversalTxn);
            
        List<loan__Repayment_Transaction_Adjustment__c> reverse = [SELECT Id,loan__Loan_Payment_Transaction__r.loan__Transaction_Amount__c FROM loan__Repayment_Transaction_Adjustment__c LIMIT 1];
        
        System.assertEquals(1,reverse.size());
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        System.debug('inside the test case 3::');
         loan__Disbursal_Adjustment__c adjTxn = new loan__Disbursal_Adjustment__c(loan__Loan_Disbursal_Transaction__c = disTxn.Id,
                                                                                  loan__Transaction_Creation_Date__c = currentSystemDate,
                                                                                  loan__Adjustment_Txn_Date__c = currentSystemDate);

        Database.insert(adjTxn);
        List<loan__Disbursal_Adjustment__c> disReverse = [SELECT Id,loan__Loan_Disbursal_Transaction__r.loan__Disbursed_Amt__c FROM loan__Disbursal_Adjustment__c LIMIT 1];
        lp.loan__Create_Summaries__C = true;
        Database.update(lp);

       List<loan__Loan_Account__c > loanAccList = new List<loan__Loan_Account__c>();
       LTSMigrationHandler handler = new LTSMigrationHandler(startDate,currentSystemDate);
       
       loanAccList.add(TestLoan.getLoanAccount(loanAcc));
       Date resolvedDate = Date.newinstance(currentSystemDate.year(), currentSystemDate.month(), currentSystemDate.day());

       handler.process(loanAccList);
        
        List<loan__Loan_Transaction_Summary__c> summary = [SELECT loan__Current_Interest_Rate__c,
                                                                  loan__Current_Loan_Balance__c,
                                                                  loan__Current_Payoff_Balance__c,
                                                                  loan__Current_Principal_Remaining__c,
                                                                  loan__Current_Delinquent_Amount__c,
                                                                  loan__Invalid_data__c
                                                           FROM loan__Loan_Transaction_Summary__c
                                                           Order By loan__Transaction_Time__c ASC]; 
        
        System.assertEquals(4,summary.size());
        System.assertEquals(summary[0].loan__Current_Interest_Rate__c,5);
        System.assertEquals(summary[0].loan__Current_Loan_Balance__c,10000);
        System.assertEquals(summary[0].loan__Current_Principal_Remaining__c,10000);
        System.assertEquals(summary[0].loan__Current_Delinquent_Amount__c,0);
        System.assertEquals(summary[1].loan__Current_Interest_Rate__c,5);
        System.assertEquals(summary[1].loan__Current_Loan_Balance__c,9910);
        System.assertEquals(summary[1].loan__Current_Principal_Remaining__c,9910);
        System.assertEquals(summary[1].loan__Current_Delinquent_Amount__c,0);
        System.assertEquals(summary[2].loan__Current_Interest_Rate__c,5);
        System.assertEquals(summary[2].loan__Current_Loan_Balance__c,10000);
        System.assertEquals(summary[2].loan__Current_Principal_Remaining__c,10000);
        System.assertEquals(summary[2].loan__Current_Delinquent_Amount__c,0);
        System.assertEquals(summary[3].loan__Current_Interest_Rate__c,5);
        System.assertEquals(summary[3].loan__Current_Loan_Balance__c,0);
        System.assertEquals(summary[3].loan__Current_Principal_Remaining__c,0);
        System.assertEquals(summary[3].loan__Current_Delinquent_Amount__c,0);
        
    }
    
        public static testMethod void TestSummaryIfAlreadyPresent(){
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
       Date currentSystemDate = dateutil.getCurrentSystemDate();
       Date startDate =currentSystemDate;
       loan__Loan_Product__c lp = getLoanProduct('Loan Product');
       Map<Id,loan__Loan_Transaction_Summary__c> existingSummaries = new Map<Id,loan__Loan_Transaction_Summary__c>();
       List<loan__Loan_Account__c> loanAccountList = new List<loan__Loan_Account__c>();
       loan__Loan_Product__c loanProd = getLoanProduct('Loan Product');
       List<loan__Office_Name__c> dummyOffice = [SELECT Id FROM loan__Office_Name__c];
       loan__Payment_Mode__c pMode = [SELECT Id,Name FROM loan__Payment_Mode__c WHERE Name = 'Cash'];
      loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
        
      loan__Loan_Account__C loanAcc = [SELECT id,
                                              loan__Provision_Amount__C ,
                                              loan__Loan_Status__c
                                      FROM loan__Loan_Account__c 
                                      WHERE loan__Product_Type__c =:loan.LoanConstants.LOAN 
                                      LIMIT 1];
       lp.loan__Create_Summaries__C = true;
       Database.update(lp);
        
        Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = new loan__Loan_Disbursal_Transaction__c();
        disTxn.loan__Loan_Account__c = loanAcc.Id;
        disTxn.loan__Disbursal_Date__c = currentSystemDate;
        disTxn.loan__Transaction_Creation_Date__c = currentSystemDate;
        distxn.loan__Disbursed_Amt__c=10000;
        disTxn.loan__Mode_Of_Payment__c = pMode.Id;
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        Test.stopTest(); 
        disTxn = [SELECT Id, 
                       Name, 
                       loan__Transaction_Creation_Date__c,
                       loan__Bank_Account__c ,
                       loan__Disbursed_Amt__c  
                FROM loan__Loan_Disbursal_Transaction__c ];
        System.assertEquals(disTxn.loan__Transaction_Creation_Date__c,dateutil.getCurrentSystemDate());
        List<loan__Loan_transaction_summary__c> summary = [SELECT loan__Current_Interest_Rate__c,
                                                                  loan__Current_Loan_Balance__c,
                                                                  loan__Current_Payoff_Balance__c,
                                                                  loan__Current_Principal_Remaining__c,
                                                                  loan__Loan_Disbursal__c,
                                                                  loan__Transaction_Amount__c,
                                                                  loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                                                                  loan__Consolidated_Loan_Balance__c
                                                           FROM loan__Loan_Transaction_Summary__c
                                                           Order By CreatedDate ASC];
        List<loan__Loan_Disbursal_Transaction__c> disbursal = [SELECT ID,loan__Disbursed_Amt__c FROM loan__Loan_Disbursal_Transaction__c limit 1];
        existingSummaries.put(summary[0].Id,summary[0]);
        loan__Loan_Payment_Transaction__c pmt = new loan__Loan_Payment_Transaction__c();
        pmt.loan__Loan_Account__c = loanAcc.Id;
        pmt.loan__Transaction_Date__c = currentSystemDate;
        pmt.loan__Transaction_Creation_Date__c = currentSystemDate;
        pmt.loan__Transaction_Amount__c =100;
        pmt.loan__Principal__c = 90;
        pmt.loan__Interest__c = 10;
        pmt.loan__Manual_Payment__c = true;
        pmt.loan__Payment_Mode__c = pMode.Id;
        Database.insert(pmt);

        pmt.loan__Cleared__c = true;
       
        Database.update(pmt);
        summary = [SELECT loan__Current_Interest_Rate__c,
                          loan__Current_Loan_Balance__c,
                          loan__Current_Payoff_Balance__c,
                          loan__Current_Principal_Remaining__c,
                          loan__Loan_Payment_Txn__c,
                          loan__Transaction_Amount__c,
                          loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                          loan__Consolidated_Loan_Balance__c
                   FROM loan__Loan_Transaction_Summary__c
                   Order By CreatedDate ASC];
        List<loan__Loan_Payment_Transaction__c> payment = [SELECT Id ,loan__Transaction_Amount__c FROM loan__Loan_Payment_Transaction__c limit 1];
        existingSummaries.put(summary[1].Id,summary[1]);
        
        loan.LoanActionFactory factory = new loan.LoanActionFactory();
        loan.LoanAction2 api = factory.getLoanAction2API();
        Set<Id> paymentId = new  Set<Id> ();
        paymentId.add(payment[0].id);
        List<loan__Repayment_Transaction_Adjustment__c> rev = api.reverseLoanPayment(paymentId,'Human Error','Ref-001');
            
        List<loan__Repayment_Transaction_Adjustment__c> reverse = [SELECT Id,
                                                                          loan__Loan_Payment_Transaction__r.loan__Transaction_Amount__c 
                                                                   FROM loan__Repayment_Transaction_Adjustment__c 
                                                                   LIMIT 1];
        summary = [SELECT loan__Current_Interest_Rate__c,
                          loan__Current_Loan_Balance__c,
                          loan__Current_Payoff_Balance__c,
                          loan__Current_Principal_Remaining__c,
                          loan__Repayment_Txn_Reversal__c,
                          loan__Transaction_Amount__c,
                          loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                          loan__Consolidated_Loan_Balance__c
                   FROM loan__Loan_Transaction_Summary__c
                   Order By CreatedDate ASC];
        
        loanAcc = TestLoan.getLoanAccount(loanAcc);

       existingSummaries.put(summary[2].Id,summary[2]);
  
        //Disbursal reversal
        loan__Disbursal_Adjustment__c adjTxn = new loan__Disbursal_Adjustment__c(loan__Loan_Disbursal_Transaction__c = disTxn.Id,
                                                                     loan__Adjustment_Txn_Date__c = dateutil.getCurrentSystemDate());

        Database.insert(adjTxn);
        List<loan__Disbursal_Adjustment__c> disReverse = [SELECT Id,
                                                                loan__Loan_Disbursal_Transaction__r.loan__Disbursed_Amt__c 
                                                          FROM loan__Disbursal_Adjustment__c 
                                                          LIMIT 1];
        summary = [SELECT loan__Current_Interest_Rate__c,
                         loan__Current_Loan_Balance__c,
                          loan__Current_Payoff_Balance__c,
                         loan__Current_Principal_Remaining__c,
                          loan__Disbursal_Reversal__c,
                         loan__Transaction_Amount__c,
                          loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                        loan__Consolidated_Loan_Balance__c,
                   CreatedDate
                   FROM loan__Loan_Transaction_Summary__c
                   Order By CreatedDate ASC];
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        existingSummaries.put(summary[3].Id,summary[3]);
        List<loan__Loan_Account__c> loanAccList = new List<loan__Loan_Account__c>();
        LTSMigrationHandler handler = new LTSMigrationHandler(startDate,currentSystemDate);       
        loanAccList.add(TestLoan.getLoanAccount(loanAcc));
        handler.process(loanAccList);
       
        List<loan__Loan_Transaction_Summary__c> newSummariesList = [SELECT Id,loan__Current_Interest_Rate__c,
                                                                      loan__Current_Loan_Balance__c,
                                                                      loan__Current_Payoff_Balance__c,
                                                                      loan__Current_Principal_Remaining__c,
                                                                      loan__Disbursal_Reversal__c,
                                                                      loan__Transaction_Amount__c,
                                                                	  loan__Repayment_Txn_Reversal__c,
                                                                      loan__Loan_Payment_Txn__c,
                                                              		  loan__Loan_Disbursal__c,
                                                                      loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                                                                      loan__Consolidated_Loan_Balance__c
                                                               FROM loan__Loan_Transaction_Summary__c
                                                               Order By CreatedDate ASC];
        System.assertEquals(newSummariesList.size(),4);
        for(loan__Loan_Transaction_Summary__c lts:newSummariesList){
            loan__Loan_Transaction_Summary__c extngLts = existingSummaries.get(lts.Id);
            System.assertEquals(extngLts.loan__Current_Principal_Remaining__c, lts.loan__Current_Principal_Remaining__c);
            System.assertEquals(extngLts.loan__Current_Payoff_Balance__c, lts.loan__Current_Payoff_Balance__c);
            System.assertEquals(extngLts.loan__Transaction_Amount__c, lts.loan__Transaction_Amount__c);
            System.assertEquals(extngLts.loan__Consolidated_Loan_Balance__c, lts.loan__Consolidated_Loan_Balance__c);
            
        }       
    }
   public static testMethod void TestSummaryOLTTxn(){
       loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
       Date currentSystemDate = dateutil.getCurrentSystemDate();
       Date startDate = currentSystemDate;
       loan__Loan_Product__c lp = getLoanProduct('Loan Product');
       List<loan__Loan_Account__c> loanAccountList = new List<loan__Loan_Account__c>();
       List<loan__Office_Name__c> dummyOffice = [SELECT Id
                                            FROM loan__Office_Name__c
                                           ];
       loan__Payment_Mode__c pMode = [SELECT Id,
                                        Name 
                                 FROM loan__Payment_Mode__c 
                                 WHERE Name = 'Cash'];
       loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
        
       loan__Loan_Account__C loanAcc = [SELECT id,
                                               loan__Provision_Amount__C ,
                                               loan__Loan_Status__c
                                        FROM loan__Loan_Account__c 
                                        WHERE loan__Product_Type__c =:loan.LoanConstants.LOAN 
                                        LIMIT 1];
        Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = new loan__Loan_Disbursal_Transaction__c();
        disTxn.loan__Loan_Account__c = loanAcc.Id;
        disTxn.loan__Disbursal_Date__c = currentSystemDate;
        disTxn.loan__Transaction_Creation_Date__c = currentSystemDate;
        distxn.loan__Disbursed_Amt__c=10000;
        disTxn.loan__Mode_Of_Payment__c = pMode.Id;
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
      

        disTxn = [SELECT Id, 
                       Name, 
                       loan__Transaction_Creation_Date__c,
                       loan__Bank_Account__c   
                FROM loan__Loan_Disbursal_Transaction__c ];
        System.assertEquals(disTxn.loan__Transaction_Creation_Date__c,dateutil.getCurrentSystemDate());
       	//Rate change
        loan.LoanAction la = new loan.LoanActionFactory().getLoanActionAPI();
		la.changeInterestRate(loanAcc.id, null, 7);
        Integer start = System.Now().millisecond();
        while(System.Now().millisecond()< start+100){ 
        }
        List<loan__Other_Transaction__c> oTxn = [SELECT Id,Name,
                                                        loan__Transaction_Type__c,
                                                        loan__Loan_Account__c
                                                FROM loan__Other_Transaction__c
                                                WHERE loan__Loan_Account__c = :loanAcc.Id
                                                Order By CreatedDate ASC];
        System.assertEquals(1, oTxn.size());
        System.assertEquals(loan.LoanConstants.LOAN_TRANSACTION_RATE_CHANGE, oTxn.get(0).loan__Transaction_Type__c);
       
        loan.GlobalProcessFacade.moveSystemToDate(currentSystemDate+1,false);   
        currentSystemDate=dateutil.getCurrentSystemDate();
        loan__Loan_Payment_Transaction__c pmt = new loan__Loan_Payment_Transaction__c();
        pmt.loan__Loan_Account__c = loanAcc.Id;
        pmt.loan__Transaction_Date__c = currentSystemDate;
        pmt.loan__Transaction_Amount__c =11000;
        pmt.loan__Principal__c = 11000;
        pmt.loan__Interest__c = 0;
        pmt.loan__Early_Total_Repayment_of_the_Loan__c = true;
        pmt.loan__Manual_Payment__c = true;
        pmt.loan__Transaction_Creation_Date__c = currentSystemDate;
        pmt.loan__Payment_Mode__c = pMode.Id;
        Database.insert(pmt);

        pmt.loan__Cleared__c = true;
       
        Database.update(pmt);
        loan__Loan_Payment_Transaction__c lpt = [SELECT Id,
                                                        loan__Early_Total_Repayment_of_the_Loan__c,
                                                        loan__Transaction_Amount__c
                                                 FROM loan__Loan_Payment_Transaction__c
                                                 WHERE loan__Loan_Account__c = :loanAcc.Id];
        System.assertEquals(true, lpt.loan__Early_Total_Repayment_of_the_Loan__c);
        Test.stopTest();
        lp.loan__Create_Summaries__C = true;
        Database.update(lp);
        List<loan__Loan_Account__c > loanAccList = new List<loan__Loan_Account__c>();
        LTSMigrationHandler handler = new LTSMigrationHandler(startDate,currentSystemDate);
        loanAccList.add(TestLoan.getLoanAccount(loanAcc));
        handler.process(loanAccList);
        List<loan__Loan_transaction_summary__c> summary = [SELECT loan__Current_Interest_Rate__c,
                                                                  loan__Current_Loan_Balance__c,
                                                                  loan__Current_Payoff_Balance__c,
                                                                  loan__Current_Principal_Remaining__c,
                                                                  loan__Other_Loan_Txn__c,
                                                                  loan__Invalid_data__c,
                                                                  loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                                                                  loan__Consolidated_Loan_Balance__c,
                                                                  loan__Loan_Payment_Txn__c
                                                         FROM loan__Loan_Transaction_Summary__c
                                                         Order By loan__Transaction_Time__c ASC];
       
        System.assertEquals(3, summary.size());
        System.assertEquals(10000, summary[0].loan__Current_Principal_Remaining__c);
        System.assertEquals(10000, summary[0].loan__Current_Payoff_Balance__c); 
       	System.assertEquals(5, summary[0].loan__Current_Interest_Rate__c);
        System.assertEquals(10000, summary[1].loan__Current_Principal_Remaining__c);
        System.assertEquals(10000, summary[1].loan__Current_Payoff_Balance__c);
        System.assertEquals(oTxn[0].Id, summary[1].loan__Other_Loan_Txn__c);
        System.assertEquals(7, summary[1].loan__Current_Interest_Rate__c);
       	System.assertEquals(0, summary[2].loan__Current_Principal_Remaining__c);
        System.assertEquals(0, summary[2].loan__Current_Payoff_Balance__c);
        System.assertEquals(lpt.Id, summary[2].loan__Loan_Payment_Txn__c);       
   }
    
    public static testMethod void TestSummaryForDateRange(){ 
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
       Date currentSystemDate = dateutil.getCurrentSystemDate();
       loan__Loan_Product__c lp = getLoanProduct('Loan Product');
       List<loan__Loan_Account__c> loanAccountList = new List<loan__Loan_Account__c>();
       loan__Loan_Product__c loanProd = getLoanProduct('Loan Product');
       List<loan__Office_Name__c> dummyOffice = [SELECT Id
                                            FROM loan__Office_Name__c
                                           ];
       loan__Payment_Mode__c pMode = [SELECT Id,
                                        Name 
                                 FROM loan__Payment_Mode__c 
                                 WHERE Name = 'Cash'];
      loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
        
      loan__Loan_Account__C loanAcc = [SELECT id,
                                         loan__Provision_Amount__C ,
                                         loan__Loan_status__c
                                      FROM loan__Loan_Account__c 
                                  WHERE loan__Product_Type__c =:loan.LoanConstants.LOAN 
                                  LIMIT 1];
        Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = new loan__Loan_Disbursal_Transaction__c();
        disTxn.loan__Loan_Account__c = loanAcc.Id;
        disTxn.loan__Disbursal_Date__c = currentSystemDate;
        disTxn.loan__Transaction_Creation_Date__c = currentSystemDate;
        distxn.loan__Disbursed_Amt__c=10000;
        disTxn.loan__Mode_Of_Payment__c = pMode.Id;
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
      
        disTxn = [SELECT Id, 
                       Name, 
                       loan__Transaction_Creation_Date__c,
                       loan__Bank_Account__c ,
                  CreatedDate
                FROM loan__Loan_Disbursal_Transaction__c ];
 
        System.assertEquals(disTxn.loan__Transaction_Creation_Date__c,dateutil.getCurrentSystemDate());
        
        loan.GlobalProcessFacade.moveSystemToDate(currentSystemDate+3,false);   
        currentSystemDate=dateutil.getCurrentSystemDate();
            
        Date startDate = currentSystemDate;
        loan__Loan_Payment_Transaction__c pmt = new loan__Loan_Payment_Transaction__c();
        pmt.loan__Loan_Account__c = loanAcc.Id;
        pmt.loan__Transaction_Date__c = currentSystemDate;
        pmt.loan__Transaction_Creation_Date__c = currentSystemDate;
        pmt.loan__Transaction_Amount__c =100;
        pmt.loan__Principal__c = 90;
        pmt.loan__Interest__c = 10;
        pmt.loan__Manual_Payment__c = true;
        pmt.loan__Payment_Mode__c = pMode.Id;
        Database.insert(pmt);

        pmt.loan__Cleared__c = true;
       
        Database.update(pmt);
        
        List<loan__Loan_Payment_Transaction__c> payment = [SELECT Id ,loan__Transaction_Amount__c FROM loan__Loan_Payment_Transaction__c limit 1];
        List<loan__Loan_Account__c > loanAccList = new List<loan__Loan_Account__c>();
        LTSMigrationHandler handler = new LTSMigrationHandler(startDate,currentSystemDate);       
        loanAccList.add(TestLoan.getLoanAccount(loanAcc));
        handler.process(loanAccList);
        List<loan__Loan_transaction_summary__c> summary = [SELECT loan__Current_Interest_Rate__c,
                                                            loan__Current_Loan_Balance__c,
                                                            loan__Current_Payoff_Balance__c,
                                                            loan__Current_Principal_Remaining__c,
                                                            loan__Other_Loan_Txn__c,
                                                            loan__Invalid_data__c,
                                                    		loan__Transaction_Amount__c,
                                                            loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                                                            loan__Consolidated_Loan_Balance__c,
                                                     loan__Loan_Payment_Txn__c
                                                     FROM loan__Loan_Transaction_Summary__c
                                                     Order By loan__Transaction_Time__c ASC];
        
       loanAcc=TestLoan.getLoanAccount(loanAcc) ; 
       System.assertEquals(1, summary.size());
       System.assertEquals(loanAcc.loan__Principal_Remaining__c, summary[0].loan__Current_Principal_Remaining__c);
       System.assertEquals(loanAcc.loan__Loan_Balance__c, summary[0].loan__Current_Loan_Balance__c);
       System.assertEquals(payment[0].Id, summary[0].loan__Loan_Payment_Txn__c);
       System.assertEquals(payment[0].loan__Transaction_Amount__c, summary[0].loan__Transaction_Amount__c);  
    }
    
    public static testMethod void TestSummaryBills(){
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
        Date currentSystemDate = dateutil.getCurrentSystemDate();
         Date startDate = currentSystemDate;
        List<loan__Loan_Account__c> loanAccountList = new List<loan__Loan_Account__c>();
         loan__Loan_Product__c lp = getLoanProduct('Loan Product');
        List<loan__Office_Name__c> dummyOffice = [SELECT Id
                                            FROM loan__Office_Name__c
                                           ];
        loan__Payment_Mode__c pMode = [SELECT Id,
                                        Name 
                                 FROM loan__Payment_Mode__c 
                                 WHERE Name = 'Cash'];
        loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
        
        loan__Loan_Account__C loanAcc = [SELECT id,
                                         loan__Provision_Amount__C ,
                                         loan__Loan_status__c
                                  FROM loan__Loan_Account__c 
                                  WHERE loan__Product_Type__c =:loan.LoanConstants.LOAN 
                                  LIMIT 1];
        Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = new loan__Loan_Disbursal_Transaction__c();
        disTxn.loan__Loan_Account__c = loanAcc.Id;
        disTxn.loan__Disbursal_Date__c = currentSystemDate;
        disTxn.loan__Transaction_Creation_Date__c = currentSystemDate;
        distxn.loan__Disbursed_Amt__c=10000;
        disTxn.loan__Mode_Of_Payment__c = pMode.Id;
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
       
        disTxn = [SELECT Id, 
                       Name, 
                       loan__Transaction_Creation_Date__c,
                       loan__Bank_Account__c   
                FROM loan__Loan_Disbursal_Transaction__c ];
        System.assertEquals(disTxn.loan__Transaction_Creation_Date__c,dateutil.getCurrentSystemDate());
        //Generating Bills
         System.debug('inisde the biling test currentSystemDate::'+currentSystemDate);
        loan.GlobalProcessFacade.moveSystemToDate(currentSystemDate+31,false);   
        currentSystemDate=dateutil.getCurrentSystemDate();
        loan__Loan_Product__c loanProd = getLoanProduct('Loan Product');
      
        loan__Loan_account_Due_Details__c bills = new loan__Loan_account_Due_Details__c();
        bills.loan__due_type_description__c ='BILL / DUE DATE';
        bills.loan__Loan_Account__c = loanAcc.Id;
        bills.loan__Archived__c = false;
        bills.loan__Due_Amt__c = 450;
        bills.loan__Transaction_Creation_Date__c =currentSystemDate;

        Database.insert(bills);

        
         bills = [SELECT loan__due_type_description__c,loan__Loan_Account__c,loan__Due_Amt__c from loan__Loan_account_Due_Details__c LIMIT 1 ];

        List<loan__Fee__c> fees = [SELECT Id, Name, loan__Include_In_Dues__c FROM loan__Fee__c ORDER BY Name ASC];
      
        loan__Charge__c charge = new loan__Charge__c();
        charge.loan__Loan_Account__c = loanAcc.Id;
        charge.loan__Original_Amount__c = 100;
        charge.loan__Transaction_Creation_Date__c = dateutil.getCurrentSystemDate();
        charge.loan__Fee__c = fees.get(0).Id;
        charge.loan__Date__c = dateutil.getCurrentSystemDate();
        Database.insert(charge);  

        List<loan__Charge__c> charges = [SELECT ID,
                                          loan__Date__c,
                                          loan__Fee__c,
                                   		loan__Original_Amount__c,
                                   loan__Transaction_Creation_Date__c
                                   FROM loan__Charge__c
                                   WHERE loan__Loan_Account__c=:loanAcc.Id];
 
        System.assertEquals(1, charges.size());
        System.debug('inside before loan__Transaction_Creation_Date__c ::'+currentSystemDate);
        charges[0].loan__Transaction_Creation_Date__c = currentSystemDate;
        Database.update(charges);
        charges = [SELECT ID,
                   loan__Date__c,
                   loan__Fee__c,
                   loan__Original_Amount__c,
                   loan__Transaction_Creation_Date__c
                   FROM loan__Charge__c
                   WHERE loan__loan_Account__c=:loanAcc.Id];
       
        loan__Loan_Payment_Transaction__c pmt = new loan__Loan_Payment_Transaction__c();
        pmt.loan__Loan_Account__c = loanAcc.Id;
        pmt.loan__Transaction_Date__c = currentSystemDate;
        pmt.loan__Transaction_Amount__c =100;
        pmt.loan__Transaction_Creation_Date__c = currentSystemDate;
        pmt.loan__Principal__c = 90;
        pmt.loan__Interest__c = 10;
        pmt.loan__Manual_Payment__c = true;
        pmt.loan__Payment_Mode__c = pMode.Id;
        Database.insert(pmt);

        pmt.loan__Cleared__c = true;
       
        Database.update(pmt);
          System.debug('inside the test case pmt::');
       
        List<loan__Loan_Payment_Transaction__c> payment = [SELECT Id ,loan__Transaction_Amount__c FROM loan__Loan_Payment_Transaction__c limit 1];
        
        lp.loan__Create_Summaries__C = true;
        Database.update(lp);
     
       List<loan__Loan_Account__c > loanAccList = new List<loan__Loan_Account__c>();
       LTSMigrationHandler handler = new LTSMigrationHandler(startDate,currentSystemDate);

       loanAccList.add(TestLoan.getLoanAccount(loanAcc));
       handler.process(loanAccList);
       Test.stopTest(); 

        List<loan__Loan_transaction_summary__c> summary = [SELECT loan__Current_Interest_Rate__c,
                                                            loan__Current_Loan_Balance__c,
                                                            loan__Current_Principal_Remaining__c,
                                                            loan__Loan_Due_Detail__c,
                                                            loan__Transaction_Amount__c,
                                                            loan__Current_Delinquent_Amount__c,
                                                            loan__Current_Payoff_Balance__c,                                                     
                                                            loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                                                            loan__Consolidated_Loan_Balance__c
                                                        FROM loan__Loan_Transaction_Summary__c
                                                        Order By loan__Transaction_Time__c ASC];
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        System.assertEquals(4, summary.size());
        System.assertEquals(summary[0].loan__Current_Interest_Rate__c,5);
        System.assertEquals(summary[0].loan__Current_Loan_Balance__c,10000);
        System.assertEquals(summary[0].loan__Current_Principal_Remaining__c,10000);
        System.assertEquals(summary[0].loan__Current_Delinquent_Amount__c,0);
        System.assertEquals(summary[0].loan__Current_Payoff_Balance__c,10000);
        System.assertEquals(10000, summary[1].loan__Current_Principal_Remaining__c);
        System.assertEquals(10000, summary[1].loan__Current_Loan_Balance__c);
        System.assertEquals(bills.Id, summary[1].loan__Loan_Due_Detail__c);
        System.assertEquals(bills.loan__Due_Amt__c, summary[1].loan__Transaction_Amount__c);
        System.assertEquals(summary[1].loan__Current_Payoff_Balance__c,10000);
        System.assertEquals(summary[2].loan__Current_Interest_Rate__c,5);
        System.assertEquals(summary[2].loan__Current_Payoff_Balance__c,10100);//Increased due to charge
        System.assertEquals(summary[2].loan__Current_Loan_Balance__c,10000);
        System.assertEquals(summary[2].loan__Current_Principal_Remaining__c,10000);
        System.assertEquals(summary[2].loan__Current_Delinquent_Amount__c,0);
        System.assertEquals(summary[3].loan__Current_Interest_Rate__c,5);
        System.assertEquals(summary[3].loan__Current_Loan_Balance__c,9910);
        System.assertEquals(summary[3].loan__Current_Principal_Remaining__c,9910);
        System.assertEquals(summary[3].loan__Current_Payoff_Balance__c,10000);       
    }
    
        //marking payment as invalid so it wont get stored
     public static testMethod void TestSummaryWithInvalidTxns(){
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
        List<String> trans = new List<String>();
        Date currentSystemDate = dateutil.getCurrentSystemDate();
        Date startDate = currentSystemDate;
        List<loan__Loan_Account__c> loanAccountList = new List<loan__Loan_Account__c>();
        loan__Loan_Product__c lp = getLoanProduct('Loan Product');
        loan__Payment_Mode__c pMode = [SELECT Id,Name FROM loan__Payment_Mode__c WHERE Name = 'Cash'];
        loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
        List<loan__Object_Event_Mapping__c> oemList=[SELECT Id, 
                                                        	loan__Enable_Tracking__c, 
                                                        	loan__Transaction_Name__c, 
                                                        	loan__API_Name__c, 
                                                        	loan__Transaction_Type__c 
                                                    FROM loan__Object_Event_Mapping__c
                                                    WHERE loan__Transaction_Name__c = 'Regular Payment'];
         
       oemList[0].loan__Enable_Tracking__c = false;
        Database.update(oemList);
        loan__Loan_Account__C loanAcc = [SELECT id,
                                         		loan__Provision_Amount__C ,
                                          		loan__Loan_Status__c
                                      	FROM loan__Loan_Account__c 
                                 		WHERE loan__Product_Type__c =:loan.LoanConstants.LOAN 
                                  		LIMIT 1];
        Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = new loan__Loan_Disbursal_Transaction__c();
        disTxn.loan__Loan_Account__c = loanAcc.Id;
        disTxn.loan__Disbursal_Date__c = currentSystemDate;
        disTxn.loan__Transaction_Creation_Date__c = currentSystemDate;
        distxn.loan__Disbursed_Amt__c=10000;
        disTxn.loan__Mode_Of_Payment__c = pMode.Id;
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        disTxn = [SELECT Id, 
                       Name, 
                       loan__Transaction_Creation_Date__c,
                       loan__Bank_Account__c ,
                       loan__Disbursed_Amt__c  
                FROM loan__Loan_Disbursal_Transaction__c ];
        System.assertEquals(disTxn.loan__Transaction_Creation_Date__c,dateutil.getCurrentSystemDate());
        Test.stopTest();
       
        loan__Loan_Payment_Transaction__c pmt = new loan__Loan_Payment_Transaction__c();
        pmt.loan__Loan_Account__c = loanAcc.Id;
        pmt.loan__Transaction_Date__c = currentSystemDate;
        pmt.loan__Transaction_Creation_Date__c = currentSystemDate;
        pmt.loan__Transaction_Amount__c =100;
        pmt.loan__Principal__c = 90;
        pmt.loan__Interest__c = 10;
        pmt.loan__Manual_Payment__c = true;
        pmt.loan__Payment_Mode__c = pMode.Id;
        Database.insert(pmt);

        pmt.loan__Cleared__c = true;
       
        Database.update(pmt);
       
       
        List<loan__Loan_Payment_Transaction__c> payment = [SELECT Id ,loan__Transaction_Amount__c FROM loan__Loan_Payment_Transaction__c limit 1];
        
        loan__Repayment_Transaction_Adjustment__c reversalTxn = new loan__Repayment_Transaction_Adjustment__c();
        reversalTxn.loan__Adjustment_Txn_Date__c = currentSystemDate;
        reversalTxn.loan__Transaction_Creation_Date__c = currentSystemDate;
        reversalTxn.loan__Loan_Payment_Transaction__c = payment[0].Id;
        reversalTxn.loan__Refund_To_Borrower__c = false;
        Database.insert(reversalTxn);
            
        List<loan__Repayment_Transaction_Adjustment__c> reverse = [SELECT Id,loan__Loan_Payment_Transaction__r.loan__Transaction_Amount__c FROM loan__Repayment_Transaction_Adjustment__c LIMIT 1];
        System.assertEquals(1,reverse.size());
  
        loanAcc = TestLoan.getLoanAccount(loanAcc);
       
        loan__Disbursal_Adjustment__c adjTxn = new loan__Disbursal_Adjustment__c(loan__Loan_Disbursal_Transaction__c = disTxn.Id,
                                                                      loan__Transaction_Creation_Date__c = currentSystemDate,
                                                                     loan__Adjustment_Txn_Date__c = currentSystemDate);

        Database.insert(adjTxn);
    
        List<loan__Disbursal_Adjustment__c> disReverse = [SELECT Id,loan__Loan_Disbursal_Transaction__r.loan__Disbursed_Amt__c FROM loan__Disbursal_Adjustment__c LIMIT 1];
        lp.loan__Create_Summaries__C = true;
        Database.update(lp);
        List<loan__Loan_Account__c > loanAccList = new List<loan__Loan_Account__c>();
        LTSMigrationHandler handler = new LTSMigrationHandler(startDate,currentSystemDate);
       
        loanAccList.add(TestLoan.getLoanAccount(loanAcc));
        Date resolvedDate = Date.newinstance(currentSystemDate.year(), currentSystemDate.month(), currentSystemDate.day());
      
        handler.process(loanAccList);
        
        List<loan__Loan_Transaction_Summary__c> summary = [SELECT loan__Current_Interest_Rate__c,
                                                                  loan__Current_Loan_Balance__c,
                                                                  loan__Current_Payoff_Balance__c,
                                                                  loan__Current_Principal_Remaining__c,
                                                                  loan__Current_Delinquent_Amount__c,
                                                                  loan__Invalid_data__c,
                                                           		  loan__Transaction_Type_Id__r.loan__Transaction_Name__C
                                                            FROM loan__Loan_Transaction_Summary__c
                                                            Order By loan__Transaction_Time__c ASC]; 
        
        System.assertEquals(3,summary.size());
        System.assertEquals(summary[0].loan__Current_Interest_Rate__c,5);
        System.assertEquals(summary[0].loan__Current_Loan_Balance__c,10000);
        System.assertEquals(summary[0].loan__Current_Principal_Remaining__c,10000);
        System.assertEquals(summary[0].loan__Current_Delinquent_Amount__c,0);
        System.assertEquals(summary[0]. loan__Transaction_Type_Id__r.loan__Transaction_Name__C,loan.LoanConstants.REGULAR_DISBURSAL_TYPE);
        System.assertEquals(summary[1].loan__Current_Interest_Rate__c,5);
        System.assertEquals(summary[1].loan__Current_Loan_Balance__c,10000);
        System.assertEquals(summary[1].loan__Current_Principal_Remaining__c,10000);
        System.assertEquals(summary[1].loan__Current_Delinquent_Amount__c,0);
        System.assertEquals(summary[1]. loan__Transaction_Type_Id__r.loan__Transaction_Name__C,loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_REVERSAL);
        System.assertEquals(summary[2].loan__Current_Interest_Rate__c,5);
        System.assertEquals(summary[2].loan__Current_Loan_Balance__c,0);
        System.assertEquals(summary[2].loan__Current_Principal_Remaining__c,0);
        System.assertEquals(summary[2].loan__Current_Delinquent_Amount__c,0);
        System.assertEquals(summary[2]. loan__Transaction_Type_Id__r.loan__Transaction_Name__C,loan.LoanConstants.LOAN_TRANSACTION_DISBURSAL_REVERSAL);
        
    }
    public static testMethod void testMigrationWithDeposit(){
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
        Contact cont = [SELECT Id FROM Contact where FirstName = 'Dummy'];
        Date currentSystemDate = dateutil.getCurrentSystemDate();
        Date startDate = currentSystemDate;
        loan__Client__c dummyClient = [SELECT Id FROM loan__Client__c Limit 1];
        loan__Loan_Product__c lp = getLoanProduct('Loan Product');
        lp.loan__Adjust_Deposit_Amount_In_Payoff__c = true;
        lp.loan__Payment_Application_Mode__c = loan.LoanConstants.LOAN_PAYMENT_APPLICATION_DEPOSIT;
        Database.update(lp);
        loan__Loan_Account__c loanAcc1 = new loan__Loan_Account__c(loan__Loan_Amount__c = 10000,
                                                                   loan__Client__c = dummyClient.ID,
                                                                   loan__Contact__c = cont.ID,
                                                                   loan__Product_Type__c = loan.LoanConstants.LOAN,
                                                                   loan__Loan_Product_Name__c = lp.ID,
                                                                   loan__Number_Of_Installments__c = 12,
                                                                   loan__Interest_Rate__c = 5,
                                                                   loan__Expected_Disbursal_Date__c = currentSystemDate,
                                                                   loan__Expected_Repayment_Start_Date__c = loan.TestHelper.systemDate.addMonths(1),
                                                                   loan__Is_Interest_Posting_Enabled__c = true,
                                                                   loan__Interest_Posting_Frequency__c = loan.LoanConstants.LOAN_PAYMENT_FREQ_BILLING_FREQUENCY,
                                                                   loan__Capitalization_Frequency__c = 'Monthly',
                                                                   loan__Pre_Bill_Days__c = 5,
                                                                   loan__Payment_Application_Order__c = loan.LoanConstants.DATE_WISE,
                                                                   loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUS_APPROVED);
      
        List<loan.LoanAccountParameters.Deposit> depositList = new List<loan.LoanAccountParameters.Deposit>();       
     	loan.LoanAccountParameters loanAccountParam = new loan.LoanAccountParameters();
     	loanAccountParam.setLoanAccountToCreate(loanAcc1);
     //   loanAccountParam.setDepositList(depositList);
        loan.AbstractLoanActions loanAPI = new loan.LoanActionFactory().getLoanActionsAPI();
     	loan__Loan_Account__c loanAcc = loanAPI.createContract(loanAccountParam); 
        List<clcommon__Deposit__c> depositList1 = new List<clcommon__Deposit__c>();
        clcommon__Deposit__c deposit1 = new clcommon__Deposit__c(clcommon__Deposit_Amount__c = 1000,
                                                                 clcommon__Current_Deposit_Amount__c = 1000,
                                                                 clcommon__Deposit_Rate__c = 5,
                                                                 clcommon__Sequence__c = 1,
                                                                 clcommon__Transaction_Creation_Date__c = currentSystemDate,
                                                                 clcommon__Priority__c = 1,
                                                                 clcommon__Transaction_Date__c =currentSystemDate,
                                                                 loan__Loan_Account__c= loanAcc.Id );
        depositList1.add(deposit1);
        deposit1 = new clcommon__Deposit__c(clcommon__Deposit_Amount__c = 1000,
                                            clcommon__Current_Deposit_Amount__c = 1000,
                                            clcommon__Deposit_Rate__c = 10,
                                            clcommon__Sequence__c = 2,
                                            clcommon__Transaction_Creation_Date__c = currentSystemDate,
                                            clcommon__Priority__c = 2,
                                            clcommon__Transaction_Date__c =currentSystemDate,
                                            loan__Loan_Account__c= loanAcc.Id );
        depositList1.add(deposit1);
        Database.insert(depositList1); 
        System.debug('inside current system date ::'+currentSystemDate);
        List<loan__Office_Name__c> dummyOffice = [SELECT Id
                                            FROM loan__Office_Name__c
                                           ];
        loan__Payment_Mode__c pMode = [SELECT Id,
                                        Name 
                                 FROM loan__Payment_Mode__c 
                                 WHERE Name = 'Cash'];
        loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
        Set<Id> loanAccsId = new  Set<Id>();
        loanAccsId.add(loanAcc.Id);
         loan.LoanTransactionUtil.queryAndSetDepositDetailsMap(loanAccsId);
         List<clcommon__Deposit__c> depositList123 = loan.LoanTransactionUtil.getDepositListForALoan(loanAcc.Id);  
        System.debug('inside the deposit ::'+depositList123);
         Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = new loan__Loan_Disbursal_Transaction__c();
        disTxn.loan__Loan_Account__c = loanAcc.Id;
        disTxn.loan__Disbursal_Date__c = currentSystemDate;
        disTxn.loan__Transaction_Creation_Date__c = currentSystemDate;
        distxn.loan__Disbursed_Amt__c=10000;
        disTxn.loan__Mode_Of_Payment__c = pMode.Id;
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        disTxn = [SELECT Id, 
                       Name, 
                       loan__Transaction_Creation_Date__c,
                       loan__Bank_Account__c ,
                       loan__Disbursed_Amt__c  
                FROM loan__Loan_Disbursal_Transaction__c ];
        System.assertEquals(disTxn.loan__Transaction_Creation_Date__c,dateutil.getCurrentSystemDate());
        Test.stopTest();

        loan.GlobalProcessFacade.moveSystemToDate(currentSystemDate+1,false);   
        currentSystemDate=dateutil.getCurrentSystemDate();
        loan__Loan_Payment_Transaction__c pmt = new loan__Loan_Payment_Transaction__c();
        pmt.loan__Loan_Account__c = loanAcc.Id;
        pmt.loan__Transaction_Date__c = currentSystemDate;
        pmt.loan__Transaction_Creation_Date__c = currentSystemDate;
        pmt.loan__Transaction_Amount__c =100;
        pmt.loan__Principal__c = 90;
        pmt.loan__Interest__c = 10;
        pmt.loan__Manual_Payment__c = true;
        pmt.loan__Payment_Mode__c = pMode.Id;
        Database.insert(pmt);

        pmt.loan__Cleared__c = true;
       
        Database.update(pmt);       
        List<loan__Loan_Payment_Transaction__c> payment = [SELECT Id ,loan__Transaction_Amount__c FROM loan__Loan_Payment_Transaction__c limit 1];
        loan.GlobalProcessFacade.moveSystemToDate(currentSystemDate+1,false);   
        currentSystemDate = dateutil.getCurrentSystemDate(); 
   
        loan.LoanActionFactory factory = new loan.LoanActionFactory();
        loan.LoanAction2 api = factory.getLoanAction2API();
        
        Set<Id> paymentId = new  Set<Id> ();
        paymentId.add(payment[0].id);
        List<loan__Repayment_Transaction_Adjustment__c> rev = api.reverseLoanPayment(paymentId,'Human Error','Ref-001');
            
        List<loan__Repayment_Transaction_Adjustment__c> reverse = [SELECT Id,loan__Loan_Payment_Transaction__r.loan__Transaction_Amount__c FROM loan__Repayment_Transaction_Adjustment__c LIMIT 1];
        lp.loan__Create_Summaries__C = true;
        Database.update(lp);
       List<loan__Loan_Account__c > loanAccList = new List<loan__Loan_Account__c>();
       LTSMigrationHandler handler = new LTSMigrationHandler(startDate,currentSystemDate);
       
       loanAccList.add(TestLoan.getLoanAccount(loanAcc));
       handler.process(loanAccList);
        List<loan__Loan_transaction_summary__c> summary = [SELECT loan__Current_Interest_Rate__c,
                                                            loan__Current_Loan_Balance__c,
                                                            loan__Current_Payoff_Balance__c,
                                                            loan__Current_Principal_Remaining__c,
                                                            loan__Other_Loan_Txn__c,
                                                            loan__Invalid_data__c,
                                                            loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                                                            loan__Consolidated_Loan_Balance__c,
                                                     loan__Current_Delinquent_Amount__c,
                                                     loan__Loan_Payment_Txn__c
                                                     FROM loan__Loan_Transaction_Summary__c
                                                     Order By loan__Transaction_Time__c ASC];
        
        
        System.assertEquals(3, summary.size()); 
        System.assertEquals(summary[0].loan__Current_Interest_Rate__c,5);
        System.assertEquals(summary[0].loan__Current_Loan_Balance__c,10000);
        System.assertEquals(summary[0].loan__Current_Principal_Remaining__c,10000);
        System.assertEquals(summary[0].loan__Current_Delinquent_Amount__c,0);
        System.assertEquals(summary[0].loan__Current_Payoff_Balance__c,10000); 
        System.assertEquals(summary[0].loan__Consolidated_Loan_Balance__c,8000); 
        
    }
    

}