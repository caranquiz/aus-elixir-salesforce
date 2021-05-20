/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This is the controller class of linkedLoan1sPage.This class the detail of Linked Loans
                    and delete the linked loan.
Development Date : 6/05/2021
Last Modified Date : 19/05/2021
****************************************************************************************************/
public with sharing class LinkedLoanDetails {

    public loan__Loan_Account__c acct {get;set;}
    public class MyException extends Exception {}
    public String llId {get; set;}
    public List<Linked_Loan__c> linkedLoanList { get; set; }
    public LinkedLoanDetails(ApexPages.StandardController stdController){
        acct = [SELECT id,
                      name 
                  FROM loan__Loan_Account__c 
                  WHERE id = :ApexPages.currentPage().getParameters().get('id')];

        linkedLoanList =[SELECT id,
                               Linked_Loan__c,
                               Current_Loan_Record__c,
                               Current_Loan_Record__r.Name,
                               Linked_Loan__r.Name,
                               Current_Loan_Balance_Excluding_Deposit__c,
                               Linked_Loan_Status__c 
                         FROM Linked_Loan__c 
                         WHERE Current_Loan_Record__c=: ApexPages.currentPage().getParameters().get('id') ];       
    }
    //Delete the Linked Loan and add the Linked Loans Name and update Total sum of Linked Loan on the CL Contract field Linked Loans.
    public PageReference deleteRecord(){
        try{
        Linked_Loan__c linkedLoan1 = [SELECT id,
                                           Linked_Loan__c,
                                           Linked_Loan__r.Name,
                                           Current_Loan_Balance_Excluding_Deposit__c,
                                           Current_Loan_Record__r.Name,
                                           Current_Loan_Record__c
                                       FROM Linked_Loan__c 
                                       WHERE id =: llId LIMIT 1];
                                        
        Linked_Loan__c linkedLoan2 = [SELECT id,
                                           Linked_Loan__c,
                                           Linked_Loan__r.Name,
                                           Current_Loan_Balance_Excluding_Deposit__c,
                                           Current_Loan_Record__r.Name,
                                           Current_Loan_Record__c
                                       FROM Linked_Loan__c 
                                       WHERE Linked_Loan__c =: linkedLoan1.Current_Loan_Record__c 
                                       AND Current_Loan_Record__c =:linkedLoan1.Linked_Loan__c LIMIT 1];   
                                       
        
        if(linkedLoan1 != null){
            database.delete(linkedLoan1,false);
        }
        if(linkedLoan2 != null){
            database.delete(linkedLoan2,false);
        }

        List<Linked_Loan__c> linkedLoanList1 =[SELECT id,
                                                    Linked_Loan__r.id,
                                                    Linked_Loan__r.Name,
                                                    Current_Loan_Record__r.Name,
                                                    Current_Loan_Record__c,
                                                    Current_Loan_Balance_Excluding_Deposit__c 
                                                FROM Linked_Loan__c 
                                                WHERE Current_Loan_Record__c=: linkedLoan1.Current_Loan_Record__c
                                                OR Current_Loan_Record__c=: linkedLoan2.Current_Loan_Record__c 
                                                ORDER BY Linked_Loan__r.Name ASC];

        List<Id> loanIdList=new List<Id>();
        List<loan__Loan_Account__c> loanList;
        loanIdList.add(ApexPages.currentPage().getParameters().get('id'));
        loanIdList.add(linkedLoan1.Linked_Loan__c);

        if(loanIdList.size()>0){
            loanList=[SELECT Name,
                            Total_Amount_Borrowed__c,
                            Current_Loan_Balance_Excluding_Deposit__c,
                            Linked_Loans__c 
                        FROM loan__Loan_Account__c 
                        WHERE id in: loanIdList ];
        }
        
        if(loanList.size()>0){
            for(loan__Loan_Account__c loan1: loanList){
                List<String> LoanNameList=new List<String>();
                loanNameList.add(loan1.Name); 
                loan1.Total_Amount_Borrowed__c=loan1.Current_Loan_Balance_Excluding_Deposit__c;
                
                if(linkedLoanList1.size()>0){
                    for(Linked_Loan__c lla : linkedLoanList1){
                        if((loan1.id==lla.Current_Loan_Record__c)){
                            if(loan1.Total_Amount_Borrowed__c==null){
                                loan1.Total_Amount_Borrowed__c=lla.Current_Loan_Balance_Excluding_Deposit__c;
                            }else{
                                loan1.Total_Amount_Borrowed__c=loan1.Total_Amount_Borrowed__c+lla.Current_Loan_Balance_Excluding_Deposit__c;
                            }
                            if(!loanNameList.contains(lla.Linked_Loan__r.Name)){
                                loanNameList.add(lla.Linked_Loan__r.Name);
                            }
                        }
                        
                    }
                }
                loanNameList.sort();
                loan1.Linked_Loans__c=null;
                Integer check=0;
                if(loanNameList.size()>0){
                    for(String loanName:loanNameList){
                        if(Loan1.Linked_Loans__c==null){
                            Loan1.Linked_Loans__c=loanName;
                        }else{
                            loan1.Linked_Loans__c=loan1.Linked_Loans__c+';'+loanName;
                        }
                        check=check+1;
                    }
                }
                if(check==1){
                    loan1.Linked_Loans__c=null;
                    loan1.Total_Amount_Borrowed__c=0;
                }        
            }
        }
        if(loanList.size()>0){
            database.update(loanList,false);
        }

        PageReference tempPage = ApexPages.currentPage();            
        tempPage.setRedirect(true);
        return tempPage;

        }catch(Exception exe){
            insert new clcommon__Log__c(
                clcommon__Message__c = 'linkedLoan1Details :Exception: '+exe.getStackTraceString()+'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Time__c = System.Now());
            return null;
        }
        
    }

}