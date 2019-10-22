/********************************************************************************
    * Description: Loan Application Convert Class to convert app to loan app and contract
    * Developer: Rameswari Barman
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
            acc = [SELECT id FROM Account WHERE id =: genApp.genesis__Account__c]; 
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
                    genApp.genesis__Status__c = 'APPROVED - CONVERTED TO CONTRACT';
                    
                    //loanApplication.Application__c = genApp.Id;   
                    loanApplication.peer__Stage__c = 'In Funding';   
                    
                    //Added for updation
                    loanApplicationList.add(loanApplication);
                    
                    //query loan Account
                    loanAcc = [SELECT ID,
                                      loan__Loan_Status__c,
                                  Loan_Application__c
                               FROM loan__loan_account__c
                               WHERE ID =: loanApplication.peer__Loan__c];
                    
                    //Map data from Application to CL contract
                    loanAcc.Loan_Application__c =loanApplication.Id;
                    loanAcc.loan__Loan_Status__c = 'Approved';
                    loanAcc.Application__c=genApp.Id;
                    
                }
            }
            else{
                returnString = 'Account could not be found!';
            }
            if(!loanApplicationList.isEmpty()){
                update loanApplicationList;
                update genApp;
                update loanAcc;
                returnString = 'Application converted to contract successfully!';
            }
        }
        else{
            returnString = 'Application not found!';
        }
    return returnString;
    }
    webservice static String convertLoanApplicationCtrl(String appId) {
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
                                        genesis__Interest_Only_Period__c
                                FROM genesis__Applications__c where id = :appId];
                                            
        if(genApp.genesis__Term__c==null){
            return ConstantValues.termValidationMsg;
        }
        if(genApp.Loan_Application__c!=null){
            return ConstantValues.AppAlreadyConvertedMsg ;
        }
        if(genApp.genesis__Interest_Rate__c == null || genApp.genesis__Interest_Rate__c <0){
            return ConstantValues.IntRateValidationMsg ;
        }
        if(genApp.genesis__Payment_Frequency__c==null){
            return ConstantValues.PmntFreqReqMsg;
        }
        if(genApp.genesis__Loan_Amount__c==null || genApp.genesis__Loan_Amount__c==0){
            return ConstantValues.loanAmntValidation;
        }
        String result = convertLoanApplication(genApp); 
        return result;
    }
}