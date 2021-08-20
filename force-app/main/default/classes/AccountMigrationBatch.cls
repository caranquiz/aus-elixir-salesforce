/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class update Account Record Type if party Legal Entity type is INDIVIDUAL.
Development Date : 05/06/2021
Last Modified Date : 06/08/2021
****************************************************************************************************/

public class AccountMigrationBatch implements DataBase.StateFul,DataBase.Batchable<sObject>{

    Date startDate = Date.newInstance(Integer.valueOf(Label.Transaction_Start_Date.split('-').get(2)),Integer.valueOf(Label.Transaction_Start_Date.split('-').get(1)),Integer.valueOf(Label.Transaction_Start_Date.split('-').get(0)));
    Date endDate = Date.newInstance(Integer.valueOf(Label.Transaction_End_Date.split('-').get(2)),Integer.valueOf(Label.Transaction_End_Date.split('-').get(1)),Integer.valueOf(Label.Transaction_End_Date.split('-').get(0)));

    //Query Party whose Legal Entity type is INDIVIDUAL and Account and Contact is not Null.
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String queryString='SELECT id,clcommon__Contact__c,clcommon__Account__c';
        for(Schema.FieldSetMember fieldMember : SObjectType.Contact.FieldSets.Contact_to_Person_Account_Utility_Field.getFields()){
            queryString+=',clcommon__Contact__r.'+fieldMember.getFieldPath();
        }
        queryString+=' FROM clcommon__Party__c WHERE clcommon__Account__c!=NULL AND clcommon__Contact__c!=NULL AND Legal_Entity_Type__c=\'Individual\' AND createdDate >=:startDate AND createdDate <=: endDate';
        return Database.getQueryLocator(queryString);
    }
    public void execute(Database.BatchableContext bc, List<clcommon__Party__c> objPartyList) {
        try{
            List<Account> objAccountList=new List<Account>();
            Set<Id> objAccountSet=new Set<Id>();
            List<Contact> objContactList=new List<Contact>();
            String RecTypeId= [SELECT Id 
                                FROM RecordType 
                                WHERE Name='Person Account' 
                                AND SobjectType='Account'].Id;
            
            for(clcommon__Party__c objParty:objPartyList){
                //Account objAccount=new Account(id=objParty.clcommon__Account__c,ParentId=Null);
                //objAccount.RecordTypeID=RecTypeId;
                /*objAccount.Salutation=objParty.clcommon__Contact__r.Salutation;
                objAccount.FirstName=objParty.clcommon__Contact__r.FirstName;
                objAccount.LastName=objParty.clcommon__Contact__r.LastName;
                objAccount.MiddleName=objParty.clcommon__Contact__r.MiddleName;
                objAccount.PersonAssistantName=objParty.clcommon__Contact__r.AssistantName;
                objAccount.PersonAssistantPhone=objParty.clcommon__Contact__r.AssistantPhone;
                objAccount.PersonBirthdate=objParty.clcommon__Contact__r.Birthdate;
                objAccount.PersonDepartment=objParty.clcommon__Contact__r.Department;
                objAccount.PersonDoNotCall=objParty.clcommon__Contact__r.DoNotCall;
                objAccount.PersonEmail=objParty.clcommon__Contact__r.Email;
                objAccount.PersonHasOptedOutOfEmail=objParty.clcommon__Contact__r.HasOptedOutOfEmail;
                objAccount.PersonHasOptedOutOfFax=objParty.clcommon__Contact__r.HasOptedOutOfFax;
                objAccount.PersonHomePhone=objParty.clcommon__Contact__r.HomePhone;
                //objAccount.PersonIndividual=objParty.clcommon__Contact__r.Individual;
                //objAccount.PersonLastCURequestDate=objParty.clcommon__Contact__r.LastCURequestDate;
                //objAccount.PersonLastCUUpdateDate=objParty.clcommon__Contact__r.LastCUUpdateDate;
                objAccount.PersonLeadSource=objParty.clcommon__Contact__r.LeadSource;
                //objAccount.PersonMailingAddress=objParty.clcommon__Contact__r.MailingAddress;
                objAccount.PersonMobilePhone=objParty.clcommon__Contact__r.MobilePhone;
                //objAccount.PersonOtherAddress=objParty.clcommon__Contact__r.OtherAddress;
                objAccount.PersonOtherPhone=objParty.clcommon__Contact__r.OtherPhone;
                objAccount.PersonTitle=objParty.clcommon__Contact__r.Title;
                objAccount.Accredited_Products__pc=objParty.clcommon__Contact__r.Accredited_Products__c;

                objAccount.Address__pc=objParty.clcommon__Contact__r.Address__c;
                objAccount.Ages__pc=objParty.clcommon__Contact__r.Ages__c;
                objAccount.Text__pc=objParty.clcommon__Contact__r.Text__c;
                objAccount.Applicant_reside_in_Australia__pc=objParty.clcommon__Contact__r.Applicant_reside_in_Australia__c;
                objAccount.clcommon__Archived__pc=objParty.clcommon__Contact__r.clcommon__Archived__c;
                objAccount.Australian_Citizen__pc=objParty.clcommon__Contact__r.Australian_Citizen__c;
                objAccount.ints__Bank_Account_Number__pc=objParty.clcommon__Contact__r.ints__Bank_Account_Number__c;
                objAccount.Bankrupt__pc=objParty.clcommon__Contact__r.Bankrupt__c;
                //objAccount.clcommon__Birth_Place__pc=objParty.clcommon__Contact__r.clcommon__Birth_Place__c;
                objAccount.loan__Branch__pc=objParty.clcommon__Contact__r.loan__Branch__c;
                objAccount.Broker_Membership_Type__pc=objParty.clcommon__Contact__r.Broker_Membership_Type__c;
                objAccount.Broker_Status__pc=objParty.clcommon__Contact__r.Broker_Status__c;
                objAccount.Broker_Underwriter__pc=objParty.clcommon__Contact__r.Broker_Underwriter__c;
                objAccount.clcommon__Business_Hours__pc=objParty.clcommon__Contact__r.clcommon__Business_Hours__c;
                objAccount.ints__Coborrower__pc=objParty.clcommon__Contact__r.ints__Coborrower__c;
                objAccount.Company__pc=objParty.clcommon__Contact__r.Company__c;
                objAccount.loan__Contact_Type__pc=objParty.clcommon__Contact__r.loan__Contact_Type__c;
                objAccount.clcommon__Country_of_Citizenship__pc=objParty.clcommon__Contact__r.clcommon__Country_of_Citizenship__c;
                objAccount.clcommon__Country_of_Residence__pc=objParty.clcommon__Contact__r.clcommon__Country_of_Residence__c;
                objAccount.clcommon__Current_City__pc=objParty.clcommon__Contact__r.clcommon__Current_City__c;
                objAccount.clcommon__Current_Country__pc=objParty.clcommon__Contact__r.clcommon__Current_Country__c;
                objAccount.clcommon__Current_State__pc=objParty.clcommon__Contact__r.clcommon__Current_State__c;

                objAccount.clcommon__Current_Street__pc=objParty.clcommon__Contact__r.clcommon__Current_Street__c;
                objAccount.clcommon__Current_Zip_Code__pc=objParty.clcommon__Contact__r.clcommon__Current_Zip_Code__c;
                objAccount.Deceased__pc=objParty.clcommon__Contact__r.Deceased__c;
                objAccount.clcommon__Default_Billing_Group__pc=objParty.clcommon__Contact__r.clcommon__Default_Billing_Group__c;
                objAccount.clcommon__Default_Payment_Spread__pc=objParty.clcommon__Contact__r.clcommon__Default_Payment_Spread__c;
                objAccount.clcommon__Delinquency_Flag__pc=objParty.clcommon__Contact__r.clcommon__Delinquency_Flag__c;
                objAccount.ints__Driver_License__pc=objParty.clcommon__Contact__r.ints__Driver_License__c;
                objAccount.clcommon__Employee__pc=objParty.clcommon__Contact__r.clcommon__Employee__c;
                objAccount.ints__Employer__pc=objParty.clcommon__Contact__r.ints__Employer__c;
                objAccount.Enter_Address_Manually__pc=objParty.clcommon__Contact__r.Enter_Address_Manually__c;
                objAccount.Enter_postal_address_manually__pc=objParty.clcommon__Contact__r.Enter_postal_address_manually__c;
                objAccount.Exit_Strategy_Commentary__pc=objParty.clcommon__Contact__r.Exit_Strategy_Commentary__c;
                objAccount.Exit_Strategy_Provided__pc=objParty.clcommon__Contact__r.Exit_Strategy_Provided__c;
                objAccount.Exit_Strategy_Suitable__pc=objParty.clcommon__Contact__r.Exit_Strategy_Suitable__c;
                objAccount.Gender__pc=objParty.clcommon__Contact__r.Gender__c;
                //objAccount.clcommon__Gender__pc=objParty.clcommon__Contact__r.clcommon__Gender__c;
                objAccount.clcommon__Generate_Invoice_Letter__pc=objParty.clcommon__Contact__r.clcommon__Generate_Invoice_Letter__c;
                objAccount.Has_applied_for_Permanent_Residency_Visa__pc=objParty.clcommon__Contact__r.Has_applied_for_Permanent_Residency_Visa__c;
                objAccount.Housing_Status__pc=objParty.clcommon__Contact__r.Housing_Status__c;
                objAccount.clcommon__Insider_Relationship__pc=objParty.clcommon__Contact__r.clcommon__Insider_Relationship__c;
                objAccount.ints__Is_Lenddo_Verified__pc=objParty.clcommon__Contact__r.ints__Is_Lenddo_Verified__c;
                objAccount.clcommon__Is_Permanent_Resident__pc=objParty.clcommon__Contact__r.clcommon__Is_Permanent_Resident__c;

                objAccount.Is_the_applicant_s_age_less_than_18_yrs__pc=objParty.clcommon__Contact__r.Is_the_applicant_s_age_less_than_18_yrs__c;
                objAccount.Is_this_the_Postal_Address__pc=objParty.clcommon__Contact__r.Is_this_the_Postal_Address__c;
                objAccount.loan__Languages__pc=objParty.clcommon__Contact__r.loan__Languages__c;
                //objAccount.clcommon__Last_4_Digits_of_SSN__pc=objParty.clcommon__Contact__r.clcommon__Last_4_Digits_of_SSN__c;
                objAccount.clcommon__Legal_Entity_Type__pc=objParty.clcommon__Contact__r.clcommon__Legal_Entity_Type__c;
                objAccount.mfiflexUtil__Level__pc=objParty.clcommon__Contact__r.mfiflexUtil__Level__c;
                objAccount.loan__Level__pc=objParty.clcommon__Contact__r.loan__Level__c;
                objAccount.Mailing_Address_Street_No__pc=objParty.clcommon__Contact__r.Mailing_Address_Street_No__c;
                objAccount.Mailing_Address_Street_Type__pc=objParty.clcommon__Contact__r.Mailing_Address_Street_Type__c;
                objAccount.Mailing_Address_Unit_No__pc=objParty.clcommon__Contact__r.Mailing_Address_Unit_No__c;
                objAccount.Main_Business_Contacts__pc=objParty.clcommon__Contact__r.Main_Business_Contacts__c;
                objAccount.clcommon__Marital_Status__pc=objParty.clcommon__Contact__r.clcommon__Marital_Status__c;
                objAccount.clcommon__Master_Archive_Object__pc=objParty.clcommon__Contact__r.clcommon__Master_Archive_Object__c;
                objAccount.Membership_Expiry_Date__pc=objParty.clcommon__Contact__r.Membership_Expiry_Date__c;
                objAccount.Membership_Number__pc=objParty.clcommon__Contact__r.Membership_Number__c;
                objAccount.Membership_Verified__pc=objParty.clcommon__Contact__r.Membership_Verified__c;
                objAccount.ints__Middle_Name__pc=objParty.clcommon__Contact__r.ints__Middle_Name__c;
                objAccount.clcommon__Military_Relationship__pc=objParty.clcommon__Contact__r.clcommon__Military_Relationship__c;
                objAccount.loan__Monthly_Income__pc=objParty.clcommon__Contact__r.loan__Monthly_Income__c;
                objAccount.clcommon__Monthly_Residential_Payment_Amount__pc=objParty.clcommon__Contact__r.clcommon__Monthly_Residential_Payment_Amount__c;
                objAccount.clcommon__Months_at_current_address__pc=objParty.clcommon__Contact__r.clcommon__Months_at_current_address__c;
                objAccount.NCCP_Transaction_Type__pc=objParty.clcommon__Contact__r.NCCP_Transaction_Type__c;
                //objAccount.clcommon__Not_A_Citizen__pc=objParty.clcommon__Contact__r.clcommon__Not_A_Citizen__c;

                objAccount.Number_Of_Dependents__pc=objParty.clcommon__Contact__r.Number_Of_Dependents__c;
                objAccount.Opt_Out_of_Marketing__pc=objParty.clcommon__Contact__r.Opt_Out_of_Marketing__c;
                objAccount.loan__Payment_Mode__pc=objParty.clcommon__Contact__r.loan__Payment_Mode__c;
                objAccount.PEP__pc=objParty.clcommon__Contact__r.PEP__c;
                objAccount.Permanent_Residency_Apply_Date__pc=objParty.clcommon__Contact__r.Permanent_Residency_Apply_Date__c;
                objAccount.Permanent_Residency_Date__pc=objParty.clcommon__Contact__r.Permanent_Residency_Date__c;
                objAccount.clcommon__Personal_Information__pc=objParty.clcommon__Contact__r.clcommon__Personal_Information__c;
                objAccount.Position__pc=objParty.clcommon__Contact__r.Position__c;
                objAccount.Postal_Address__pc=objParty.clcommon__Contact__r.Postal_Address__c;
                objAccount.Preferred_Name__pc=objParty.clcommon__Contact__r.Preferred_Name__c;
                objAccount.Primary_Contact__pc=objParty.clcommon__Contact__r.Primary_Contact__c;
                objAccount.ints__Reference_Token__pc=objParty.clcommon__Contact__r.ints__Reference_Token__c;
                objAccount.Relationship__pc=objParty.clcommon__Contact__r.Relationship__c;
                objAccount.clcommon__Residential_Status__pc=objParty.clcommon__Contact__r.clcommon__Residential_Status__c;
                objAccount.ints__Routing_Number__pc=objParty.clcommon__Contact__r.ints__Routing_Number__c;
                objAccount.clcommon__Mailing_Address_Same_as_Current_Address__pc=objParty.clcommon__Contact__r.clcommon__Mailing_Address_Same_as_Current_Address__c;
                objAccount.clcommon__Service_Member_Military_Status__pc=objParty.clcommon__Contact__r.clcommon__Service_Member_Military_Status__c;
                objAccount.SMS_Opt_Out__pc=objParty.clcommon__Contact__r.SMS_Opt_Out__c;
                objAccount.ints__Social_Security_Number__pc=objParty.clcommon__Contact__r.ints__Social_Security_Number__c;
                objAccount.genesis__SSN__pc=objParty.clcommon__Contact__r.genesis__SSN__c;
                objAccount.ints__SSN__pc=objParty.clcommon__Contact__r.ints__SSN__c;
                objAccount.clcommon__Summary__pc=objParty.clcommon__Contact__r.clcommon__Summary__c;
                objAccount.clcommon__Summary_Record_Id__pc=objParty.clcommon__Contact__r.clcommon__Summary_Record_Id__c;

                
                objAccount.loan__Tax_Id__pc=objParty.clcommon__Contact__r.loan__Tax_Id__c;
                objAccount.Temporary_Visa_Expiry_Date__pc=objParty.clcommon__Contact__r.Temporary_Visa_Expiry_Date__c;
                objAccount.Temporary_Visa_Suitability__pc=objParty.clcommon__Contact__r.Temporary_Visa_Suitability__c;
                objAccount.Temporary_Visa_Suitability_Commentary__pc=objParty.clcommon__Contact__r.Temporary_Visa_Suitability_Commentary__c;
                objAccount.ints__University__pc=objParty.clcommon__Contact__r.ints__University__c;
                objAccount.Visa_Subclass_Code__pc=objParty.clcommon__Contact__r.Visa_Subclass_Code__c;
                objAccount.clcommon__Years_At_Current_Address__pc=objParty.clcommon__Contact__r.clcommon__Years_At_Current_Address__c;
                */
                objAccountSet.add(objParty.clcommon__Account__c);
            }
            objAccountList=[SELECT id,RecordTypeID FROM Account WHERE id=:objAccountSet AND ParentId=Null];
            for(Account account:objAccountList){
                account.RecordTypeID=RecTypeId;
            }
            if(objAccountList.size()>0){
                update objAccountList;
            }
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'AccountMigrationBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
    public void finish(Database.BatchableContext bc){
    }
}