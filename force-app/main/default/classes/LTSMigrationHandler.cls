/******************************************************************
Description : This class has been provided by CL to handle transactions present
              on Transaction Summary object and migrate to Loan Transaction Summary
******************************************************************/
global with sharing class LTSMigrationHandler {
    public loan__Org_Parameters__c orgParam;
    private mfiflexUtil.UnitOfWorkTransaction uowTransaction;
    List<loan__Batch_Process_Log__c> logsList = new List<loan__Batch_Process_Log__c>();
    Date startDate,endDate;
    String ns;
    //This constructor helps in setting up the dates
    global LTSMigrationHandler(Date startDate, Date endDate) {
        orgParam = loan.CustomSettingsUtil.getOrgParameters();
        uowTransaction = new mfiflexUtil.UnitOfWorkTransaction(new loan.LoanAccountObjectHierarchy());
        ns = loan.CustomSettingsUtil.getOrgParameters().loan__Namespace_Prefix__c;
        this.startDate = startDate;
        this.endDate = endDate ;
    }
    //Helps in picking up existing LTS records
    global List<loan__Loan_Transaction_Summary__c> getLTSTxn1(Date startDate, Date endDate,Set<Id> loanIds){
        String fields = 'Id,Last_transaction_id__c,Loan_Account__c,Consolidated_Loan_Balance__c,Current_Interest_Rate__c,'+
                        'Current_Loan_Balance__c, Current_Principal_Remaining__c,Repayment_Txn_Reversal__c,'+
                        'Current_Payoff_Balance__c, Current_Delinquent_Amount__c,Interest_Rate__c, Balance__c,Principal_Remaining__c,Pay_Off_Amount_As_Of_Today__c,'+
                        'Loan_Disbursal__c,Discarded_Data__c,Transaction_Date__c, Other_Loan_Txn__c,Loan_Payment_Txn__c, Interest_Posting_Txn__c,'+
                        'Loan_Charge__c,Disbursal_Reversal__c, Loan_Due_Detail__c, Transaction_Time__c, Delinquent_Amount__c, Interest_Posting_Txn__r.Balance__c, CreatedDate,Last_Transaction_Type__c  ';

        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache loanOC ; //helping in query formation
        loanOC = ec.getObject('LoansJob'); //helping in query formation
        if ( loanOC != null) {
            ec.deleteObject('LoansJob'); //helping in query formation
        }
        loanOC = ec.createObject('LoansJob', 'Loan_Transaction_Summary__c', ns);
        loanOC.addFields(fields);
        loanOC.addNamedParameter('loanIds', loanIds);
        loanOC.addNamedParameter('startDate', startDate);
        loanOC.addNamedParameter('endDate', endDate);
        String whereClause = ' Loan_Account__c IN :loanIds' ;
        whereClause += ' AND Transaction_Date__c >= :startDate';
        whereClause += ' AND Transaction_Date__c <= :endDate';
        
        whereClause += ' AND Investment_order__c = null';
        whereClause += ' AND Discarded_Data__c  != True';
        whereClause +=' AND Invalid_Data__c !=True';

        loanOC.setWhereClause(whereClause);
        loanOC.setOrderClause('CreatedDate');
        loanOC.buildQuery();
        loanOC.executeQuery();
        List<loan__Loan_transaction_summary__c> txnList = (List<loan__Loan_transaction_summary__c>)loanOC.getRecords();
        return txnList;
    }
    //This function is just taking up relevant IPTs and building query for IPT
    global List<loan__Interest_Posting_Transaction__c> getIntrstPstngTxn(Date startDate, Date endDate,Set<Id> loanIds){
        String fields = 'Id, Name, CreatedDate, Balance__c,Loan_Contract__c, Interest_Posting_Transaction_Snapshot__c,'+ 
                        'Interest_Posting_Type__c,Transaction_Posting_Date__c, '+
                        'Additional_Interest_Component_Snapshot__c,Transaction_Creation_Date__c,Interest_Posted__c,Transaction_Time__c, ';

        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache loanOC ; 
        loanOC = ec.getObject('LoansJob');
        if ( loanOC != null) {
            ec.deleteObject('LoansJob');
        }
        loanOC = ec.createObject('LoansJob', 'Interest_Posting_Transaction__c', ns);
        loanOC.addFields(fields);
        loanOC.addNamedParameter('loanIds', loanIds);
        loanOC.addNamedParameter('startDate', startDate);
        loanOC.addNamedParameter('endDate', endDate);
        String whereClause = ' Loan_Contract__c IN :loanIds' ;
            whereClause += ' AND Transaction_Posting_Date__c >= :startDate';
            whereClause += ' AND Transaction_Posting_Date__c <= :endDate';
        
        whereClause += ' And Is_Posted__c = true';
        whereClause += ' AND Reversed__c = false';
        whereClause += ' AND Archived__c = false';

        loanOC.setWhereClause(whereClause);
        loanOC.setOrderClause('Transaction_Posting_Date__c');
        loanOC.buildQuery();
        loanOC.executeQuery();
        List<loan__Interest_Posting_Transaction__c> txnList = (List<loan__Interest_Posting_Transaction__c>)loanOC.getRecords();
        return txnList;
        
    }
    //This function is just taking up relevant Bills and building query for Bills
    global List<loan__Loan_account_Due_Details__c> getBillTxn(Date startDate, Date endDate,Set<Id> loanIds){
        String fields = 'Id,Loan_Account__c, Archived__c,CreatedDate, Name, Due_Amt__c,'+
                        'Transaction_Creation_Date__c, Due_Type_Description__c, Due_Date__c ';

        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache loanOC ; 
        loanOC = ec.getObject('LoansJob');
        if ( loanOC != null) {
            ec.deleteObject('LoansJob');
        }
        loanOC = ec.createObject('LoansJob', 'Loan_account_Due_Details__c', ns);
        loanOC.addFields(fields);
        loanOC.addNamedParameter('loanIds', loanIds);
        loanOC.addNamedParameter('startDate', startDate);
        loanOC.addNamedParameter('endDate', endDate);
        String whereClause = ' Loan_Account__c IN :loanIds' ;
        whereClause += ' AND Due_Date__c >= :startDate';
        whereClause += ' AND Due_Date__c <= :endDate';
        whereClause += ' AND Archived__c = false';

        loanOC.setWhereClause(whereClause);
        loanOC.setOrderClause('Due_Date__c');
        loanOC.buildQuery();
        loanOC.executeQuery();
        List<loan__Loan_account_Due_Details__c> txnList = (List<loan__Loan_account_Due_Details__c>)loanOC.getRecords();
        return txnList;
        
    }
    //This function is just taking up relevant LDT reversal and building query for LDT reversal
    global List<loan__Disbursal_Adjustment__c>  getDisRevTxn(Date startDate, Date endDate,Set<Id> loanIds){
        String fields = ' Id, Name, Transaction_Time__c, CreatedDate, Transaction_Creation_Date__c,'+
                        'Rejected__c,Adjustment_Txn_Date__c, '+
                        'Loan_Disbursal_Transaction__r.Loan_Account__c, Loan_Disbursal_Transaction__r.Disbursed_Amt__c,'+
                        'Loan_Disbursal_Transaction__r.Loan_Snapshot__c, Cleared__c ';

        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache loanOC ; 
        loanOC = ec.getObject('LoansJob');
        if ( loanOC != null) {
            ec.deleteObject('LoansJob');
        }
        loanOC = ec.createObject('LoansJob', 'Disbursal_Adjustment__c', ns);
        loanOC.addFields(fields);
        loanOC.addNamedParameter('loanIds', loanIds);
        loanOC.addNamedParameter('startDate', startDate);
        loanOC.addNamedParameter('endDate', endDate);
        String whereClause = ' Loan_Disbursal_Transaction__r.Loan_Account__c IN :loanIds' ;
        whereClause += ' AND Adjustment_Txn_Date__c >= :startDate';
        whereClause += ' AND _Adjustment_Txn_Date__c <= :endDate';
        
        whereClause += ' AND Archived__c = false';
        whereClause += ' AND Rejected__c = false';
        whereClause += ' AND Cleared__c = true';

        loanOC.setWhereClause(whereClause);
        loanOC.setOrderClause('Adjustment_Txn_Date__c');
        loanOC.buildQuery();
        loanOC.executeQuery();
        List<loan__Disbursal_Adjustment__c> txnList = (List<loan__Disbursal_Adjustment__c>)loanOC.getRecords();
        return txnList;
        
    }
    //This function is just taking up relevant LPT reversal and building query for LPT reversal
    global List<loan__Repayment_Transaction_Adjustment__c> getPayRevTxn(Date startDate, Date endDate,Set<Id> loanIds){
        String fields = 'Id, Loan_Snapshot__c, CreatedDate, Name, Rejected__c, Loan_Payment_Transaction__r.Loan_Account__c,'+
                        'Loan_Payment_Transaction__r.Loan_Snapshot__c,Transaction_Time__c, '+
                        'Loan_Payment_Transaction__r.Transaction_Amount__c , Transaction_Creation_Date__c, Adjustment_Txn_Date__c,Loan_Payment_Transaction__r.Balance__c ';
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache loanOC ; 
        loanOC = ec.getObject('LoansJob');
        if ( loanOC != null) {
            ec.deleteObject('LoansJob');
        }
        loanOC = ec.createObject('LoansJob', 'Repayment_Transaction_Adjustment__c', ns);
        loanOC.addFields(fields);
        loanOC.addNamedParameter('loanIds', loanIds);
        loanOC.addNamedParameter('startDate', startDate);
        loanOC.addNamedParameter('endDate', endDate);
        String whereClause = '  Loan_Payment_Transaction__r.Loan_Account__c  IN :loanIds' ;
        whereClause += ' AND Adjustment_Txn_Date__c >= :startDate';
        whereClause += ' AND Adjustment_Txn_Date__c <= :endDate';
        whereClause += ' AND Archived__c = false';
        whereClause += ' AND Rejected__c = false';
        whereClause += ' AND Cleared__c = true';
        loanOC.setWhereClause(whereClause);
        loanOC.setOrderClause('Adjustment_Txn_Date__c');
        loanOC.buildQuery();
        loanOC.executeQuery();
        List<loan__Repayment_Transaction_Adjustment__c> txnList = (List<loan__Repayment_Transaction_Adjustment__c>)loanOC.getRecords();
        return txnList;
        
    }
    //This function is just taking up relevant Charge and building query for Charge
    global List<loan__Charge__c> getChargeTxn(Date startDate, Date endDate,Set<Id> loanIds){
        String fields = 'Id, Name, CreatedDate, Charge_Type__c,Loan_Account__c, Archived__c, Original_Amount__c,'+
                        'Transaction_Creation_Date__c,Balance__c,Date__c  ';
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache loanOC ; 
        loanOC = ec.getObject('LoansJob');
        if ( loanOC != null) {
            ec.deleteObject('LoansJob');
        }
        loanOC = ec.createObject('LoansJob', 'Charge__c', ns);
        loanOC.addFields(fields);
        loanOC.addNamedParameter('loanIds', loanIds);
        loanOC.addNamedParameter('startDate', startDate);
        loanOC.addNamedParameter('endDate', endDate);
        String whereClause = ' Loan_Account__c  IN :loanIds' ;
        whereClause += ' AND Date__c >= :startDate';
        whereClause += ' AND Date__c <= :endDate';
        whereClause += ' AND Archived__c = false';

        loanOC.setWhereClause(whereClause);
        loanOC.setOrderClause('Date__c');
        loanOC.buildQuery();
        loanOC.executeQuery();
        List<loan__Charge__c> txnList = (List<loan__Charge__c>)loanOC.getRecords();
        return txnList;
        
    }
    //This function is just taking up relevant OLT and building query for OLTs
    global List<loan__Other_Transaction__c> getOtherLoanTxn(Date startDate, Date endDate,Set<Id> loanIds){
        String fields = 'Id,Transaction_Creation_Date__c,Rejected__c,Loan_Snapshot__c,Loan_Account__c, CreatedDate, Name, Reversed__c,'+
                        ' Txn_Amt__c, Transaction_Type__c, Txn_Date__c,New_Interest_Rate__c,Transaction_Time__c ';
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        String allowedLoanStatuses = '\'' + loan.LoanConstants.LOAN_TRANSACTION_RESCHEDULE + '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_TRANSACTION_DELINQUENT_PMT_PLAN + '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_TRANSACTION_DELINQUENT_PMT_PLAN_REV + '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_TRANSACTION_EXTENSION+ '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_TRANSACTION_EXTENSION_REV + '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_TRANSACTION_DDC + '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_TRANSACTION_REFUND + '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_TRANSACTION_REFUND_REV + '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_TRANSACTION_RATE_CHANGE + '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_TRANSACTION_RATE_CHANGE_REV + '\'' + ',' +
                                        '\'' + loan.LoanConstants.ADDITIONAL_INTEREST_COMPONENT_RATE_CHANGE + '\'' + ',' +
                                        '\'' + loan.LoanConstants.ADDITIONAL_INTEREST_RATE_CHANGE + '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_RATE_CHANGE + '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_CHANGE + '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_CHANGE_REV + '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_TRANSACTION_CHARGE_OFF + '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_TRANSACTION_CHARGE_OFF_REV + '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_TRANSACTION_CREDIT_LIMIT_CHANGE + '\'' + ',' +
                                        '\'' + ConstantValues.DEPOSIT_SUBTRACT + '\'' + ',' +
                                        '\'' + ConstantValues.DEPOSIT_ADD + '\'' + ',' +
                                        '\'' + loan.LoanConstants.ADDITIONAL_INTEREST_RATE_CHANGE_REV + '\'' ;
        
        mfiflexUtil.ObjectCache loanOC ; 
        loanOC = ec.getObject('LoansJob');
        if ( loanOC != null) {
            ec.deleteObject('LoansJob');
        }
        loanOC = ec.createObject('LoansJob', 'Other_Transaction__c', ns);
        loanOC.addFields(fields);
        loanOC.addNamedParameter('loanIds', loanIds);
        loanOC.addNamedParameter('startDate', startDate);
        loanOC.addNamedParameter('endDate', endDate);
        loanOC.addNamedParameter('allowedLoanStatuses', allowedLoanStatuses);
        String whereClause = ' Loan_Account__c  IN :loanIds' ;
        whereClause += ' AND Txn_Date__c >= :startDate';
        whereClause += ' AND Txn_Date__c <= :endDate';
        whereClause += ' AND Rejected__c = false';
        whereClause += ' AND Transaction_Type__c IN (' + allowedLoanStatuses + ')';

        loanOC.setWhereClause(whereClause);
        loanOC.setOrderClause('Txn_Date__c');
        loanOC.buildQuery();
        loanOC.executeQuery();
        List<loan__Other_Transaction__c> txnList = (List<loan__Other_Transaction__c>)loanOC.getRecords();
        return txnList;
        
    }
    //This function is just taking up relevant LDT and building query for LDTs
    global List<loan__Loan_Disbursal_Transaction__c> getDisbursalTxn(Date startDate, Date endDate,Set<Id> loanIds){
        String fields = ' Id,Loan_Snapshot__c,CreatedDate,Name,Reversed__c,Rejected__c,Disbursed_Amt__c,Loan_Account__c,'+
                        'Loan_Disbursal_Transaction_Type__c,Transaction_Creation_Date__c,Disbursal_Date__c,Disbursal_Time__c ';
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache loanOC ; 
        loanOC = ec.getObject('LoansJob');
        if ( loanOC != null) {
            ec.deleteObject('LoansJob');
        }
        loanOC = ec.createObject('LoansJob', 'Loan_Disbursal_Transaction__c', ns);
        loanOC.addFields(fields);
        loanOC.addNamedParameter('loanIds', loanIds);
        loanOC.addNamedParameter('startDate', startDate);
        loanOC.addNamedParameter('endDate', endDate);
        String whereClause = ' Loan_Account__c  IN :loanIds' ;
        whereClause += ' AND Disbursal_Date__c >= :startDate';
        whereClause += ' AND Disbursal_Date__c <= :endDate';
        whereClause += ' AND Rejected__c = false';
        whereClause += ' AND Cleared__c = true';

        loanOC.setWhereClause(whereClause);
        loanOC.setOrderClause('Disbursal_Date__c');
        loanOC.buildQuery();
        loanOC.executeQuery();
        List<loan__Loan_Disbursal_Transaction__c> txnList = (List<loan__Loan_Disbursal_Transaction__c>)loanOC.getRecords();
        return txnList;
    }
    //This function is just taking up relevant LPT and building query for LPTs
    global List<loan__Loan_Payment_transaction__c> getPaymentTxn(Date startDate, Date endDate,Set<Id> loanIds){
        String fields = 'Id,Loan_Snapshot__c, CreatedDate, Name, Reversed__c,Loan_Account__c,Principal__c,Interest__c,'+
                        'Fees__c, Transaction_Amount__c,Payment_Type__c,Transaction_Time__c,'+
                        'Transaction_Creation_Date__c, Transaction_Date__c ,Rejected__c,Balance__c,Cleared__c ';
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache loanOC ; 
        loanOC = ec.getObject('LoansJob');
        if ( loanOC != null) {
            ec.deleteObject('LoansJob');
        }
        loanOC = ec.createObject('LoansJob', 'Loan_Payment_transaction__c', ns);
        loanOC.addFields(fields);
        loanOC.addNamedParameter('loanIds', loanIds);
        loanOC.addNamedParameter('startDate', startDate);
        loanOC.addNamedParameter('endDate', endDate);
        String whereClause = ' Loan_Account__c  IN :loanIds' ;
        whereClause += ' AND Transaction_Date__c >= :startDate';
        whereClause += ' AND Transaction_Date__c <= :endDate';
        whereClause += ' AND Rejected__c = false';
        whereClause += ' AND Cleared__c = true';

        loanOC.setWhereClause(whereClause);
        loanOC.setOrderClause('Transaction_Date__c');
        loanOC.buildQuery();
        loanOC.executeQuery();
        List<loan__Loan_Payment_transaction__c> txnList = (List<loan__Loan_Payment_transaction__c>)loanOC.getRecords();
        return txnList;        
    }
    //This function is just taking up relevant Cl Contract and getting details from CL Contract for populating them in LTS
    global List<loan__Loan_Account__c> getLoanDetails(Set<Id> loanIds){
        String ns = loan.CustomSettingsUtil.getOrgParameters().loan__Namespace_Prefix__c;
        String fields = 'Id,Interest_Rate__c,Pay_Off_Amount_As_Of_Today__c,Delinquent_Amount__c,Loan_Balance__c,Principal_Remaining__c ,Transaction_Summary_Migrated_Till_Date__c ';

        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache loanOC ; 
        loanOC = ec.getObject('LoansJob');
        if ( loanOC != null) {
            ec.deleteObject('LoansJob');
        }
        loanOC = ec.createObject('LoansJob', 'Loan_Account__c', ns);
        loanOC.addFields(fields);
        loanOC.addNamedParameter('loanIds', loanIds);
        String whereClause = ' Id IN :loanIds' ;
        
        loanOC.setWhereClause(whereClause);
        loanOC.buildQuery();
        loanOC.executeQuery();
        List<loan__Loan_Account__c> loan = (List<loan__Loan_Account__c>)loanOC.getRecords();
        return loan;       
    }

    global void process(List<loan__Loan_Account__c> loanAccounts) {
        Map<Id,List<loan__Loan_Transaction_Summary__c>> loanIdToLTSMap = new Map<Id,List<loan__Loan_Transaction_Summary__c>>();
        Map<Id,List<loan__Loan_Disbursal_Transaction__c>> loanIdToLDTMap = new Map<Id,List<loan__Loan_Disbursal_Transaction__c>>();
        Map<Id,List<loan__Loan_Payment_Transaction__c>> loanIdToLPTMap = new Map<Id,List<loan__Loan_Payment_Transaction__c>>();
        Map<Id,List<loan__Charge__c>> loanIdtoChargeMap = new Map<Id,List<loan__Charge__c>>();
        Map<Id,List<loan__Interest_Posting_Transaction__c>> IdToIPTMap = new  Map<Id,List<loan__Interest_Posting_Transaction__c>>();
        Map<Id,List<loan__Loan_Account_Due_Details__c>> loanIdToBillMap = new Map<Id,List<loan__Loan_Account_Due_Details__c>>();
        Map<Id,List<loan__Repayment_Transaction_Adjustment__c>> loanIdToLPTRevMap = new  Map<Id,List<loan__Repayment_Transaction_Adjustment__c>>();
        Map<Id,List<loan__Disbursal_Adjustment__c>> loanIdToLDTRevMap = new Map<Id,List<loan__Disbursal_Adjustment__c>>();
        Map<Id,List<loan__Other_Transaction__c>> loanIdToOLTMap = new Map<Id,List<loan__Other_Transaction__c>>();
        Map<Id,loan__Loan_Account__c> loanAccValue = new Map<Id,loan__Loan_Account__c>();
        Set<Id> loanAccIds = new Set<Id>();
        String loanIds ='';
        List<loan__Loan_Transaction_Summary__c> newSummaries = new List<loan__Loan_Transaction_Summary__c>();
        //Taking all the CL Contracts that came from parameter and making where in clause
        for(loan__Loan_Account__c acc : loanAccounts){
            loanAccIds.add(acc.id);
        }
        if(loanAccounts.size() == 1){
            loanIds ='\'' + loanAccounts[0].Id + '\'';
        }
        else if(loanAccounts.size() > 1){
            Integer i =0;
            for(i = 0;i < loanAccounts.size() -1 ;i++){
                loanIds += '\'' + loanAccounts[i].Id + '\'' + ',' ;
            }
            loanIds +=loanAccounts[i].Id ;
        }
        loan.LoanTransactionUtil.queryAndSetDepositDetailsMap(loanAccIds);
        loan.LoanTransactionSummaryUtil.transTypeMap();
        List<loan__Loan_Transaction_Summary__c> ltsList = getLTSTxn1(startDate,endDate,loanAccIds);
        for(loan__Loan_Transaction_Summary__c lts : ltsList){
            //Creating a map with new LTS list against CL contract ID
            if(!loanIdToLTSMap.containsKey(lts.loan__Loan_Account__c)){
                loanIdToLTSMap.put(lts.loan__Loan_Account__c,new List<loan__Loan_Transaction_Summary__c>());
            }
            List<loan__Loan_Transaction_Summary__c> txnList = loanIdToLTSMap.get(lts.loan__Loan_Account__c);
            txnList.add(lts);
        }
        //getting all the LDT transactions in mentioned range
        List<loan__Loan_Disbursal_Transaction__c> ldtList = getDisbursalTxn(startDate,endDate,loanAccIds);
        for(loan__Loan_Disbursal_Transaction__c ldt :ldtList){
            if(!loanIdToLDTMap.containsKey(ldt.loan__Loan_Account__c)){
                loanIdToLDTMap.put(ldt.loan__Loan_Account__c , new List<loan__Loan_Disbursal_Transaction__c>());
            }
            List<loan__Loan_Disbursal_Transaction__c> txnList = loanIdToLDTMap.get(ldt.loan__Loan_Account__c);
            txnList.add(ldt);
        }
        //getting all the LPT transactions in mentioned range
        List<loan__Loan_Payment_transaction__c> lptList = getPaymentTxn(startDate,endDate,loanAccIds);
        for(loan__Loan_Payment_transaction__c lpt : lptList){
            if(!loanIdToLPTMap.containsKey(lpt.loan__Loan_Account__c)){
                loanIdToLPTMap.put(lpt.loan__Loan_Account__c , new List<loan__Loan_Payment_transaction__c>());
            }
            List<loan__Loan_Payment_transaction__c> txnList = loanIdToLPTMap.get(lpt.loan__Loan_Account__c);
            txnList.add(lpt);
        }
        //getting all the OLT transactions in mentioned range
        List<loan__Other_Transaction__c> oltList =  getOtherLoanTxn(startDate,endDate,loanAccIds);
        for(loan__Other_Transaction__c oth : oltList){  
            if(!loanIdToOLTMap.containsKey(oth.loan__Loan_Account__c)){
                loanIdToOLTMap.put(oth.loan__Loan_Account__c,new List<loan__Other_Transaction__c>());
            }
            List<loan__Other_Transaction__c> txnList = loanIdToOLTMap.get(oth.loan__Loan_Account__c);
            txnList.add(oth);
        }
        //getting all the Reversed LPTs transactions in mentioned range
        List<loan__Repayment_Transaction_Adjustment__c>  lptRevList =  getPayRevTxn(startDate,endDate,loanAccIds);   
        for(loan__Repayment_Transaction_Adjustment__c lptRev : lptRevList){     
            if(!loanIdToLPTRevMap.containsKey(lptRev.loan__Loan_Payment_Transaction__r.loan__Loan_Account__c)){
                loanIdToLPTRevMap.put(lptRev.loan__Loan_Payment_Transaction__r.loan__Loan_Account__c,new List<loan__Repayment_Transaction_Adjustment__c>());
            }
            List<loan__Repayment_Transaction_Adjustment__c> txnList =   loanIdToLPTRevMap.get(lptRev.loan__Loan_Payment_Transaction__r.loan__Loan_Account__c);
            txnList.add(lptRev);  
        }
        /*//getting all the Reversed LDTs transactions in mentioned range- Elixir does not have reversed LDT - So commenting this for now
        List<loan__Disbursal_Adjustment__c> ldtRevList = getDisRevTxn(startDate,endDate,loanAccIds);
        for(loan__Disbursal_Adjustment__c ldtRev : ldtRevList){
            if(!loanIdToLDTRevMap.containsKey(ldtRev.loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__c)){
                loanIdToLDTRevMap.put(ldtRev.loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__c , new List<loan__Disbursal_Adjustment__c>());
            }
            List<loan__Disbursal_Adjustment__c> txnList = loanIdToLDTRevMap.get(ldtRev.loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__c);
            txnList.add(ldtRev);
        }*/
        //getting all the Charges transactions in mentioned range
        List<loan__Charge__c> chargeList = getChargeTxn(startDate,endDate,loanAccIds);
        for(loan__Charge__c charge : chargeList){
            if(!loanIdtoChargeMap.containsKey(charge.loan__Loan_Account__c)){
                loanIdtoChargeMap.put(charge.loan__Loan_Account__c, new List<loan__Charge__c> ());
            }
            List<loan__Charge__c> txnList = loanIdtoChargeMap.get(charge.loan__Loan_Account__c);
            txnList.add(charge);
        }
        //getting all the IPTs transactions in mentioned range
        List<loan__Interest_Posting_Transaction__c> iptList = getIntrstPstngTxn(startDate,endDate,loanAccIds);
        for(loan__Interest_Posting_Transaction__c ipt :iptList){
            if(!IdToIPTMap.containsKey(ipt.loan__Loan_Contract__c)){
                IdToIPTMap.put(ipt.loan__Loan_Contract__c,new List<loan__Interest_Posting_Transaction__c>());
            }
            List<loan__Interest_Posting_Transaction__c> txnList = IdToIPTMap.get(ipt.loan__Loan_Contract__c);
            txnList.add(ipt);
        }
        //getting all the Bill transactions in mentioned range
        List<loan__Loan_account_Due_Details__c> billList = getBillTxn(startDate,endDate,loanAccIds);
        for(loan__Loan_account_Due_Details__c bill : billList){
            if(!loanIdToBillMap.containsKey(bill.loan__Loan_Account__c)){
                loanIdToBillMap.put(bill.loan__Loan_Account__c , new List<loan__Loan_account_Due_Details__c> ());
            }
            List<loan__Loan_account_Due_Details__c> txnList = loanIdToBillMap.get(bill.loan__Loan_Account__c);
            txnList.add(bill);
        }
        //Creating a map with loan ID against loan details
        List<loan__Loan_Account__c> loanAccList = getLoanDetails(loanAccIds);
        for(loan__Loan_Account__c lacc: loanAccList){
            loanAccValue.put(lacc.Id,lacc);//this is important as well - here the loan details are stored        
        }
        //IMPORTANT!
        //Calling main processing function ***********
        for(loan__loan_account__c laonAcc :loanAccounts ){
            mfiflexUtil.UnitOfWork uow = uowTransaction.createUnitOfWork(laonAcc.Name);
            try{
                createLTSForLoan(endDate,uow,laonAcc,loanIdToLTSMap.get(laonAcc.Id),loanIdToLDTMap.get(laonAcc.Id),loanIdToLPTMap.get(laonAcc.Id),loanIdtoChargeMap.get(laonAcc.Id),IdToIPTMap.get(laonAcc.Id),loanIdToBillMap.get(laonAcc.Id),loanIdToLPTRevMap.get(laonAcc.Id),loanIdToLDTRevMap.get(laonAcc.Id),loanIdToOLTMap.get(laonAcc.Id),loanAccValue.get(laonAcc.Id));

            }
            catch(Exception e){
                uowTransaction.deleteUnitOfWork(laonAcc.Name);
            }
            
        }
        uowTransaction.commitWork();
        Database.insert(logsList);
    }

   global void updateFieldForReversal(loan__Loan_Transaction_Summary__c revSummary ,String snapShot){
        if(snapShot!=null){
            loan__Loan_Account__C loanAcc = loan.BalanceSnapshotUnit.getLoanAccountFromSnapShot(snapShot);
            if(revSummary.loan__Current_Interest_Rate__c ==null && loanAcc.loan__Interest_Rate__c!=null ){
                revSummary.loan__Current_Interest_Rate__c = loanAcc.loan__Interest_Rate__c;
            }
            if(revSummary.loan__Current_Loan_Balance__c ==null && loanAcc.loan__Principal_Remaining__c != null && loanAcc.loan__Capitalized_Fee__c!=NULL && loanAcc.loan__Capitalized_Interest__c!=NULL){
                revSummary.loan__Current_Loan_Balance__c = loanAcc.loan__Principal_Remaining__c + loanAcc.loan__Capitalized_Fee__c + loanAcc.loan__Capitalized_Interest__c;
            }
            if(revSummary.loan__Current_Payoff_Balance__c ==null && loanAcc.loan__Pay_Off_Amount_As_Of_Today__c!=null){
                revSummary.loan__Current_Payoff_Balance__c = loanAcc.loan__Pay_Off_Amount_As_Of_Today__c;
            }
          
            if(revSummary.loan__Current_Principal_Remaining__c ==null && loanAcc.loan__Principal_Remaining__c!=null){
                revSummary.loan__Current_Principal_Remaining__c = loanAcc.loan__Principal_Remaining__c;
            }
            if(revSummary.loan__Current_Delinquent_Amount__c ==null && loanAcc.loan__Delinquent_Amount__c!=null){
                revSummary.loan__Current_Delinquent_Amount__c = loanAcc.loan__Delinquent_Amount__c;
            }
        }   
    }

    //This function is written to update the current state for LPT and LDT txn
    //This is done to ignore the situation in case when any txn is happenig that doenst have snaphot.
    //Like Bills is created just after the disbursal so current state will not be capture propely as bill snapshot will be same as LDT
    global void updateCurrentStateForLDT(loan__Loan_Transaction_Summary__c summary , Decimal amount){
        if(summary.loan__Interest_Rate__c!=NULL){
            summary.loan__Current_Interest_Rate__c = summary.loan__Interest_Rate__c;
        }
        if(summary.loan__Balance__c!=NULL && amount!=NULL){
            summary.loan__Current_Loan_Balance__c = summary.loan__Balance__c + amount;
        }
        if(summary.loan__Pay_Off_Amount_As_Of_Today__c!=NULL && amount!=NULL){
            summary.loan__Current_Payoff_Balance__c = summary.loan__Pay_Off_Amount_As_Of_Today__c + amount;
        }
        if(summary.loan__Principal_Remaining__c!=NULL && amount!=NULL){
            summary.loan__Current_Principal_Remaining__c = summary.loan__Principal_Remaining__c + amount;
        }
        if(summary.loan__Delinquent_Amount__c!=NULL){
            summary.loan__Current_Delinquent_Amount__c = summary.loan__Delinquent_Amount__c;
        }
        if(summary.loan__Current_Delinquent_Amount__c == null){
            summary.loan__Current_Delinquent_Amount__c = 0;
        }
    }
    global void updateValueFromPrevState(loan__Loan_Transaction_Summary__c currentSummary,loan__Loan_Transaction_Summary__c prevSummary,Decimal balance){
        if(prevSummary.loan__Current_Interest_Rate__c!=NULL){
            currentSummary.loan__Current_Interest_Rate__c = prevSummary.loan__Current_Interest_Rate__c;
        }
        //Changes made by Rameswari
        if(currentSummary.loan__Interest_Posting_Txn__c != NULL && balance != NULL){
            currentSummary.loan__Current_Loan_Balance__c = balance;
        }
        else if(currentSummary.loan__Loan_Charge__c != NULL && balance != NULL){
           currentSummary.loan__Current_Loan_Balance__c = balance;
        }
        else{
            //Was written by prod team and the below line is responsible for updating previous balance
            currentSummary.loan__Current_Loan_Balance__c = prevSummary.loan__Current_Loan_Balance__c;
        }
        if(prevSummary.loan__Current_Payoff_Balance__c!=NULL){
            currentSummary.loan__Current_Payoff_Balance__c = prevSummary.loan__Current_Payoff_Balance__c;
        }
        if(prevSummary.loan__Current_Principal_Remaining__c!=NULL){
            currentSummary.loan__Current_Principal_Remaining__c = prevSummary.loan__Current_Principal_Remaining__c;
        }
        if(prevSummary.loan__Current_Delinquent_Amount__c!=NULL){
            currentSummary.loan__Current_Delinquent_Amount__c = prevSummary.loan__Current_Delinquent_Amount__c;
        }
    }

    global void updateValueForNewSummary(loan__Loan_Transaction_Summary__c summary , DateTime createdDate,Id lstTxnId,Id loanId){
        summary.loan__Invalid_data__c = true;//why??
        if(loanId!=NULL){
            summary.loan__Loan_Account__c = loanId;
        }
        if(lstTxnId!=NULL){
            summary.loan__Last_transaction_id__c = lstTxnId;
        }
        if(createdDate!=NULL){
            summary.loan__Transaction_Time__c = createdDate;
        }
    }
    
    /*
    This function will return the transaction id that is not stored in field called last_transaction_id
    This will happen in case if migration is happening after the summaries is on and already some transactio is created before migration started
    In some cases like bills and rescheule the last trnasaction id is not getting populated due to the UOW
    RB's comment EOW??
    */
    global String getLastTransactionId(loan__Loan_Transaction_Summary__c summary){
        if(summary.loan__Loan_Due_Detail__c != null){
            return (String) summary.loan__Loan_Due_Detail__c;
        }
        else if(summary.loan__Repayment_Txn_Reversal__c != null){
            return (String) summary.loan__Repayment_Txn_Reversal__c;
        }
        else if(summary.loan__Disbursal_Reversal__c != null){
            return (String)summary.loan__Disbursal_Reversal__c;
        }
        else if(summary.loan__Loan_Charge__c != null){
            return (String)summary.loan__Loan_Charge__c;
        }
        else if(summary.loan__Interest_Posting_Txn__c != null){
            return (String)summary.loan__Interest_Posting_Txn__c;
        }
        else if(summary.loan__Loan_Payment_Txn__c != null){
            return (String)summary.loan__Loan_Payment_Txn__c;
        }
        else if(summary.loan__Other_Loan_Txn__c != null){
            return (String)summary.loan__Other_Loan_Txn__c;
        }
        else if(summary.loan__Loan_Disbursal__c != null){
            return (String)summary.loan__Loan_Disbursal__c;
        }
        return null;
    }

    global void updateTransactionDate(loan__Loan_Transaction_Summary__c summary , Date transactionDate , Datetime createdDate){
        if(summary.loan__Transaction_Date__c == null){
            if(transactionDate != null){
                summary.loan__Transaction_Date__c =  transactionDate;
            }
            else{
                summary.loan__Transaction_Date__c =  Date.valueOf(createdDate);
            }
        }
    }

    global static void updateSnapShotField(loan__Loan_Transaction_Summary__c summaryWithoutSnapshot , loan__Loan_Transaction_Summary__c summaryWithSnapshot){
        if(summaryWithSnapshot.loan__Interest_Rate__c!=NULL){
            summaryWithoutSnapshot.loan__Interest_Rate__c = summaryWithSnapshot.loan__Interest_Rate__c;
        }
        if(summaryWithSnapshot.loan__Balance__c!=NULL){
            summaryWithoutSnapshot.loan__Balance__c = summaryWithSnapshot.loan__Balance__c;
        }
        if(summaryWithSnapshot.loan__Pay_Off_Amount_As_Of_Today__c!=NULL){
            summaryWithoutSnapshot.loan__Pay_Off_Amount_As_Of_Today__c = summaryWithSnapshot.loan__Pay_Off_Amount_As_Of_Today__c;
        }
        if(summaryWithSnapshot.loan__Principal_Remaining__c!=NULL){
            summaryWithoutSnapshot.loan__Principal_Remaining__c = summaryWithSnapshot.loan__Principal_Remaining__c;
        }
        if(summaryWithSnapshot.loan__Delinquent_Amount__c!=NULL){
            summaryWithoutSnapshot.loan__Delinquent_Amount__c = summaryWithSnapshot.loan__Delinquent_Amount__c;
        }
    }

    global void createLTSForLoan(Date endDate,mfiflexUtil.UnitOfWork uow,
                                 loan__Loan_Account__c loanAcc,
                                 List<loan__Loan_Transaction_Summary__c> ltsList ,
                                 List<loan__Loan_Disbursal_Transaction__c> ldtList,
                                 List<loan__Loan_Payment_Transaction__c> lptList,
                                 List<loan__Charge__c> chargeList,
                                 List<loan__Interest_Posting_Transaction__c> iptsList,
                                 List<loan__Loan_account_Due_Details__c> billList,
                                 List<loan__Repayment_Transaction_Adjustment__c> lptRevList,
                                 List<loan__Disbursal_Adjustment__c>  disursalRevList,
                                 List<loan__Other_Transaction__c> othList,
                                 loan__Loan_Account__c loanAcct){
        //Did not understand what LoanTransactionSummaryUtil.selectedTxnTypeMap is doing                            
        Map<String,String> transTypeToIdMapLDT = loan.LoanTransactionSummaryUtil.selectedTxnTypeMap.get('Loan_Disbursal__c');
        Map<String,String> transTypeToIdMapLPT = loan.LoanTransactionSummaryUtil.selectedTxnTypeMap.get('Loan_Payment_Txn__c');
        Map<String,String> transTypeToIdMapBills = loan.LoanTransactionSummaryUtil.selectedTxnTypeMap.get('Loan_Due_Detail__c');
        Map<String,String> transTypeToIdMapIPT = loan.LoanTransactionSummaryUtil.selectedTxnTypeMap.get('Interest_Posting_Txn__c');
        Map<String,String> transTypeToIdMapCharge = loan.LoanTransactionSummaryUtil.selectedTxnTypeMap.get('Loan_Charge__c');
        Map<String,String> transTypeToIdMapLDTRev = loan.LoanTransactionSummaryUtil.selectedTxnTypeMap.get('Disbursal_Reversal__c');
        Map<String,String> transTypeToIdMapLPTRev = loan.LoanTransactionSummaryUtil.selectedTxnTypeMap.get('Repayment_Txn_Reversal__c');
        Map<String,String> transTypeToIdMapOLT = loan.LoanTransactionSummaryUtil.selectedTxnTypeMap.get('Other_Loan_Txn__c');

        Map<String,loan__Loan_Transaction_Summary__c> lastTxnToSummaryMap = new Map<String,loan__Loan_Transaction_Summary__c>();
        Map<String,loan__Loan_Transaction_Summary__c> IdsWhtSnapshot = new Map<String,loan__Loan_Transaction_Summary__c>();
        Map<String,Decimal> IDToAmountMap = new  Map<String,Decimal> ();
        List<clcommon__Deposit__c> depositList = loan.LoanTransactionUtil.getDepositListForALoan(loanAcc.Id); 
        List<clcommon__Deposit__c> depositList2=new List<clcommon__Deposit__c>();
       for(clcommon__Deposit__c deposit:depositList){
            if(deposit.clcommon__Parent_Deposit__c!=NULL){
                if(deposit.loan__Loan_Payment_Transaction__c!=NULL){
                    for(loan__Loan_Payment_Transaction__c lpt:lptList){
                        if(deposit.loan__Loan_Payment_Transaction__c==lpt.id && lpt.loan__Cleared__c==true && lpt.loan__Reversed__c!=true && lpt.loan__Rejected__c!=true ){
                            depositList2.add(deposit);
                        }
                    }
                }else if(deposit.loan__Other_Loan_Transaction__c!=NULL){
                    for(loan__Other_Transaction__c  oth:othList){
                        if(deposit.loan__Other_Loan_Transaction__c==oth.id ){
                            depositList2.add(deposit);
                        }
                    }
                }else{
                    depositList2.add(deposit);
                }
                
            }
        }
        Map<Id,SObject> invalidTxnIdToTxnMap = new Map<Id,SObject>();  
        Decimal totalDepositAmount ;  
     
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
        try{
            loan.LoanTransactionSummaryUtil.markMigrationTrue();
            List<loan__Loan_Transaction_Summary__c> summariesToBeInserted = new List<loan__Loan_Transaction_Summary__c>();

            //processing existing LTS records
            if(ltsList !=null && ltsList.size()>0){
                for(loan__Loan_Transaction_Summary__c lts :ltsList){
                    if(lts.loan__Last_transaction_id__c == null){
                        String lastTxn = getLastTransactionId(lts);//if the last transaction id is not stored this helps in retreiving
                        if(lastTxn !=null){
                            lastTxnToSummaryMap.put(lastTxn,lts);
                        }
                    }
                    else{
                        lastTxnToSummaryMap.put(lts.loan__Last_transaction_id__c,lts);
                    }                
                    summariesToBeInserted.add(lts);
                }
            }

            if(ldtList != null && ldtList.size()>0){
                for(loan__Loan_Disbursal_Transaction__c ldt :ldtList){
                    loan__Loan_Transaction_Summary__c summary = new loan__Loan_Transaction_Summary__c ();
                    if(!loan.LoanTransactionSummaryUtil.isValidTransaction(ldt)){
                        invalidTxnIdToTxnMap.put(ldt.Id,ldt);
                    }
                    if(!lastTxnToSummaryMap.containsKey(ldt.Id)){
                        summary = loan.LoanTransactionSummaryUtil.getSummaryRecord(loanAcc.Id,null,ldt);
                        updateValueForNewSummary(summary , (Datetime)ldt.get('loan__Disbursal_Time__c') ,ldt.Id,ldt.loan__Loan_Account__c);
                        updateTransactionDate(summary,ldt.loan__Disbursal_Date__c,ldt.CreatedDate);
                        
                    }
                    else{
                        summary = lastTxnToSummaryMap.get(ldt.Id);
                    }
                    
                    if(summary != null && summary.loan__Loan_Disbursal__c == null){ 
                        if(ldt.loan__Disbursed_Amt__c!=NULL){                  
                            summary.loan__Transaction_Amount__c = ldt.loan__Disbursed_Amt__c;
                        }
                        summary.loan__Loan_Disbursal__c = ldt.Id;
                        if(ldt.loan__Loan_Disbursal_Transaction_Type__c !=null){ 
                            summary.loan__Transaction_Type_Id__c = transTypeToIdMapLDT.get(ldt.loan__Loan_Disbursal_Transaction_Type__c);
                        }
                        updateCurrentStateForLDT(summary,ldt.loan__Disbursed_Amt__c);
                    }
                    summariesToBeInserted.add(summary);

                }
            }
            
            if(lptList != null && lptList.size()>0){
                for(loan__Loan_Payment_transaction__c lpt :lptList){
                   
                    if(!loan.LoanTransactionSummaryUtil.isValidTransaction(lpt)){
                        invalidTxnIdToTxnMap.put(lpt.Id,lpt);
                    }
                    loan__Loan_Transaction_Summary__c summary = new loan__Loan_Transaction_Summary__c ();
                    if(!lastTxnToSummaryMap.containsKey(lpt.Id)){
                        summary = loan.LoanTransactionSummaryUtil.getSummaryRecord(loanAcc.Id,null,lpt);
                        updateValueForNewSummary(summary , (Datetime)lpt.get('loan__Transaction_Time__c') ,lpt.Id,lpt.loan__Loan_Account__c);
                        updateTransactionDate(summary,lpt.loan__Transaction_Date__c,lpt.CreatedDate);

                    }else{
                        summary = lastTxnToSummaryMap.get(lpt.Id);
                    }
                    if(summary != null && summary.loan__Loan_Payment_Txn__c == null){
                        summary.loan__Loan_Payment_Txn__c = lpt.Id;
                        if(lpt.loan__Payment_Type__c != null){
                            summary.loan__Transaction_Type_Id__c = transTypeToIdMapLPT.get(lpt.loan__Payment_Type__c);
                        }
                        if(lpt.loan__Transaction_Amount__c!=NULL){
                            summary.loan__Transaction_Amount__c = lpt.loan__Transaction_Amount__c;
                        }
                        if(summary.loan__Interest_Rate__c!=NULL){
                            summary.loan__Current_Interest_Rate__c = summary.loan__Interest_Rate__c;
                        }
                        if(lpt.loan__Balance__c!=NULL){
                            summary.loan__Current_Loan_Balance__c = lpt.loan__Balance__c;
                        }
                        if(summary.loan__Current_Loan_Balance__c < 0){
                            summary.loan__Current_Loan_Balance__c = 0;
                        }
                        if(summary.loan__Pay_Off_Amount_As_Of_Today__c!=NULL && lpt.loan__Transaction_Amount__c!=NULL){
                            summary.loan__Current_Payoff_Balance__c = summary.loan__Pay_Off_Amount_As_Of_Today__c - lpt.loan__Transaction_Amount__c;
                        }
                        if(summary.loan__Current_Payoff_Balance__c < 0){
                            summary.loan__Current_Payoff_Balance__c = 0;
                        }
                        if(summary.loan__Principal_Remaining__c!=NULL && lpt.loan__Principal__c!=NULL){
                            summary.loan__Current_Principal_Remaining__c = summary.loan__Principal_Remaining__c - lpt.loan__Principal__c;
                        }
                        if(summary.loan__Current_Principal_Remaining__c < 0){
                            summary.loan__Current_Principal_Remaining__c = 0;
                        }
                        if(summary.loan__Current_Delinquent_Amount__c == null){
                            summary.loan__Current_Delinquent_Amount__c = 0;
                        }
                    }
                    summariesToBeInserted.add(summary);
                }
            }
            if(othList != null && othList.size()>0){
                for(loan__Other_Transaction__c oth :othList){
                    if(!loan.LoanTransactionSummaryUtil.isValidTransaction(oth) && oth.loan__Transaction_Type__c != ConstantValues.DEPOSIT_SUBTRACT){
                        invalidTxnIdToTxnMap.put(oth.Id,oth);
                    }
                    loan__Loan_Transaction_Summary__c summary = new loan__Loan_Transaction_Summary__c();
                    if(!lastTxnToSummaryMap.containsKey(oth.Id) && oth.loan__Loan_Snapshot__c!=null){
                        summary = loan.LoanTransactionSummaryUtil.getSummaryRecord(loanAcc.Id,null,oth);
                        updateValueForNewSummary(summary , (Datetime)oth.get('loan__Transaction_Time__c') ,oth.Id,oth.loan__Loan_Account__c);
                        updateTransactionDate(summary,oth.loan__Txn_Date__c,oth.CreatedDate);
                    }
                    else{
                        if(oth.loan__Transaction_Type__c == ConstantValues.DEPOSIT_SUBTRACT){
                            if(oth.loan__Txn_Amt__c!=NULL){
                                summary.loan__Transaction_Amount__c = ((oth.loan__Txn_Amt__c)*(-1));
                            }
                            if(oth.loan__Txn_Date__c!=NULL){
                                summary.loan__Transaction_Date__c = oth.loan__Txn_Date__c;
                            }
                            summary.loan__Loan_Account__c = loanAcc.Id;
                            summary.loan__Last_Transaction_Type__c = ConstantValues.DEPOSIT_SUBTRACT;
                            updateValueForNewSummary(summary , (Datetime)oth.get('CreatedDate') ,oth.Id,oth.loan__Loan_Account__c);
                        }
                        else{
                            summary = lastTxnToSummaryMap.get(oth.Id);
                        }
                    }
                    if(summary != null && summary.loan__Other_Loan_Txn__c == null){
                        updateValueForNewSummary(summary , (Datetime)oth.get('loan__Txn_Date__c') ,oth.Id,oth.loan__Loan_Account__c);
                        summary.loan__Other_Loan_Txn__c = oth.Id;
                        if(oth.loan__Txn_Amt__c != null && oth.loan__Transaction_Type__c != ConstantValues.DEPOSIT_SUBTRACT){
                            summary.loan__Transaction_Amount__c = oth.loan__Txn_Amt__c;
                        }
                        if(oth.loan__Transaction_Type__c != null){
                            summary.loan__Transaction_Type_Id__c = transTypeToIdMapOLT.get(oth.loan__Transaction_Type__c);
                        } 
                    }
                    summariesToBeInserted.add(summary);
                }
            }
            if(lptRevList != null && lptRevList.size()>0){
                for(loan__Repayment_Transaction_Adjustment__c lptRev : lptRevList){ 
                    if(!(loan.LoanTransactionSummaryUtil.isValidTransaction(lptRev))){
                        invalidTxnIdToTxnMap.put(lptRev.Id,lptRev);
                    }
                    loan__Loan_Transaction_Summary__c summary = new loan__Loan_Transaction_Summary__c();
                    if(!lastTxnToSummaryMap.containsKey(lptRev.Id)){
                        updateValueForNewSummary(summary , (Datetime)lptRev.get('loan__Transaction_Time__c') ,lptRev.Id,lptRev.loan__Loan_Payment_Transaction__r.loan__Loan_Account__c);
                        updateTransactionDate(summary,lptRev.loan__Adjustment_Txn_Date__c,lptRev.CreatedDate);
                    }
                    else{
                        summary = lastTxnToSummaryMap.get(lptRev.Id);
                    }
                    if(summary != null && summary.loan__Repayment_Txn_Reversal__c == null){
                        summary.loan__Repayment_Txn_Reversal__c = lptRev.Id;
                        if(lptRev.loan__Loan_Payment_Transaction__r.loan__Transaction_Amount__c!=NULL){
                            summary.loan__Transaction_Amount__c = lptRev.loan__Loan_Payment_Transaction__r.loan__Transaction_Amount__c;
                        }
                        updateFieldForReversal(summary,lptRev.loan__Loan_Payment_Transaction__r.loan__Loan_Snapshot__c);
                        summary.loan__Transaction_Type_Id__c = transTypeToIdMapLPTRev.get(loan.LoanConstants.LOAN_TRANSACTION_PAYMENT_REVERSAL);
                    }
                    IdsWhtSnapshot.put(summary.loan__Last_transaction_id__c,summary); 
                    summariesToBeInserted.add(summary);
                }
            }

            if(billList != null && billList.size()>0){
                for(loan__Loan_account_Due_Details__c bill : billList){
                    if(!loan.LoanTransactionSummaryUtil.isValidTransaction(bill)){
                        invalidTxnIdToTxnMap.put(bill.Id,bill);
                    }
                    loan__Loan_Transaction_Summary__c summary = new loan__Loan_Transaction_Summary__c();
                    if(!lastTxnToSummaryMap.containsKey(bill.Id)){
                        updateValueForNewSummary(summary , (Datetime)bill.get('loan__Due_Date__c') ,bill.Id,bill.loan__Loan_Account__c);
                                               
                        if(bill.loan__Due_Type_Description__c != null){
                            summary.loan__Transaction_Type_Id__c = transTypeToIdMapBills.get(bill.loan__Due_Type_Description__c);
                        }
                        
                        updateTransactionDate(summary,bill.loan__Due_Date__c,bill.CreatedDate);
                    }
                    else{
                        summary = lastTxnToSummaryMap.get(bill.Id);
                    }
                    if(summary !=null && summary.loan__Loan_Due_Detail__c == null) {
                        summary.loan__Last_Transaction_Type__c = String.valueOf(((Id)bill.Id).getSobjectType());
                        summary.loan__Loan_Due_Detail__c = bill.Id;
                        if(bill.loan__Due_Amt__c!=NULL){
                            summary.loan__Transaction_Amount__c = bill.loan__Due_Amt__c;
                        }
                    }
                    
                    IdsWhtSnapshot.put(summary.loan__Last_transaction_id__c,summary); 
                    summariesToBeInserted.add(summary);
                }
            }

            if(disursalRevList != null && disursalRevList.size()>0){
                for(loan__Disbursal_Adjustment__c disursalRev : disursalRevList){
                    if(!loan.LoanTransactionSummaryUtil.isValidTransaction(disursalRev)){
                        invalidTxnIdToTxnMap.put(disursalRev.Id,disursalRev);
                    }
                    loan__Loan_Transaction_Summary__c summary = new loan__Loan_Transaction_Summary__c();
                    if(!lastTxnToSummaryMap.containsKey(disursalRev.Id)){
                        updateValueForNewSummary(summary , (Datetime)disursalRev.get('loan__Transaction_Time__c') ,disursalRev.Id,disursalRev.loan__Loan_Disbursal_Transaction__r.loan__Loan_Account__c);
                        updateTransactionDate(summary,disursalRev.loan__Adjustment_Txn_Date__c ,disursalRev.CreatedDate);
                        IdsWhtSnapshot.put(summary.loan__Last_transaction_id__c,summary); 
                    }
                    else{
                        summary = lastTxnToSummaryMap.get(disursalRev.Id);
                    }
                    if(summary !=null && summary.loan__Disbursal_Reversal__c == null) {
                        summary.loan__Disbursal_Reversal__c = disursalRev.Id;
                        if(disursalRev.loan__Loan_Disbursal_Transaction__r.loan__Disbursed_Amt__c!=NULL){
                            summary.loan__Transaction_Amount__c = disursalRev.loan__Loan_Disbursal_Transaction__r.loan__Disbursed_Amt__c;
                        }
                        if(disursalRev.Id != null){
                            summary.loan__Last_Transaction_Type__c = String.valueOf(((Id)disursalRev.Id).getSobjectType());
                        }
                        summary.loan__Transaction_Type_Id__c = transTypeToIdMapLDTRev.get(loan.LoanConstants.LOAN_TRANSACTION_DISBURSAL_REVERSAL);
                        updateFieldForReversal(summary,disursalRev.loan__Loan_Disbursal_Transaction__r.loan__Loan_Snapshot__c);

                    }            
                    summariesToBeInserted.add(summary);
                }
            }
            if(iptsList != null && iptsList.size()>0){
                for(loan__Interest_Posting_Transaction__c ipts : iptsList){
                    if(!loan.LoanTransactionSummaryUtil.isValidTransaction(ipts)){
                        invalidTxnIdToTxnMap.put(ipts.Id,ipts);
                    }
                    loan__Loan_Transaction_Summary__c summary = new loan__Loan_Transaction_Summary__c();
                    if( !lastTxnToSummaryMap.containsKey(ipts.Id)){
                        updateTransactionDate(summary,ipts.loan__Transaction_Posting_Date__c,ipts.CreatedDate);   
                        
                        updateValueForNewSummary(summary , (Datetime)ipts.get('loan__Transaction_Time__c') ,ipts.Id, ipts.loan__Loan_Contract__c);         
                    }
                    else{
                        summary = lastTxnToSummaryMap.get(ipts.Id);
                    }
                    if(summary !=null && summary.loan__Interest_Posting_Txn__c == null){
                        if(ipts.loan__Interest_Posted__c!=NULL){
                            summary.loan__Transaction_Amount__c = ipts.loan__Interest_Posted__c;
                        }
                        summary.loan__Interest_Posting_Txn__c = ipts.Id;
                        if(ipts.loan__Interest_Posting_Type__c != null ){
                            summary.loan__Transaction_Type_Id__c = transTypeToIdMapIPT.get(ipts.loan__Interest_Posting_Type__c);
                        }
                    }
                    summariesToBeInserted.add(summary);
                    if(ipts.id!=NULL && ipts.loan__Interest_Posted__c!=NULL){
                        IDToAmountMap.put(ipts.Id,ipts.loan__Interest_Posted__c);
                    }
                }
            }

            if(chargeList != null && chargeList.size()>0){
                for(loan__Charge__c charge : chargeList){
                    if(!loan.LoanTransactionSummaryUtil.isValidTransaction(charge)){
                        invalidTxnIdToTxnMap.put(charge.Id,charge);
                    }
                    loan__Loan_Transaction_Summary__c summary = new loan__Loan_Transaction_Summary__c();
                    if(!lastTxnToSummaryMap.containsKey(charge.Id)){
                        updateTransactionDate(summary,charge.loan__Date__c,charge.CreatedDate);     
                        IdsWhtSnapshot.put(summary.loan__Last_transaction_id__c,summary); 
                        updateValueForNewSummary(summary , (Datetime)charge.get('loan__Date__c') ,charge.Id, charge.loan__Loan_Account__c); 
                    }
                    else{
                        summary = lastTxnToSummaryMap.get(charge.Id);
                    }
                    if( summary != null && summary.loan__Loan_Charge__c == null){
                        if(charge.loan__Original_Amount__c!=NULL){
                            summary.loan__Transaction_Amount__c = charge.loan__Original_Amount__c;
                        }
                        if(charge.Id != null){
                            summary.loan__Last_Transaction_Type__c = String.valueOf(((Id)charge.Id).getSobjectType());
                            summary.loan__Loan_Charge__c = charge.Id;
                        }
                        summary.loan__Transaction_Type_Id__c = transTypeToIdMapCharge.get(loan.LoanConstants.LOAN_CHARGE);
                    }
                    if(charge.loan__Balance__c != NULL){
                        summary.loan__Current_Loan_Balance__c = charge.loan__Balance__c;
                    }
                    if(summary != NULL){
                        summariesToBeInserted.add(summary);
                    }
                    if(charge.Id != NULL && charge.loan__Original_Amount__c != NULL){
                        IDToAmountMap.put(charge.Id,charge.loan__Original_Amount__c);
                    }
                }
            }
            Integer i =0;
            if(!summariesToBeInserted.isEmpty()){
                summariesToBeInserted = loan.LoanTransactionSummaryUtil.sortByTransactionTime(summariesToBeInserted);
                if(IdsWhtSnapshot !=null){
                    for(i = 0 ;i < summariesToBeInserted.size()-1 ;i++){
                        if(summariesToBeInserted[i].loan__Last_transaction_id__c != NULL && IdsWhtSnapshot.containsKey(summariesToBeInserted[i].loan__Last_transaction_id__c)){
                            summariesToBeInserted.remove(i); //This is done to check whether the first sorted txn has snapshot or not
                        }
                        else{
                            break;
                        }
                    }
                }
                if(summariesToBeInserted[0].loan__Transaction_Date__c!=NULL){
                    if(loanAcct.loan__Transaction_Summary_Migrated_Till_Date__c == null || loanAcct.loan__Transaction_Summary_Migrated_Till_Date__c > summariesToBeInserted[0].loan__Transaction_Date__c){
                        loanAcct.loan__Transaction_Summary_Migrated_Till_Date__c = summariesToBeInserted[0].loan__Transaction_Date__c;
                    }
                }
                for(i = 0 ;i < summariesToBeInserted.size();i++){
                    if(summariesToBeInserted[i] != NULL){
                        if(IdsWhtSnapshot !=null){
                            if(summariesToBeInserted[i].loan__Last_transaction_id__c != NULL && IdsWhtSnapshot.isEmpty() == false && IdsWhtSnapshot.containsKey(summariesToBeInserted[i].loan__Last_transaction_id__c)){
                                //This is done to handle the case of txn order like, txn with snaphot -> wht Snaphot
                                //reschedule - > bills ->Pmt
                                //so to fill the value in reschule txn current state, we need value from next snapshot that is not present,
                                //to maintain the consistency of code flow, bills LTS snapshot fields will have same snapshot value as of it is present in reschedule
                                updateSnapShotField(summariesToBeInserted[i],summariesToBeInserted[i-1]);
                            }
                        }
                        if(endDate == dateutil.getCurrentSystemDate() && i != summariesToBeInserted.size()){ //GlobalLoanUtilFacade.getCurrentSystemDate
                            if(i == summariesToBeInserted.size()-1){
                                break;
                            }
                        }
                        //This is done in case next two transaction are two which will not have snapshot
                        //So,to get the better nearest data to get exact the data what was previous state of loan
                        //Like Disbursal, charge, bill ,, then we cannot get better state of loan by using snapshot because txn without snap are gtng updated from previous snapshot
                        if((summariesToBeInserted[i].loan__Interest_Posting_Txn__c != null || summariesToBeInserted[i].loan__Loan_Due_Detail__c != null || summariesToBeInserted[i].loan__Loan_Charge__c != null || summariesToBeInserted[i].loan__Other_Loan_Txn__c != null) && i > 0){
                            if(summariesToBeInserted[i].loan__Loan_Charge__c != null){
                                for(loan__Charge__c charge : chargeList){
                                    if(summariesToBeInserted[i].loan__Loan_Charge__c==charge.id){
                                        updateValueFromPrevState(summariesToBeInserted[i],summariesToBeInserted[i-1],charge.loan__Balance__c);
                                    }
                                }
                                
                            }else if(summariesToBeInserted[i].loan__Interest_Posting_Txn__c != null){
                                for(loan__Interest_Posting_Transaction__c ipts : iptsList){
                                    if(summariesToBeInserted[i].loan__Interest_Posting_Txn__c==ipts.id){
                                        updateValueFromPrevState(summariesToBeInserted[i],summariesToBeInserted[i-1],ipts.loan__Balance__c);
                                    }
                                }
                                
                            }
                            else{
                                updateValueFromPrevState(summariesToBeInserted[i],summariesToBeInserted[i-1],0);
                            }
                            if(summariesToBeInserted[i].loan__Loan_Due_Detail__c == null && summariesToBeInserted[i].loan__Current_Payoff_Balance__c !=NULL && summariesToBeInserted[i].loan__Last_transaction_id__c != NULL &&  IDToAmountMap.get(summariesToBeInserted[i].loan__Last_transaction_id__c) != NULL){
                                summariesToBeInserted[i].loan__Current_Payoff_Balance__c = summariesToBeInserted[i].loan__Current_Payoff_Balance__c + IDToAmountMap.get(summariesToBeInserted[i].loan__Last_transaction_id__c) ;
                            }
                        }               
                        if(summariesToBeInserted[i].loan__Current_Loan_Balance__c ==null && summariesToBeInserted[i+1].loan__Balance__c != NULL){
                            summariesToBeInserted[i].loan__Current_Loan_Balance__c = summariesToBeInserted[i+1].loan__Balance__c;
                        }
                        if(summariesToBeInserted[i].loan__Current_Interest_Rate__c ==null && summariesToBeInserted[i+1].loan__Interest_Rate__c != NULL){
                            summariesToBeInserted[i].loan__Current_Interest_Rate__c = summariesToBeInserted[i+1].loan__Interest_Rate__c;
                        }
                        if(summariesToBeInserted[i].loan__Current_Payoff_Balance__c ==null && summariesToBeInserted[i+1].loan__Pay_Off_Amount_As_Of_Today__c != NULL){
                            summariesToBeInserted[i].loan__Current_Payoff_Balance__c = summariesToBeInserted[i+1].loan__Pay_Off_Amount_As_Of_Today__c;
                        }
                        if(summariesToBeInserted[i].loan__Current_Principal_Remaining__c ==null && summariesToBeInserted[i+1].loan__Principal_Remaining__c != NULL){
                            summariesToBeInserted[i].loan__Current_Principal_Remaining__c = summariesToBeInserted[i+1].loan__Principal_Remaining__c;
                        }
                        
                        if(summariesToBeInserted[i].loan__Current_Delinquent_Amount__c == null && summariesToBeInserted[i+1].loan__Delinquent_Amount__c != NULL){
                            summariesToBeInserted[i].loan__Current_Delinquent_Amount__c = summariesToBeInserted[i+1].loan__Delinquent_Amount__c;
                        }
                        if(depositList2 !=null && depositList2.size()>1 && summariesToBeInserted[i] != NULL && summariesToBeInserted[i].loan__Transaction_Date__c != NULL){
                            Integer j;
                            for(j=0;j<(depositList2.size()-1);j++){
                                if(summariesToBeInserted[i].loan__Current_Loan_Balance__c != NULL && summariesToBeInserted[i].loan__Last_Transaction_Type__c!='loan__Loan_Disbursal_Transaction__c'){
                                    if(depositList2[j].clcommon__Deposit_Amount__c!=NULL && depositList2[j].clcommon__Transaction_Date__c <= summariesToBeInserted[i].loan__Transaction_Date__c && depositList2[j+1].clcommon__Transaction_Date__c > summariesToBeInserted[i].loan__Transaction_Date__c){
                                        summariesToBeInserted[i].loan__Consolidated_Loan_Balance__c =  summariesToBeInserted[i].loan__Current_Loan_Balance__c  - depositList2[j].clcommon__Deposit_Amount__c;
                                    }
                                    if(j==depositList2.size()-2 && depositList2[j+1].clcommon__Transaction_Date__c <= summariesToBeInserted[i].loan__Transaction_Date__c ){
                                        if(depositList2[j+1].clcommon__Deposit_Amount__c!=NULL)
                                            summariesToBeInserted[i].loan__Consolidated_Loan_Balance__c =  summariesToBeInserted[i].loan__Current_Loan_Balance__c  - depositList2[j+1].clcommon__Deposit_Amount__c;
                                    }
                                }else{
                                    if(summariesToBeInserted[i].loan__Current_Loan_Balance__c != NULL){
                                        summariesToBeInserted[i].loan__Consolidated_Loan_Balance__c =  summariesToBeInserted[i].loan__Current_Loan_Balance__c ;
                                    }
                                }
                            }
                        }else if(depositList2 !=null && depositList2.size()==1 && summariesToBeInserted[i] != NULL && summariesToBeInserted[i].loan__Transaction_Date__c != NULL && summariesToBeInserted[i].loan__Last_Transaction_Type__c!='loan__Loan_Disbursal_Transaction__c'){
                            if(summariesToBeInserted[i].loan__Current_Loan_Balance__c != NULL && depositList2[0].clcommon__Deposit_Amount__c!=NULL && depositList2[0].clcommon__Transaction_Date__c <= summariesToBeInserted[i].loan__Transaction_Date__c){
                                summariesToBeInserted[i].loan__Consolidated_Loan_Balance__c =  summariesToBeInserted[i].loan__Current_Loan_Balance__c  - depositList2[0].clcommon__Deposit_Amount__c;
                            }else if(summariesToBeInserted[i].loan__Current_Loan_Balance__c != NULL){
                                summariesToBeInserted[i].loan__Consolidated_Loan_Balance__c =  summariesToBeInserted[i].loan__Current_Loan_Balance__c;
                            }
                        }else if(summariesToBeInserted[i].loan__Current_Loan_Balance__c != NULL){
                            summariesToBeInserted[i].loan__Consolidated_Loan_Balance__c =  summariesToBeInserted[i].loan__Current_Loan_Balance__c ;
                        }
                        if(summariesToBeInserted[i].loan__Consolidated_Loan_Balance__c == NULL && summariesToBeInserted[i].loan__Current_Loan_Balance__c != NULL ){
                            summariesToBeInserted[i].loan__Consolidated_Loan_Balance__c =  summariesToBeInserted[i].loan__Current_Loan_Balance__c ;
                        }
                    }
                    else{
                        summariesToBeInserted.remove(i);
                    }
                }
            }
            if(endDate == dateutil.getCurrentSystemDate()){
                if(summariesToBeInserted[i].loan__Current_Interest_Rate__c == null && loanAcct.loan__Interest_Rate__c != NULL){
                    summariesToBeInserted[i].loan__Current_Interest_Rate__c = loanAcct.loan__Interest_Rate__c;
                }
                if(summariesToBeInserted[i].loan__Current_Loan_Balance__c == null && loanAcct.loan__Loan_Balance__c != NULL){
                    summariesToBeInserted[i].loan__Current_Loan_Balance__c = loanAcct.loan__Loan_Balance__c;
                }
                if(summariesToBeInserted[i].loan__Current_Payoff_Balance__c == null && loanAcct.loan__Pay_Off_Amount_As_Of_Today__c != NULL){
                    summariesToBeInserted[i].loan__Current_Payoff_Balance__c = loanAcct.loan__Pay_Off_Amount_As_Of_Today__c;
                }
                if(summariesToBeInserted[i].loan__Current_Principal_Remaining__c == null && loanAcct.loan__Principal_Remaining__c != NULL){
                    summariesToBeInserted[i].loan__Current_Principal_Remaining__c = loanAcct.loan__Principal_Remaining__c;
                }
                if(summariesToBeInserted[i].loan__Current_Delinquent_Amount__c == null && loanAcct.loan__Delinquent_Amount__c != NULL){
                    summariesToBeInserted[i].loan__Current_Delinquent_Amount__c = loanAcct.loan__Delinquent_Amount__c;
                }
            }
            //Seperate summaries that needs to be updated and inserted
            for(i=0;i<summariesToBeInserted.size();i++){
                if(summariesToBeInserted[i] != NULL){
                    if(lastTxnToSummaryMap.size() > 0 && summariesToBeInserted[i].loan__Last_transaction_id__c != NULL && (lastTxnToSummaryMap.containsKey(summariesToBeInserted[i].loan__Last_transaction_id__c) || invalidTxnIdToTxnMap.containsKey(summariesToBeInserted[i].loan__Last_transaction_id__c))){
                        summariesToBeInserted.remove(i);
                        lastTxnToSummaryMap.remove(summariesToBeInserted[i].loan__Last_transaction_id__c);
                    }
                }
                else{
                    summariesToBeInserted.remove(i);
                }
            }
            uow.addToInsert(summariesToBeInserted);
            uow.addToUpdate(loanAcct); 
            uow.addToUpdate(lastTxnToSummaryMap.values());    

        }catch(Exception e){
            
            String error  = 'Loan Transaction summary util createSummariesForLoan=EXCEPTION ::'+e.getStackTraceString();
            loan__Batch_Process_Log__c log = new loan__Batch_Process_Log__c(loan__Date__c =  dateutil.getCurrentSystemDate(),
                                                                            loan__Log_Level__c = 'ERROR',
                                                                            loan__Type__c = 'Exception',
                                                                            loan__Message__c = error);
            logsList.add(log);
            throw(e);
        }
    }
}