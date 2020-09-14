/********************************
Class Name : DepositUpdateHelper
Developer : Deep Bhattacharjee
Last Modified by : Rameswari Barman
Last Modified Date : 14/09/2020
Purpose : When a record in Deposit Details of Cl Contract is updated,this class gets called.
          With this class, Deposit Amount field of Cl Contract gets updated.
*********************************/

global class DepositUpdateHelper {
    global static void depositUpdate(List <clcommon__Deposit__c> newList){
        List <loan__Loan_Account__c> contractList = new List<loan__Loan_Account__c> ();
        Savepoint sp = Database.setSavepoint();
        try{
            List<clcommon__Deposit__c> depList = [SELECT id,loan__Loan_Account__c,clcommon__Parent_Deposit__c,clcommon__Current_Deposit_Amount__c FROM clcommon__Deposit__c WHERE id =: newList];
            if(!(depList != NULL && depList.size() > 0)){
                throw new CustomException('No deposit is present for processing!');
            }
            for(clcommon__Deposit__c dep : depList){
                if(dep.loan__Loan_Account__c != NULL && dep.clcommon__Parent_Deposit__c == NULL){
                    //only picks the parent deposit record as any redraw or deposit added is reflected in the parent depsit record
                    loan__Loan_Account__c loan = new loan__Loan_Account__c(Id = dep.loan__Loan_Account__c);
                    loan.Deposit_Amount__c = dep.clcommon__Current_Deposit_Amount__c;
                    contractList.add(loan);
                }
            }
            if(contractList != NULL && contractList.size()> 0){
                update contractList;
            }  
        }  
        catch(Exception e){
            Database.rollback(sp);
            GenericUtility.insertLog('DepositUpdateHelper', e);   
        }
    }
}