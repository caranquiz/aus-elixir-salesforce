/********************************************************************************
    * Description: Loan Application Convert Class to convert app to loan app and contract
    * Developer: Rameswari Barman
    * Creation Date : 8/08/2019
    * Implementation code : genesis__Applications__c app = [SELECT    id,
                                                Name,
                                                genesis__Balloon_Payment__c,
                                                genesis__Account__c,
                                                genesis__Interest_Rate__c,
                                                genesis__Term__c,
                                                genesis__Payment_Frequency__c,
                                                genesis__Expected_First_Payment_Date__c,
                                                genesis__Expected_Start_Date__c,
                                                genesis__CL_Purpose__r.loan__Lending_Purpose__c,
                                                genesis__CL_Product__r.loan__Lending_Product__c,
                                                genesis__CL_Product__c,
                                                genesis__CL_Product__r.clcommon__Product_Name__c,
                                                genesis__CL_Product__r.loan__Lending_Product__r.id,
                                                genesis__Status__c,
                                                Loan_Application__c,
                                                genesis__Loan_Amount__c,
                                                genesis__Days_Convention__c,
                                                genesis__Interest_Only_Period__c,
                                                Fixed_Rate_Term__c
                                                FROM genesis__Applications__c where id = 'XXXXXX'];
    String st=LoanApplicationConvert.convertLoanApplicationCtrl(app.Id);
********************************************************************************/


global class LoanApplicationConvert{
    private static List< peer__Loan_Application__c> loanApplicationList;
    private static Date currentSystemDate;
    public static String returnString;
    
    //Creates marketplace  loan application and cl contract in partial stage 
    //and attaches with the created loan app
    public static String convertLoanApplication(genesis__Applications__c  genApp){
        currentSystemDate = (Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
        SavePoint sp = Database.setSavePoint();
        Date firstPaymentDate = genApp.genesis__Expected_First_Payment_Date__c;
        loan__loan_account__c loanAcc = new loan__loan_account__c(); 
        peer__Loan_Application__c loanApplication;
        Account acc; 
        loanApplicationList = new List<peer__Loan_Application__c>();
        if(genApp != NULL){
            acc = [SELECT id,Last_Approved_Application_ID__c FROM Account WHERE id =: genApp.genesis__Account__c]; 
            acc.Last_Approved_Application_ID__c = genApp.Id;
            if(acc != null && Schema.sObjectType.Account.fields.Last_Approved_Application_ID__c.isUpdateable()){
                update acc;
            }
            if(acc != null){
                peer.LoanApplicationBuilder loanApplication1 = new peer.LoanApplicationBuilder(acc,
                                                                                            genApp.genesis__Loan_Amount__c,
                                                                                            genApp.genesis__Term__c,
                                                                                            genApp.genesis__Interest_Rate__c,
                                                                                            genApp.genesis__CL_Purpose__r.loan__Lending_Purpose__c);
                                                                                            
                //Set Disbursal Date
                loanApplication1.setExpectedDisbursalDate(currentSystemDate);
                
                //set first payment date
                loanApplication1.setFirstInstallmentDate(firstPaymentDate); 
                
                loanApplication1.setPaymentFrequency(genApp.genesis__Payment_Frequency__c);
                
                //Set lending product using cl product
                loanApplication1.setLoanProductId(genApp.genesis__CL_Product__r.loan__Lending_Product__c);
                
                //Generate Schedule
                loanApplication1.setCreateSchedule(False);
                
                //Set Interest only period if applicable
                if(genApp.genesis__Interest_Only_Period__c != null){
                    loanApplication1.setInterestOnlyPeriod(genApp.genesis__Interest_Only_Period__c);
                }
                //Set ballon payment if applicable
                if(genApp.genesis__Balloon_Payment__c != null){
                    loanApplication1.setBalloonAmount(genApp.genesis__Balloon_Payment__c);
                }
                if(true){ 
                    loanApplication = loanApplication1.build();
                }else{
                    loanApplication = new peer__Loan_Application__c();
                }
                //Set Loan Application 
                if(loanApplication != NULL){  
                    //Displays created loan appliaction id on genesis application  
                    genApp.Loan_Application__c = loanApplication.Id;
                    genApp.genesis__Status__c = System.label.ApplicationStatusAfterCLContractConverted;
                    
                    //loanApplication.Application__c = genApp.Id;   
                    loanApplication.peer__Stage__c = System.label.InFunding;   
                    
                    //Added for updation
                    loanApplicationList.add(loanApplication);
                    
                    //query loan Account
                    loanAcc = [SELECT ID,
                                loan__Loan_Status__c,
                                Loan_Application__c,
                                Fixed_Rate_Term__c,
                                Application__c
                                FROM loan__loan_account__c
                            WHERE ID =: loanApplication.peer__Loan__c];
                    //Map data from Application to CL contract
                    loanAcc.Loan_Application__c = loanApplication.Id;
                    loanAcc.loan__Loan_Status__c = ConstantValues.APPROVED;
                    loanAcc.Application__c=genApp.Id;
                    loanAcc.Fixed_Rate_Term__c  = genApp.Fixed_Rate_Term__c;
                    
                }
            }
            else{
                returnString = System.label.AccountNotFound;
            }
            if(!loanApplicationList.isEmpty()){
                update loanApplicationList;
                if(genApp != null){//updates the status and loan application field of application record
                    update genApp;
                }
                if(loanAcc != null){
                    update loanAcc;
                }
                returnString = System.label.ApplicationToCLContractSuccessStatus;
            }
        }
        else{
            returnString = System.label.ApplicantNotFoundErrorMsg;
        }
    return returnString;
    }
    webservice static String convertLoanApplicationCtrl(Id appId) {
        genesis__Applications__c  genApp =[SELECT id,
                                        Name,
                                        genesis__Balloon_Payment__c,
                                        genesis__Account__c,
                                        genesis__Interest_Rate__c,
                                        genesis__Term__c,
                                        genesis__Payment_Frequency__c,
                                        genesis__Expected_First_Payment_Date__c,
                                        genesis__Expected_Start_Date__c,
                                        genesis__CL_Purpose__r.loan__Lending_Purpose__c,
                                        genesis__CL_Product__r.loan__Lending_Product__c,
                                        genesis__CL_Product__c,
                                        genesis__CL_Product__r.clcommon__Product_Name__c,
                                        genesis__CL_Product__r.loan__Lending_Product__r.id,
                                        genesis__Status__c,
                                        Loan_Application__c,
                                        genesis__Loan_Amount__c,
                                        genesis__Days_Convention__c,
                                        genesis__Interest_Only_Period__c,
                                        Fixed_Rate_Term__c
                                FROM genesis__Applications__c where id = :appId];                                
        if(genApp.genesis__Term__c==null){
            return ConstantValues.TERM_VALIDATION_MSG;
        }
        if(genApp.Loan_Application__c!=null){
            return ConstantValues.APP_ALREADY_CONVERTED_MSG;
        }
        if(genApp.genesis__Interest_Rate__c == null || genApp.genesis__Interest_Rate__c <0){
            return ConstantValues.INTEREST_RATE_VALIDATION_MSG;
        }
        if(genApp.genesis__Payment_Frequency__c==null){
            return ConstantValues.PAYMENT_FREQUENCY_VALIDATION_MSG;
        }
        if(genApp.genesis__Loan_Amount__c==null || genApp.genesis__Loan_Amount__c==0){
            return ConstantValues.LOAN_AMT_VALIDATION_MSG;
        }
        String result = convertLoanApplication(genApp); 
        return result;
    }
}