/********************************************************************************
Name : PrepaidFeeCalculatorClass
Purpose : Custom Fee calculator class which returns the pre-paid fees amount.
            and also the value of the periodic fee
Developer : Rameswari Barman
*********************************************************************************/
public without sharing class PrepaidFeeCalculatorClass implements loan.CustomFeeCalculator{
    public Decimal computeFee(loan__Fee__c fee, loan__Loan_Account__c loan){
        try{
            //Decimal amt = 0;
            loan__Loan_Account__c lacc = [Select id,
                                                 loan__Account__c,
                                                 loan__Frequency_of_Loan_Payment__c,
                                                 Application__c,
                                                 Loan_Application__c,
                                                 loan__Account__r.last_Approved_Application_ID__c
                                          From loan__Loan_Account__c 
                                          Where id =: loan.id];
            //---------------------------------------------------------------------------------
            if(lacc != null && lacc.loan__Account__r.last_Approved_Application_ID__c != null){
                lacc.Application__c = lacc.loan__Account__r.last_Approved_Application_ID__c;
                update lacc;
            }
            
            //--------------------------------------------------------------------------------                              
            //       code to dynamically get all the fields                               
            //--------------------------------------------------------------------------------
            Schema.DescribeSObjectResult r = genesis__Applications__c.sObjectType.getDescribe();
            List<String>apiNames =  new list<String>();
            for(string apiName : r.fields.getMap().keySet()){
               apiNames.add(apiName);
            }
            
            //---------------------------------------------------------------------------------
            //   Creating Query using the Fields
            //---------------------------------------------------------------------------------
            String query='Select '+String.join(apiNames,',')+' From genesis__Applications__c Where id=\''+lacc.Application__c+'\'';
            genesis__Applications__c genApp=Database.query(query);
            
            //---------------------------------------------------------------------------------
            //    Custom settings list to get all fees and its fields mapping from APP fields
            //---------------------------------------------------------------------------------
            map<String,Elixir_Before_Or_On_Settlement_Fees__c> feeSetFieldMap= Elixir_Before_Or_On_Settlement_Fees__c.getAll();
            
            //---------------------------------------------------------------------------------
            //        Get Field API name from custom settings and its current value 
            //---------------------------------------------------------------------------------
            if(feeSetFieldMap.get(fee.Name)!=null && feeSetFieldMap.get(fee.Name).Fee_Field_API_Name__c!=null){
                if(genApp.get(feeSetFieldMap.get(fee.Name).Fee_Field_API_Name__c)!=null && genApp.get(feeSetFieldMap.get(fee.Name).Fee_Field_API_Name__c)!=0){
                    return (Decimal)genApp.get(feeSetFieldMap.get(fee.Name).Fee_Field_API_Name__c);
                }else {
                    return 0;
                }
            }else {
                return 0;
            }
        }catch(Exception e){
            return 0;//throw e;
        }
    }
}