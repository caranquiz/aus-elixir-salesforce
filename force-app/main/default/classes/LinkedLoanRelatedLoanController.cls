/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This is the controller class of linkedLoansPage.This class shows detail of Linked Loans 
			related to Loan and delete the linked loan when Del button is clicked.
Development Date : 6/05/2021
Last Modified Date : 19/05/2021
****************************************************************************************************/
public with sharing class LinkedLoanRelatedLoanController {

    public loan__Loan_Account__c acct {get;set;}
    public String linkedLoanId {get; set;}
    
    public LinkedLoanRelatedLoanController(ApexPages.StandardController stdController){
        acct = [SELECT id,
                      Name 
                  FROM loan__Loan_Account__c 
                  WHERE id = :ApexPages.currentPage().getParameters().get(ConstantValues.LOAN_ID)];
    }
    //This method returns the Linked Loan Details related to CL Contract.
    public List<Linked_Loan__c> getLinkedLoanList(){
        List<Linked_Loan__c> linkedLoanList =[SELECT id,
                                                    Linked_Loan__c,
                                                    Current_Loan_Record__c,
                                                    Current_Loan_Record__r.Name,
                                                    Linked_Loan__r.Name,
                                                    Current_Loan_Balance_Excluding_Deposit__c,
                                                    Linked_Loan_Status__c 
                                                FROM Linked_Loan__c 
                                                WHERE Current_Loan_Record__c=:acct.id];
        return linkedLoanList;
    }

    //This method delete the selected Linked Loan 
    public PageReference deleteLinkedLoan(){
        try{
        List<Id> loanIdList=new List<Id>();
        Linked_Loan__c linkedLoan1=new Linked_Loan__c();
        Linked_Loan__c linkedLoan2=new Linked_Loan__c();
        if(linkedLoanId!=null){
            linkedLoan1 = [SELECT id,
                                Linked_Loan__c,
                                Linked_Loan__r.Name,
                                Current_Loan_Balance_Excluding_Deposit__c,
                                Current_Loan_Record__r.Name,
                                Current_Loan_Record__c
                            FROM Linked_Loan__c 
                            WHERE id =: linkedLoanId LIMIT 1];
        }
        if(linkedLoan1!=null){                               
            linkedLoan2 = [SELECT id,
                                Linked_Loan__c,
                                Linked_Loan__r.Name,
                                Current_Loan_Balance_Excluding_Deposit__c,
                                Current_Loan_Record__r.Name,
                                Current_Loan_Record__c
                            FROM Linked_Loan__c 
                            WHERE Linked_Loan__c =: linkedLoan1.Current_Loan_Record__c 
                            AND Current_Loan_Record__c =:linkedLoan1.Linked_Loan__c LIMIT 1];   
        }
        
        loanIdList.add(linkedLoan1.Current_Loan_Record__c);
        loanIdList.add(linkedLoan1.Linked_Loan__c);
        if(linkedLoan1 != null){
            database.delete(linkedLoan1,false);
        }
        if(linkedLoan2 != null){
            database.delete(linkedLoan2,false);
        }

        updateLoanAccount(loanIdList);

        PageReference tempPage = ApexPages.currentPage();            
        tempPage.setRedirect(true);
        return tempPage;

        }catch(Exception exe){
            insert new clcommon__Log__c(
                clcommon__Message__c = 'LinkedLoanRelatedLoanController :Exception: '+exe.getStackTraceString()+'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Time__c = System.Now());
            return null;
        }
        
    }
    //This method add the Linked Loans Name on Linked Loans field and update Total sum of Linked Loan on the CL Contract.
    public static void updateLoanAccount(List<Id> loanIdList){

        try{
            List<loan__Loan_Account__c> loanList=new List<loan__Loan_Account__c>();
            List<Linked_Loan__c> linkedLoanList1=new List<Linked_Loan__c>();
            if(loanIdList.size()>0){
                loanList=[SELECT Name,
                                Total_Sum_Of_Linked_Loans__c,
                                Current_Loan_Balance_Excluding_Deposit__c,
                                Linked_Loans__c 
                            FROM loan__Loan_Account__c 
                            WHERE id in: loanIdList ];
                linkedLoanList1 =[SELECT id,
                                        Linked_Loan__r.id,
                                        Linked_Loan__r.Name,
                                        Current_Loan_Record__r.Name,
                                        Current_Loan_Record__c,
                                        Current_Loan_Balance_Excluding_Deposit__c 
                                    FROM Linked_Loan__c 
                                    WHERE Current_Loan_Record__c IN: loanIdList
                                    ORDER BY Linked_Loan__r.Name ASC];
            }
            
            if(loanList.size()>0){
                for(loan__Loan_Account__c loan1: loanList){
                    List<String> LoanNameList=new List<String>();
                    loanNameList.add(loan1.Name); 
                    loan1.Total_Sum_Of_Linked_Loans__c=loan1.Current_Loan_Balance_Excluding_Deposit__c;
                    
                    if(linkedLoanList1.size()>0){
                        for(Linked_Loan__c linkedLoan : linkedLoanList1){
                            if((loan1.id==linkedLoan.Current_Loan_Record__c)){
                                if(loan1.Total_Sum_Of_Linked_Loans__c==null){
                                    loan1.Total_Sum_Of_Linked_Loans__c=linkedLoan.Current_Loan_Balance_Excluding_Deposit__c;
                                }else{
                                    loan1.Total_Sum_Of_Linked_Loans__c = loan1.Total_Sum_Of_Linked_Loans__c
                                                                        +linkedLoan.Current_Loan_Balance_Excluding_Deposit__c;
                                }
                                if(!loanNameList.contains(linkedLoan.Linked_Loan__r.Name)){
                                    loanNameList.add(linkedLoan.Linked_Loan__r.Name);
                                }
                            }
                            
                        }
                    }
                    loanNameList.sort();
                    loan1.Linked_Loans__c=null;
                    if(loanNameList.size()>1){
                        for(String loanName:loanNameList){
                            if(Loan1.Linked_Loans__c==null){
                                Loan1.Linked_Loans__c=loanName;
                            }else{
                                loan1.Linked_Loans__c = loan1.Linked_Loans__c
                                                        +ConstantValues.SEMICOLON+loanName;
                            }
                            
                        }
                    }else{
                        loan1.Linked_Loans__c=null;
                        loan1.Total_Sum_Of_Linked_Loans__c=0;
                    }        
                }
            }
            if(loanList.size()>0){
                database.update(loanList,false);
            }
        }catch(Exception exe){
            insert new clcommon__Log__c(
                clcommon__Message__c = 'LinkedLoanRelatedLoanController :Exception: '+exe.getStackTraceString()+'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Time__c = System.Now());
        }
    }

}