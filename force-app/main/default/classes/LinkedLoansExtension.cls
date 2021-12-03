/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This is the controller class of CustonLinkedLoansPage.It save the linked loan to Contract and 
                update the linked Loan and Total Sum of linked loan field in Cl Contract.
Development Date : 30/03/2021
Last Modified Date : 20/05/2021
****************************************************************************************************/
public with sharing class LinkedLoansExtension {

    public loan__Loan_Account__c acct {get;set;}
    public loan__Loan_Account__c loan { get; set; }
    public Linked_Loan__c linkedLoan1 { get; set; }
    public Linked_Loan__c linkedLoan2 { get; set; }
    
    public LinkedLoansExtension(ApexPages.StandardController stdController){
        acct = [SELECT id,
                      name 
                  FROM loan__Loan_Account__c 
                  WHERE id = :ApexPages.currentPage().getParameters().get(ConstantValues.LOAN_ACCOUNT_ID)];
        loan = new loan__Loan_Account__c();
        linkedLoan1 = new Linked_Loan__c();
        linkedLoan2 = new Linked_Loan__c();

    }
    //This method returns the Linked Loan Details related to CL Contract.
    public List<Linked_Loan__c> getlinkedLoanList(){
        List<Linked_Loan__c> linkedLoanList = [SELECT id,
                                                    Current_Loan_Record__r.Name,
                                                    Linked_Loan__r.Name 
                                                FROM Linked_Loan__c 
                                                WHERE Current_Loan_Record__c=: acct.id];
        return linkedLoanList;
    }
    //This method Save or Insert the Linked Loan 
    public PageReference Save() {
        try {
            List<Linked_Loan__c> linkedLoanCheckList=new List<Linked_Loan__c>();
            List<Id> loanIdList=new List<Id>();

            linkedLoan1.Current_Loan_Record__c = acct.id;
            if(linkedLoan1.Current_Loan_Record__c==linkedLoan1.Linked_Loan__c){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error, ConstantValues.LINKED_LOAN_ERROR_MSG1));
                return null;
            }
            if(acct!=null){
                linkedLoanCheckList=[SELECT id,
                                           Linked_Loan__c 
                                       FROM Linked_Loan__c 
                                       WHERE Current_Loan_Record__c =: acct.id];
            }
            for(Linked_Loan__c linkedLoan:linkedLoanCheckList){
                if(linkedLoan.Linked_Loan__c == linkedLoan1.Linked_Loan__c){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error, ConstantValues.LINKED_LOAN_ERROR_MSG2));
                    return null;
                }
            }
            if(linkedLoan1!=null){
                database.insert(linkedLoan1,false); 
            }
            linkedLoan2.Linked_Loan__c=acct.id;
            linkedLoan2.Current_Loan_Record__c =linkedLoan1.Linked_Loan__c;
            if(linkedLoan2!=null){
                database.insert(linkedLoan2,false);
            }
            
            loanIdList.add(linkedLoan1.Current_Loan_Record__c);
            loanIdList.add(linkedLoan2.Current_Loan_Record__c);
            updateLoanAccount(loanIdList);
            
            return new Pagereference('/'+ApexPages.currentPage().getParameters().get(ConstantValues.LOAN_ACCOUNT_ID));

        }catch(Exception exe){
            insert new clcommon__Log__c(
                clcommon__Message__c = 'LinkedLoansExtension :Exception: '+exe.getStackTraceString()+'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Time__c = System.Now());
            return null;
        }
    }
    //Cancel button in VF page.
    public PageReference Cancel() {
        return new Pagereference('/'+ApexPages.currentPage().getParameters().get(ConstantValues.LOAN_ACCOUNT_ID)); 
    }
    //This method add the Linked Loans Name on Linked Loans field and update Total sum of Linked Loan on the CL Contract.
    public static void updateLoanAccount(List<Id> loanIdList){
        try{
            List<loan__Loan_Account__c> loanList=new List<loan__Loan_Account__c>();
            List<Linked_Loan__c> linkedLoanList1=new List<Linked_Loan__c>();
            List<String> loanNameList=new List<String>();
            List<String> loanFinancierList=new List<String>();
            if(loanIdList.size()>0){
                loanList=[SELECT Name,
                                Total_Sum_Of_Linked_Loans__c,
                                Current_Loan_Balance_Excluding_Deposit__c,
                                Linked_Loans__c,
                                Financier_Linked_Loans__c,
                                Warehouse__c,
                                Total_Sum_of_Financier_Exposure__c  
                            FROM loan__Loan_Account__c 
                            WHERE id in: loanIdList ];

                linkedLoanList1 =[SELECT id,
                                        Linked_Loan__r.id,
                                        Linked_Loan__r.Name,
                                        Current_Loan_Record__r.Name,
                                        Current_Loan_Record__c,
                                        Current_Loan_Balance_Excluding_Deposit__c,
                                        Linked_Loan__r.Warehouse__c   
                                    FROM Linked_Loan__c 
                                    WHERE Current_Loan_Record__c IN: loanIdList
                                    ORDER BY Linked_Loan__r.Name ASC];
            }
            for(loan__Loan_Account__c loan1: loanList){
                loan1.Linked_Loans__c=loan1.Name;
                loan1.Total_Sum_Of_Linked_Loans__c=loan1.Current_Loan_Balance_Excluding_Deposit__c;
                loan1.Financier_Linked_Loans__c=null;
                loan1.Total_Sum_of_Financier_Exposure__c=0;
                for(Linked_Loan__c linkedloan : linkedLoanList1){
                    if((loan1.id==linkedloan.Current_Loan_Record__c)){
                        if(loan1.Total_Sum_Of_Linked_Loans__c==null){
                            loan1.Total_Sum_Of_Linked_Loans__c = linkedloan.Current_Loan_Balance_Excluding_Deposit__c;
                        }else if(linkedloan.Current_Loan_Balance_Excluding_Deposit__c!=null){
                            loan1.Total_Sum_Of_Linked_Loans__c = loan1.Total_Sum_Of_Linked_Loans__c
                                                                +linkedloan.Current_Loan_Balance_Excluding_Deposit__c;
                        }
                        if(loan1.Linked_Loans__c!=null){
                            loan1.Linked_Loans__c = loan1.Linked_Loans__c
                                            +ConstantValues.SEMICOLON+linkedloan.Linked_Loan__r.Name;
                        }
                        if(loan1.Financier_Linked_Loans__c==null){
                            loan1.Financier_Linked_Loans__c=loan1.Name;
                        }
                        if(loan1.Financier_Linked_Loans__c != null && linkedLoan.Linked_Loan__r.Name!=null 
                            && linkedLoan.Linked_Loan__r.Warehouse__c==loan1.Warehouse__c){
                            loan1.Financier_Linked_Loans__c = loan1.Financier_Linked_Loans__c
                                + ConstantValues.SEMICOLON+linkedLoan.Linked_Loan__r.Name;
                        }
                        if(loan1.Total_Sum_of_Financier_Exposure__c==0 && linkedLoan.Current_Loan_Balance_Excluding_Deposit__c!=null){
                            loan1.Total_Sum_of_Financier_Exposure__c=loan1.Current_Loan_Balance_Excluding_Deposit__c;
                        }
                        if(loan1.Total_Sum_of_Financier_Exposure__c!=null && linkedLoan.Current_Loan_Balance_Excluding_Deposit__c!=null
                            && linkedLoan.Linked_Loan__r.Warehouse__c==loan1.Warehouse__c){
                            loan1.Total_Sum_of_Financier_Exposure__c = loan1.Total_Sum_of_Financier_Exposure__c
                                                                +linkedLoan.Current_Loan_Balance_Excluding_Deposit__c;
                        }
                    }    
                }
                //Sort the Linked Loans in Ascending order 
                if(loan1.Linked_Loans__c!=null){
                    loanNameList=loan1.Linked_Loans__c.split(';');
                    loanNameList.sort();
                    loan1.Linked_Loans__c=null;
                    for(String loanName:loanNameList){
                        if(loan1.Linked_Loans__c==null){
                            loan1.Linked_Loans__c = loanName;
                        }else{
                            loan1.Linked_Loans__c = loan1.Linked_Loans__c
                                            +ConstantValues.SEMICOLON+loanName;
                        }
                    }
                }
                //Sort the Financier Linked Loans in Ascending Order.
                if(loan1.Financier_Linked_Loans__c!=null){
                    loanFinancierList=loan1.Financier_Linked_Loans__c.split(';');
                    loanFinancierList.sort();
                    loan1.Financier_Linked_Loans__c=null;
                    for(String loanFinancier:loanFinancierList){
                        if(loan1.Financier_Linked_Loans__c==null){
                            loan1.Financier_Linked_Loans__c = loanFinancier;
                        }else{
                            loan1.Financier_Linked_Loans__c = loan1.Financier_Linked_Loans__c
                                            +ConstantValues.SEMICOLON+loanFinancier;
                        }
                    }
                }
            }
            if(loanList.size()>0){
                database.update(loanList,false);
            }

        }catch(Exception exe){
            insert new clcommon__Log__c(
                clcommon__Message__c = 'LinkedLoansExtension :Exception: '+exe.getStackTraceString()+'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Time__c = System.Now());
        }
    }

}