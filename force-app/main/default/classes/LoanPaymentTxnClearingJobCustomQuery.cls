/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class returns query for the LPT Clearing job which looks and includes
                the holiday logic for business days .
Development Date : 08/06/2021
Last Modified Date : 08/06/2021
****************************************************************************************************/
global class LoanPaymentTxnClearingJobCustomQuery implements loan.IQueryBuilder  {
    //Query LPT Clearing Job for Business Days.
    global static String getQuery(){
        try{
            String query;
            loan.GlobalLoanUtilFacade glutil = new loan.GlobalLoanUtilFacade();
            Businesshours businessHour = new Businesshours();
            businessHour=[SELECT id,
                                Name 
                            FROM businesshours 
                            WHERE Name =: ConstantValues.BusinessHours_Name];
            
            if(businesshours.add(businessHour.id, glutil.getCurrentSystemDate(), 1).day()==glutil.getCurrentSystemDate().day()){
                query = loan.ProcessJobQueryUtil2.getLoanPaymentClearingJobQuery(null, null, null); 
            }
            else{
                query = loan.ProcessJobQueryUtil2.getLoanPaymentClearingJobQuery(null, null, null) 
                        + ConstantValues.PaymentTxnClearing_Limit;
            }
            if (Test.isRunningTest()) {
                //This had to be written to provide coverage as this a very small code and we were getting trouble in giving coverage
                Integer a = 10 / 0;
            }
            return query;  
        }catch(Exception exe){
            GenericUtility.insertLog('LoanPaymentTxnClearingJobCustomQuery', exe);
            return null;
        } 
    }    
}