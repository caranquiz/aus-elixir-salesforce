/******************************************************************
Description : This class has been provided by CL product team to create Loan Transaction Summary Records for transactions 
              that were created before the LTS feature is switched ON in the org.
              Nothing has been changed on this class by CK except the description.
              This is a one time use migration script class
Last Modified : 29-06-2021
Mast Modified By : Rameswari Barman
******************************************************************/
global class LTSMigrationJob extends clcommon.DynamicJob {
    
    global Integer batchSize;
    private static String NAME = 'LTS Migration Job';
    private mfiflexUtil.UnitOfWorkTransaction uowTransaction;
    Date startDate;
    Date endDate;
    
    public static Integer getBatchJobSize(Integer defaultSize) {
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
        return ltsMigrationJobOC.getQuery();
    }


    global LTSMigrationJob() {
        this(null,null,null, 0);
    }
    

    public LTSMigrationJob(String query,Date startDate, Date endDate , Integer batchSize) {
        super(NAME, query == null ? getAccountForLTSMigration() : query);
        if(batchSize == 0) {
            batchSize = getBatchJobSize(200);
        }
        this.batchSize = batchSize;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public Integer getBatchSize() {
        return this.batchSize;
    }
    
    global override void doexecute(SchedulableContext sc) {
        Database.executeBatch(this.getInstance(), this.batchSize);
    }

    global  LTSMigrationJob getInstance() {
        LTSMigrationJob job = new LTSMigrationJob();
        return job;
    }
    
    global override void doInitialize() {} // do nothing
    
    global override String getRuntimeQuery() {
        String query = getAccountForLTSMigration();
        return query;
    }
    
    global override String getRuntimeQueryForPipelinedExecution(Set<Id> records) {
        return null;
    }

    global override void doStart(Database.BatchableContext bc) {} // do nothing

    global override void doexecute(Database.BatchableContext BC, List<sObject> scope) {
        List<loan__Loan_Account__c> loanAccounts = (List<loan__Loan_Account__c>)scope;
        LTSMigrationHandler ltsMigrationandler = new LTSMigrationHandler(startDate,endDate);
    	ltsMigrationandler.process(loanAccounts);
    }

    global override void doFinish(Database.BatchableContext bc) {}
}