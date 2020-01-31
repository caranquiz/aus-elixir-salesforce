/*************************************
Description : Controller class for warehouse tagging - used to tag a warehouse when 'Add Warehouse' button is clicked in CL contract.
Developer : Deep Bhattacharjee
Date : 01/01/20
***************************************/

public class WarehouseController{
    public loan__Loan_Account__c acct {get;set;}
    public class MyException extends Exception {}
    public WarehouseController(){
        acct = [SELECT id,name, Warehouse__c, Application__r.Name FROM loan__Loan_Account__c WHERE id = :ApexPages.currentPage().getParameters().get('loanId')];
    }
    public PageReference Save() {
        try {
            Loan_Warehouse__c obj = new Loan_Warehouse__c();
            obj.Warehouse__c = acct.Warehouse__c;
            obj.Application__c = acct.Application__c;
            obj.CL_Contract__c = acct.id;
            if(obj!=Null){
                insert obj;
            }
            return new Pagereference('/'+ApexPages.currentPage().getParameters().get('loanId'));
        }
        catch(Exception e){
            insert new clcommon__Log__c(
                clcommon__Message__c = 'WarehouseController :Exception: '+e.getStackTraceString()+'error='+e.getMessage()+' at Line Number '+e.getLineNumber(),
                clcommon__Time__c = System.Now());
            return null;
        }
    }
    public PageReference Cancel() {
        return new Pagereference('/'+ApexPages.currentPage().getParameters().get('loanId')); 
    }
}