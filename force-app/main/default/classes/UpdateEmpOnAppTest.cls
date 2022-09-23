/****************************************************************************************************
Company              : Cloudkaptan Consultancy Services Pvt. Ltd. 
Class Name           : UpdateEmploymentTypeOnApplication 
Created Date         : 13/07/2022 
Developed By         : Sayak Mukhopadhyay 
Description          : This is Test class of UpdateEmploymentTypeOnApplication,UpdateEmpTypeBatch,
                        UpdateTotalIncomesOnParty
****************************************************************************************************/
@isTest(SeeAllData = false)
public class UpdateEmpOnAppTest {
    @TestSetup
    static void initialize(){
        //Inserting Individual Legal Entity
        clcommon__Legal_Entity__c objLegEntity = GenericUtilityTestHelper.returnLegalEntity();
        System.AssertNotEquals(
            objLegEntity.Id,
            null,
            'Legal Entity inserted successfully.'
        );
        //Inserting Joint Legal Entity
        clcommon__Legal_Entity__c objJointLegEntity = GenericUtilityTestHelper.returnJointLegalEntity();
        System.AssertNotEquals(
            objJointLegEntity.Id,
            null,
            'Legal Entity inserted successfully.'
        );
        // Inserting Borrower Party Type
        clcommon__Party_Type__c objBorrowerPartyType = GenericUtilityTestHelper.returnBorrowerPartyType();
        System.AssertNotEquals(
            objBorrowerPartyType.Id,
            null,
            'Party Type inserted successfully.'
        );
        // Inserting Borrower Party Type
        clcommon__Party_Type__c objHouseholdPartyType = GenericUtilityTestHelper.returnHouseholdPartyType();
        System.AssertNotEquals(
            objHouseholdPartyType.Id,
            null,
            'Party Type inserted successfully.'
        );
        // Inserting Account for Individual
        Account objAccount = GenericUtilityTestHelper.insertDummyAccount();
        objAccount.clcommon__Legal_Entity_Type__c = objLegEntity.id; // Individual
        update objAccount;
        System.AssertNotEquals(
            objAccount.Id,
            null,
            'Account inserted successfully.'
        );
        // Inserting Account For Household 
        Account objHouseholdAccount = GenericUtilityTestHelper.insertDummyAccount();
        objHouseholdAccount.clcommon__Legal_Entity_Type__c = objJointLegEntity.id;
        objHouseholdAccount.Name = 'Elixir & Financial';
        update objHouseholdAccount;
        System.AssertNotEquals(
            objHouseholdAccount.Id,
            null,
            'Account inserted successfully.'
        );
        // Inserting Application
        genesis__applications__c objApplication = GenericUtilityTestHelper.returnApplication(objAccount.id);
        objApplication.Total_Self_Employed_Income__c = 0;
        objApplication.Total_Self_Employed_Full_Doc_Income__c = 0;
        objApplication.Months_Self_Employed__c = 0;
        update objApplication;
        System.AssertNotEquals(
            objApplication.Id,
            null,
            'Application inserted successfully.'
        );
        // Inserting Individual Party 
        clcommon__Party__c objParty = GenericUtilityTestHelper.returnParty(objApplication.id,objAccount.id);
        //objParty.clcommon__Type__c = 'a2V2N000000IHVk'; // Borrower
        objParty.clcommon__Type__c = objBorrowerPartyType.id; // Borrower
        update objParty;
        System.AssertNotEquals(
            objParty.Id,
            null,
            'Party inserted successfully.'
        );
        // Inserting Household Party 
        clcommon__Party__c objHouseholdParty = GenericUtilityTestHelper.returnParty(objApplication.id,objHouseholdAccount.id);
        //objHouseholdParty.clcommon__Type__c = 'a2V2N000000IHWU'; // Household
        objHouseholdParty.clcommon__Type__c = objHouseholdPartyType.id;
        //objHouseholdParty.Diff_Of_Asset_and_Liability__c = 500;
        update objHouseholdParty;
        System.AssertNotEquals(
            objHouseholdParty.Id,
            null,
            'Party inserted successfully.'
        );
        // Inserting Employment Information
        genesis__Employment_Information__c objEmpInfo = GenericUtilityTestHelper.returnEmploymentInformation(objApplication.id);
        objEmpInfo.Override_Amount__c = '10';
        objEmpInfo.Months_Self_Employed__c = 0;
        objEmpInfo.Document_Type__c = 'Full';
        objEmpInfo.Party__c = objParty.id;
        objEmpInfo.Total_Current_Income_Period__c = 200;
        update objEmpInfo;
        System.AssertNotEquals(
            objEmpInfo.Id,
            null,
            'Employment Information inserted successfully.'
        );
        // Inserting Income
        genesis__Income__c objIncome = GenericUtilityTestHelper.returnEmploymentInformation(objApplication.id,objEmpInfo.id);
        objIncome.genesis__Amount__c = 0;
        objIncome.Document_Type__c = ConstantValues.ALT;
        objIncome.Party__c = objParty.id;
        update objIncome;
        System.AssertNotEquals(
            objIncome.Id,
            null,
            'Income inserted successfully.'
        );
        // Inserting Liability
        genesis__Liability__c objLiability = GenericUtilityTestHelper.returnLiability(objApplication.id);
        objLiability.genesis__Original_Amount__c = 200;
        update objLiability;
        System.AssertNotEquals(
            objLiability.Id,
            null,
            'Liability inserted successfully.'
        );
        // Inserting Asset
        genesis__Asset_Information__c objAssetInfo = GenericUtilityTestHelper.returnAssetInformation(objApplication.id);
        objAssetInfo.genesis__Market_Value__c = 300;
        update objAssetInfo;
        System.AssertNotEquals(
            objAssetInfo.Id,
            null,
            'Liability inserted successfully.'
        );
    }
    @isTest
    static void UpdateEmpTestMethodOne(){
        test.startTest();
        List<genesis__applications__c> objApplicationList = [SELECT id
                                                                FROM genesis__applications__c];
        List<genesis__Employment_Information__c> objEmpInfoList = [SELECT id,Party__c,Party__r.Party_Type_Name__c,Party__r.Legal_Entity_Type__c,Document_Type__c FROM genesis__Employment_Information__c WHERE genesis__Application__c in :objApplicationList];                                                       
        UpdateEmploymentTypeOnApplication.updateEmploymentTypeWS(objApplicationList[0].id);
    }
    @isTest
    static void UpdateEmpTestMethodTwo(){
        test.startTest();
        List<genesis__Employment_Information__c> objEmpInfoList = [SELECT id,Document_Type__c,Override_Amount__c,Income_for_servicing_purposes__c FROM genesis__Employment_Information__c];
        if(objEmpInfoList.size()>0){
            objEmpInfoList[0].Document_Type__c = ConstantValues.ALT;
            objEmpInfoList[0].Override_Amount__c = null;
            objEmpInfoList[0].Total_Current_Income_Period__c = 10;
            objEmpInfoList[0].Total_Previous_Income_Period__c = 9;
            update objEmpInfoList[0];
        }
        List<genesis__applications__c> objApplicationList = [SELECT id
                                                                FROM genesis__applications__c];                                                       
        if(objApplicationList.size()>0){
            List <clcommon__Party__c> partyList = [Select Id from clcommon__Party__c where genesis__Application__c =: objApplicationList[0].Id];
            System.assert(partyList.size() > 0, 'Party found successfully!');
            List <genesis__Income__c> incomeList = [SELECT id,
                                                        genesis__Amount__c,
                                                        genesis__Application__r.id,
                                                        genesis__Frequency__c
                                                        FROM genesis__Income__c
                                                        WHERE genesis__Application__c =: objApplicationList[0].Id];
            System.assertEquals(incomeList.size() > 0, true, 'Incomes inserted successfully!');  
            incomeList[0].PAYG_Income__c = true;
            incomeList[0].genesis__Frequency__c = ConstantValues.weekly;
            incomeList[0].genesis__Amount__c = 100;
            update incomeList;
            incomeList = [SELECT id,
                              genesis__Amount__c,
                              genesis__Application__r.id,
                              genesis__Frequency__c
                          FROM genesis__Income__c
                          WHERE genesis__Application__c =: objApplicationList[0].Id
                          AND PAYG_Income__c = TRUE];
            System.assertEquals(incomeList.size() > 0, true, 'Incomes updated successfully!');                                           
            UpdateEmploymentTypeOnApplication.updateEmploymentTypeWS(objApplicationList[0].id);
            UpdateTotalIncomesOnParty.updateIncomesWS(partyList[0].Id);
            UpdateEmpTypeBatch obj = new UpdateEmpTypeBatch(); 
            database.executebatch(obj,1);
        }
    }
    @isTest
    static void UpdateEmpTestMethodThree(){
        test.startTest();
        List<genesis__Employment_Information__c> objEmpInfoList = [SELECT id,Document_Type__c,Override_Amount__c,Income_for_servicing_purposes__c FROM genesis__Employment_Information__c];
        if(objEmpInfoList.size()>0){
            objEmpInfoList[0].Document_Type__c = 'Alt';
            objEmpInfoList[0].Override_Amount__c = null;
            objEmpInfoList[0].Total_Current_Income_Period__c = 10;
            objEmpInfoList[0].Total_Previous_Income_Period__c = 9;
            update objEmpInfoList[0];
        }
        List<genesis__applications__c> objApplicationList = [SELECT id
                                                                FROM genesis__applications__c];                                                       
        if(objApplicationList.size()>0){
            List <clcommon__Party__c> partyList = [Select Id from clcommon__Party__c where genesis__Application__c =: objApplicationList[0].Id];
            System.assert(partyList.size() > 0, 'Party found successfully!');
            List <genesis__Income__c> incomeList = [SELECT id,
                                                        genesis__Amount__c,
                                                        genesis__Application__r.id,
                                                        genesis__Frequency__c
                                                        FROM genesis__Income__c
                                                        WHERE genesis__Application__c =: objApplicationList[0].Id];
            System.assertEquals(incomeList.size() > 0, true, 'Incomes inserted successfully!');  
            incomeList[0].PAYG_Income__c = true;
            incomeList[0].genesis__Frequency__c = ConstantValues.FORTNIGHTLY;
            incomeList[0].genesis__Amount__c = 100;
            update incomeList;
            UpdateEmploymentTypeOnApplication.updateEmploymentTypeWS(objApplicationList[0].id);
            incomeList = [SELECT id,
                              genesis__Amount__c,
                              genesis__Application__r.id,
                              genesis__Frequency__c
                          FROM genesis__Income__c
                          WHERE genesis__Application__c =: objApplicationList[0].Id
                          AND PAYG_Income__c = TRUE];
            System.assertEquals(incomeList.size() > 0, true, 'Incomes updated successfully!');                                           
            UpdateEmpTypeBatch obj = new UpdateEmpTypeBatch(); 
            database.executebatch(obj,1);
        }
    }
    @isTest
    static void UpdateEmpTestMethodFour(){
        test.startTest();
        List<genesis__Employment_Information__c> objEmpInfoList = [SELECT id,Document_Type__c,Override_Amount__c,Income_for_servicing_purposes__c FROM genesis__Employment_Information__c];
        if(objEmpInfoList.size()>0){
            objEmpInfoList[0].Document_Type__c = 'Alt';
            objEmpInfoList[0].Override_Amount__c = null;
            objEmpInfoList[0].Total_Current_Income_Period__c = 10;
            objEmpInfoList[0].Total_Previous_Income_Period__c = 9;
            update objEmpInfoList[0];
        }
        List<genesis__applications__c> objApplicationList = [SELECT id
                                                                FROM genesis__applications__c];                                                       
        if(objApplicationList.size()>0){
            List <clcommon__Party__c> partyList = [Select Id from clcommon__Party__c where genesis__Application__c =: objApplicationList[0].Id];
            System.assert(partyList.size() > 0, 'Party found successfully!');
            List <genesis__Income__c> incomeList = [SELECT id,
                                                        genesis__Amount__c,
                                                        genesis__Application__r.id,
                                                        genesis__Frequency__c
                                                        FROM genesis__Income__c
                                                        WHERE genesis__Application__c =: objApplicationList[0].Id];
            System.assertEquals(incomeList.size() > 0, true, 'Incomes inserted successfully!');  
            incomeList[0].PAYG_Income__c = true;
            incomeList[0].genesis__Frequency__c = ConstantValues.YEARLY;
            incomeList[0].genesis__Amount__c = 100;
            update incomeList;
            incomeList = [SELECT id,
                              genesis__Amount__c,
                              genesis__Application__r.id,
                              genesis__Frequency__c
                          FROM genesis__Income__c
                          WHERE genesis__Application__c =: objApplicationList[0].Id
                          AND PAYG_Income__c = TRUE];
            System.assertEquals(incomeList.size() > 0, true, 'Incomes updated successfully!');                                           
            UpdateEmploymentTypeOnApplication.updateEmploymentTypeWS(objApplicationList[0].id);
            UpdateEmpTypeBatch obj = new UpdateEmpTypeBatch(); 
            database.executebatch(obj,1);
        }
    }
    @isTest
    static void UpdateEmpTestMethodFive(){
        test.startTest();
        List<genesis__Employment_Information__c> objEmpInfoList = [SELECT id,Document_Type__c,Override_Amount__c,Income_for_servicing_purposes__c FROM genesis__Employment_Information__c];
        if(objEmpInfoList.size()>0){
            objEmpInfoList[0].Document_Type__c = 'Alt';
            objEmpInfoList[0].Override_Amount__c = null;
            objEmpInfoList[0].Total_Current_Income_Period__c = 10;
            objEmpInfoList[0].Total_Previous_Income_Period__c = 9;
            update objEmpInfoList[0];
        }
        List<genesis__applications__c> objApplicationList = [SELECT id
                                                                FROM genesis__applications__c];                                                       
        if(objApplicationList.size()>0){
            List <clcommon__Party__c> partyList = [Select Id from clcommon__Party__c where genesis__Application__c =: objApplicationList[0].Id];
            System.assert(partyList.size() > 0, 'Party found successfully!');
            List <genesis__Income__c> incomeList = [SELECT id,
                                                        genesis__Amount__c,
                                                        genesis__Application__r.id,
                                                        genesis__Frequency__c
                                                        FROM genesis__Income__c
                                                        WHERE genesis__Application__c =: objApplicationList[0].Id];
            System.assertEquals(incomeList.size() > 0, true, 'Incomes inserted successfully!');  
            incomeList[0].PAYG_Income__c = true;
            incomeList[0].genesis__Frequency__c = ConstantValues.monthly;
            incomeList[0].genesis__Amount__c = 100;
            update incomeList;
            incomeList = [SELECT id,
                              genesis__Amount__c,
                              genesis__Application__r.id,
                              genesis__Frequency__c
                          FROM genesis__Income__c
                          WHERE genesis__Application__c =: objApplicationList[0].Id
                          AND PAYG_Income__c = TRUE];
            UpdateEmploymentTypeOnApplication.updateEmploymentTypeWS(objApplicationList[0].id);
            System.assertEquals(incomeList.size() > 0, true, 'Incomes updated successfully!');                                           
            UpdateEmpTypeBatch obj = new UpdateEmpTypeBatch(); 
            database.executebatch(obj,1);
        }
    }
    @isTest
    static void UpdateEmpTestMethodSix(){
        test.startTest();
        List<genesis__Employment_Information__c> objEmpInfoList = [SELECT id,Document_Type__c,Override_Amount__c,Income_for_servicing_purposes__c FROM genesis__Employment_Information__c];
        if(objEmpInfoList.size()>0){
            objEmpInfoList[0].Document_Type__c = 'Alt';
            objEmpInfoList[0].Override_Amount__c = null;
            objEmpInfoList[0].Total_Current_Income_Period__c = 10;
            objEmpInfoList[0].Total_Previous_Income_Period__c = 9;
            update objEmpInfoList[0];
        }
        List<genesis__applications__c> objApplicationList = [SELECT id
                                                                FROM genesis__applications__c];                                                       
        if(objApplicationList.size()>0){
            List <clcommon__Party__c> partyList = [Select Id from clcommon__Party__c where genesis__Application__c =: objApplicationList[0].Id];
            System.assert(partyList.size() > 0, 'Party found successfully!');
            List <genesis__Income__c> incomeList = [SELECT id,
                                                        genesis__Amount__c,
                                                        Unemployed_Income__c,
                                                        genesis__Application__r.id,
                                                        genesis__Frequency__c
                                                        FROM genesis__Income__c
                                                        WHERE genesis__Application__c =: objApplicationList[0].Id];
            System.assertEquals(incomeList.size() > 0, true, 'Incomes inserted successfully!');  
            incomeList[0].Employment_Information__c = null;
            incomeList[0].Unemployed_Income__c = true;
            incomeList[0].genesis__Frequency__c = ConstantValues.monthly;
            incomeList[0].genesis__Amount__c = 100;
            update incomeList;
            incomeList = [SELECT id,
                              genesis__Amount__c,
                              genesis__Application__r.id,
                              genesis__Frequency__c
                          FROM genesis__Income__c
                          WHERE genesis__Application__c =: objApplicationList[0].Id
                          AND Unemployed_Income__c = TRUE];
            System.assertEquals(incomeList.size() > 0, true, 'Incomes updated successfully!');                                           
            UpdateTotalIncomesOnParty.updateIncomesWS(partyList[0].Id);
            CustomerCallBatch obj = new CustomerCallBatch(); 
            database.executebatch(obj,1);
        }
    }
    @isTest
    static void UpdateEmpTestMethodSeven(){
        test.startTest();
        List<genesis__Employment_Information__c> objEmpInfoList = [SELECT id,Document_Type__c,Override_Amount__c,Income_for_servicing_purposes__c FROM genesis__Employment_Information__c];
        if(objEmpInfoList.size()>0){
            objEmpInfoList[0].Document_Type__c = 'Alt';
            objEmpInfoList[0].Override_Amount__c = null;
            objEmpInfoList[0].Total_Current_Income_Period__c = 10;
            objEmpInfoList[0].Total_Previous_Income_Period__c = 9;
            update objEmpInfoList[0];
        }
        List<genesis__applications__c> objApplicationList = [SELECT id
                                                                FROM genesis__applications__c];                                                       
        if(objApplicationList.size()>0){
            List <clcommon__Party__c> partyList = [Select Id from clcommon__Party__c where genesis__Application__c =: objApplicationList[0].Id];
            System.assert(partyList.size() > 0, 'Party found successfully!');
            List <genesis__Income__c> incomeList = [SELECT id,
                                                        genesis__Amount__c,
                                                        Other_Income__c,
                                                        genesis__Application__r.id,
                                                        genesis__Frequency__c
                                                        FROM genesis__Income__c
                                                        WHERE genesis__Application__c =: objApplicationList[0].Id];
            System.assertEquals(incomeList.size() > 0, true, 'Incomes inserted successfully!');  
            incomeList[0].Employment_Information__c = null;
            incomeList[0].Other_Income__c = true;
            incomeList[0].genesis__Frequency__c = ConstantValues.monthly;
            incomeList[0].genesis__Amount__c = 100;
            update incomeList;
            incomeList = [SELECT id,
                              genesis__Amount__c,
                              genesis__Application__r.id,
                              genesis__Frequency__c
                          FROM genesis__Income__c
                          WHERE genesis__Application__c =: objApplicationList[0].Id
                          AND Other_Income__c = TRUE];
            System.assertEquals(incomeList.size() > 0, true, 'Incomes updated successfully!');                                           
            UpdateTotalIncomesOnParty.updateIncomesWS(partyList[0].Id);
            CustomerCallBatch obj = new CustomerCallBatch(); 
            database.executebatch(obj,1);
        }
    }
    @isTest
    static void UpdateEmpTestMethodEight(){
        test.startTest();
        List<genesis__applications__c> objApplicationList = [SELECT id
                                                                FROM genesis__applications__c];                                                       
        if(objApplicationList.size()>0){
            CustomerCallBatch obj = new CustomerCallBatch(); 
            database.executebatch(obj,1);
        }
    }
}