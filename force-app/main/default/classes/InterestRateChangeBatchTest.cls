/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Sayak Mukhopadhyay
Development Date : 26/05/2022
Last Modified By : Sayak Mukhopadhyay
Last Modified Date : 27/05/2022
Description : This is the test class for InterestRateChangeBatch and InterestRateChangeHandler
 
***********************************************************************************************************************************************************/


@isTest(SeeAllData = false)
public class InterestRateChangeBatchTest{
    @TestSetup
    static void initialize(){
        Date currentSystemDate = Date.Today();
          //Inserting Account 
        Account objAccount = GenericUtilityTestHelper.insertDummyAccount();
        System.AssertNotEquals(
            objAccount.Id,
            null,
            'Account inserted successfully.'
        );
        // Inserting Application
        genesis__applications__c objApplication = GenericUtilityTestHelper.returnApplication(objAccount.id);
        System.AssertNotEquals(
            objApplication.Id,
            null,
            'Application inserted successfully.'
        );
        //Inserting Contract
        loan__Loan_Account__c objContract = GenericUtilityTestHelper.returnLoanAccount();
        objContract.New_Interest_Rate__c = 5;
        objContract.New_Interest_Rate_Effective_Date__c = currentSystemDate;
        objContract.loan__Interest_Type__c = 'Fixed';
        objContract.loan__Invalid_Data__c  = false;
        objContract.loan__Loan_Status__c = 'Active - Good Standing';
        objContract.loan__Uncleared_Repayment_Amount__c = 0;
        objContract.loan__Floating_Rate_Index__c = null;
        objContract.First_Repayment_Date_After_IR_Change__c = currentSystemDate + 23;
        objContract.First_Repayment_Date__c = date.today();
        objContract.Second_Repayment_Date__c=date.newInstance(2022, 8, 7);
        objContract.Interest_Rate_Change_Notification_Date__c = currentSystemDate + 1;
        objContract.Second_Repayment_Date_After_IR_Change__c = currentSystemDate + 46;
        objContract.loan__Interest_Rate__c = 3;
        objContract.Repayment_Type__c='Principal and Interest';
        objContract.loan__Pmt_Amt_Cur__c=3000;
        objContract.loan__Due_Day__c = (currentSystemDate + 23).day();
        update objContract;
        System.AssertNotEquals(
            objContract.Id,
            null,
            'Contract inserted successfully.'
        );

        //Inserting Payment
        loan__Payment_Mode__c objPaymentMode=GenericUtilityTestHelper.getPaymentMode();
        List<loan__Payment_Mode__c> objPaymentModeList=[SELECT id FROM loan__Payment_Mode__c WHERE Name='Direct Debit'];
        System.assertEquals(
            objPaymentModeList.size(), 
            1, 
            'Payment Mode Inserted'
        );

        //Inserting APS
        loan__Automated_Payment_Setup__c objAPS=GenericUtilityTestHelper.returnAPS(objContract.id,objPaymentMode.id);
        objAPS.Created_after_reschedule__c=true;
        objAPS.loan__Amount_Type__c='FIXED AMOUNT';
        update objAPS;
        List<loan__Automated_Payment_Setup__c> objAPSList=[SELECT id FROM loan__Automated_Payment_Setup__c WHERE Created_after_reschedule__c=true AND loan__Amount_Type__c='FIXED AMOUNT'];
        System.assertEquals(
            objAPSList.size(), 
            1, 
            'Payment Mode Inserted'
        );
    }
    @isTest
    static void InterestRateChangeBatchTestMethodeOne(){
        test.startTest();
        List<loan__Loan_Account__c>objContractList = [SELECT id,
                                               Name,
                                               New_Interest_Rate__c,
                                               New_Interest_Rate_Effective_Date__c,
                                               loan__Next_Installment_Date__c,
                                               Calculated_Upcoming_Repayment_Amount__c,
                                               loan__Interest_Rate__c,
                                               Repayment_Type__c ,
                                               Remaining_Loan_Term__c,
                                               Remaining_Term_from_Schedule__c,
                                               Remaining_IO_Period__c,
                                               loan__Due_Day__c,
                                               loan__Frequency_of_Loan_Payment__c,
                                               Interest_Rate_Change_Notification_Date__c,
                                               First_Repayment_Date_After_IR_Change__c,
                                               Second_Repayment_Date_After_IR_Change__c,
                                               loan__Pmt_Amt_Cur__c,
                                               loan__Uncleared_Repayment_Amount__c,
                                               loan__Loan_Status__c,
                                               loan__Delinquent_Amount__c
                                        FROM loan__Loan_Account__c];                  
        InterestRateChangeBatch obj = new InterestRateChangeBatch();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Check', sch, obj );
        test.stopTest();
    }
    @isTest
    static void InterestRateChangeBatchTestMethodeTwo(){
        test.startTest();
        List<loan__Loan_Account__c>objContractList = [SELECT id,
                                               Name,
                                               New_Interest_Rate__c,
                                               New_Interest_Rate_Effective_Date__c,
                                               loan__Next_Installment_Date__c,
                                               Calculated_Upcoming_Repayment_Amount__c,
                                               loan__Interest_Rate__c,
                                               Repayment_Type__c ,
                                               Remaining_Loan_Term__c,
                                               Remaining_Term_from_Schedule__c,
                                               Remaining_IO_Period__c,
                                               loan__Due_Day__c,
                                               loan__Frequency_of_Loan_Payment__c,
                                               Interest_Rate_Change_Notification_Date__c,
                                               First_Repayment_Date_After_IR_Change__c,
                                               Second_Repayment_Date_After_IR_Change__c,
                                               loan__Pmt_Amt_Cur__c,
                                               loan__Uncleared_Repayment_Amount__c,
                                               loan__Loan_Status__c,
                                               loan__Delinquent_Amount__c
                                        FROM loan__Loan_Account__c];
        if(objContractList.size()>0){
            objContractList[0].First_Repayment_Date_After_IR_Change__c = Date.Today() + 1;
            objContractList[0].Interest_Rate_Change_Notification_Date__c = Date.Today() + 5;
            objContractList[0].Second_Repayment_Date_After_IR_Change__c = Date.Today() + 30;
            objContractList[0].loan__Due_Day__c = (Date.Today() + 1).day();
        }
        Database.update(objContractList,false);
        Date firstRepaymentDateAfterIrChange = Date.Today() + 1;
        List<loan__Loan_Account__c> objLoanAccountList = [SELECT id,
                                        First_Repayment_Date_After_IR_Change__c,
                                        Interest_Rate_Change_Notification_Date__c,
                                        New_Interest_Rate_Effective_Date__c,
                                        Second_Repayment_Date_After_IR_Change__c,
                                        loan__Due_Day__c
                                        FROM loan__Loan_Account__c
                                        WHERE First_Repayment_Date_After_IR_Change__c =: firstRepaymentDateAfterIrChange];
        if(objLoanAccountList.size()>0){
            InterestRateChangeBatch obj = new InterestRateChangeBatch();
            String sch = '0 0 23 * * ?';
            system.schedule('Test Check', sch, obj );
        }
        test.stopTest();
    }
    @isTest
    static void InterestRateChangeBatchTestMethodeThree(){
        test.startTest();
        List<loan__Loan_Account__c>objContractList = [SELECT id,
                                               Name,
                                               New_Interest_Rate__c,
                                               New_Interest_Rate_Effective_Date__c,
                                               loan__Next_Installment_Date__c,
                                               Calculated_Upcoming_Repayment_Amount__c,
                                               loan__Interest_Rate__c,
                                               Repayment_Type__c ,
                                               Remaining_Loan_Term__c,
                                               Remaining_Term_from_Schedule__c,
                                               Remaining_IO_Period__c,
                                               loan__Due_Day__c,
                                               loan__Frequency_of_Loan_Payment__c,
                                               Interest_Rate_Change_Notification_Date__c,
                                               First_Repayment_Date_After_IR_Change__c,
                                               Second_Repayment_Date_After_IR_Change__c,
                                               loan__Pmt_Amt_Cur__c,
                                               loan__Uncleared_Repayment_Amount__c,
                                               loan__Loan_Status__c,
                                               loan__Delinquent_Amount__c
                                        FROM loan__Loan_Account__c];
        if(objContractList.size()>0){
            objContractList[0].First_Repayment_Date_After_IR_Change__c = Date.Today() + 1;
            objContractList[0].Interest_Rate_Change_Notification_Date__c = Date.Today() + 5;
            objContractList[0].Second_Repayment_Date_After_IR_Change__c = Date.Today() + 30;
            objContractList[0].loan__Due_Day__c = ((Date.Today() + 1).day())+1;
        }
        Database.update(objContractList,false);
        Date firstRepaymentDateAfterIrChange = Date.Today() + 1;
        List<loan__Loan_Account__c> objLoanAccountList = [SELECT id,
                                        First_Repayment_Date_After_IR_Change__c,
                                        Interest_Rate_Change_Notification_Date__c,
                                        New_Interest_Rate_Effective_Date__c,
                                        Second_Repayment_Date_After_IR_Change__c,
                                        loan__Due_Day__c
                                        FROM loan__Loan_Account__c
                                        WHERE First_Repayment_Date_After_IR_Change__c =: firstRepaymentDateAfterIrChange];
        if(objLoanAccountList.size()>0){
            InterestRateChangeBatch obj = new InterestRateChangeBatch();
            String sch = '0 0 23 * * ?';
            system.schedule('Test Check', sch, obj );
        }
        test.stopTest();
    }
    @isTest
    static void InterestRateChangeBatchTestMethodeFour(){

        test.startTest();
        
        List<loan__Automated_Payment_Setup__c> objAPSList=[SELECT id FROM loan__Automated_Payment_Setup__c];
        objAPSList[0].loan__Type__c='RECURRING';
        objAPSList[0].loan__Frequency__c='Monthly';
        objAPSList[0].loan__Actual_Date__c=date.today();
        //objAPSList[0].loan__Debit_Date__c=date.newinstance(2022,11,1);
        update objAPSList;
        List<loan__Automated_Payment_Setup__c> objAPSList2=[SELECT id FROM loan__Automated_Payment_Setup__c WHERE loan__Type__c='RECURRING' AND loan__Frequency__c='Monthly'];
        System.assertEquals(
            objAPSList2.size(), 
            1, 
            'APS Inserted'
        );

        List<Id> apsIdList=new List<Id>();
        apsIdList.add(objAPSList[0].id);
        OneTimeAPSCreation.oneTimeAPSCreationPILoan(apsIdList);
        test.stopTest();
    }
    @isTest
    static void InterestRateChangeBatchTestMethodFour(){

        test.startTest();
        List<loan__Loan_Account__c>objContractList = [SELECT id,
                                        Flat_Repayment_Amount__c,
                                        Interest_Rate_Change_Notification_Date__c
                                        FROM loan__Loan_Account__c];
        if(objContractList.size()>0){
            objContractList[0].Flat_Repayment_Amount__c = 3000;
        }
        update objContractList;
        List<loan__Loan_Account__c> objLoanList=[SELECT id 
                                                            FROM loan__Loan_Account__c 
                                                            WHERE Flat_Repayment_Amount__c=3000];
        System.assertEquals(
            objLoanList.size(), 
            1, 
            'Contract Inserted'
        );

        List<loan__Automated_Payment_Setup__c> objAPSList=[SELECT id FROM loan__Automated_Payment_Setup__c];
        objAPSList[0].loan__Type__c='RECURRING';
        objAPSList[0].loan__Frequency__c='Monthly';
        objAPSList[0].loan__Actual_Date__c=date.today();
        update objAPSList;
        List<loan__Automated_Payment_Setup__c> objAPSList2=[SELECT id FROM loan__Automated_Payment_Setup__c WHERE loan__Type__c='RECURRING' AND loan__Frequency__c='Monthly'];
        System.assertEquals(
            objAPSList.size(), 
            1, 
            'APS Inserted'
        );

        List<Id> apsIdList=new List<Id>();
        apsIdList.add(objAPSList[0].id);
        OneTimeAPSCreation.oneTimeAPSCreationPILoan(apsIdList);
        test.stopTest();
    }
    @isTest
    static void InterestRateChangeBatchTestMethodFive(){

        test.startTest();
        List<loan__Loan_Account__c>objContractList = [SELECT id,
                                        Flat_Repayment_Amount__c,
                                        First_Repayment_Date_After_IR_Change__c,
                                        Interest_Rate_Change_Notification_Date__c
                                        FROM loan__Loan_Account__c];
        if(objContractList.size()>0){
            objContractList[0].Flat_Repayment_Amount__c = 3000;
            objContractList[0].First_Repayment_Date_After_IR_Change__c = date.newinstance(2021,8,2);
            objContractList[0].Interest_Rate_Change_Notification_Date__c = date.newinstance(2021,8,10);
        }
        update objContractList;
        List<loan__Loan_Account__c> objLoanList=[SELECT id 
                                                            FROM loan__Loan_Account__c 
                                                            WHERE Flat_Repayment_Amount__c=3000];
        System.assertEquals(
            objLoanList.size(), 
            1, 
            'Contract Inserted'
        );

        List<loan__Automated_Payment_Setup__c> objAPSList=[SELECT id FROM loan__Automated_Payment_Setup__c];
        objAPSList[0].loan__Type__c='RECURRING';
        objAPSList[0].loan__Frequency__c='Monthly';
        objAPSList[0].loan__Actual_Date__c=date.today();
        update objAPSList;
        List<loan__Automated_Payment_Setup__c> objAPSList2=[SELECT id 
                                                            FROM loan__Automated_Payment_Setup__c 
                                                            WHERE loan__Type__c='RECURRING' 
                                                            AND loan__Frequency__c='Monthly'];
        System.assertEquals(
            objAPSList.size(), 
            1, 
            'APS Inserted'
        );

        List<Id> apsIdList=new List<Id>();
        apsIdList.add(objAPSList[0].id);
        OneTimeAPSCreation.oneTimeAPSCreationPILoan(apsIdList);
        test.stopTest();
    }
    @isTest
    static void UpdateFirstSecondPmntDateBatchTest(){
        test.startTest();
        List<loan__Loan_Account__c>objContractList = [SELECT Id,
                                            Name,
                                            First_Repayment_Date_After_IR_Change__c,
                                            Second_Repayment_Date_After_IR_Change__c,
                                            New_Interest_Rate_Effective_Date__c,
                                            New_Interest_Rate__c,
                                            Scheduled_Balance_As_at_IR_change_date__c,
                                            loan__Loan_Amount__c
                                            FROM loan__Loan_Account__c];
        if(objContractList.size()>0){
            UpdateFirstSecondPmntDateBatch obj = new UpdateFirstSecondPmntDateBatch();
            String sch = '0 0 22 * * ?';
            system.schedule('Test Check', sch, obj );
        }
        test.stopTest();
    }
    @isTest
    static void UpdateLastDueDayBatchTest(){
        test.startTest();
        
        List<loan__Loan_Account__c>objContractList = [SELECT Id,
                                                         Name,
                                                         loan__Previous_Installment_Date__c
                                                     FROM loan__Loan_Account__c
                                                     ORDER BY Id];
        if(objContractList.size()>0){
            // Inserting Bills
            loan__Loan_account_Due_Details__c objBill = GenericUtilityTestHelper.returnBill(objContractList[0].id);
            System.AssertNotEquals(
                objBill.Id,
                null,
                'Bill inserted successfully.'
            );
            objContractList[0].loan__Previous_Installment_Date__c = NULL;
            update objContractList;
            objContractList = [SELECT Id,
                                      Name,
                                      loan__Previous_Installment_Date__c
                                    FROM loan__Loan_Account__c
                                    WHERE loan__Previous_Installment_Date__c = NULL];
            System.AssertNotEquals(
                objContractList.size(),
                0,
                'Loan updated successfully.'
            );   
            LastDueDateUpdateBatch obj = new LastDueDateUpdateBatch();
            String sch = '0 0 22 * * ?';
            system.schedule('Test Check', sch, obj );
        }
        test.stopTest();
    }
}