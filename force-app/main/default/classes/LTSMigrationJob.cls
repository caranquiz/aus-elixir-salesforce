/******************************************************************
Description : This class has been provided by CL to handle transactions present
              on Transaction Summary object and migrate to Loan Transaction Summary
******************************************************************/
global class LTSMigrationJob extends clcommon.DynamicJob {
    
    global Integer batchSize;
    private static String NAME = 'LTS Migration Job';
    private mfiflexUtil.UnitOfWorkTransaction uowTransaction;
    Date startDate;
    Date endDate;
    
    public static Integer getBatchJobSize(Integer defaultSize) {
        System.debug('Rameswari == A');
        //First consider custom settings else default a job should have or SF's default
        Integer batchSize = loan.CustomSettingsUtil.getBatchSize();

        if(batchSize != null && batchSize > 0 && batchSize <= 10000) {  //10000 is maximum batch size restricted by SF
            return batchSize;
        }
        if(defaultSize != null) {
            return defaultSize;
        }
        return 200;
    }
    global static String getAccountForLTSMigration(){
        System.debug('Rameswari == B');
        String ns = loan.CustomSettingsUtil.getOrgParameters().loan__Namespace_Prefix__c;
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        if (ec.getObject('LTSMigrationJob') != null) {
            ec.deleteObject('LTSMigrationJob');
        }
        mfiflexUtil.ObjectCache ltsMigrationJobOC = ec.createObject('LTSMigrationJob',
                                                                    'loan__Loan_Account__c',
                                                                     loan.CustomSettingsUtil.getOrgParameters().loan__Namespace_Prefix__c);
        String allowabledLoanStatuses = '\'' + loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING + '\'' + ',' +
                                        '\'' + loan.LoanConstants.LOAN_STATUS_CLOSED_OBLIGATIONS_MET + '\'' + ',' +
                                        '\''+ loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING + '\'';
                                 
        String fieldsName = loan.ObjectCacheQueryUtil.getLoanSnapshotFields();
        ltsMigrationJobOC.addFields(fieldsName);
        
        String whereClause = 'loan__Invalid_Data__c = false '+
                             ' AND loan__Loan_Status__c IN ('+  allowabledLoanStatuses +') ';
       
        ltsMigrationJobOC.setWhereClause(whereClause);
        ltsMigrationJobOC.buildQuery();
        System.debug('inside the job query ::'+ltsMigrationJobOC.getQuery());
        System.debug('Rameswari in ==>getAccountForLTSMigration()');
        return ltsMigrationJobOC.getQuery();
    }


    global LTSMigrationJob() {
        this(null,null,null, 0);
        System.debug('Rameswari == C');
    }
    

    public LTSMigrationJob(String query,Date startDate, Date endDate , Integer batchSize) {
        super(NAME, query == null ? getAccountForLTSMigration() : query);
        System.debug('Rameswari == D');
        if(batchSize == 0) {
            batchSize = getBatchJobSize(200);
        }
        this.batchSize = batchSize;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public Integer getBatchSize() {
        System.debug('Rameswari == E');
        return this.batchSize;
    }
    
    global override void doexecute(SchedulableContext sc) {
        System.debug('Rameswari == F');
        Database.executeBatch(this.getInstance(), this.batchSize);
    }

    global  LTSMigrationJob getInstance() {
        System.debug('Rameswari == G');
        LTSMigrationJob job = new LTSMigrationJob();
        return job;
    }
    
    global override void doInitialize() {} // do nothing
    
    global override String getRuntimeQuery() {
        System.debug('Rameswari == H');
        String query = getAccountForLTSMigration();
        return query;
    }
    
    global override String getRuntimeQueryForPipelinedExecution(Set<Id> records) {
        System.debug('Rameswari == I');
        return null;
    }

    global override void doStart(Database.BatchableContext bc) {} // do nothing

    global override void doexecute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('Rameswari == J');
    	List<loan__Loan_Account__c> loanAccounts = (List<loan__Loan_Account__c>)scope;
        LTSMigrationHandler ltsMigrationandler = new LTSMigrationHandler(startDate,endDate);
    	ltsMigrationandler.process(loanAccounts);
    }

    global override void doFinish(Database.BatchableContext bc) {
        System.debug('Rameswari == K');
    }
}