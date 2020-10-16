/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EquifaxApplyIndividualResponseHelper */
/* Created Date         : 14/08/2020 */
/* Developed By         : Souvik */
/* Description          : This class is used to Parse and Store Apply Individual Response of Equifax */
/* Last Modified Date   : 15/08/2020 */
/* Last Modified By     : Souvik */
/*********************************************************************************************************/

public class EquifaxApplyIndividualResponseHelper{
	public Cls_Envelope envelope;
	class Cls_Envelope {
        public Cls_Header header;
		public Cls_Body body;
    }
    class Cls_Header {
        public Cls_messageId messageId;
    }
    class Cls_messageId {
        String nodeValue;
    }
	class Cls_Body {
        public Cls_response response;
        public Cls_fault fault;
	}
	class Cls_response {
        public Cls_productData productData;
        public Cls_productHeader productHeader;
        public Cls_generalMessages generalMessages;
        public Cls_errors errors;
    }
    class Cls_errors {
        public Cls_error error;
    }
    class Cls_error {
        public Cls_detail detail;
    }
    class Cls_detail {
        String nodeValue;
    }
    class Cls_generalMessages {
        public Cls_message[] message;
    }
    class Cls_message {
        String nodeValue;
    }
    class Cls_productHeader {
        public Cls_enquiryId enquiryId;
        public Cls_dateTimeGenerated dateTimeGenerated;
        public Cls_permissionType permissionType;
    }
    class Cls_enquiryId {
        public String nodeValue;
    }
    class Cls_dateTimeGenerated {
        public String nodeValue;
    }
    class Cls_permissionType {
        public String nodeValue;
    }
    class Cls_productData {
		public Cls_enquiryReport enquiryReport;
		public Cls_summaryData summaryData;
        public Cls_scoreData scoreData;
        public Cls_possibleMatches possibleMatches;
    }
    class Cls_possibleMatches {
        public Cls_possibleMatch possibleMatch;
    }
    class Cls_possibleMatch {
        public Cls_identity identity;
        public Cls_addresses addresses;
        public Cls_employment employment;
    }
    class Cls_identity {
        public Cls_individualName individualName;
        public Cls_gender gender;
        public Cls_dateOfBirth dateOfBirth;
    }
    class Cls_employment {
        public Cls_employer[] employer;
    }
    class Cls_employer {
        public Cls_name name;
    }
	class Cls_enquiryReport {
        public Cls_otherIdentities otherIdentities;
		public Cls_primaryMatch primaryMatch;
		public Cls_addresses addresses;
		public Cls_employment employment;
		public Cls_consumerCreditFile consumerCreditFile;
		public Cls_commercialCreditFile commercialCreditFile;
		public Cls_publicRecordOrConsumerCreditInformation publicRecordOrConsumerCreditInformation;
    }
    class Cls_otherIdentities {
        public Cls_otherIdentity[] otherIdentity;
    }
    class Cls_otherIdentity {
        Cls_bureauReference bureauReference;
        Cls_individualName individualName;
        Cls_gender gender;
        Cls_dateOfBirth dateOfBirth;
    }
	class Cls_primaryMatch {
		public String type;
		public Cls_bureauReference bureauReference;
		public Cls_individualName individualName;
        public Cls_dateOfBirth dateOfBirth;
        public Cls_addresses addresses;
	}
	class Cls_bureauReference {
		public String nodeValue;
    }
	class Cls_individualName {
		public String nodeValue;
		public String lastReportedDate;
		public String lastCreditEnquiryDate;
		public String firstReportedDate;
		public Cls_familyName familyName;
		public Cls_firstGivenName firstGivenName;
		public Cls_otherGivenName otherGivenName;
    }
    class Cls_familyName {
		public String nodeValue;
	}
	class Cls_firstGivenName {
		public String nodeValue;
	}
	class Cls_otherGivenName {
		public String nodeValue;
	}
	class Cls_gender {
		public String nodeValue;
		public String code;
	}
	class Cls_dateOfBirth {
		public String nodeValue;
    }
	class Cls_addresses {
		public String nodeValue;
		public Cls_address[] address;
	}
	class Cls_address {
		public String nodeValue;
		public String type;
		Cls_property property;
		Cls_unitNumber unitNumber;
		Cls_streetNumber streetNumber;
		Cls_streetName streetName;
		Cls_streetType streetType;
		Cls_suburb suburb;
		Cls_state state;
		Cls_postcode postcode;
		Cls_countryCode countryCode;
	}
	class Cls_idReference {
		public String nodeValue;
    }
    class Cls_property {
		public String nodeValue;
	}
	class Cls_unitNumber {
		public String nodeValue;
	}
	class Cls_streetNumber {
		public String nodeValue;
	}
	class Cls_streetName {
		public String nodeValue;
	}
	class Cls_streetType {
		public String nodeValue;
	}
	class Cls_suburb {
		public String nodeValue;
	}
	class Cls_state {
		public String nodeValue;
	}
	class Cls_postcode {
		public String nodeValue;
	}
	class Cls_countryCode {
		public String nodeValue;
	}
	class Cls_name {
		public String nodeValue;
    }
    class Cls_value {
		public String nodeValue;
    }
    class Cls_consumerCreditFile {
		public String nodeValue;
		public Cls_creditEnquiries creditEnquiries;
		public Cls_accounts accounts;
	}
	class Cls_creditEnquiries {
		public String nodeValue;
		public Cls_creditEnquiry[] creditEnquiry;
	}
	class Cls_creditEnquiry {
		public String nodeValue;
		public String type;
		public String enquiryDate;
		public Cls_accountType accountType;
		public Cls_enquiryAmount enquiryAmount;
		public Cls_relationship relationship;
		public Cls_creditEnquirer creditEnquirer;
		public Cls_enquiryClientReference enquiryClientReference;
	}
	class Cls_accountType {
		public String nodeValue;
		public String code;
	}
	class Cls_enquiryAmount {
		public String nodeValue;
		public String currencyCode;
	}
	class Cls_relationship {
		public String nodeValue;
		public String code;
	}
	class Cls_creditEnquirer {
		public String nodeValue;
		public Cls_name name;
	}
	class Cls_enquiryClientReference {
		public String nodeValue;
	}
	class Cls_accounts {
		public String nodeValue;
        public Cls_account[] account;
        public Cls_pDefaults pDefaults;
	}
	class Cls_account {
		public String nodeValue;
		public String latestUpdateDate;
		public String accountDataLevel;
        public Cls_accountId accountId;
        public Cls_originalCreditProvider originalCreditProvider;
		public Cls_latestCreditProvider latestCreditProvider;
		public Cls_accountType accountType;
		public Cls_relationship relationship;
		public Cls_associationInformation associationInformation;
		public Cls_pDefaults pDefaults;
	}
	class Cls_accountId {
		public String nodeValue;
    }
	class Cls_originalCreditProvider {
		public String nodeValue;
		public Cls_name name;
		public Cls_classification classification;
	}
	class Cls_classification {
		public String nodeValue;
	}
	class Cls_latestCreditProvider {
		public String nodeValue;
		public Cls_name name;
		public Cls_classification classification;
	}
	class Cls_associationInformation {
		public String nodeValue;
		public Cls_isSeriousCreditInfringement isSeriousCreditInfringement;
	}
	class Cls_isSeriousCreditInfringement {
		public String nodeValue;
	}
	class Cls_pDefaults {
		public String nodeValue;
		public Cls_pDefault[] pDefault;
	}
	class Cls_pDefault {
		public String nodeValue;
        public Cls_status status;
        Cls_statusDate statusDate;
		public Cls_originalpDefault originalpDefault;
		public Cls_currentpDefault currentpDefault;
    }
	class Cls_status {
		public String nodeValue;
		public String code;
    }
    class Cls_statusDate {
		public String nodeValue;
	}
	class Cls_originalpDefault {
		public String nodeValue;
		public Cls_dateRecorded dateRecorded;
		public Cls_pDefaultAmount pDefaultAmount;
		public Cls_reasonToReport reasonToReport;
	}
	class Cls_dateRecorded {
		public String nodeValue;
	}
	class Cls_pDefaultAmount {
		public String nodeValue;
		public String currencyCode;
	}
	class Cls_currentpDefault {
		public String nodeValue;
		public Cls_dateRecorded dateRecorded;
		public Cls_pDefaultAmount pDefaultAmount;
		public Cls_reasonToReport reasonToReport;
    }
	class Cls_commercialCreditFile {
		public String nodeValue;
		public Cls_creditEnquiries creditEnquiries;
		public Cls_accounts accounts;
	}
	class Cls_reasonToReport {
		public String nodeValue;
		public String code;
    }
	class Cls_publicRecordOrConsumerCreditInformation {
		public Cls_directorships directorships;
		public Cls_disqualifiedDirectorships disqualifiedDirectorships ;
    }
	class Cls_disqualifiedDirectorships {
		public String nodeValue;
		public Cls_disqualifiedDirectorship[] disqualifiedDirectorship;
	}
	class Cls_disqualifiedDirectorship {
        public String nodeValue;
		public Cls_dateDisqualified dateDisqualified;
        public Cls_dateDisqualifiedUntil dateDisqualifiedUntil;
        public Cls_additionalDataFields additionalDataFields;
	}
	class Cls_dateDisqualified {
		public String nodeValue;
	}
	class Cls_dateDisqualifiedUntil {
		public String nodeValue;
    }
    class Cls_additionalDataFields {
        Cls_dataField dataField;
    }
    class Cls_dataField {
        Cls_key key;
        Cls_value value;
    }
    class Cls_key {
        String nodeValue;
    }
	class Cls_directorships {
		public Cls_directorship[] directorship;
	}
	class Cls_directorship {
		public String nodeValue;
		public String type;
		public Cls_dateAppointed dateAppointed;
		public Cls_organisation organisation;
	}
	class Cls_dateAppointed {
		public String nodeValue;
	}
	class Cls_organisation {
        public String nodeValue;
        public Cls_bureauReference bureauReference;
		public Cls_name name;
        public Cls_type type;
        public Cls_status status;
        public Cls_organisationNumber organisationNumber;
        public Cls_ABN abn;
	}
	class Cls_type {
		public String nodeValue;
    }
    class Cls_organisationNumber {
        public String nodeValue;
    }
    class Cls_ABN {
        public String nodeValue;
    }
	class Cls_businessNames {
		public String nodeValue;
		public Cls_businessName[] businessName;
	}
	class Cls_businessName {
		public String nodeValue;
		public Cls_startDate startDate;
		public Cls_business business;
	}
	class Cls_startDate {
		public String nodeValue;
	}
	class Cls_business {
		public String nodeValue;
		public Cls_name name;
	}
	class Cls_summaryData {
		public String nodeValue;
		public Cls_dataBlock dataBlock;
	}
	class Cls_dataBlock {
		public String nodeValue;
		public String type;
		public String name;
		public Cls_characteristic[] characteristic;
	}
	class Cls_characteristic {
		public String nodeValue;
		public String keyCharacteristic;
		public String id;
		public Cls_variableName variableName;
		public Cls_description description;
		public Cls_value value;
		public Cls_dataLevel dataLevel;
	}
	class Cls_variableName {
		public String nodeValue;
	}
	class Cls_description {
		public String nodeValue;
	}
	class Cls_dataLevel {
		public String nodeValue;
		public String code;
	}
	class Cls_scoreData {
		public String nodeValue;
		public Cls_score[] score;
	}
	class Cls_score {
		public String nodeValue;
		public Cls_scorecard scorecard;
		public Cls_scoreMasterscale scoreMasterscale;
	}
	class Cls_scorecard {
		public String nodeValue;
		public String id;
		public Cls_name name;
		public Cls_version version;
		public Cls_type type;
		public Cls_dataLevel dataLevel;
	}
	class Cls_version {
		public String nodeValue;
	}
	class Cls_scoreImpactor {
		public String nodeValue;
	}
	class Cls_scoreMasterscale {
		public String nodeValue;
    }

    class Cls_fault {
        Cls_faultcode faultcode;
        Cls_faultstring faultstring;
    }
    class Cls_faultcode {
        String nodeValue;
    }
    class Cls_faultstring {
        String nodeValue;
    }

    static Cls_characteristic findInSummaryData(Cls_characteristic[] all, String val){
        if (all == null) {
            return new Cls_characteristic();
        }
        for (Cls_characteristic each : all) {
            if(each == null || each.variableName == null){
                continue;
            }
            if (each.variableName.nodeValue == val) {
                return each;
            }
        }
        return new Cls_characteristic();
    }
    static String processAddress(Cls_address addr) {
        String res = '';
        if (addr.unitNumber != null) {
            res += (String) addr.unitNumber.nodeValue;
        }
        if (addr.streetNumber != null) {
            res += ' ' + (String) addr.streetNumber.nodeValue;
        }
        if (addr.streetType != null) {
            res += ' ' + (String) addr.streetType.nodeValue + ',';
        }
        if (addr.suburb != null) {
            res += ' ' + (String) addr.suburb.nodeValue;
        }
        if (addr.state != null) {
            res += ' ' + (String) addr.state.nodeValue;
        }
        if (addr.postcode != null) {
            res += ' ' + (String) addr.postcode.nodeValue;
        }
        if (addr.countryCode != null) {
            res += ' ' + (String) addr.countryCode.nodeValue;
        }
        return res;
    }
    static String processPossiblyMatchedData(Cls_possibleMatch possibleMatchData){
        String data = '';
        try{
            data += possibleMatchData.identity.individualName.firstGivenName.nodeValue + ' ';
        }catch(Exception ex){}
        try{
            data += possibleMatchData.identity.individualName.otherGivenName.nodeValue + ' ';
        }catch(Exception ex){}
        try{
            data += possibleMatchData.identity.individualName.familyName.nodeValue + ' ';
        }catch(Exception ex){}
        try{
            data += '\nD.O.B : ' + possibleMatchData.identity.dateOfBirth.nodeValue;
        }catch(Exception ex){}
        try{
            data += '\nAddresses : ';
            for(Cls_address each : possibleMatchData.addresses.address){
                data += processAddress(each) + '\n';
            }
        }catch(Exception ex){}
        return data;
    }
	public static EquifaxApplyIndividualResponseHelper parse(String json, Id partyId){
        try{
            json = json.replaceAll('default', 'pDefault');
            json = GenericUtility.modifyJsonKeysIntoCamelcasingV2(json);
            List<String> queries = new List<String>();
            queries.add('"directorship"');
            queries.add('"disqualifiedDirectorship"');
            queries.add('"pDefault"');
            queries.add('"characteristic"');
            queries.add('"address"');
            queries.add('"creditEnquiry"');
            queries.add('"account"');
            queries.add('"employer"');
            queries.add('"message"');
            queries.add('"otherIdentity"');
            JsonObjectToArray obj = new JsonObjectToArray();
            json = obj.modifyAllByRecur(json, queries);
            // EquifaxApplyIndividualResponseHelper helperObject = (EquifaxApplyIndividualResponseHelper) System.JSON.deserialize(json, EquifaxApplyIndividualResponseHelper.class);
            return (EquifaxApplyIndividualResponseHelper) System.JSON.deserialize(json, EquifaxApplyIndividualResponseHelper.class);
        }catch(Exception ex){
            GenericUtility.insertLog('EquifaxApplyIndividualResponseHelper', ex);
            return null;
        }
    }
    private static List<Current_Directorship__c> updateCurrentDirectorships(Cls_directorship[] directorshipList, clcommon__Party__c partyObj){
        List<Current_Directorship__c> currentDirectorships = new List<Current_Directorship__c>();
        if(directorshipList == null){
            return null;
        }
        for(Cls_directorship each : directorshipList){
            if(String.isNotBlank(each.type) && each.type.equals('C')){
                Current_Directorship__c refDirShip;
                try{
                    refDirShip = new Current_Directorship__c();
                    refDirShip.Directorship_Type__c = 'Current';
                    refDirShip.Party__c = partyObj.Id;
                }catch(Exception ex){}
                try{
                    refDirShip.Org_Name__c = each.organisation.name.nodeValue + ' ' + each.organisation.type.nodeValue;
                }catch(Exception ex){}
                try{
                    refDirShip.Company_Status__c = each.organisation.status.nodeValue;
                }catch(Exception ex){}
                try{
                    refDirShip.ABN__c = each.organisation.abn.nodeValue;
                }catch(Exception ex){}
                try{
                    refDirShip.ACN__c = each.organisation.organisationNumber.nodeValue;
                }catch(Exception ex){}
                if(refDirShip != null){
                    currentDirectorships.add(refDirShip);
                }
            }
        }
        return currentDirectorships;
    }
    public static String updatePartyWithApplyIndividualResponse(clcommon__Party__c partyObj, EquifaxApplyIndividualResponseHelper helperObject){
        String returnVal = ConstantValues.APPLY_IND_SUCCESS;
        Cls_characteristic[] summaryDataList;
        Cls_characteristic charData;
        Cls_creditEnquiry[] creditEnquiryList;
        Cls_account[] accountList;
        Cls_pDefault[] defaultList;
        Cls_score[] scoreList;
        List<Current_Directorship__c> currentDirectorships = new List<Current_Directorship__c>();
        List<Credit_Enquiry__c> creditEnquiries = new List<Credit_Enquiry__c>();
        List<Credit_Account__c> creditAccounts = new List<Credit_Account__c>();
        List<Payment_Default__c> paymentDefaults = new List<Payment_Default__c>();
        Map<String, Payment_Default__c> accountIdDefaultMap = new Map<String, Payment_Default__c>();
        Map<String, Id> accountIdIdMap = new Map<String, Id>();
        try{
            if(partyObj == null || helperObject == null){
                throw new CustomException(ConstantValues.APPLY_IND_PARAM_NULL);
            }
            clearPartyObjectData(partyObj);
            try{
                partyObj.Request_Id__c = helperObject.envelope.header.messageId.nodeValue;
            }catch(Exception ex){
                return ConstantValues.GENERAL_ERROR;
            }
            update partyObj;
            // Checks if any fault exists
            try{
                String faultString = helperObject.envelope.body.fault.faultstring.nodeValue;
                return faultString;
            }catch(Exception ex){}
            try{
                String faultString = helperObject.envelope.body.response.errors.error.detail.nodeValue;
                return faultString;
            }catch(Exception ex){}
            try{
                summaryDataList = helperObject.envelope.body.response.productData.summaryData.dataBlock.characteristic;
            }catch(Exception ex){}
            try{
                String dateTimeGenString = helperObject.envelope.body.response.productHeader.datetimeGenerated.nodeValue;
                Date dateGen = Date.newInstance(Integer.valueOf(dateTimeGenString.subString(0,4)),
                Integer.valueOf(dateTimeGenString.subString(5,7)),
                Integer.valueOf(dateTimeGenString.subString(8,10)));
                partyObj.Report_Created_Date__c = dateGen;
                partyObj.Permission_Type__c = helperObject.envelope.body.response.productHeader.permissionType.nodeValue;
            }catch(Exception ex){
                return ConstantValues.GENERAL_ERROR;
            }
            try{
                Cls_possibleMatch possibleMatchData = helperObject.envelope.body.response.productData.possibleMatches.possibleMatch;
                partyObj.Possibly_matched_data__c = processPossiblyMatchedData(possibleMatchData);
            }catch(Exception ex){}
            try{
                partyObj.File_Number__c = helperObject.envelope.body.response.productData.enquiryReport.primaryMatch.bureauReference.nodeValue;
            }catch(Exception ex){}
            try{
                charData = findInSummaryData(summaryDataList, 'NA8904_age_fle');
                partyObj.Age_of_Credit_File__c = Decimal.valueOf(charData.value.nodeValue).round(System.RoundingMode.HALF_DOWN);
                charData = findInSummaryData(summaryDataList, 'NY7601_adv_48_84m');
                if(charData.value.nodeValue.equalsIgnoreCase('Y')){
                    partyObj.Adverse_on_file__c = 'Yes';
                }else if(charData.value.nodeValue.equalsIgnoreCase('N')){
                    partyObj.Adverse_on_file__c = 'No';
                }
                charData = findInSummaryData(summaryDataList, 'NX7601_adv_48_84m');
                if(charData.value.nodeValue.equalsIgnoreCase('Y')){
                    partyObj.Consumer_Adverse_on_file__c = 'Yes';
                }else if(charData.value.nodeValue.equalsIgnoreCase('N')){
                    partyObj.Consumer_Adverse_on_file__c = 'No';
                }
                charData = findInSummaryData(summaryDataList, 'NP8500_dr_cur');
                partyObj.Current_Directorships__c = Integer.valueOf(charData.value.nodeValue);
                charData = findInSummaryData(summaryDataList, 'NP8506_dr_adv_disq_60m_ever');
                partyObj.External_Administrators__c = Integer.valueOf(charData.value.nodeValue);
                charData = findInSummaryData(summaryDataList, 'NP8512_inslv_bkrpt');
                partyObj.Number_of_bankrupt_on_file__c = Integer.valueOf(charData.value.nodeValue);
                charData = findInSummaryData(summaryDataList, 'NP7502_inslv_bkrpt_84m');
                partyObj.Number_of_bankrupt_on_file_in_last_84m__c = Integer.valueOf(charData.value.nodeValue);
                charData = findInSummaryData(summaryDataList, 'NP8511_inslv_dis');
                partyObj.Number_of_Discharged_Insolvencies__c = Integer.valueOf(charData.value.nodeValue);
                charData = findInSummaryData(summaryDataList, 'NP8510_inslv');
                partyObj.Number_of_insolvencies_on_file__c = Integer.valueOf(charData.value.nodeValue);
                charData = findInSummaryData(summaryDataList, 'NY8006_enq_60m');
            }catch(Exception ex){}
            try{
                scoreList = helperObject.envelope.body.response.productData.scoreData.score;
            }catch(Exception ex){
            }
            if(scoreList != null){
                for(Cls_score each : scoreList){
                    try {
                        String scoreCardIdVal = each.scorecard.id;
                        if(scoreCardIdVal.equalsIgnoreCase('VSA_2.0_XY_NR') || scoreCardIdVal.equalsIgnoreCase('CCAI_2.0_YX_NR')){
                            partyObj.Credit_Score__c = Decimal.valueOf(each.scoreMasterscale.nodeValue);
                        }
                    }catch(Exception ex){
                    }
                }
            }
            try{
                Cls_address[] addressList = helperObject.envelope.body.response.productData.enquiryReport.addresses.address;
                for(Cls_address each : addressList){
                    if(String.isNotBlank(each.type) && each.type.equals('C')){
                        partyObj.Individual_Address__c = processAddress(each);
                        break;
                    }
                }
            }catch(Exception ex){}
            try{
                partyObj.Employer__c = helperObject.envelope.body.response.productData.enquiryReport.employment.employer[0].name.nodeValue;
            }catch(Exception ex){
            }
            Database.update(partyObj);
            // Update Directorships from the Response
            List<Current_Directorship__c> eraseDirectorships = [SELECT Id, Party__c FROM Current_Directorship__c WHERE Party__c =:partyObj.Id];
            Database.delete(eraseDirectorships, false);
            Cls_directorship[] directorshipList;
            try {
                directorshipList = helperObject.envelope.body.response.productData.enquiryReport.publicRecordOrConsumerCreditInformation.directorships.directorship;
            }catch(Exception ex){
                returnVal += '\n' + ConstantValues.NO_DIRECTORSHIPS;
            }
            List<Current_Directorship__c>  currentDirectorshipsRef = updateCurrentDirectorships(directorshipList, partyObj);
            if(currentDirectorshipsRef != null){
                currentDirectorships.addAll(currentDirectorshipsRef);
            }
            Cls_disqualifiedDirectorship[] disqDirectorshipList;
            try {
                disqDirectorshipList = helperObject.envelope.body.response.productData.enquiryReport.publicRecordOrConsumerCreditInformation.disqualifiedDirectorships.disqualifiedDirectorship;
                for(Cls_disqualifiedDirectorship each : disqDirectorshipList){
                    Current_Directorship__c refDirShip;
                    refDirShip = new Current_Directorship__c();
                    refDirShip.Directorship_Type__c = 'Disqualified';
                    refDirShip.Party__c = partyObj.Id;
                    try{
                        String dateDisqStr = each.dateDisqualified.nodeValue;
                        Date dateDisq = Date.newInstance(Integer.valueOf(dateDisqStr.subString(0,4)),
                        Integer.valueOf(dateDisqStr.subString(5,7)),
                        Integer.valueOf(dateDisqStr.subString(8,10)));
                        refDirShip.Date_Disqualified__c = dateDisq;
                    }catch(Exception ex){
                    }
                    try{
                        String dateDisqUntilStr = each.dateDisqualifiedUntil.nodeValue;
                        Date dateDisqUntil = Date.newInstance(Integer.valueOf(dateDisqUntilStr.subString(0,4)),
                        Integer.valueOf(dateDisqUntilStr.subString(5,7)),
                        Integer.valueOf(dateDisqUntilStr.subString(8,10)));
                        refDirShip.Date_disqualified_until__c = dateDisqUntil;
                    }catch(Exception ex){
                    }
                    if(refDirShip != null){
                        currentDirectorships.add(refDirShip);
                    }
                }
            }catch(Exception ex){
                returnVal += '\n' + 'No Disqualified Directorships found';
            }
            Database.insert(currentDirectorships, false);
            List<Credit_Enquiry__c> eraseCreditEnquiries = [SELECT Id, Party__c FROM Credit_Enquiry__c WHERE Party__c =:partyObj.Id];
            Database.delete(eraseCreditEnquiries, false);
            // Update Consumer Credit Enquiries from the Response
            try {
                creditEnquiryList = helperObject.envelope.body.response.productData.enquiryReport.consumerCreditFile.creditEnquiries.creditEnquiry;
                for(Cls_creditEnquiry each : creditEnquiryList){
                    Credit_Enquiry__c creditEnquiryObj;
                    try{
                        creditEnquiryObj = new Credit_Enquiry__c();
                        creditEnquiryObj.Party__c = partyObj.Id;
                        creditEnquiryObj.Credit_Enquiry_Type__c = 'Consumer';

                        String dateString = each.enquiryDate;
                        Date enqDate = Date.newInstance(Integer.valueOf(dateString.subString(0,4)),
                        Integer.valueOf(dateString.subString(5,7)),
                        Integer.valueOf(dateString.subString(8,10)));
                        creditEnquiryObj.Enquiry_Date__c = enqDate;
                    }catch(Exception ex){
                    }
                    try{
                        creditEnquiryObj.Credit_Enquirer__c = each.creditEnquirer.name.nodeValue;
                    }catch(Exception ex){
                    }
                    try{
                        creditEnquiryObj.Account_Type__c = each.accountType.nodeValue;
                    }catch(Exception ex){
                    }
                    try{
                        creditEnquiryObj.Enquiry_amount__c = Decimal.valueOf(each.enquiryAmount.nodeValue);
                    }catch(Exception ex){
                    }
                    try{
                        Integer codeValue = Integer.valueOf(each.relationship.code);
                        switch on codeValue {
                            when 1 {
                                creditEnquiryObj.Role_in_Enquiry__c = 'Principal (sole)';
                            }
                            when 2 {
                                creditEnquiryObj.Role_in_Enquiry__c = 'Principal (joint)';
                            }
                            when 3 {
                                creditEnquiryObj.Role_in_Enquiry__c = 'Guarantor';
                            }
                        }
                    }catch(Exception ex){
                    }
                    try{
                        creditEnquiryObj.Reference_No__c = each.enquiryClientReference.nodeValue;
                    }catch(Exception ex){
                    }
                    if(creditEnquiryObj != null){
                        creditEnquiries.add(creditEnquiryObj);
                    }
                }
            }catch(Exception ex){
                returnVal += '\n' + 'No Consumer Credit Enquiries found';
            }
            // Update Commercial Credit Enquiries from the Response
            try {
                creditEnquiryList = helperObject.envelope.body.response.productData.enquiryReport.commercialCreditFile.creditEnquiries.creditEnquiry;
                for(Cls_creditEnquiry each : creditEnquiryList){
                    Credit_Enquiry__c creditEnquiryObj;
                    try{
                        creditEnquiryObj = new Credit_Enquiry__c();
                        creditEnquiryObj.Party__c = partyObj.Id;
                        creditEnquiryObj.Credit_Enquiry_Type__c = 'Commercial';

                        String dateString = each.enquiryDate;
                        Date enqDate = Date.newInstance(Integer.valueOf(dateString.subString(0,4)),
                        Integer.valueOf(dateString.subString(5,7)),
                        Integer.valueOf(dateString.subString(8,10)));
                        creditEnquiryObj.Enquiry_Date__c = enqDate;
                    }catch(Exception ex){
                    }
                    try{
                        creditEnquiryObj.Credit_Enquirer__c = each.creditEnquirer.name.nodeValue;
                    }catch(Exception ex){
                    }
                    try{
                        creditEnquiryObj.Account_Type__c = each.accountType.nodeValue;
                    }catch(Exception ex){
                    }
                    try{
                        creditEnquiryObj.Enquiry_amount__c = Decimal.valueOf(each.enquiryAmount.nodeValue);
                    }catch(Exception ex){
                    }
                    try{
                        Integer codeValue = Integer.valueOf(each.relationship.code);
                        switch on codeValue {
                            when 1 {
                                creditEnquiryObj.Role_in_Enquiry__c = 'Principal (sole)';
                            }
                            when 2 {
                                creditEnquiryObj.Role_in_Enquiry__c = 'Principal (joint)';
                            }
                            when 3 {
                                creditEnquiryObj.Role_in_Enquiry__c = 'Guarantor';
                            }
                        }
                    }catch(Exception ex){
                    }
                    try{
                        creditEnquiryObj.Reference_No__c = each.enquiryClientReference.nodeValue;
                    }catch(Exception ex){
                    }
                    if(creditEnquiryObj != null){
                        creditEnquiries.add(creditEnquiryObj);
                    }
                }
            }catch(Exception ex){
                returnVal += '\n' + 'No Commercial Credit Enquiries found';
            }
            Database.insert(creditEnquiries, false);
            List<Credit_Account__c> eraseCreditAccounts = [SELECT Id, Party__c FROM Credit_Account__c WHERE Party__c =:partyObj.Id];
            Database.delete(eraseCreditAccounts, false);
            // Update Commercial Credit Accounts from the Response
            try{
                accountList = helperObject.envelope.body.response.productData.enquiryReport.commercialCreditFile.accounts.account;
                for(Cls_account each : accountList){
                    Credit_Account__c creditAccountObj;
                    creditAccountObj = new Credit_Account__c();
                    creditAccountObj.Party__c = partyObj.Id;
                    creditAccountObj.Credit_Account_Type__c = 'Commercial';
                    try{
                        creditAccountObj.Account_Id__c = each.accountId.nodeValue;
                    }catch(Exception ex){}
                    try{
                        creditAccountObj.Account_Type__c = each.accountType.nodeValue;
                    }catch(Exception ex){}
                    try{
                        creditAccountObj.Original_Credit_Provider__c = each.originalCreditProvider.name.nodeValue;
                    }catch(Exception ex){}
                    try{
                        creditAccountObj.Latest_Credit_Provider__c = each.latestCreditProvider.name.nodeValue;
                    }catch(Exception ex){}
                    try{
                        creditAccountObj.Relationship__c = each.relationship.nodeValue;
                    }catch(Exception ex){}
                    if(creditAccountObj != null){
                        creditAccounts.add(creditAccountObj);
                    }
                    try {
                        defaultList = each.pDefaults.pDefault;
                        for(Cls_pDefault eachDefault : defaultList){
                            Payment_Default__c paymentDefaultObj;
                            paymentDefaultObj = new Payment_Default__c();
                            try {
                                paymentDefaultObj.Status__c = eachDefault.status.nodeValue;
                            }catch(Exception ex){
                            }
                            try {
                                String dateString = eachDefault.statusDate.nodeValue;
                                Date statusDate = Date.newInstance(Integer.valueOf(dateString.subString(0,4)),
                                Integer.valueOf(dateString.subString(5,7)),
                                Integer.valueOf(dateString.subString(8,10)));
                                paymentDefaultObj.Status_Date__c = statusDate;
                            }catch(Exception ex){
                            }
                            try {
                                paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(eachDefault.currentpDefault.pDefaultAmount.nodeValue);
                            }catch(Exception ex){
                            }
                            try {
                                paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(eachDefault.originalpDefault.pDefaultAmount.nodeValue);
                            }catch(Exception ex){
                            }
                            if(paymentDefaultObj != null){
                                if(String.isNotBlank(creditAccountObj.Account_Id__c)){
                                    accountIdDefaultMap.put('Commercial'
                                    + creditAccountObj.Account_Id__c, paymentDefaultObj);
                                }
                            }
                        }
                    }catch(Exception ex){}
                }
            }catch(Exception ex){
                returnVal += '\n' + 'No Commercial Credit Accounts found';
            }
            // Update Consumer Credit Accounts from the Response
            try{
                accountList = helperObject.envelope.body.response.productData.enquiryReport.consumerCreditFile.accounts.account;
                for(Cls_account each : accountList){
                    Credit_Account__c creditAccountObj;
                    creditAccountObj = new Credit_Account__c();
                    creditAccountObj.Party__c = partyObj.Id;
                    creditAccountObj.Credit_Account_Type__c = 'Consumer';
                    try{
                        creditAccountObj.Account_Id__c = each.accountId.nodeValue;
                    }catch(Exception ex){}
                    try{
                        creditAccountObj.Account_Type__c = each.accountType.nodeValue;
                    }catch(Exception ex){}
                    try{
                        creditAccountObj.Original_Credit_Provider__c = each.originalCreditProvider.name.nodeValue;
                    }catch(Exception ex){}
                    try{
                        creditAccountObj.Latest_Credit_Provider__c = each.latestCreditProvider.name.nodeValue;
                    }catch(Exception ex){}
                    try{
                        creditAccountObj.Relationship__c = each.relationship.nodeValue;
                    }catch(Exception ex){}
                    if(creditAccountObj != null){
                        creditAccounts.add(creditAccountObj);
                    }
                    try {
                        defaultList = each.pDefaults.pDefault;
                        for(Cls_pDefault eachDefault : defaultList){
                            Payment_Default__c paymentDefaultObj;
                            try{
                                paymentDefaultObj = new Payment_Default__c();
                            }catch(Exception ex){}
                            try {
                                paymentDefaultObj.Status__c = eachDefault.status.nodeValue;
                            }catch(Exception ex){
                            }
                            try {
                                String dateString = eachDefault.statusDate.nodeValue;
                                Date statusDate = Date.newInstance(Integer.valueOf(dateString.subString(0,4)),
                                Integer.valueOf(dateString.subString(5,7)),
                                Integer.valueOf(dateString.subString(8,10)));
                                paymentDefaultObj.Status_Date__c = statusDate;
                            }catch(Exception ex){
                            }
                            try {
                                paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(eachDefault.currentpDefault.pDefaultAmount.nodeValue);
                            }catch(Exception ex){}
                            try {
                                paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(eachDefault.originalpDefault.pDefaultAmount.nodeValue);
                            }catch(Exception ex){}
                            if(paymentDefaultObj != null){
                                if(String.isNotBlank(creditAccountObj.Account_Id__c)){
                                    accountIdDefaultMap.put('Consumer'
                                    + creditAccountObj.Account_Id__c, paymentDefaultObj);
                                }
                            }
                        }
                    }catch(Exception ex){}
                }
            }catch(Exception ex){
                returnVal += '\n' + 'No Consumer Credit Accounts found';
            }
            Database.insert(creditAccounts, false);
            creditAccounts = [SELECT Id, Party__c, Credit_Account_Type__c, Account_Id__c FROM Credit_Account__c WHERE Party__c =:partyObj.Id];
            for(Credit_Account__c each : creditAccounts){
                if(String.isNotBlank(each.Account_Id__c)){
                    accountIdIdMap.put(each.Credit_Account_Type__c
                    + each.Account_Id__c, each.Id);
                }
            }
            for(String key : accountIdDefaultMap.keySet()){
                Payment_Default__c paymentDefaultObj = accountIdDefaultMap.get(key);
                paymentDefaultObj.Credit_Account__c = accountIdIdMap.get(key);
                paymentDefaults.add(paymentDefaultObj);
            }
            Database.insert(paymentDefaults, false);
            Database.executeBatch(new EquifaxOrgIdSearchBatch(), 1);
            return returnVal;
        }
        catch(Exception ex){
            GenericUtility.insertLog('EquifaxApplyIndividualResponseHelper', ex);
        }
        return ConstantValues.GENERAL_ERROR;
    }
    private static void clearPartyObjectData(clcommon__Party__c partyObj){
        partyObj.Request_Id__c = null;
        partyObj.Report_Created_Date__c = null;
        partyObj.Permission_Type__c = null;
        partyObj.Possibly_matched_data__c = null;
        partyObj.File_Number__c = null;
        partyObj.Age_of_Credit_File__c = null;
        partyObj.Adverse_on_file__c = null;
        partyObj.Consumer_Adverse_on_file__c = null;
        partyObj.Current_Directorships__c = null;
        partyObj.External_Administrators__c = null;
        partyObj.Number_of_bankrupt_on_file__c = null;
        partyObj.Number_of_bankrupt_on_file_in_last_84m__c = null;
        partyObj.Number_of_Discharged_Insolvencies__c = null;
        partyObj.Number_of_insolvencies_on_file__c = null;
        update partyObj;
    }
}