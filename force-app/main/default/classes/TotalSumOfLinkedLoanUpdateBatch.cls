/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class updates the Total Sum of Linked Loan in CL Contract whenever this batch job runs.
Development Date : 19/05/2021
Last Modified Date : 20/05/2021
****************************************************************************************************/

public class TotalSumOfLinkedLoanUpdateBatch implements DataBase.StateFul,DataBase.Batchable<sObject>,Schedulable {
    //Query all Cl Contract  
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT id,
                                               Name,
                                               Linked_Loans__c,
                                               Current_Loan_Balance_Excluding_Deposit__c,
                                               Total_Sum_Of_Linked_Loans__c,
                                               Total_Sum_of_Financier_Exposure__c,
                                               Warehouse__c,
                                               loan__Loan_Status__c,
                                               Financier_Linked_Loans__c
                                           FROM loan__Loan_Account__c
                                           WHERE Current_Loan_Balance_Excluding_Deposit__c!= null]);
    }
    //This method updates Total Sum of Linked Loan in CL Contract.
    public void execute(Database.BatchableContext bc, List<loan__Loan_Account__c> objLoanList) {
        try{
            List<Linked_Loan__c> objLinkedLoanList = new List<Linked_Loan__c>();
            List<String> loanFinancierList=new List<String>();
            List<String> loanNameList=new List<String>();

            if(objLoanList.size()>0){
                objLinkedLoanList =[SELECT id,
                                       Linked_Loan__r.Name,
                                       Current_Loan_Record__c,
                                       Current_Loan_Balance_Excluding_Deposit__c,
                                       Linked_Loan__r.Warehouse__c,
                                       Linked_Loan__r.Id 
                                   FROM Linked_Loan__c 
                                   WHERE Current_Loan_Record__c IN: objLoanList
                                   AND Current_Loan_Balance_Excluding_Deposit__c!=null];
                List<Id> loanId=new List<Id>();
                List<String> loanStatusList=System.label.loanStatus.split(',');
                for(loan__Loan_Account__c loanAccount:objLoanList){
                    if(loanStatusList.contains(loanAccount.loan__Loan_Status__c)){
                        loanId.add(loanAccount.id);
                    }
                }
                if(loanId.size()>0){
                    deleteLinkage(loanId);
                }
            
                for(loan__Loan_Account__c loanAccount:objLoanList){
                    loanAccount.Total_Sum_Of_Linked_Loans__c=0;
                    loanAccount.Total_Sum_of_Financier_Exposure__c=0;
                    loanAccount.Financier_Linked_Loans__c=null;
                    loanAccount.Linked_Loans__c=null;
                    if(!loanStatusList.contains(loanAccount.loan__Loan_Status__c)){
                        for(Linked_Loan__c linkedLoan : objLinkedLoanList){
                            if(linkedLoan.Current_Loan_Record__c==loanAccount.id  && !loanId.contains(linkedLoan.Linked_Loan__r.Id)){
                                if(loanAccount.Total_Sum_Of_Linked_Loans__c==0){
                                    loanAccount.Total_Sum_Of_Linked_Loans__c=loanAccount.Current_Loan_Balance_Excluding_Deposit__c;
                                }
                                if(loanAccount.Total_Sum_Of_Linked_Loans__c!=NULL){
                                    loanAccount.Total_Sum_Of_Linked_Loans__c = loanAccount.Total_Sum_Of_Linked_Loans__c 
                                                                                + linkedLoan.Current_Loan_Balance_Excluding_Deposit__c;
                                }
                                if(loanAccount.Linked_Loans__c==null){
                                    loanAccount.Linked_Loans__c=loanAccount.Name;
                                }
                                if(loanAccount.Linked_Loans__c!=null && linkedLoan.Linked_Loan__r.Name!=null){
                                    loanAccount.Linked_Loans__c = loanAccount.Linked_Loans__c
                                                        +ConstantValues.SEMICOLON+linkedLoan.Linked_Loan__r.Name;
                                }
                                if(loanAccount.Total_Sum_of_Financier_Exposure__c==0 && loanAccount.Current_Loan_Balance_Excluding_Deposit__c!=null){
                                    loanAccount.Total_Sum_of_Financier_Exposure__c=loanAccount.Current_Loan_Balance_Excluding_Deposit__c;
                                }
                                if(loanAccount.Total_Sum_of_Financier_Exposure__c!=null && linkedLoan.Current_Loan_Balance_Excluding_Deposit__c!=null
                                    && linkedLoan.Linked_Loan__r.Warehouse__c==loanAccount.Warehouse__c){
                                    loanAccount.Total_Sum_of_Financier_Exposure__c = loanAccount.Total_Sum_of_Financier_Exposure__c
                                                                        +linkedLoan.Current_Loan_Balance_Excluding_Deposit__c;
                                }
                                if(loanAccount.Financier_Linked_Loans__c==null){
                                    loanAccount.Financier_Linked_Loans__c=loanAccount.Name;
                                }
                                if(loanAccount.Financier_Linked_Loans__c != null && linkedLoan.Linked_Loan__r.Name!=null 
                                    && linkedLoan.Linked_Loan__r.Warehouse__c==loanAccount.Warehouse__c){
                                    loanAccount.Financier_Linked_Loans__c = loanAccount.Financier_Linked_Loans__c
                                        + ConstantValues.SEMICOLON+linkedLoan.Linked_Loan__r.Name;
                                }
                            }
                        }
                        //Sort the Linked Loans in Ascending order 
                        if(loanAccount.Linked_Loans__c!=null){
                            loanNameList=loanAccount.Linked_Loans__c.split(';');
                            loanNameList.sort();
                            loanAccount.Linked_Loans__c=null;
                            for(String loanName:loanNameList){
                                if(loanAccount.Linked_Loans__c==null){
                                    loanAccount.Linked_Loans__c = loanName;
                                }else{
                                    loanAccount.Linked_Loans__c = loanAccount.Linked_Loans__c
                                                    +ConstantValues.SEMICOLON+loanName;
                                }
                            }
                        }
                        //Sort the Financier Linked Loans in Ascending Order.
                        if(loanAccount.Financier_Linked_Loans__c!=null){
                            loanFinancierList=loanAccount.Financier_Linked_Loans__c.split(';');
                            loanFinancierList.sort();
                            loanAccount.Financier_Linked_Loans__c=null;
                            for(String loanFinancier:loanFinancierList){
                                if(loanAccount.Financier_Linked_Loans__c==null){
                                    loanAccount.Financier_Linked_Loans__c = loanFinancier;
                                }else{
                                    loanAccount.Financier_Linked_Loans__c = loanAccount.Financier_Linked_Loans__c
                                                    +ConstantValues.SEMICOLON+loanFinancier;
                                }
                            }
                        }
                    }
                }
            }
            if(objLoanList.size()>0){
                Database.update(objLoanList,false);
            }
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'TotalSumOfLinkedLoanUpdateBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
    public static void deleteLinkage(List<Id> loanId){
        List<Linked_Loan__c> linkedLoan=new List<Linked_Loan__c>();
        linkedLoan=[SELECT id,
                        Linked_Loan__c,
                        Current_Loan_Record__c 
                    FROM Linked_Loan__c 
                    WHERE Linked_Loan__c=:loanId 
                    OR Current_Loan_Record__c=:loanId];
        if(linkedLoan.size()>0){
            Database.delete(linkedLoan,false);
        }
    }
    public void execute(SchedulableContext sc) {
        TotalSumOfLinkedLoanUpdateBatch obj = new TotalSumOfLinkedLoanUpdateBatch();
        Integer size = Integer.valueof(System.label.TotalSumOfLinkedLoanUpdateBatch_Size);  
        database.executebatch(obj,size);
    }
    public void finish(Database.BatchableContext bc){
    }

}