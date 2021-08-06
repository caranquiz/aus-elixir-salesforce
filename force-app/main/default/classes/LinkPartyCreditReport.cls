/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class pull the credit Report from selected party and 
            insert the credit Report in another party.
Development Date : 30/06/2021
Last Modified Date : 06/07/2021
****************************************************************************************************/

global with sharing class LinkPartyCreditReport {
    //Method used for inserting the Credit Report in party
    Webservice static String linkCreditReport(Id partyId,Id partyId2){
        try{
            Map<String, Payment_Default__c> accountIdDefaultMap = new Map<String, Payment_Default__c>();
            Map<String, Id> accountIdIdMap = new Map<String, Id>();
            clcommon__Party__c party=new clcommon__Party__c();
            List <clcommon__Party__c> partyList = [SELECT Id,
                                                        ABN_Company_Name__c,
                                                        Request_Id__c,
                                                        Report_Created_Date__c,
                                                        File_Number__c,
                                                        Permission_Type__c,
                                                        Age_of_Credit_File__c,
                                                        ASIC_Extract_Date__c,
                                                        Organization_Status__c,
                                                        Incorporation_Date__c,
                                                        Registered_Office__c,
                                                        File_create_date__c,
                                                        Explanation_of_Age_of_Credit_File_Suitab__c,
                                                        Explanation_of_Age_of_Credit_File_Commen__c,
                                                        Credit_Score__c,
                                                        External_Administrators__c,
                                                        Possibly_Matched_data__c,
                                                        Confirm_Possible_Match_Credit_Report_Run__c,
                                                        Adverse_on_file__c,
                                                        Consumer_Adverse_on_file__c,
                                                        Individual_Address__c,
                                                        Employer__c,
                                                        Linked_Application_Search__c,
                                                        genesis__Application__r.Legal_Entity__c,
                                                        Number_of_Credit_Enquiries_in_Last_12_Mo__c,
                                                        Explanation_of_Credit_Enquiries_Suitable__c,
                                                        Explanation_of_Credit_Enquiries_Commenta__c,
                                                        Applicant_ever_declared_banckrupt__c,
                                                        Bankrupt_Date__c,
                                                        bankrupt_discharged__c,
                                                        Previously_Bankrupt_Discharge_Date__c,
                                                        Explanation_of_Bankruptcy_Received__c,
                                                        Explanation_of_Bankruptcy_Suitable__c,
                                                        Explanation_of_Bankruptcy_Commentary__c,
                                                        Company_Director_s_Adverse__c,
                                                        Company_Director_s_Related_Entity_Advers__c,
                                                        Court_Writs__c,
                                                        Court_Writ_Amount__c,
                                                        Court_Actions__c,
                                                        Court_Action_Amount__c,
                                                        Petitions__c,
                                                        Ignore__c,
                                                        Credit_Event__c,
                                                        Explanation_Provided__c,
                                                        Number_Of_Credit_Events__c,
                                                        Credit_Status__c,
                                                        Explanation_of_Credit_Events_Suitable__c,
                                                        Explanation_of_Credit_Events_Commentary__c,
                                                        Risk_Grade__c,
                                                        Date_of_Most_Recent_Credit_Event__c,
                                                        ABN_Status_Explanation_Provided__c,
                                                        ABN_Status_Explanation_Suitable__c,
                                                        ABN_Status_Commentary__c,
                                                        Loan_Assesment_Commentary_Credit_History__c,
                                                        genesis__Application__c
                                                    FROM clcommon__Party__c
                                                    WHERE id = : partyId];
        
            if(partyId2!=NULL){
                party=[SELECT Id,
                            Request_Id__c,
                            Report_Created_Date__c,
                            File_Number__c,
                            Permission_Type__c,
                            Age_of_Credit_File__c,
                            ASIC_Extract_Date__c,
                            clcommon__Account__c,
                            clcommon__Account__r.Name,
                            Organization_Status__c,
                            Incorporation_Date__c,
                            Registered_Office__c,
                            File_create_date__c,
                            Explanation_of_Age_of_Credit_File_Suitab__c,
                            Explanation_of_Age_of_Credit_File_Commen__c,
                            Credit_Score__c,
                            External_Administrators__c,
                            Possibly_Matched_data__c,
                            Confirm_Possible_Match_Credit_Report_Run__c,
                            Adverse_on_file__c,
                            Consumer_Adverse_on_file__c,
                            Individual_Address__c,
                            Employer__c,
                            Linked_Application_Search__c,
                            genesis__Application__r.Legal_Entity__c,
                            Number_of_Credit_Enquiries_in_Last_12_Mo__c,
                            Explanation_of_Credit_Enquiries_Suitable__c,
                            Explanation_of_Credit_Enquiries_Commenta__c,
                            Applicant_ever_declared_banckrupt__c,
                            Bankrupt_Date__c,
                            bankrupt_discharged__c,
                            Previously_Bankrupt_Discharge_Date__c,
                            Explanation_of_Bankruptcy_Received__c,
                            Explanation_of_Bankruptcy_Suitable__c,
                            Explanation_of_Bankruptcy_Commentary__c,
                            Company_Director_s_Adverse__c,
                            Company_Director_s_Related_Entity_Advers__c,
                            Court_Writs__c,
                            Court_Writ_Amount__c,
                            Court_Actions__c,
                            Court_Action_Amount__c,
                            Petitions__c,
                            Ignore__c,
                            Credit_Event__c,
                            Explanation_Provided__c,
                            Number_Of_Credit_Events__c,
                            Credit_Status__c,
                            Explanation_of_Credit_Events_Suitable__c,
                            Explanation_of_Credit_Events_Commentary__c,
                            Risk_Grade__c,
                            Date_of_Most_Recent_Credit_Event__c,
                            ABN_Status_Explanation_Provided__c,
                            ABN_Status_Explanation_Suitable__c,
                            ABN_Status_Commentary__c,
                            Loan_Assesment_Commentary_Credit_History__c,
                            genesis__Application__c
                        FROM clcommon__Party__c
                        WHERE id = : partyId2];
                if(party!=NULL && partyList.size()>0){

                    partyList[0].Request_Id__c=party.Request_Id__c;
                    partyList[0].Report_Created_Date__c=party.Report_Created_Date__c;
                    partyList[0].File_Number__c=party.File_Number__c;
                    partyList[0].Permission_Type__c=party.Permission_Type__c;
                    partyList[0].Age_of_Credit_File__c=party.Age_of_Credit_File__c;
                    partyList[0].ASIC_Extract_Date__c=party.ASIC_Extract_Date__c;
                    partyList[0].Organization_Status__c=party.Organization_Status__c;
                    partyList[0].Incorporation_Date__c=party.Incorporation_Date__c;
                    partyList[0].Registered_Office__c=party.Registered_Office__c;
                    partyList[0].File_create_date__c=party.File_create_date__c;
                    partyList[0].Explanation_of_Age_of_Credit_File_Suitab__c=party.Explanation_of_Age_of_Credit_File_Suitab__c;
                    partyList[0].Explanation_of_Age_of_Credit_File_Commen__c=party.Explanation_of_Age_of_Credit_File_Commen__c;
                    partyList[0].Credit_Score__c=party.Credit_Score__c;
                    partyList[0].External_Administrators__c=party.External_Administrators__c;
                    partyList[0].Possibly_Matched_data__c=party.Possibly_Matched_data__c;
                    partyList[0].Confirm_Possible_Match_Credit_Report_Run__c=party.Confirm_Possible_Match_Credit_Report_Run__c;
                    partyList[0].Adverse_on_file__c=party.Adverse_on_file__c;
                    partyList[0].Consumer_Adverse_on_file__c=party.Consumer_Adverse_on_file__c;
                    partyList[0].Employer__c=party.Employer__c;
                    partyList[0].Individual_Address__c=party.Individual_Address__c;
                    partyList[0].Number_of_Credit_Enquiries_in_Last_12_Mo__c=party.Number_of_Credit_Enquiries_in_Last_12_Mo__c;
                    partyList[0].Explanation_of_Credit_Enquiries_Suitable__c=party.Explanation_of_Credit_Enquiries_Suitable__c;
                    partyList[0].Explanation_of_Credit_Enquiries_Commenta__c=party.Explanation_of_Credit_Enquiries_Commenta__c;
                    partyList[0].Applicant_ever_declared_banckrupt__c=party.Applicant_ever_declared_banckrupt__c;
                    partyList[0].Bankrupt_Date__c=party.Bankrupt_Date__c;
                    partyList[0].bankrupt_discharged__c=party.bankrupt_discharged__c;
                    partyList[0].Previously_Bankrupt_Discharge_Date__c=party.Previously_Bankrupt_Discharge_Date__c;
                    partyList[0].Explanation_of_Bankruptcy_Received__c=party.Explanation_of_Bankruptcy_Received__c;
                    partyList[0].Explanation_of_Bankruptcy_Suitable__c=party.Explanation_of_Bankruptcy_Suitable__c;
                    partyList[0].Explanation_of_Bankruptcy_Commentary__c=party.Explanation_of_Bankruptcy_Commentary__c;
                    partyList[0].Company_Director_s_Adverse__c=party.Company_Director_s_Adverse__c;
                    partyList[0].Company_Director_s_Related_Entity_Advers__c=party.Company_Director_s_Related_Entity_Advers__c;
                    partyList[0].Court_Writs__c=party.Court_Writs__c;
                    partyList[0].Court_Writ_Amount__c=party.Court_Writ_Amount__c;
                    partyList[0].Court_Actions__c=party.Court_Actions__c;
                    partyList[0].Court_Action_Amount__c=party.Court_Action_Amount__c;
                    partyList[0].Petitions__c=party.Petitions__c;
                    partyList[0].Ignore__c=party.Ignore__c;
                    partyList[0].Credit_Event__c=party.Credit_Event__c;
                    partyList[0].Explanation_Provided__c=party.Explanation_Provided__c;
                    partyList[0].Number_Of_Credit_Events__c=party.Number_Of_Credit_Events__c;
                    partyList[0].Credit_Status__c=party.Credit_Status__c;
                    partyList[0].Explanation_of_Credit_Events_Suitable__c=party.Explanation_of_Credit_Events_Suitable__c;
                    partyList[0].Explanation_of_Credit_Events_Commentary__c=party.Explanation_of_Credit_Events_Commentary__c;
                    partyList[0].Risk_Grade__c=party.Risk_Grade__c;
                    partyList[0].Date_of_Most_Recent_Credit_Event__c=party.Date_of_Most_Recent_Credit_Event__c;
                    partyList[0].ABN_Status_Explanation_Provided__c=party.ABN_Status_Explanation_Provided__c;
                    partyList[0].ABN_Status_Explanation_Suitable__c=party.ABN_Status_Explanation_Suitable__c;
                    partyList[0].ABN_Status_Commentary__c=party.ABN_Status_Commentary__c;
                    partyList[0].Loan_Assesment_Commentary_Credit_History__c=party.Loan_Assesment_Commentary_Credit_History__c;
                }
            }
            if(partyId2!=NULL && partyId!=NULL){
                List<Credit_Enquiry__c> creditEnquiryList1=[SELECT id,
                                                                  Party__c,
                                                                  Account_Type__c,
                                                                  Credit_Enquirer__c,
                                                                  Credit_Enquiry_Type__c,
                                                                  Enquiry_amount__c,
                                                                  Enquiry_Date__c,
                                                                  Reference_No__c,
                                                                  Role_in_Enquiry__c
                                                            FROM Credit_Enquiry__c 
                                                            WHERE Party__c=:partyId2];
                List<Credit_Enquiry__c> deletecreditEnquiryList=[SELECT id FROM Credit_Enquiry__c WHERE Party__c=:partyId];
                if(deletecreditEnquiryList.size()>0){
                    Database.delete(deletecreditEnquiryList,false);
                }
                List<Credit_Enquiry__c> creditEnquiryList=new List<Credit_Enquiry__c>();
                for(Credit_Enquiry__c creditEnquiry1:creditEnquiryList1){
                    Credit_Enquiry__c creditEnquiry=new Credit_Enquiry__c();
                    creditEnquiry.Party__c=partyId;
                    creditEnquiry.Account_Type__c=creditEnquiry1.Account_Type__c;
                    creditEnquiry.Credit_Enquirer__c=creditEnquiry1.Credit_Enquirer__c;
                    creditEnquiry.Credit_Enquiry_Type__c=creditEnquiry1.Credit_Enquiry_Type__c;
                    creditEnquiry.Enquiry_amount__c=creditEnquiry1.Enquiry_amount__c;
                    creditEnquiry.Enquiry_Date__c=creditEnquiry1.Enquiry_Date__c;
                    creditEnquiry.Reference_No__c=creditEnquiry1.Reference_No__c;
                    creditEnquiry.Role_in_Enquiry__c=creditEnquiry1.Role_in_Enquiry__c;
                    creditEnquiryList.add(creditEnquiry);
                }
                if(creditEnquiryList.size()>0){
                    Database.insert(creditEnquiryList,false);
                }
            }

            if(partyId2!=NULL && partyId!=NULL){
                List<Director__c> directorList1=[SELECT id,
                                                        Party__c,
                                                        Address__c,
                                                        Beneficially_Held__c,
                                                        Class_of_shares__c,
                                                        Collateral__c,
                                                        Date_of_birth__c,
                                                        Entity_Name__c,
                                                        Entity_Type__c,
                                                        File_Number__c,
                                                        Found_in_Party__c,
                                                        Gender__c,
                                                        Jointly_Held__c,
                                                        Migration__c,
                                                        Number_of_shares_issued__c,
                                                        Registration_Number__c,
                                                        Resident_Overseas__c,
                                                        Pmsi__c,
                                                        Secured_Parties__c,
                                                        Start_Date__c
                                                    FROM Director__c
                                                    WHERE Party__c=:partyId2];
                List<Director__c> deleteDirectorList=[SELECT id FROM Director__c WHERE Party__c=:partyId];
                if(deleteDirectorList.size()>0){
                    Database.delete(deleteDirectorList,false);
                }
                List<Director__c> directorList=new List<Director__c>();
                for(Director__c director1:directorList1){
                    Director__c director=new Director__c();
                    director.Party__c=partyId;
                    director.Address__c=director1.Address__c;
                    director.Beneficially_Held__c=director1.Beneficially_Held__c;
                    director.Class_of_shares__c=director1.Class_of_shares__c;
                    director.Collateral__c=director1.Collateral__c;
                    director.Date_of_birth__c=director1.Date_of_birth__c;
                    director.Entity_Name__c=director1.Entity_Name__c;
                    director.Entity_Type__c=director1.Entity_Type__c;
                    director.File_Number__c=director1.File_Number__c;
                    director.Found_in_Party__c=director1.Found_in_Party__c;
                    director.Gender__c=director1.Gender__c;
                    director.Jointly_Held__c=director1.Jointly_Held__c;
                    director.Migration__c=director1.Migration__c;
                    director.Number_of_shares_issued__c=director1.Number_of_shares_issued__c;
                    director.Registration_Number__c=director1.Registration_Number__c;
                    director.Resident_Overseas__c=director1.Resident_Overseas__c;
                    director.Pmsi__c=director1.Pmsi__c;
                    director.Secured_Parties__c=director1.Secured_Parties__c;
                    director.Start_Date__c=director1.Start_Date__c;
                    directorList.add(director);
                }
                if(directorList.size()>0){
                    Database.insert(directorList,false);
                }   
            }

            if(partyId2!=NULL && partyId!=NULL){
                List<Current_Directorship__c> currentDirectorshipList1=[SELECT id,
                                                                                Party__c,
                                                                                ABN__c,
                                                                                ACN__c,
                                                                                Org_Id_verified__c,
                                                                                Org_Name__c,
                                                                                Org_Id_verified_Asic_status__c,
                                                                                Org_Id_verified_ABN__c,
                                                                                Id_reference__c,
                                                                                Directorship_Type__c,
                                                                                Date_disqualified_until__c,
                                                                                Date_Disqualified__c,
                                                                                Company_Status__c,
                                                                                Appointment_Date__c,
                                                                                Record_Extract_Date__c
                                                                            FROM Current_Directorship__c 
                                                                            WHERE Party__c=: partyId2];

                List<Current_Directorship__c> deleteCurrentDirectorshipList=[SELECT id FROM Current_Directorship__c WHERE Party__c=: partyId];
                if(deleteCurrentDirectorshipList.size()>0){
                    Database.delete(deleteCurrentDirectorshipList,false);
                }
                List<Current_Directorship__c> currentDirectorshipList=new List<Current_Directorship__c>();
                for(Current_Directorship__c currentDirectorship1:currentDirectorshipList1){
                    Current_Directorship__c currentDirectorship=new Current_Directorship__c();
                    currentDirectorship.Party__c=partyId;
                    currentDirectorship.ABN__c=currentDirectorship1.ABN__c;
                    currentDirectorship.ACN__c=currentDirectorship1.ACN__c;
                    currentDirectorship.Record_Extract_Date__c=currentDirectorship1.Record_Extract_Date__c;
                    currentDirectorship.Org_Name__c=currentDirectorship1.Org_Name__c;
                    currentDirectorship.Org_Id_verified__c=currentDirectorship1.Org_Id_verified__c;
                    currentDirectorship.Org_Id_verified_Asic_status__c=currentDirectorship1.Org_Id_verified_Asic_status__c;
                    currentDirectorship.Org_Id_verified_ABN__c=currentDirectorship1.Org_Id_verified_ABN__c;
                    currentDirectorship.Id_reference__c=currentDirectorship1.Id_reference__c;
                    currentDirectorship.Directorship_Type__c=currentDirectorship1.Directorship_Type__c;
                    currentDirectorship.Date_disqualified_until__c=currentDirectorship1.Date_disqualified_until__c;
                    currentDirectorship.Date_Disqualified__c=currentDirectorship1.Date_Disqualified__c;
                    currentDirectorship.Company_Status__c=currentDirectorship1.Company_Status__c;
                    currentDirectorship.Appointment_Date__c=currentDirectorship1.Appointment_Date__c;
                    currentDirectorshipList.add(currentDirectorship);
                }
                if(currentDirectorshipList.size()>0){
                    Database.insert(currentDirectorshipList,false);
                }                                                   
            }
            if(partyId2!=NULL && partyId!=NULL){
                List<Credit_Account__c> creditAccountList1=[SELECT id,
                                                                    Party__c,
                                                                    Account_Id__c,
                                                                    Account_Number__c,
                                                                    Account_Type__c,
                                                                    Credit_Account_Type__c,
                                                                    Credit_Event__c,
                                                                    Current_Default_Amount__c,
                                                                    Default_Date__c,
                                                                    Explanation_Provided__c,
                                                                    Ignore__c,
                                                                    Latest_Credit_Provider__c,
                                                                    Original_Credit_Provider__c,
                                                                    Original_Default_Amount__c,
                                                                    Original_Default_Date__c,
                                                                    Original_Report_Reason__c,
                                                                    Relationship__c,
                                                                    Role__c,
                                                                    Report_Reason__c,
                                                                    Status__c,
                                                                    Status_Date__c
                                                                FROM Credit_Account__c
                                                                WHERE Party__c=:partyId2];
                List<Payment_Default__c> paymentDefault1=[SELECT id,
                                                                Credit_Account__c,
                                                                Credit_Event__c,
                                                                Current_Default_Amount__c,
                                                                Explanation_Provided__c,
                                                                Original_Default_Amount__c,
                                                                Status__c,
                                                                Status_Date__c,
                                                                Ignore__c
                                                            FROM Payment_Default__c 
                                                            WHERE Credit_Account__c IN:creditAccountList1];

                List<Credit_Account__c> deleteCreditAccount=[SELECT id FROM Credit_Account__c WHERE Party__c=:partyId];
                if(deleteCreditAccount.size()>0){
                    Database.delete(deleteCreditAccount,false);
                }
                List<Credit_Account__c> creditAccountList=new List<Credit_Account__c>();
                List<Payment_Default__c> paymentDefault=new List<Payment_Default__c>();
                for(Credit_Account__c creditAccount1:creditAccountList1){
                    Credit_Account__c creditAccount=new Credit_Account__c();
                    creditAccount.Party__c=partyId;
                    creditAccount.Account_Id__c =creditAccount1.Account_Id__c;  
                    creditAccount.Account_Number__c=creditAccount1.Account_Number__c;
                    creditAccount.Account_Type__c=creditAccount1.Account_Type__c;
                    creditAccount.Credit_Account_Type__c=creditAccount1.Credit_Account_Type__c;
                    creditAccount.Credit_Event__c=creditAccount1.Credit_Event__c;
                    creditAccount.Current_Default_Amount__c=creditAccount1.Current_Default_Amount__c;
                    creditAccount.Default_Date__c=creditAccount1.Default_Date__c;
                    creditAccount.Explanation_Provided__c=creditAccount1.Explanation_Provided__c;
                    creditAccount.Ignore__c=creditAccount1.Ignore__c;
                    creditAccount.Latest_Credit_Provider__c=creditAccount1.Latest_Credit_Provider__c;
                    creditAccount.Original_Credit_Provider__c=creditAccount1.Original_Credit_Provider__c;
                    creditAccount.Original_Default_Amount__c=creditAccount1.Original_Default_Amount__c;
                    creditAccount.Original_Default_Date__c=creditAccount1.Original_Default_Date__c;
                    creditAccount.Original_Report_Reason__c=creditAccount1.Original_Report_Reason__c;
                    creditAccount.Relationship__c=creditAccount1.Relationship__c;
                    creditAccount.Role__c=creditAccount1.Role__c;
                    creditAccount.Report_Reason__c=creditAccount1.Report_Reason__c;
                    creditAccount.Status__c=creditAccount1.Status__c;
                    creditAccount.Status_Date__c=creditAccount1.Status_Date__c;
                    creditAccountList.add(creditAccount);

                    for(Payment_Default__c objdefault:paymentDefault1){
                        if(objdefault.Credit_Account__c==creditAccount1.id){
                            Payment_Default__c objPayment=new Payment_Default__c();
                            objPayment.Credit_Event__c=objdefault.Credit_Event__c;
                            objPayment.Current_Default_Amount__c=objdefault.Current_Default_Amount__c;
                            objPayment.Explanation_Provided__c=objdefault.Explanation_Provided__c;
                            objPayment.Original_Default_Amount__c=objdefault.Original_Default_Amount__c;
                            objPayment.Status__c=objdefault.Status__c;
                            objPayment.Status_Date__c=objdefault.Status_Date__c;
                            objPayment.Ignore__c=objdefault.Ignore__c;
                            if (String.isNotBlank(creditAccount.Account_Id__c)) {
                                accountIdDefaultMap.put(
                                    creditAccount.Credit_Account_Type__c + creditAccount.Account_Id__c,
                                    objPayment
                                );
                            }
                        }
                    }
                }
                if(creditAccountList.size()>0){
                    Database.insert(creditAccountList,false);
                }
                for (Credit_Account__c eachCreditAccount : creditAccountList) {
                    if (String.isNotBlank(eachCreditAccount.Account_Id__c)) {
                        accountIdIdMap.put(
                        eachCreditAccount.Credit_Account_Type__c +
                        eachCreditAccount.Account_Id__c,
                        eachCreditAccount.Id
                        );
                    }
                }
                for (String key : accountIdDefaultMap.keySet()) {
                    Payment_Default__c paymentDefaultObj = accountIdDefaultMap.get(key);
                    paymentDefaultObj.Credit_Account__c = accountIdIdMap.get(key);
                    paymentDefault.add(paymentDefaultObj);
                }
                Database.insert(paymentDefault, false);
            }
            
            if(partyId2!=NULL && partyId!=NULL){
                List<Credit_History__c> creditHistoryList1=[SELECT id,
                                                                Party__c,
                                                                Issue__c,
                                                                Amount__c,
                                                                Is_Current__c,
                                                                Details__c,
                                                                Date__c,
                                                                Default_to_be_ignored__c
                                                            FROM Credit_History__c
                                                            WHERE Party__c=: partyId2];

                List<Credit_History__c> deletecreditHistoryList=[SELECT id FROM Credit_History__c WHERE Party__c=:partyId];
                if(deletecreditHistoryList.size()>0){
                    Database.delete(deletecreditHistoryList,false);
                }
                List<Credit_History__c> creditHistoryList=new List<Credit_History__c>();
                for(Credit_History__c creditHistory1:creditHistoryList1){
                    Credit_History__c creditHistory=new Credit_History__c();
                    creditHistory.Party__c=partyId;
                    creditHistory.Issue__c=creditHistory1.Issue__c;
                    creditHistory.Amount__c=creditHistory1.Amount__c;
                    creditHistory.Is_Current__c=creditHistory1.Is_Current__c;
                    creditHistory.Details__c=creditHistory1.Details__c;
                    creditHistory.Date__c=creditHistory1.Date__c;
                    creditHistory.Default_to_be_ignored__c=creditHistory1.Default_to_be_ignored__c;
                    creditHistoryList.add(creditHistory);
                }
                if(creditHistoryList.size()>0){
                    Database.insert(creditHistoryList,false);
                }
            }
            if(partyId2!=NULL && partyId!=NULL){
                List<PPSR_Registration__c> registrationList1=[SELECT id,
                                                                Party__c,
                                                                Search_Number__c,
                                                                Search_Date__c,
                                                                Total_Registrations__c
                                                            FROM PPSR_Registration__c
                                                            WHERE Party__c=:partyId2];
                List<PPSR_Registration__c> deleteRegistrationList=[SELECT id FROM PPSR_Registration__c WHERE Party__c=:partyId];
                if(deleteRegistrationList.size()>0){
                    Database.delete(deleteRegistrationList,false);
                }
                List<PPSR_Registration__c> registrationList=new List<PPSR_Registration__c>();
                for(PPSR_Registration__c registration1:registrationList1){
                    PPSR_Registration__c registration=new PPSR_Registration__c();
                    registration.Party__c=partyId;
                    registration.Search_Number__c=registration1.Search_Number__c;
                    registration.Search_Date__c=registration1.Search_Date__c;
                    registration.Total_Registrations__c=registration1.Total_Registrations__c;
                    registrationList.add(registration);
                }
                if(registrationList.size()>0){
                    Database.insert(registrationList,false);
                }
            }
            if(party!=null && partyId2!=null){
                String attchmentName=ConstantValues.PREV_ENQ_PDF_NAME_PREF + party.clcommon__Account__r.Name +' (OBSOLETE).pdf';
                List<Attachment> att = [Select Id,Body from Attachment where ParentId =: partyId2 and Name =:attchmentName];
                List<Attachment> attch=[Select Id,Body from Attachment where ParentId =: partyId and Name =:attchmentName];
                if(attch.size()>0){
                    Database.delete(attch,false);
                }
                if(att.size()>0){    
                    Attachment attachmentObj=new Attachment();
                    attachmentObj.ParentId=partyId;
                    attachmentObj.Name=attchmentName;
                    attachmentObj.Body=att[0].Body;
                    Database.insert(attachmentObj,false);
                }
            }
            
            Database.update(partyList,false);
            return 'Success';
        }catch(Exception exe){
            GenericUtility.insertLog('UpdateApplicationDateValue.updateApplication', exe);
            return ConstantValues.GENERAL_ERROR;
        }
        
    }

}