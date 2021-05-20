/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This is the controller class of CustonLinkedLoansPage.It save the linked loan to Contract.
Development Date : 30/03/2021
Last Modified Date : 20/05/2021
****************************************************************************************************/
public with sharing class LinkedLoansExtension {

    public loan__Loan_Account__c acct {get;set;}
    public class MyException extends Exception {}
    public loan__Loan_Account__c loan { get; set; }
    public Linked_Loan__c linkedLoan1 { get; set; }
    public Linked_Loan__c linkedLoan2 { get; set; }
    public List<Linked_Loan__c> linkedLoanList { get; set;}
    public LinkedLoansExtension(ApexPages.StandardController stdController){
        acct = [SELECT id,
                      name 
                  FROM loan__Loan_Account__c 
                  WHERE id = :ApexPages.currentPage().getParameters().get('loanId')];

        loan = new loan__Loan_Account__c();
        linkedLoan1 = new Linked_Loan__c();
        linkedLoan2 = new Linked_Loan__c();

        linkedLoanList =[SELECT id,
                               Current_Loan_Record__r.Name,
                               Linked_Loan__r.Name 
                           FROM Linked_Loan__c 
                           WHERE Current_Loan_Record__c=: ApexPages.currentPage().getParameters().get('loanId')];
    }

    //Save the Linked Loan and add the Linked Loans Name on the CL Contract field Linked Loans.
    public PageReference Save() {
        try {
            linkedLoan1.Current_Loan_Record__c = ApexPages.currentPage().getParameters().get('loanId');
            if(linkedLoan1.Current_Loan_Record__c==linkedLoan1.Linked_Loan__c){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error, ConstantValues.LINKED_LOAN_ERROR_MSG1));
                return null;
            }
            List<Linked_Loan__c> linkedLoanCheckList=[SELECT id,
                                                            Linked_Loan__c 
                                                        FROM Linked_Loan__c 
                                                        WHERE Current_Loan_Record__c =: ApexPages.currentPage().getParameters().get('loanId')];
            if(linkedLoanCheckList.size()>0){
                for(Linked_Loan__c lloan:linkedLoanCheckList){
                    if(lloan.Linked_Loan__c == linkedLoan1.Linked_Loan__c){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error, ConstantValues.LINKED_LOAN_ERROR_MSG2));
                        return null;
                    }
                }
            }
            if(linkedLoan1!=Null){
                database.insert(linkedLoan1,false); 
            }
            linkedLoan2.Linked_Loan__c=ApexPages.currentPage().getParameters().get('loanId');
            linkedLoan2.Current_Loan_Record__c =linkedLoan1.Linked_Loan__c;
            if(linkedLoan2!=null){
                database.insert(linkedLoan2,false);
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
            loanIdList.add(linkedLoan1.Current_Loan_Record__c);
            loanIdList.add(linkedLoan2.Current_Loan_Record__c);
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
                    List<String> loanNameList=new List<String>();
                    LoanNameList.add(loan1.Name); 
                    
                    loan1.Total_Amount_Borrowed__c=loan1.Current_Loan_Balance_Excluding_Deposit__c;
                    if(linkedLoanList1.size()>0){
                        for(Linked_Loan__c lla : linkedLoanList1){
                            if((loan1.id==lla.Current_Loan_Record__c)){
                                if(loan1.Total_Amount_Borrowed__c==null){
                                    loan1.Total_Amount_Borrowed__c=lla.Current_Loan_Balance_Excluding_Deposit__c;
                                }else{
                                    loan1.Total_Amount_Borrowed__c=loan1.Total_Amount_Borrowed__c+lla.Current_Loan_Balance_Excluding_Deposit__c;
                                }
                                if(!LoanNameList.contains(lla.Linked_Loan__r.Name)){
                                    LoanNameList.add(lla.Linked_Loan__r.Name);
                                }
                            }    
                        }
                    }
                    LoanNameList.sort();
                    Loan1.Linked_Loans__c=null;
                    for(String loanName:LoanNameList){
                        if(Loan1.Linked_Loans__c==null){
                            Loan1.Linked_Loans__c=loanName;
                        }else{
                            loan1.Linked_Loans__c=loan1.Linked_Loans__c+';'+loanName;
                        }
                    }
                }
            }
            if(loanList.size()>0){
                database.update(loanList,false);
            }
            return new Pagereference('/'+ApexPages.currentPage().getParameters().get('loanId'));

        }catch(Exception exe){
            insert new clcommon__Log__c(
                clcommon__Message__c = 'LinkedLoansExtension :Exception: '+exe.getStackTraceString()+'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Time__c = System.Now());
            return null;
        }
    }
    //Cancel button in VF page.
    public PageReference Cancel() {
        return new Pagereference('/'+ApexPages.currentPage().getParameters().get('loanId')); 
    }
}