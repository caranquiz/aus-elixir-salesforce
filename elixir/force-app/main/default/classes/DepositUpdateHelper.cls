/********************************
Class Name : DepositUpdateHelper
Developer : Deep Bhattacharjee
Purpose : When a record in Deposit Details of Cl Contract is updated,this class gets called.
          With this class, Deposit Amount field of Cl Contract gets updated.
*********************************/

global class DepositUpdateHelper {
    global static void depositUpdate(List <clcommon__Deposit__c> newList){
        Set <String> conId = New Set<String> ();
        Decimal amt;
        Savepoint sp = Database.setSavepoint();
        try{
            List<clcommon__Deposit__c> depList = [SELECT id,loan__Loan_Account__c,clcommon__Parent_Deposit__c,clcommon__Current_Deposit_Amount__c FROM clcommon__Deposit__c WHERE id =: newList];
            for(clcommon__Deposit__c dep : depList){
                if(dep.loan__Loan_Account__c != Null && dep.clcommon__Parent_Deposit__c == Null){
                    amt = dep.clcommon__Current_Deposit_Amount__c;
                    conId.add(dep.loan__Loan_Account__c);
                }
            }
            if(conId.size()> 0){
                List <loan__Loan_Account__c> contractList = new List<loan__Loan_Account__c> ();
                List <loan__Loan_Account__c> contList = [SELECT id,Deposit_Amount__c FROM loan__Loan_Account__c WHERE id =: conId];
                for(loan__Loan_Account__c conr : contList){
                    conr.Deposit_Amount__c = amt;
                    contractList.add(conr);
                }
                if(contractList.size()> 0){
                    update contractList;
                }   
            }
        }  
        catch(Exception e){
            Database.rollback(sp);
            insert new clcommon__Log__c(
                clcommon__Message__c = 'DepositUpdateHelper :Exception: '+e.getStackTraceString()+'error= '+e.getMessage()+' at Line Number '+e.getLineNumber(),
                clcommon__Time__c = System.Now());
        }   
    }
}