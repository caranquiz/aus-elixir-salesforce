/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class give coverage to LinkedLoansExtension and LinkedLoanDetails apex class.
Development Date : 
Last Modified Date : 
****************************************************************************************************/

@isTest(SeeAllData=false)
public class LinkedLoansExtensionTest {
    @TestSetup
    static void initialize(){

        loan__Loan_Account__c lla=ElixirTestHelper.returnLoanAccount();
        lla.loan__Loan_Balance__c=10000;
        lla.Deposit_Amount__c=100;
        upsert lla;
        List<loan__Loan_Account__c> llaList=[SELECT id 
                                                FROM loan__Loan_Account__c 
                                                WHERE id=: lla.id 
                                                LIMIT 1];
        system.assertEquals(llalist.size(), 1);
        
        Linked_Loan__c linkedloan=new Linked_Loan__c();
        linkedloan.Current_Loan_Record__c=lla.id;
        linkedloan.Linked_Loan__c=lla.id;
        insert linkedloan;
        List<Linked_Loan__c> linkedList=[SELECT id 
                                            FROM Linked_Loan__c 
                                            WHERE id=: linkedloan.id 
                                            LIMIT 1];
        system.assertEquals(linkedlist.size(), 1);

    }
	@isTest
    static void deleteRecordTest1(){
        
        loan__Loan_Account__c lla=[SELECT id,
                                         loan__Loan_Balance__c 
                                     FROM loan__Loan_Account__c 
                                     WHERE loan__Loan_Balance__c=10000 
                                     LIMIT 1];
        system.assertEquals(lla.loan__Loan_Balance__c, 10000);
        
        Linked_Loan__c linked=[SELECT id,
                                     Current_Loan_Record__c 
                                 FROM Linked_Loan__c 
                                 WHERE Current_Loan_Record__c=: lla.id 
                                 LIMIT 1];
        

        PageReference pageRef =page.LinkedLoansPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',lla.id);
        
        ApexPages.StandardController stc = new ApexPages.StandardController(lla);
        
        test.startTest();
        LinkedLoanDetails obj=new LinkedLoanDetails(stc);
        obj.llId=linked.id;
        PageReference objPageRef = obj.deleteRecord();
        
        test.stopTest();
            
    }
    @isTest
    static void deleteRecordTest2(){
        
        loan__Loan_Account__c lla=[SELECT id,
                                         loan__Loan_Balance__c 
                                     FROM loan__Loan_Account__c 
                                     WHERE loan__Loan_Balance__c=10000 
                                     LIMIT 1];
        system.assertEquals(lla.loan__Loan_Balance__c, 10000);
        
        PageReference pageRef =page.LinkedLoansPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',lla.id);
        
        ApexPages.StandardController stc = new ApexPages.StandardController(lla);
        
        test.startTest();
        LinkedLoanDetails obj=new LinkedLoanDetails(stc);
        PageReference objPageRef = obj.deleteRecord();
        
        test.stopTest();
            
    }
    @isTest
    static void saveRecordTest(){
        
        loan__Loan_Account__c lla=[SELECT id,
                                         loan__Loan_Balance__c 
                                     FROM loan__Loan_Account__c 
                                     WHERE loan__Loan_Balance__c=10000 
                                     LIMIT 1];
        system.assertEquals(lla.loan__Loan_Balance__c, 10000);
        
        Linked_Loan__c linked=[SELECT id,
                                     Current_Loan_Record__c,
                                     Linked_Loan__c 
                                 FROM Linked_Loan__c 
                                 WHERE Current_Loan_Record__c=: lla.id 
                                 LIMIT 1];
        

        PageReference pageRef =page.CustomLinkedLoansPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('loanId',lla.id);
        
        ApexPages.StandardController stc = new ApexPages.StandardController(lla);
        
        test.startTest();
        LinkedLoansExtension obj=new LinkedLoansExtension(stc);
        obj.linkedLoan.Current_Loan_Record__c=lla.id;
        obj.linkedLoan.Linked_Loan__c=lla.id;
        PageReference objPageRef = obj.Save();
        test.stopTest();
            
    }
    @isTest
    static void cancelTest(){
        
        loan__Loan_Account__c lla=[SELECT id,
                                         loan__Loan_Balance__c 
                                     FROM loan__Loan_Account__c 
                                     WHERE loan__Loan_Balance__c=10000 
                                     LIMIT 1];
        system.assertEquals(lla.loan__Loan_Balance__c, 10000);

        PageReference pageRef =page.CustomLinkedLoansPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('loanId',lla.id);
        
        ApexPages.StandardController stc = new ApexPages.StandardController(lla);
        
        test.startTest();
        LinkedLoansExtension obj=new LinkedLoansExtension(stc);
        PageReference objPageRef = obj.Cancel();
        
        test.stopTest();
            
    }
}