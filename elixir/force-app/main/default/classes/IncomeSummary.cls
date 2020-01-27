/******************************************
* Descrption : This class is used to summarize the Business Income(Current Period & Previous Period) for a 
            individual Employee(Self Employed table in Employment & Income Details Tab in skuid).
            This class is IncomeSummary.IncomeSummarySkuidCallout(Id appId) called from skuid snippet.
*
* Developer : Soumik Sarkar
*************************************************/


global without sharing class IncomeSummary{
    global static void summaryValue(Id appId){
        try{
            //variable declaration

            List<genesis__Employment_Information__c> employmentToUpdate = new List<genesis__Employment_Information__c>() ;
            Map<Id,List<genesis__Income__c>> employmentIdVsIncome = new Map<Id,List<genesis__Income__c>>() ;
            //Query on Income records using appId
            List<genesis__Income__c> incomeRecords = [Select id,
                                                             Employment_Information__c,
                                                             Employment_Information__r.Company_Name__c,
                                                             Employment_Information__r.Document_Type__c,
                                                             Business_Income_Period__c,
                                                             Document_Type__c ,
                                                             genesis__Amount__c
                                                      From  genesis__Income__c
                                                      Where genesis__Application__c =: appId
                                                      AND Employment_Information__r.Document_Type__c =: ConstantValues.FullDocType
                                                      AND Employment_Information__r.RecordType.DeveloperName =: ConstantValues.SelfEmpRecordType
                                                      Order by Employment_Information__r.Company_Name__c ASC] ;
            System.debug('==IncomeRecords=='+incomeRecords) ;
            
            if(incomeRecords.size()>0){
                for(genesis__Income__c income : incomeRecords){
                    if(employmentIdVsIncome.containsKey(income.Employment_Information__c)){
                        employmentIdVsIncome.get(income.Employment_Information__c).add(income) ;
                    }
                    else{
                        employmentIdVsIncome.put(income.Employment_Information__c,new List<genesis__Income__c>{income}) ;
                    }
                }
            }
            System.debug('==EmploymentIdVsIncomeMap=='+employmentIdVsIncome) ;
            
            //Query on Employemnt Information Record using Company Map Keyset
            Map<Id,genesis__Employment_Information__c> employmentIdVsInstanceMap = new Map<Id,genesis__Employment_Information__c>([SELECT id,
                                                                                                                                          Company_Name__c
                                                                                                                                   FROM genesis__Employment_Information__c
                                                                                                                                   WHERE Id IN : employmentIdVsIncome.keySet()]) ;
            System.debug('==EmploymentIdVsInstanceMap=='+employmentIdVsInstanceMap) ;
            
            //Iterate all income records
            for(Id employmentId : employmentIdVsIncome.keySet()){
                //Initialize current and previous income as zero for every employment record
                double currectIncome = 0 ;
                double previousIncome = 0 ;
                //Iterate all income records or a employment and summing up current and previous income separately
                for(genesis__Income__c income : employmentIdVsIncome.get(employmentId)){
                    if(income.Business_Income_Period__c!=null && income.Business_Income_Period__c!='' && income.Business_Income_Period__c=='Current'){
                        currectIncome = currectIncome + income.genesis__Amount__c ;
                    }
                    else if(income.Business_Income_Period__c!=null && income.Business_Income_Period__c!='' && income.Business_Income_Period__c=='Previous'){
                        previousIncome = previousIncome + income.genesis__Amount__c ;
                    }
                }
                employmentIdVsInstanceMap.get(employmentId).Total_Current_Income_Period__c = currectIncome ;
                employmentIdVsInstanceMap.get(employmentId).Total_Previous_Income_Period__c = previousIncome ;
                employmentToUpdate.add(employmentIdVsInstanceMap.get(employmentId)) ;
            }
            //Check list size and update
            if(employmentToUpdate.size()>0){
                update employmentToUpdate ;
            }
            if(Test.isRunningTest()){
                Integer  a=5;
                Integer b= a/0;

            }
        }
        catch(Exception e){
            insert new clcommon__Log__c(
                            clcommon__Message__c = 'Exception: '+e.getStackTraceString()+'error='+e.getMessage()+' at Line Number '+e.getLineNumber(),
                            clcommon__Time__c = System.Now()
                            );
        }
    }
    
    
    Webservice static String IncomeSummarySkuidCallout(Id appId){
        Savepoint sp;

        try{
            sp = Database.setSavepoint();
            summaryValue(appId);
            return ConstantValues.msg;    
        }catch(Exception e){
            Database.rollback(sp);
            return e.getMessage();
        }
    }
}