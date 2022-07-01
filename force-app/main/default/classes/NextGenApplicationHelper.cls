/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class acts as the parser class for the request of NextGenAuthentication .
Development Date : 10/04/2022
Last Modified Date : 18/05/2022
Devloper's comment : Some part of the codes are hardcoded and not been put in Constant Classes - since
                    they are referenced only here and its a one time use.
****************************************************************************************************/
public class NextGenApplicationHelper {
    
    public static String parse(
    String json,
    Map<String, Object> response,
    String params
    ) {
        String returnValue ='';
        String errorForUser = '';
        String brokerId='';
        String borrowerNameNext='';
        String applicationId;

        try{
            Boolean flag = true;
            Boolean flagCreditCheck = true;
            Boolean flagThirdParty = true;
            Decimal smfcurrentValue=0;
            Map<String,Object> applicationMap=new Map<String,Object>();
            Map<String,Object> partySegmentMap=new Map<String,Object>();
            Map<String,Object> addressSegmentMap=new Map<String,Object>();
            Map<String,Object> relatedPartySegmentMap=new Map<String,Object>();
            Map<String,Object> homePhoneMap=new Map<String,Object>();
            Map<String, Telephone_Contact_Number__c> telephoneContactMap = new Map<String, Telephone_Contact_Number__c>();
            Map<String,Id> contactIdMap=new Map<String,Id>();
            Map<String,Id> partyIdMap=new Map<String,Id>();
            Map<String,Id> employmentIdMap=new Map<String,Id>();
            Map<String,Object> addressdetailMap=new Map<String,Object>();
            Map<String, clcommon__Address__c> contactAddressMap = new Map<String, clcommon__Address__c>();
            Map<String,clcommon__Address__c> contactAddressMap2 = new Map<String,clcommon__Address__c>();
            Map<String, clcommon__Address__c> contactAddressMap3 = new Map<String, clcommon__Address__c>();
            Map<String,String> addressCheck=new Map<String,String>();
            Map<String, clcommon__Collateral__c> collateralAddressMap = new Map<String, clcommon__Collateral__c>();
            Integer count=0;
            Integer countTrustee=0;
            Map<String,clcommon__Address__c> accountAddressMap = new Map<String,clcommon__Address__c>();
            Map<String,id>accountLegalentityMap=new Map<String,id>();
            Map<String, clcommon__Party__c> objPartyMap = new Map<String, clcommon__Party__c>();
            Map<String, clcommon__Party__c> objSMSFPartyMap = new Map<String, clcommon__Party__c>();
            Map<String, clcommon__Party__c> objSMSFMemberMap = new Map<String, clcommon__Party__c>();
            List<Account> duplicateAccountList=new List<Account>();
            Map<String, String> objPartyIdentifierMap = new Map<String, String>();
            Map<String, clcommon__Party__c> objIdentifierPartyMap = new Map<String, clcommon__Party__c>();
            Map<String, clcommon__Party__c> objSMSFMemberPartyMap = new Map<String, clcommon__Party__c>();
            Map<String, Account> objSMSFMemberAccountMap = new Map<String, Account>();

            Map<String, id> objaccountIdentifierMap = new Map<String, id>();
            List<String> accountNameList=new List<String>();
            Map<String,Id> accountIdMap=new Map<String,Id>();
            String borrowerAccount, brokerName='';
            Set<String> brokerNameList=new Set<String>();
            Map<String,String> relatedPartyMap=new Map<String,String>();
            Map<String,String> relatedEmployerABNMap=new Map<String,String>();
            Map<String,String> relatedPartyACNMap=new Map<String,String>();
            Map<genesis__Income__c,String> objIncomeMap=new Map<genesis__Income__c,String>();
            Map<genesis__Income__c,String> objSMSFIncomeMap=new Map<genesis__Income__c,String>();
            Map<String,genesis__Income__c> objIncomeMap2=new Map<String,genesis__Income__c>();
            Map<genesis__Employment_Information__c,String> objEmploymentInfoMap=new Map<genesis__Employment_Information__c,String>();
            Map<String,Object> personMap=new Map<String,Object>();
            List<genesis__Employment_Information__c> objEmploymentInfoList=new List<genesis__Employment_Information__c>();
            Map<String,String> employerName=new Map<String,String>();
            List<genesis__Income__c> objIncomeList=new List<genesis__Income__c>();
            List<Proof_Of_Identity_Do__c> objProofList=new List<Proof_Of_Identity_Do__c>();
            Map<Proof_Of_Identity_Do__c,String> objProofMap=new Map<Proof_Of_Identity_Do__c,String>();
            Map<String,genesis__Income__c> objCompanyIncomeMap=new Map<String,genesis__Income__c>();
            String smsfAccountName;
            String objSmsfAccountName;
            Map<String,String> coApplicantMap =new Map<String,String>();
            Map<String,String> objPartyHouseholdMap =new Map<String,String>();
            List<String> checkDuplicateHouseHold=new List<String>();
            Map<String,Object> questionSegmentMap=new Map<String,Object>();
            Map<String,Object> financialSegmentMap=new Map<String,Object>();
            List<String> identifierList=new List<String>();
            Map<String,Account> objSMSFAccount=new Map<String,Account>();
            Map<String,clcommon__Party__c> securityCusPartyList=new Map<String,clcommon__Party__c>();

            if (
                ((Map<String, Object>) response.get('Envelope')) !=null &&
                ((Map<String, Object>) ((Map<String, Object>) response.get('Envelope'))
                .get('Body')) != null 
                ) {
                applicationMap=(Map<String, Object>) ((Map<String, Object>) response.get('Envelope')).get('Body');
            }
            if (
                ((Map<String,Object>)applicationMap) !=null &&
                ((Map<String, Object>) applicationMap.get('Application')) !=null &&
                ((Map<String, Object>) ((Map<String, Object>) applicationMap.get('Application'))
                .get('Identifier')) != null 
                ) {
                    brokerId=(String)((Map<String, Object>) ((Map<String, Object>) applicationMap.get('Application'))
                            .get('Identifier')).get('NodeValue');
                }
            if (
                ((Map<String,Object>)applicationMap) !=null &&
                ((Map<String, Object>) applicationMap.get('Application')) !=null &&
                ((Map<String, Object>) ((Map<String, Object>) applicationMap.get('Application'))
                .get('FinancialSegment')) != null 
                ) {
                    financialSegmentMap=(Map<String, Object>) ((Map<String, Object>) applicationMap
                            .get('Application')).get('FinancialSegment');

                }
            if (
                ((Map<String, Object>) applicationMap) !=null &&
                ((Map<String, Object>) applicationMap.get('Application')) !=null &&
                ((Map<String, Object>) ((Map<String, Object>) applicationMap.get('Application'))
                .get('QuestionSegment')) != null 
                ) {
                    questionSegmentMap=(Map<String, Object>) ((Map<String, Object>) applicationMap
                            .get('Application')).get('QuestionSegment');
            }
            if (
                ((Map<String, Object>) applicationMap) !=null &&
                ((Map<String, Object>) applicationMap.get('Application')) !=null &&
                ((Map<String, Object>) ((Map<String, Object>) applicationMap.get('Application'))
                .get('RelatedPartySegment')) != null 
                ) {
                relatedPartySegmentMap=(Map<String, Object>) ((Map<String, Object>) applicationMap
                        .get('Application')).get('RelatedPartySegment');
            }

            if (
                ((Map<String, Object>) applicationMap) !=null &&
                ((Map<String, Object>) applicationMap.get('Application')) !=null &&
                ((Map<String, Object>) ((Map<String, Object>) applicationMap.get('Application'))
                .get('PartySegment')) != null 
                ) {
                partySegmentMap=(Map<String, Object>) ((Map<String, Object>) applicationMap
                        .get('Application')).get('PartySegment');
            }
            if (
                ((Map<String, Object>) applicationMap) !=null &&
                ((Map<String, Object>) applicationMap.get('Application')) !=null &&
                ((Map<String, Object>) ((Map<String, Object>) applicationMap.get('Application'))
                .get('AddressSegment')) != null 
                ) {
                addressSegmentMap=(Map<String, Object>) ((Map<String, Object>) applicationMap
                        .get('Application')).get('AddressSegment');
            }
            List<Account> accountList=new List<Account>();
            List<clcommon__Party__c> partyList=new List<clcommon__Party__c>();
            List<clcommon__Party_Type__c> partyTypeList=[SELECT id,Name FROM clcommon__Party_Type__c ];
            List<clcommon__Legal_Entity__c> legalEntityList=[SELECT id,Name FROM clcommon__Legal_Entity__c];
            List<Telephone_Contact_Number__c> contactNumberList=new List<Telephone_Contact_Number__c>();
            List<clcommon__Address__c> addressList=new List<clcommon__Address__c>();
            List<clcommon__Address__c> addressList2=new List<clcommon__Address__c>();
            List<String> firstNameBrokerList=new List<String>();
            List<String> lastNameBrokerList=new List<String>();
            Map<String,String> addressMap=new Map<String,String>();

            brokerName=NextGenPartyCreation.salesChannelBrokerCheck(applicationMap,firstNameBrokerList,lastNameBrokerList);
            if(brokerName!=null){
                brokerNameList.add(brokerName);
            }
            
            if(brokerName != null && brokerName.contains('Pty ')){
                brokerName=brokerName.substringBefore(' Pty ');
            }else if(brokerName != null && brokerName.contains('Proprietary ')){
                brokerName=brokerName.substringBefore(' Proprietary');
            }
            if(brokerName!=null){
                brokerNameList.add(brokerName);
                brokerNameList.add(brokerName+' Pty Ltd');
                brokerNameList.add(brokerName+' Proprietary Ltd');
                brokerNameList.add(brokerName+' Proprietary Limited');
                brokerNameList.add(brokerName+' Pty Limited');
            }
            List<Account> brokerAccountList=[SELECT id,Name FROM Account WHERE Name in:brokerNameList AND loan__Broker__c=true];

            if(
                ((Map<String, Object>)relatedPartySegmentMap)!= null &&
                String.valueOf(
                    ((Map<String, Object>)relatedPartySegmentMap
                    ))
                    .contains('RelatedParty=(')
            ){
                List<Object> refRelatedParty = ((List<Object>) ((Map<String, Object>)relatedPartySegmentMap).get('RelatedParty'));
                for(Object each:refRelatedParty){
                    relatedPartyParsing(
                        (Map<String, Object>) each, 
                        relatedPartyMap, 
                        relatedEmployerABNMap, 
                        relatedPartyACNMap, 
                        employerName
                    );
                }

            }else if(
                ((Map<String, Object>)relatedPartySegmentMap)!= null &&
                String.valueOf(
                    ((Map<String, Object>)relatedPartySegmentMap
                    ))
                    .contains('RelatedParty={')
            ){
                Object refRelatedParty = ((Object) ((Map<String, Object>)relatedPartySegmentMap).get('RelatedParty'));
                relatedPartyParsing(
                    (Map<String, Object>) refRelatedParty, 
                    relatedPartyMap, 
                    relatedEmployerABNMap, 
                    relatedPartyACNMap, 
                    employerName
                );
            }
            IndividualApplicantNextGen.addressWrapper(addressSegmentMap, addressMap, contactAddressMap, collateralAddressMap);

            NextGenPartyCreation.partyRecordCreation(partySegmentMap, relatedPartyMap, relatedEmployerABNMap, identifierList);
            
            if (
                ((Map<String, Object>)partySegmentMap)!= null &&
            String.valueOf(
                ((Map<String, Object>)partySegmentMap
                ))
                .contains('Party=(')
            ) {
                List<Object> refParty = ((List<Object>) ((Map<String, Object>)partySegmentMap).get('Party'));
                for (Object each : refParty) {
                    
                    if(((String) ((Map<String, Object>) each).get('Type')) != null &&
                            ((String) ((Map<String, Object>) each).get('Type')) !='SecurityCustodian'){
                        
                        if(((Map<String, Object>) each) !=null  && 
                                ((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null ){
                            Account objAccount=new Account();
                            clcommon__Party__c objParty=new clcommon__Party__c();

                            if(((Map<String, Object>) each) !=null && 
                                    ((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null &&
                                    (String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('TrustType') !=null){

                                objParty.Trust_Structure__c = (String)((Map<String, Object>)((Map<String, Object>) each)
                                        .get('Trust')).get('TrustType');
                                if((String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('TrustType') == 'SMSF'){
                                    for(clcommon__Legal_Entity__c legalEntity:legalEntityList){
                                        if(legalEntity.Name=='SMSF'){
                                            objAccount.clcommon__Legal_Entity_Type__c=legalEntity.id;
                                        }
                                    }                               
                                }else{
                                    for(clcommon__Legal_Entity__c legalEntity:legalEntityList){
                                        if(legalEntity.Name=='Trust'){
                                            objAccount.clcommon__Legal_Entity_Type__c=legalEntity.id;
                                        }
                                    }
                                }
                            }
                            NextGenPartyCreation.trustPartyCreation((Map<String, Object>) each,objAccount,objParty,flag);
                            if(((Map<String, Object>) each) != null &&
                            ((Map<String, Object>)((Map<String, Object>) each).get('Trust'))!=null &&
                            (String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('ABN') != null){
                                objParty.Company_ABN__c = (String)((Map<String, Object>)((Map<String, Object>) each)
                                        .get('Trust')).get('ABN');
                            }
                            
                            if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Person')) != null){

                                    objParty.Trustee_Type__c='Individual';
                                    countTrustee+=1;
                                    objParty.Trustee_Name__c='';
                                    if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')) != null
                                    && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')).get('PersonName')) !=null){
                                        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('PersonName')).get('FirstName')) !=null){
                                            objParty.Trustee_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                                                    ((Map<String, Object>) each).get('Person')).get('PersonName')).get('FirstName')).get('NodeValue')+' ';
                                        }
                                        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('PersonName')).get('OtherName')) !=null){
                                            objParty.Trustee_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                                                    ((Map<String, Object>) each).get('Person')).get('PersonName')).get('OtherName')).get('NodeValue')+' ';
                                        }
                                        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('PersonName')).get('Surname')) !=null){
                                            objParty.Trustee_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                                                    ((Map<String, Object>) each).get('Person')).get('PersonName')).get('Surname')).get('NodeValue');
                                        }
                                        objAccount.Name=objParty.Trustee_Name__c+' ATF '+objAccount.Name;
                                }
                                if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')) != null
                                    && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')).get('ContactDetails')) !=null && 
                                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')).get('ContactDetails'))!=null){
        
                                        addressdetailMap=(Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each)
                                                .get('Person')).get('ContactDetails');

                                        NextGenPartyCreation.partyAddressCreation(addressdetailMap,contactAddressMap,accountAddressMap,addressCheck,objAccount);

                                }
                            }
                            else if(((Map<String, Object>) each) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Company')) != null){
                                objParty.Trustee_Type__c='Corporate';
                                if(((Map<String, Object>) each) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')) != null && 
                                        ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')).get('CompanyName')) != null &&
                                        ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')).get('CompanyName')).get('BusinessName')) != null){
                                    objParty.Trustee_Name__c=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')).get('CompanyName')).get('BusinessName');
                                }
                                if(((Map<String, Object>) each) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')) != null && 
                                        ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')).get('CompanyNumber')) != null &&
                                        ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')).get('CompanyNumber')).get('ACN')) != null){
                                    objParty.Trustee_ACN__c=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')).get('CompanyNumber')).get('ACN');
                                        
                                }
                                objAccount.Name=objParty.Trustee_Name__c+' ATF '+objAccount.Name;
                                if(((Map<String, Object>) each) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')) != null
                                        && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')).get('ContactDetails')) !=null && 
                                        ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')).get('ContactDetails'))!=null){
    
                                    addressdetailMap=(Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get('Company')).get('ContactDetails');
                                    NextGenPartyCreation.partyAddressCreation(addressdetailMap,contactAddressMap,accountAddressMap,addressCheck,objAccount);

                                }
                                NextGenPartyCreation.companyPartyCreation((Map<String, Object>) each, objAccount, objParty, objCompanyIncomeMap);

                            }
                            
                            if(((Map<String, Object>) each) != null && 
                                            ((String) ((Map<String, Object>) each).get('Type')) != null && 
                                            ((String) ((Map<String, Object>) each).get('PrimaryApplicant')) != null &&
                                            (String)((Map<String, Object>) each).get('Type')=='Applicant' &&
                                            (String)((Map<String, Object>) each).get('PrimaryApplicant')=='Yes'){
                                for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                    if(objPartyType.Name=='Borrower'){
                                        objParty.clcommon__Type__c=objPartyType.id;
                                        borrowerAccount=objAccount.Name;
                                        borrowerNameNext=objAccount.Name;
                                    }
                                }
                            }
                            if(((Map<String, Object>) each) != null && 
                                ((String) ((Map<String, Object>) each).get('Type')) != null && 
                                ((String) ((Map<String, Object>) each).get('PrimaryApplicant')) != null &&
                                (String)((Map<String, Object>) each).get('Type')=='Applicant' &&
                                (String)((Map<String, Object>) each).get('PrimaryApplicant')=='No'){
                                for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                    if(objPartyType.Name=='Co-applicant'){
                                        objParty.clcommon__Type__c=objPartyType.id;
                                    }
                                }
                            }
                            if(((Map<String, Object>) each) !=null  && 
                                    ((Map<String, Object>)((Map<String, Object>) each).get('SMSF')) != null ){
                                objSMSFAccount.put('SecurityCustodian',objAccount);
                                objPartyMap.put('SecurityCustodian',objParty);
                                objSmsfAccountName=objAccount.Name;

                            }else{
                                accountList.add(objAccount);
                                objPartyMap.put(objAccount.Name,objParty);

                            }
                                if(((Map<String, Object>) each) !=null && 
                                        ((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null &&
                                (String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('TrustType') !=null &&
                                (String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('TrustType')=='SMSF'){
                                    smsfAccountName=objAccount.Name;
                                }

                                if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Identifier')) != null){
                                        objPartyIdentifierMap.put(objAccount.Name,(String)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Identifier')).get('NodeValue'));
                                        objIdentifierPartyMap.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Identifier')).get('NodeValue'),objParty);

                                }
                        }
                        
                        if(((Map<String, Object>) each) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Person')) != null && 
                            ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Identifier'))!=null &&
                            (objSMSFMemberMap.containsKey((String)((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Identifier')).get('NodeValue')) || !objSMSFPartyMap.containsKey((String)((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Identifier')).get('NodeValue')))){
                                Account objAccount=new Account();
                                clcommon__Party__c objParty=new clcommon__Party__c();
                                if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Privacy')) != null &&
                                    ((String)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Privacy')).get('AllowDirectMarketing')) != null){
                                        objParty.Allow_Direct_Marketing__c =  (String)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Privacy')).get('AllowDirectMarketing');
                                        if(objParty.Allow_Direct_Marketing__c == 'No'){
                                                flag = false;
                                        }
                                }
                                if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Privacy')) != null &&
                                    ((String)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Privacy')).get('AllowCreditCheck')) != null){
                                        if((String)((Map<String, Object>) ((Map<String, Object>) each).get('Privacy')).get('AllowCreditCheck') == 'No'){
                                                flagCreditCheck = false;
                                        }
                                }
                                if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Privacy')) != null &&
                                    ((String)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Privacy')).get('AllowThirdPartyDisclosure')) != null){
                                        if((String)((Map<String, Object>) ((Map<String, Object>) each).get('Privacy')).get('AllowThirdPartyDisclosure') == 'No'){
                                                flagThirdParty = false;
                                        }
                                }
                                NextGenPartyCreation.individualPartyCreation((Map<String, Object>) each, objAccount, objParty, telephoneContactMap);

                                for(clcommon__Legal_Entity__c legalEntity:legalEntityList){
                                    if(legalEntity.Name=='Individual'){
                                        objAccount.clcommon__Legal_Entity_Type__c=legalEntity.id;
                                    }
                                }
                                objParty.Applicant_ever_declared_banckrupt__c='No';

                                if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')) != null
                                    && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')).get('MaritalStatus')) !=null && 
                                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')).get('MaritalStatus')).get('RelatedEntityRef')) != null){
                                        coApplicantMap.put((String)((Map<String, Object>)((Map<String, Object>)
                                                ((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Person')).get('MaritalStatus')).get('RelatedEntityRef')).get('NodeValue'),
                                                objAccount.FirstName+' '+objAccount.LastName);
                                        
                                        if(identifierList.contains((String)((Map<String, Object>)
                                                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Person')).get('MaritalStatus')).get('RelatedEntityRef')).get('NodeValue'))){
                                            objParty.Is_this_a_joint_applicant__c='Yes';
                                        }else{
                                            objParty.Is_this_a_joint_applicant__c='No';
                                        }
                                }

                                if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Identifier')) != null ){
                                        objPartyHouseholdMap.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Identifier')).get('NodeValue'),objAccount.FirstName+' '+objAccount.LastName);
                                        if (
                                            ((Map<String, Object>)questionSegmentMap)!= null &&
                                        String.valueOf(
                                            ((Map<String, Object>)questionSegmentMap
                                            ))
                                            .contains('Question=(')
                                        ) {
                                            List<Object> refQuestion = ((List<Object>) ((Map<String, Object>)questionSegmentMap).get('Question'));
                                            for (Object eachquestion : refQuestion) {
                                                questionSegmentParsing((Map<String, Object>) eachquestion, (Map<String, Object>) each,objParty);
                                            }
                                        }else if (
                                            ((Map<String, Object>)questionSegmentMap)!= null &&
                                        String.valueOf(
                                            ((Map<String, Object>)questionSegmentMap
                                            ))
                                            .contains('Question={')
                                        ) {
                                            Object eachquestion = ((Object) (questionSegmentMap).get('Question'));
                                            questionSegmentParsing((Map<String, Object>) eachquestion, (Map<String, Object>) each,objParty);
                                            
                                        }
                                }
                            

                                if(((Map<String, Object>) each) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')) != null
                                        && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('ContactDetails')) !=null && 
                                        ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('ContactDetails'))!=null){
        
                                        addressdetailMap=(Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each)
                                                .get('Person')).get('ContactDetails');
                                        if (
                                            ((Map<String, Object>)addressdetailMap)!= null &&
                                            String.valueOf(
                                            ((Map<String, Object>)addressdetailMap
                                            ))
                                            .contains('AddressDetails=(')
                                        ){
                                            List<Object> refaddress = ((List<Object>) ((Map<String, Object>)addressdetailMap)
                                                    .get('AddressDetails'));
                                                for (Object eachAddress : refaddress) {
                                                if(((Map<String, Object>) eachAddress) != null &&
                                                    ((Map<String, Object>) ((Map<String, Object>) eachAddress)
                                                    .get('RelatedEntityRef')) != null){
                                                        if(((String) ((Map<String, Object>) eachAddress).get('Residential')) == 'No' &
                                                                ((String) ((Map<String, Object>) eachAddress).get('Mailing')) == 'Yes'){
                                                            clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                            objAccount.PersonMailingStreet=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'OtherStreet');
                                                            objAccount.PersonMailingState=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'State');
                                                            objAccount.PersonMailingCity=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'City');
                                                            objAccount.PersonMailingPostalCode=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Postcode');
                                                            objAccount.PersonMailingCountry=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Country');
                                                            contactAddressMap2.put(objAccount.FirstName+objAccount.PersonEmail+'OtherAt',objAddress);
                                                            objAccount.Is_this_the_Postal_Address__pc='No';
                                                            addressCheck.put(objAccount.FirstName+objAccount.PersonEmail+'OtherAt','OtherAt');

        
                                                        }
                                                        if(((String) ((Map<String, Object>) eachAddress).get('Residential')) == 'Yes'){
                                                            clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                            
                                                            
                                                            objAccount.PersonOtherStreet=addressMap.get((String)((Map<String, Object>)
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'OtherStreet');
                                                            objAccount.PersonOtherState=addressMap.get((String)((Map<String, Object>)
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'State');
                                                            objAccount.PersonOtherCity=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'City');
                                                            objAccount.PersonOtherPostalCode=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Postcode');
                                                            objAccount.PersonOtherCountry=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Country');
                                                            contactAddressMap2.put(objAccount.FirstName+objAccount.PersonEmail+'MailAt',objAddress);
                                                            addressCheck.put(objAccount.FirstName+objAccount.PersonEmail+'MailAt','MailAt');
                                                        }
                                                }
                                            }
                                        }else if(
                                            ((Map<String, Object>)addressdetailMap)!= null &&
                                            String.valueOf(
                                            ((Map<String, Object>)addressdetailMap
                                            ))
                                            .contains('AddressDetails={')
                                        ){
                                            Object eachAddress = ((Object) (addressdetailMap).get('AddressDetails'));
                                            if(((Map<String, Object>) eachAddress) != null &&
                                                    ((Map<String, Object>) ((Map<String, Object>) eachAddress)
                                                    .get('RelatedEntityRef')) != null){
                                                        if(((String) ((Map<String, Object>) eachAddress).get('Residential')) == 'Yes'){
                                                            clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                            
                                                            objAccount.PersonOtherStreet=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'OtherStreet');
                                                            objAccount.PersonOtherState=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'State');
                                                            objAccount.PersonOtherCity=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'City');
                                                            objAccount.PersonOtherPostalCode=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Postcode');
                                                            objAccount.PersonOtherCountry=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Country');
                                                            contactAddressMap2.put(objAccount.FirstName+objAccount.PersonEmail+'MailAt',objAddress);
                                                            addressCheck.put(objAccount.FirstName+objAccount.PersonEmail+'MailAt','MailAt');

                                                        }
                                                        if(((String) ((Map<String, Object>) eachAddress).get('Residential')) == 'No' && ((String) ((Map<String, Object>) eachAddress).get('Mailing')) == 'Yes'){
                                                            clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                            
                                                            objAccount.PersonMailingStreet=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'OtherStreet');
                                                            objAccount.PersonMailingState=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'State');
                                                            objAccount.PersonMailingCity=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'City');
                                                            objAccount.PersonMailingPostalCode=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Postcode');
                                                            objAccount.PersonMailingCountry=addressMap.get((String)((Map<String, Object>) 
                                                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Country');
                                                            contactAddressMap2.put(objAccount.FirstName+objAccount.PersonEmail+'OtherAt',objAddress);
                                                            objAccount.Is_this_the_Postal_Address__pc='No';
                                                            addressCheck.put(objAccount.FirstName+objAccount.PersonEmail+'OtherAt','OtherAt');

                                                        }
                                            }
                                        }         
                            }
                            if(((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null){
                                for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                    if(objPartyType.Name=='Guarantor'){
                                        objParty.clcommon__Type__c=objPartyType.id;
                                    }
                                }
                            }else{
                                if(((Map<String, Object>) each) != null && 
                                    ((String) ((Map<String, Object>) each).get('Type')) != null && 
                                    ((String) ((Map<String, Object>) each).get('PrimaryApplicant')) != null &&
                                    (String)((Map<String, Object>) each).get('Type')=='Applicant' &&
                                    (String)((Map<String, Object>) each).get('PrimaryApplicant')=='Yes'){
                                    for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                        if(objPartyType.Name=='Borrower'){
                                            objParty.clcommon__Type__c=objPartyType.id;
                                            borrowerAccount=objAccount.FirstName+objAccount.PersonEmail;
                                            borrowerNameNext=objAccount.FirstName+objAccount.LastName;
                                        }
                                    }
                                }
                                if(((Map<String, Object>) each) != null && 
                                            ((String) ((Map<String, Object>) each).get('Type')) != null && 
                                            ((String) ((Map<String, Object>) each).get('PrimaryApplicant')) != null &&
                                            (String)((Map<String, Object>) each).get('Type')=='Applicant' &&
                                            (String)((Map<String, Object>) each).get('PrimaryApplicant')=='No'){
                                        for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                            if(objPartyType.Name=='Co-applicant'){
                                                objParty.clcommon__Type__c=objPartyType.id;
                                            }
                                        }
                                }
                                if(((Map<String, Object>) each) != null && 
                                        ((String) ((Map<String, Object>) each).get('Type')) != null &&
                                        ((String)((Map<String, Object>) each).get('Type')=='Guarantor') ||
                                        ((String)((Map<String, Object>) each).get('Type')=='SMSFMember')){
                                    for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                        if(objPartyType.Name=='Guarantor'){
                                            objParty.clcommon__Type__c=objPartyType.id;
                                        }
                                    }
                                }
                            }
                            
                            if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Person')) != null){
                                personMap=(Map<String, Object>) ((Map<String, Object>) each).get('Person');
                            }
                            //Passing More than 4 parameters else the code get more complex.

                            IndividualApplicantNextGen.individualRecordCreation(personMap,objEmploymentInfoMap,objIncomeMap,objIncomeMap2,
                                    objAccount.FirstName+objAccount.PersonEmail,objParty,employerName,relatedEmployerABNMap,relatedPartyMap);
        
                            if(((Map<String, Object>) each) != null && 
                                ((String) ((Map<String, Object>) each).get('Type')) != null &&
                                ((String)((Map<String, Object>) each).get('Type')!='SMSFMember')){
                                accountList.add(objAccount);
                                objPartyMap.put(objAccount.FirstName+objAccount.PersonEmail,objParty);
                                if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Identifier')) != null){
                                    objPartyIdentifierMap.put(objAccount.FirstName+objAccount.PersonEmail,
                                            (String)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Identifier')).get('NodeValue'));
                                    objIdentifierPartyMap.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Identifier')).get('NodeValue'),objParty);

                                }
                            }else{
                                
                                if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Identifier')) != null){
                                    objSMSFMemberPartyMap.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Identifier')).get('NodeValue'),objParty);
                                    objSMSFMemberAccountMap.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Identifier')).get('NodeValue'),objAccount);
                                }

                            }
                            

                            IndividualApplicantNextGen.proofIndentityRecord(objProofMap,((Map<String, Object>) each),
                                    objAccount.FirstName+objAccount.PersonEmail);
                            
                        }
                        if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Company')) != null &&
                                ((Map<String, Object>)((Map<String, Object>) each).get('Trust')) == null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Identifier'))!=null &&
                                (objSMSFMemberMap.containsKey((String)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Identifier')).get('NodeValue')) || 
                                !objSMSFPartyMap.containsKey((String)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Identifier')).get('NodeValue')))){
                            Account objAccount=new Account();
                            clcommon__Party__c objParty=new clcommon__Party__c();
                            if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Privacy')) != null &&
                                ((String)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Privacy')).get('AllowDirectMarketing')) != null){
                                    objParty.Allow_Direct_Marketing__c =  (String)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Privacy')).get('AllowDirectMarketing');
                                    if(objParty.Allow_Direct_Marketing__c == 'No'){
                                            flag = false;
                                    }
                            }
                            objParty.Other_Expenses__c=0;
                            objParty.Rent_Board_Monthly_Amount__c=0;
                            NextGenPartyCreation.companyPartyCreation((Map<String, Object>) each, objAccount,
                                    objParty, objCompanyIncomeMap);
                            for(clcommon__Legal_Entity__c legalEntity:legalEntityList){
                                if(legalEntity.Name=='Company'){
                                    objAccount.clcommon__Legal_Entity_Type__c=legalEntity.id;
                                }
                            }    

                                if(((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null){
                                    for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                        if(objPartyType.Name=='Guarantor'){
                                            objParty.clcommon__Type__c=objPartyType.id;
                                        }
                                    }
                                }else{
                                    if(((Map<String, Object>) each) != null && 
                                            ((String) ((Map<String, Object>) each).get('Type')) != null && 
                                            ((String) ((Map<String, Object>) each).get('PrimaryApplicant')) != null &&
                                            (String)((Map<String, Object>) each).get('Type')=='Applicant' &&
                                            (String)((Map<String, Object>) each).get('PrimaryApplicant')=='Yes'){
                                        for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                            if(objPartyType.Name=='Borrower'){
                                                objParty.clcommon__Type__c=objPartyType.id;
                                                borrowerAccount=objAccount.Name;
                                                borrowerNameNext=objAccount.Name;

                                            }
                                        }
                                    }
                                    if(((Map<String, Object>) each) != null && 
                                            ((String) ((Map<String, Object>) each).get('Type')) != null && 
                                            ((String) ((Map<String, Object>) each).get('PrimaryApplicant')) != null &&
                                            (String)((Map<String, Object>) each).get('Type')=='Applicant' &&
                                            (String)((Map<String, Object>) each).get('PrimaryApplicant')=='No'){
                                        for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                            if(objPartyType.Name=='Co-applicant'){
                                                objParty.clcommon__Type__c=objPartyType.id;
                                            }
                                        }
                                    }
                                    if(((Map<String, Object>) each) != null && 
                                        ((String) ((Map<String, Object>) each).get('Type')) != null &&
                                        ((String)((Map<String, Object>) each).get('Type')=='Guarantor') ||
                                        ((String)((Map<String, Object>) each).get('Type')=='SMSFMember')){
                                        for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                            if(objPartyType.Name=='Guarantor'){
                                                objParty.clcommon__Type__c=objPartyType.id;
                                            }
                                        }
                                    }
                                }

                                if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Company')) != null && 
                                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Company')).get('ContactDetails')) != null){
                                    addressdetailMap=(Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get('Company')).get('ContactDetails');
                                    NextGenPartyCreation.partyAddressCreation(addressdetailMap, contactAddressMap, accountAddressMap, addressCheck, objAccount);
                                }
                                if(((Map<String, Object>) each) != null && 
                                ((String) ((Map<String, Object>) each).get('Type')) != null &&
                                ((String)((Map<String, Object>) each).get('Type')!='SMSFMember')){
                                    accountList.add(objAccount);
                                    if(((Map<String, Object>) each) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Identifier')) != null){
                                            objPartyIdentifierMap.put(objAccount.Name,(String)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Identifier')).get('NodeValue'));
                                            objIdentifierPartyMap.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Identifier')).get('NodeValue'),objParty);
        
                                    }
                                    
                                    objPartyMap.put(objAccount.Name,objParty);
                                }else{
                                    if(((Map<String, Object>) each) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Identifier')) != null){
                                            objSMSFMemberPartyMap.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Identifier')).get('NodeValue'),objParty);
                                            objSMSFMemberAccountMap.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Identifier')).get('NodeValue'),objAccount);
        
                                    }
                                }
                                

                        }
                        if(((Map<String, Object>) each) !=null  && ((Map<String, Object>)((Map<String, Object>) each).get('SMSF')) != null ){
                            clcommon__Party__c objParty=objPartyMap.get('SecurityCustodian');
                        
                            if(((Map<String, Object>) each) !=null  &&
                                ((Map<String, Object>)((Map<String, Object>) each).get('SMSF')) != null &&
                                String.valueOf(
                                ((Map<String, Object>)((Map<String, Object>) each).get('SMSF')))
                                    .contains('Trustee=(')){
                                        List<Object> refTrustee = ((List<Object>) ((Map<String, Object>)((Map<String, Object>) each).get('SMSF')).get('Trustee'));
                                        for(Object eachTrustee:refTrustee){
                                            if(((Map<String, Object>) eachTrustee) !=null && ((Map<String, Object>)((Map<String, Object>) eachTrustee).get('RelatedEntityRef'))!=null){
                                                objSMSFPartyMap.put((String)((Map<String, Object>)((Map<String, Object>) eachTrustee).get('RelatedEntityRef')).get('NodeValue'),objParty);
                                            }
                                        }
                        
                                }else if(((Map<String, Object>) each) !=null  &&
                                ((Map<String, Object>)((Map<String, Object>) each).get('SMSF')) != null &&
                                String.valueOf(
                                ((Map<String, Object>)((Map<String, Object>) each).get('SMSF')))
                                    .contains('Trustee={')){
                                        Object eachTrustee = ((Object) ((Map<String, Object>)((Map<String, Object>) each).get('SMSF')).get('Trustee'));
                                        if(((Map<String, Object>) eachTrustee) !=null && ((Map<String, Object>)((Map<String, Object>) eachTrustee).get('RelatedEntityRef'))!=null){
                                            objSMSFPartyMap.put((String)((Map<String, Object>)((Map<String, Object>) eachTrustee).get('RelatedEntityRef')).get('NodeValue'),objParty);
                                        }
                                }

                                if(((Map<String, Object>) each) !=null  &&
                                ((Map<String, Object>)((Map<String, Object>) each).get('SMSF')) != null &&
                                String.valueOf(
                                ((Map<String, Object>)((Map<String, Object>) each).get('SMSF')))
                                    .contains('Member=(')){
                                        List<Object> refMember = ((List<Object>) ((Map<String, Object>)((Map<String, Object>) each).get('SMSF')).get('Member'));
                                        for(Object eachMember:refMember){
                                            if(((Map<String, Object>) eachMember) !=null && ((Map<String, Object>)((Map<String, Object>) eachMember).get('RelatedEntityRef'))!=null){
                                                objSMSFMemberMap.put((String)((Map<String, Object>)((Map<String, Object>) eachMember).get('RelatedEntityRef')).get('NodeValue'),objParty);
                                            }
                                            if(((Map<String, Object>)eachMember)!= null &&
                                                (String.valueOf(((Map<String, Object>)eachMember)).contains('Contribution=(') || 
                                                String.valueOf(((Map<String, Object>)eachMember)).contains('Contribution={'))){
                                                smfcurrentValue+=IndividualApplicantNextGen.smsfIncomeCreation((Map<String, Object>)eachMember, objSMSFIncomeMap, objSmsfAccountName,objParty);
                                            }
                                            
                                        }
                        
                                }else if(((Map<String, Object>) each) !=null  &&
                                ((Map<String, Object>)((Map<String, Object>) each).get('SMSF')) != null &&
                                String.valueOf(
                                ((Map<String, Object>)((Map<String, Object>) each).get('SMSF')))
                                    .contains('Member={')){
                                        Object eachMember = ((Object) ((Map<String, Object>)((Map<String, Object>) each).get('SMSF')).get('Member'));
                                        if(((Map<String, Object>) eachMember) !=null && ((Map<String, Object>)((Map<String, Object>) eachMember).get('RelatedEntityRef'))!=null){
                                            objSMSFMemberMap.put((String)((Map<String, Object>)((Map<String, Object>) eachMember).get('RelatedEntityRef')).get('NodeValue'),objParty);
                                        }
                                        smfcurrentValue+=IndividualApplicantNextGen.smsfIncomeCreation((Map<String, Object>)eachMember, objSMSFIncomeMap, objSmsfAccountName,objParty);
                                }
                        
                        }
                        
                        
                    }
                    
                }
            }else if (
                ((Map<String, Object>)partySegmentMap)!= null &&
                String.valueOf(
                ((Map<String, Object>)partySegmentMap
                ))
                .contains('Party={')
                ) {
                    
                    Object each = ((Object) (partySegmentMap).get('Party'));
                    
                    if(((String) ((Map<String, Object>) each).get('Type')) != null && ((String) ((Map<String, Object>) each).get('Type')) !='SecurityCustodian'){
                        
                        if(((Map<String, Object>) each) !=null  && ((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null ){
                            Account objAccount=new Account();
                            clcommon__Party__c objParty=new clcommon__Party__c();
                            
                            if(((Map<String, Object>) each) !=null && ((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null &&
                                (String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('TrustType') !=null){
                                    objParty.Trust_Structure__c = (String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('TrustType');
                                if((String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('TrustType') == 'SMSF'){
                                    for(clcommon__Legal_Entity__c legalEntity:legalEntityList){
                                        if(legalEntity.Name=='SMSF'){
                                            objAccount.clcommon__Legal_Entity_Type__c=legalEntity.id;
                                        }
                                    }
                                }else{
                                    for(clcommon__Legal_Entity__c legalEntity:legalEntityList){
                                        if(legalEntity.Name=='Trust'){
                                            objAccount.clcommon__Legal_Entity_Type__c=legalEntity.id;
                                        }
                                    }
                                }
                            }
                            
                            NextGenPartyCreation.trustPartyCreation((Map<String, Object>) each,objAccount,objParty,flag);

                            if(((Map<String, Object>) each) != null &&
                            ((Map<String, Object>)((Map<String, Object>) each).get('Trust'))!=null &&
                            (String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('ABN') != null){
                                objParty.Company_ABN__c = (String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('ABN');
                            }

                            if(((Map<String, Object>) each) != null && 
                                    ((String) ((Map<String, Object>) each).get('Type')) != null && 
                                    ((String) ((Map<String, Object>) each).get('PrimaryApplicant')) != null &&
                                    (String)((Map<String, Object>) each).get('Type')=='Applicant' &&
                                    (String)((Map<String, Object>) each).get('PrimaryApplicant')=='No'){
                                for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                    if(objPartyType.Name=='Co-applicant'){
                                        objParty.clcommon__Type__c=objPartyType.id;
                                    }
                                }
                            }
                            
                            if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Person')) != null){

                                    objParty.Trustee_Type__c='Individual';
                                    countTrustee+=1;
                                    objParty.Trustee_Name__c='';
                                    if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')) != null
                                    && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')).get('PersonName')) !=null){
                                        
                                        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('PersonName')).get('FirstName')) !=null){
                                            objParty.Trustee_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('FirstName')).get('NodeValue')+' ';
                                        }
                                        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('PersonName')).get('OtherName')) !=null){
                                            objParty.Trustee_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('OtherName')).get('NodeValue')+' ';
                                        }
                                        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('PersonName')).get('Surname')) !=null){
                                            objParty.Trustee_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('Surname')).get('NodeValue');
                                        }
                                        objAccount.Name=objParty.Trustee_Name__c+' ATF '+objAccount.Name;
                                }
                                if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')) != null
                                    && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')).get('ContactDetails')) !=null && 
                                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')).get('ContactDetails'))!=null){
        
                                        addressdetailMap=(Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get('Person')).get('ContactDetails');
                                        NextGenPartyCreation.partyAddressCreation(addressdetailMap, contactAddressMap, accountAddressMap, addressCheck, objAccount);
                                }
                            }
                            else if(((Map<String, Object>) each) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Company')) != null){
                                objParty.Trustee_Type__c='Corporate';
                                if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')) != null && 
                                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')).get('CompanyName')) != null &&
                                    ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')).get('CompanyName')).get('BusinessName')) != null){
                                        objParty.Trustee_Name__c=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')).get('CompanyName')).get('BusinessName');
                                    }
                                    if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')) != null && 
                                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')).get('CompanyNumber')) != null &&
                                    ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')).get('CompanyNumber')).get('ACN')) != null){
                                        objParty.Trustee_ACN__c=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')).get('CompanyNumber')).get('ACN');
                                        
                                    }
                                    objAccount.Name=objParty.Trustee_Name__c+' ATF '+objAccount.Name;
                                    if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')) != null
                                    && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')).get('ContactDetails')) !=null && 
                                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')).get('ContactDetails'))!=null){
        
                                        addressdetailMap=(Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get('Company')).get('ContactDetails');
                                        NextGenPartyCreation.partyAddressCreation(addressdetailMap,contactAddressMap,accountAddressMap,addressCheck,objAccount);

                                }
                                NextGenPartyCreation.companyPartyCreation((Map<String, Object>) each, objAccount, objParty, objCompanyIncomeMap);

                            }
                            
                            if(((Map<String, Object>) each) != null && 
                                            ((String) ((Map<String, Object>) each).get('Type')) != null && 
                                            ((String) ((Map<String, Object>) each).get('PrimaryApplicant')) != null &&
                                            (String)((Map<String, Object>) each).get('Type')=='Applicant' &&
                                            (String)((Map<String, Object>) each).get('PrimaryApplicant')=='Yes'){
                                for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                    if(objPartyType.Name=='Borrower'){
                                        objParty.clcommon__Type__c=objPartyType.id;
                                        borrowerAccount=objAccount.Name;
                                        borrowerNameNext=objAccount.Name;

                                    }
                                }
                            }
                            if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Trust')) != null && 
                                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Trust')).get('ContactDetails')) != null &&
                                String.valueOf(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Trust')).get('ContactDetails'))).contains('AddressDetails=(')){
                                    List<Object> refaddress = ((List<Object>) ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Trust')).get('ContactDetails')).get('AddressDetails'));
                                    for (Object eachAddress : refaddress) {
                                        if(((Map<String, Object>) eachAddress) != null &&
                                            ((Map<String, Object>) ((Map<String, Object>) eachAddress)
                                            .get('RelatedEntityRef')) != null){
                                                if(((String) ((Map<String, Object>) eachAddress).get('Residential')) == 'Yes'){
                                                    clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                    if(objAddress!=null){
                                                        accountAddressMap.put(objAccount.Name+'BillAt',objAddress);
                                                        addressCheck.put(objAccount.Name+'BillAt','BillAt');
                                                    }
                                                    
                                                }
                                                if(((String) ((Map<String, Object>) eachAddress).get('Mailing')) == 'Yes'){
                                                    objAccount.Is_the_postal_address__c='No';
                                                    clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                    if(objAddress!=null){
                                                        accountAddressMap.put(objAccount.Name+'ShipAt',objAddress);
                                                        addressCheck.put(objAccount.Name+'ShipAt','ShipAt');
                                                    }
                                                    
                                                }
                                        }
                                }
                            }else if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Trust')) != null && 
                                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Trust')).get('ContactDetails')) != null &&
                                String.valueOf(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Trust')).get('ContactDetails'))).contains('AddressDetails={')){
                                    Object eachaddress = ((Object) ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Trust')).get('ContactDetails')).get('AddressDetails'));
                                    if(((Map<String, Object>) eachAddress) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) eachAddress)
                                        .get('RelatedEntityRef')) != null){
                                            if(((String) ((Map<String, Object>) eachAddress).get('Residential')) == 'Yes'){
                                                clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                if(objAddress!=null){
                                                    accountAddressMap.put(objAccount.Name+'BillAt',objAddress);
                                                    addressCheck.put(objAccount.Name+'BillAt','BillAt');
                                                }
                                                
                                            }
                                            if(((String) ((Map<String, Object>) eachAddress).get('Mailing')) == 'Yes'){
                                                objAccount.Is_the_postal_address__c='No';
                                                clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                if(objAddress!=null){
                                                    accountAddressMap.put(objAccount.Name+'ShipAt',objAddress);
                                                    addressCheck.put(objAccount.Name+'ShipAt','ShipAt');

                                                }
                                                
                                            }
                                    }
                                }
                                accountList.add(objAccount);
                                objPartyMap.put(objAccount.Name,objParty);
                                objPartyMap.put('SecurityCustodian',objParty);
                                if(((Map<String, Object>) each) !=null && ((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null &&
                                    (String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('TrustType') !=null &&
                                    (String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('TrustType')=='SMSF'){
                                    smsfAccountName=objAccount.Name;
                                }
                                //NextGenPartyCreation.trustcoApplicantInsertion((Map<String, Object>)each, objParty, coApplicantMap,objPartyHouseholdMap);

                                if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Identifier')) != null){
                                        objPartyIdentifierMap.put(objAccount.Name,(String)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Identifier')).get('NodeValue'));
                                        objIdentifierPartyMap.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Identifier')).get('NodeValue'),objParty);
                                        
                                }
                        }
                        if(((Map<String, Object>) each) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Person')) != null){
                                Account objAccount=new Account();
                                clcommon__Party__c objParty=new clcommon__Party__c();
                                if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Privacy')) != null &&
                                ((String)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Privacy')).get('AllowDirectMarketing')) != null){
                                    objParty.Allow_Direct_Marketing__c =  (String)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Privacy')).get('AllowDirectMarketing');
                                    if(objParty.Allow_Direct_Marketing__c == 'No'){
                                            flag = false;
                                    }
                                }
                                if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Privacy')) != null &&
                                    ((String)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Privacy')).get('AllowCreditCheck')) != null){
                                        if((String)((Map<String, Object>) ((Map<String, Object>) each).get('Privacy')).get('AllowCreditCheck') == 'No'){
                                                flagCreditCheck = false;
                                        }
                                }
                                if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Privacy')) != null &&
                                    ((String)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Privacy')).get('AllowThirdPartyDisclosure')) != null){
                                        if((String)((Map<String, Object>) ((Map<String, Object>) each).get('Privacy')).get('AllowThirdPartyDisclosure') == 'No'){
                                                flagThirdParty = false;
                                        }
                                }
                            NextGenPartyCreation.individualPartyCreation((Map<String, Object>) each,objAccount,objParty,telephoneContactMap);

                            for(clcommon__Legal_Entity__c legalEntity:legalEntityList){
                                if(legalEntity.Name=='Individual'){
                                    objAccount.clcommon__Legal_Entity_Type__c=legalEntity.id;
                                }
                            }
                            objParty.Applicant_ever_declared_banckrupt__c='No';

                            if(((Map<String, Object>) each) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Person')) != null
                            && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Person')).get('MaritalStatus')) !=null && 
                            ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Person')).get('MaritalStatus')).get('RelatedEntityRef')) != null){
                                coApplicantMap.put((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Person')).get('MaritalStatus')).get('RelatedEntityRef')).get('NodeValue'),objAccount.FirstName+' '+objAccount.LastName);
                                
                                if(identifierList.contains((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Person')).get('MaritalStatus')).get('RelatedEntityRef')).get('NodeValue'))){
                                    objParty.Is_this_a_joint_applicant__c='Yes';
                                }else{
                                    objParty.Is_this_a_joint_applicant__c='No';
                                }
                            }

                            if(((Map<String, Object>) each) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Identifier')) != null ){
                                objPartyHouseholdMap.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Identifier')).get('NodeValue'),objAccount.FirstName+' '+objAccount.LastName);
                                if (
                                    ((Map<String, Object>)questionSegmentMap)!= null &&
                                String.valueOf(
                                    ((Map<String, Object>)questionSegmentMap
                                    ))
                                    .contains('Question=(')
                                ) {
                                    List<Object> refQuestion = ((List<Object>) ((Map<String, Object>)questionSegmentMap).get('Question'));
                                    for (Object eachquestion : refQuestion) {
                                        questionSegmentParsing((Map<String, Object>) eachquestion, (Map<String, Object>) each, objParty);
                                    }
                                }else if (
                                    ((Map<String, Object>)questionSegmentMap)!= null &&
                                String.valueOf(
                                    ((Map<String, Object>)questionSegmentMap
                                    ))
                                    .contains('Question={')
                                ) {
                                    Object eachquestion = ((Object) (questionSegmentMap).get('Question'));
                                    questionSegmentParsing((Map<String, Object>) eachquestion, (Map<String, Object>) each, objParty);

                                }   
                            }
                                if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')) != null
                                    && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')).get('ContactDetails')) !=null && 
                                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')).get('ContactDetails'))!=null){
        
                                        addressdetailMap=(Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get('Person')).get('ContactDetails');
                                        if (
                                            ((Map<String, Object>)addressdetailMap)!= null &&
                                            String.valueOf(
                                            ((Map<String, Object>)addressdetailMap
                                            ))
                                            .contains('AddressDetails=(')
                                        ){
                                            List<Object> refaddress = ((List<Object>) ((Map<String, Object>)addressdetailMap).get('AddressDetails'));
                                                for (Object eachAddress : refaddress) {
                                                if(((Map<String, Object>) eachAddress) != null &&
                                                    ((Map<String, Object>) ((Map<String, Object>) eachAddress)
                                                    .get('RelatedEntityRef')) != null){
                                                        if(((String) ((Map<String, Object>) eachAddress).get('Residential')) == 'Yes'){
                                                            clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                            
                                                            objAccount.PersonOtherStreet=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'OtherStreet');
                                                            objAccount.PersonOtherState=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'State');
                                                            objAccount.PersonOtherCity=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'City');
                                                            objAccount.PersonOtherPostalCode=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Postcode');
                                                            objAccount.PersonOtherCountry=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Country');
                                                            contactAddressMap2.put(objAccount.FirstName+objAccount.PersonEmail+'MailAt',objAddress);
                                                            addressCheck.put(objAccount.FirstName+objAccount.PersonEmail+'MailAt','MailAt');

                                                        }
                                                        if(((String) ((Map<String, Object>) eachAddress).get('Residential')) == 'No' && ((String) ((Map<String, Object>) eachAddress).get('Mailing')) == 'Yes'){
                                                            objAccount.Is_this_the_Postal_Address__pc='No';
                                                            clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                            
                                                            objAccount.PersonMailingStreet=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'OtherStreet');
                                                            objAccount.PersonMailingState=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'State');
                                                            objAccount.PersonMailingCity=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'City');
                                                            objAccount.PersonMailingPostalCode=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Postcode');
                                                            objAccount.PersonMailingCountry=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Country');
                                                            contactAddressMap2.put(objAccount.FirstName+objAccount.PersonEmail+'OtherAt',objAddress);
                                                            addressCheck.put(objAccount.FirstName+objAccount.PersonEmail+'OtherAt','OtherAt');

                                                        }
                                                }
                                            }
                                        }else if(
                                            ((Map<String, Object>)addressdetailMap)!= null &&
                                            String.valueOf(
                                            ((Map<String, Object>)addressdetailMap
                                            ))
                                            .contains('AddressDetails={')
                                        ){
                                            Object eachAddress = ((Object) (addressdetailMap).get('AddressDetails'));
                                            if(((Map<String, Object>) eachAddress) != null &&
                                                    ((Map<String, Object>) ((Map<String, Object>) eachAddress)
                                                    .get('RelatedEntityRef')) != null){
                                                        if(((String) ((Map<String, Object>) eachAddress).get('Residential')) == 'Yes'){
                                                            clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                            
                                                            objAccount.PersonOtherStreet=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'OtherStreet');
                                                            objAccount.PersonOtherState=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'State');
                                                            objAccount.PersonOtherCity=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'City');
                                                            objAccount.PersonOtherPostalCode=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Postcode');
                                                            objAccount.PersonOtherCountry=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Country');
                                                            contactAddressMap2.put(objAccount.FirstName+objAccount.PersonEmail+'MailAt',objAddress);
                                                            addressCheck.put(objAccount.FirstName+objAccount.PersonEmail+'MailAt','MailAt');

                                                        }
                                                        if(((String) ((Map<String, Object>) eachAddress).get('Residential')) == 'No' && ((String) ((Map<String, Object>) eachAddress).get('Mailing')) == 'Yes'){
                                                            clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                            
                                                            objAccount.PersonMailingStreet=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'OtherStreet');
                                                            objAccount.PersonMailingState=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'State');
                                                            objAccount.PersonMailingCity=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'City');
                                                            objAccount.PersonMailingPostalCode=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Postcode');
                                                            objAccount.PersonMailingCountry=addressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue')+'Country');
                                                            contactAddressMap2.put(objAccount.FirstName+objAccount.PersonEmail+'OtherAt',objAddress);
                                                            objAccount.Is_this_the_Postal_Address__pc='No';
                                                            addressCheck.put(objAccount.FirstName+objAccount.PersonEmail+'OtherAt','OtherAt');

                                                        }
                                            }
                                        }         
                            }
                            if(((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null){
                                for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                    if(objPartyType.Name=='Guarantor'){
                                        objParty.clcommon__Type__c=objPartyType.id;
                                    }
                                }
                            }else{
                                if(((Map<String, Object>) each) != null && 
                                    ((String) ((Map<String, Object>) each).get('Type')) != null && 
                                    ((String) ((Map<String, Object>) each).get('PrimaryApplicant')) != null &&
                                    (String)((Map<String, Object>) each).get('Type')=='Applicant' &&
                                    (String)((Map<String, Object>) each).get('PrimaryApplicant')=='Yes'){
                                    for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                        if(objPartyType.Name=='Borrower'){
                                            objParty.clcommon__Type__c=objPartyType.id;
                                            borrowerAccount=objAccount.FirstName+objAccount.PersonEmail;
                                            borrowerNameNext=objAccount.FirstName+objAccount.LastName;

                                        }
                                    }
                                }
                                if(((Map<String, Object>) each) != null && 
                                        ((String) ((Map<String, Object>) each).get('Type')) != null && 
                                        ((String) ((Map<String, Object>) each).get('PrimaryApplicant')) != null &&
                                        (String)((Map<String, Object>) each).get('Type')=='Applicant' &&
                                        (String)((Map<String, Object>) each).get('PrimaryApplicant')=='No'){
                                    for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                        if(objPartyType.Name=='Co-applicant'){
                                            objParty.clcommon__Type__c=objPartyType.id;
                                        }
                                    }
                                }
                                if(((Map<String, Object>) each) != null && 
                                        ((String) ((Map<String, Object>) each).get('Type')) != null &&
                                        ((String)((Map<String, Object>) each).get('Type')=='Guarantor') ||
                                        ((String)((Map<String, Object>) each).get('Type')=='SMSFMember')){
                                    for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                        if(objPartyType.Name=='Guarantor'){
                                            objParty.clcommon__Type__c=objPartyType.id;
                                        }
                                    }
                                }

                            }
                            
                            if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Person')) != null){
                                personMap=(Map<String, Object>) ((Map<String, Object>) each).get('Person');
                            }
                            IndividualApplicantNextGen.individualRecordCreation(personMap,objEmploymentInfoMap,objIncomeMap,objIncomeMap2,objAccount.FirstName+objAccount.PersonEmail,objParty,employerName,relatedEmployerABNMap,relatedPartyMap);
                            objParty.Other_Expenses__c=0;
                            objParty.Rent_Board_Monthly_Amount__c=0;
                            accountList.add(objAccount);
                            objPartyMap.put(objAccount.FirstName+objAccount.PersonEmail,objParty);
                            if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Identifier')) != null){
                                    objPartyIdentifierMap.put(objAccount.FirstName+objAccount.PersonEmail,(String)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Identifier')).get('NodeValue'));
                                    objIdentifierPartyMap.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Identifier')).get('NodeValue'),objParty);

                            }
                            IndividualApplicantNextGen.proofIndentityRecord(objProofMap,((Map<String, Object>) each),objAccount.FirstName+objAccount.PersonEmail);

                        }
                        if(((Map<String, Object>) each) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) each)
                        .get('Company')) != null && ((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null){
                            Account objAccount=new Account();
                            clcommon__Party__c objParty=new clcommon__Party__c();
                            if(((Map<String, Object>) each) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Privacy')) != null &&
                            ((String)((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Privacy')).get('AllowDirectMarketing')) != null){
                                objParty.Allow_Direct_Marketing__c =  (String)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Privacy')).get('AllowDirectMarketing');
                                if(objParty.Allow_Direct_Marketing__c == 'No'){
                                        flag = false;
                                }
                            }
                            NextGenPartyCreation.companyPartyCreation((Map<String, Object>) each, objAccount, objParty, objCompanyIncomeMap);
                                
                            for(clcommon__Legal_Entity__c legalEntity:legalEntityList){
                                if(legalEntity.Name=='Company'){
                                    objAccount.clcommon__Legal_Entity_Type__c=legalEntity.id;
                                }
                            }    
                                if(((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null){
                                    for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                        if(objPartyType.Name=='Guarantor'){
                                            objParty.clcommon__Type__c=objPartyType.id;
                                        }
                                    }
                                }else{
                                    if(((Map<String, Object>) each) != null && 
                                    ((String) ((Map<String, Object>) each).get('Type')) != null && 
                                    ((String) ((Map<String, Object>) each).get('PrimaryApplicant')) != null &&
                                    (String)((Map<String, Object>) each).get('Type')=='Applicant' &&
                                    (String)((Map<String, Object>) each).get('PrimaryApplicant')=='Yes'){
                                        for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                            if(objPartyType.Name=='Borrower'){
                                                objParty.clcommon__Type__c=objPartyType.id;
                                                borrowerAccount=objAccount.Name;
                                                borrowerNameNext=objAccount.Name;

                                            }
                                        }
                                    }
                                    if(((Map<String, Object>) each) != null && 
                                            ((String) ((Map<String, Object>) each).get('Type')) != null && 
                                            ((String) ((Map<String, Object>) each).get('PrimaryApplicant')) != null &&
                                            (String)((Map<String, Object>) each).get('Type')=='Applicant' &&
                                            (String)((Map<String, Object>) each).get('PrimaryApplicant')=='No'){
                                        for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                            if(objPartyType.Name=='Co-applicant'){
                                                objParty.clcommon__Type__c=objPartyType.id;
                                            }
                                        }
                                    }
                                    if(((Map<String, Object>) each) != null && 
                                        ((String) ((Map<String, Object>) each).get('Type')) != null &&
                                        ((String)((Map<String, Object>) each).get('Type')=='Guarantor') ||
                                        ((String)((Map<String, Object>) each).get('Type')=='SMSFMember')){
                                        for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                            if(objPartyType.Name=='Guarantor'){
                                                objParty.clcommon__Type__c=objPartyType.id;
                                            }
                                        }
                                    }
                                }
                                
                                if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')) != null && 
                                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')).get('ContactDetails')) != null &&
                                    String.valueOf(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')).get('ContactDetails'))).contains('AddressDetails=(')){
                                        List<Object> refaddress = ((List<Object>) ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Company')).get('ContactDetails')).get('AddressDetails'));
                                        for (Object eachAddress : refaddress) {
                                            if(((Map<String, Object>) eachAddress) != null &&
                                                ((Map<String, Object>) ((Map<String, Object>) eachAddress)
                                                .get('RelatedEntityRef')) != null){
                                                    if(((String) ((Map<String, Object>) eachAddress).get('Residential')) == 'Yes'){
                                                        clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                        if(objAddress != null){
                                                            accountAddressMap.put(objAccount.Name+'BillAt',objAddress);
                                                            addressCheck.put(objAccount.Name+'BillAt','BillAt');

                                                        }
                                                    }
                                                    if(((String) ((Map<String, Object>) eachAddress).get('Mailing')) == 'Yes'){
                                                        objAccount.Is_the_postal_address__c='No';
                                                        clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                        if(objAddress != null){
                                                            accountAddressMap.put(objAccount.Name+'ShipAt',objAddress);
                                                            addressCheck.put(objAccount.Name+'ShipAt','ShipAt');

                                                        }
                                                    }


                                            }
                                        }
                                    }else if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')) != null && 
                                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')).get('ContactDetails')) != null &&
                                    String.valueOf(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')).get('ContactDetails'))).contains('AddressDetails={')){
                                        Object eachAddress = ((Object) ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Company')).get('ContactDetails')).get('AddressDetails'));
                                        if(((Map<String, Object>) eachAddress) != null &&
                                                ((Map<String, Object>) ((Map<String, Object>) eachAddress)
                                                .get('RelatedEntityRef')) != null){
                                                    if(((String) ((Map<String, Object>) eachAddress).get('Residential')) == 'Yes'){
                                                        clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                        if(objAddress!=null){
                                                            accountAddressMap.put(objAccount.Name+'BillAt',objAddress);
                                                            addressCheck.put(objAccount.Name+'BillAt','BillAt');

                                                        }
                                                        
                                                    }
                                                    if(((String) ((Map<String, Object>) eachAddress).get('Mailing')) == 'Yes'){
                                                        objAccount.Is_the_postal_address__c='No';
                                                        clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                                                        if(objAddress!=null){
                                                            accountAddressMap.put(objAccount.Name+'ShipAt',objAddress);
                                                            addressCheck.put(objAccount.Name+'ShipAt','ShipAt');

                                                        }
                                                        
                                                    }
                                            }
                                    }
                            accountList.add(objAccount);
                            if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Identifier')) != null){
                                    objPartyIdentifierMap.put(objAccount.Name,(String)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Identifier')).get('NodeValue'));
                                    objIdentifierPartyMap.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Identifier')).get('NodeValue'),objParty);

                            }
                            objParty.Other_Expenses__c=0;
                            objParty.Rent_Board_Monthly_Amount__c=0;
                            objPartyMap.put(objAccount.Name,objParty);

                        }
                        if(((String) ((Map<String, Object>) each).get('Type')) != null && ((String) ((Map<String, Object>) each).get('Type')) =='SMSFMember'){
                            if(objPartyMap.containsKey('SecurityCustodian') && objPartyMap.get('SecurityCustodian')!=null){
                                clcommon__Party__c objParty=objPartyMap.get('SecurityCustodian');
                                        if(((Map<String, Object>) each) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')) != null){
                                            objParty.Trustee_Type__c='Individual';
                                            objParty.Trustee_Name__c='';
                                            countTrustee+=1;
                                            if(((Map<String, Object>) each) != null &&
                                                ((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Person')) != null
                                                && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Person')).get('PersonName')) !=null){
                                                    objParty.Trustee_Name__c='';
                                                    if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Person')).get('PersonName')).get('NameTitle')) !=null){
                                                        String nameTitle=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('NameTitle')).get('Value');
                                                        if(nameTitle=='Rev'){
                                                            objParty.Trustee_Name__c+='Other'+' ';
                                                        }else if(nameTitle=='Miss'){
                                                            objParty.Trustee_Name__c+='Ms'+' ';
                                                        }else{
                                                            objParty.Trustee_Name__c+=nameTitle+' ';
                                                        }
                                                    }
                                                    if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Person')).get('PersonName')).get('FirstName')) !=null){
                                                        objParty.Trustee_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('FirstName')).get('NodeValue')+' ';
                                                    }
                                                    if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Person')).get('PersonName')).get('OtherName')) !=null){
                                                        objParty.Trustee_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('OtherName')).get('NodeValue')+' ';
                                                    }
                                                    if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Person')).get('PersonName')).get('Surname')) !=null){
                                                        objParty.Trustee_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('Surname')).get('NodeValue');
                                                    }
                                            }
                                            }else if(((Map<String, Object>) each) != null &&
                                            ((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Company')) != null){
                                                objParty.Trustee_Type__c='Corporate';
                                                if(((Map<String, Object>) each) != null &&
                                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Company')) != null && 
                                                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Company')).get('CompanyName')) != null &&
                                                    ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Company')).get('CompanyName')).get('BusinessName')) != null){
                                                    objParty.Trustee_Name__c=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                        .get('Company')).get('CompanyName')).get('BusinessName');
                                                }
                                                if(((Map<String, Object>) each) != null &&
                                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Company')) != null && 
                                                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Company')).get('CompanyNumber')) != null &&
                                                    ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Company')).get('CompanyNumber')).get('ACN')) != null){
                                                        objParty.Trustee_ACN__c=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                        .get('Company')).get('CompanyNumber')).get('ACN');
                                                        
                                                }
                                            }
                                        objPartyMap.put(smsfAccountName,objParty);
                                        objPartyMap.put('SecurityCustodian',objParty);
                            }
                        }
                    }
                    else{
                        if(objPartyMap.containsKey('SecurityCustodian') && objPartyMap.get('SecurityCustodian')!=null){
                            clcommon__Party__c objParty=objPartyMap.get('SecurityCustodian');


                            if(((Map<String, Object>) each) !=null  && ((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null &&
                            ((String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('TrustName')) != null){
                                objParty.Property_Trust_Name__c=(String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('TrustName');
                            
                            }
                            if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Person')) != null){
                                    if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')) != null
                                    && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')).get('PersonName')) !=null){
                                        objParty.Company_Name__c='';
                                        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('PersonName')).get('NameTitle')) !=null){
                                            String nameTitle=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('NameTitle')).get('Value');
                                            if(nameTitle=='Rev'){
                                                objParty.Company_Name__c+='Other'+' ';
                                            }else if(nameTitle=='Miss'){
                                                objParty.Company_Name__c+='Ms'+' ';
                                            }else{
                                                objParty.Company_Name__c+=nameTitle+' ';
                                            }
                                        }
                                        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('PersonName')).get('FirstName')) !=null){
                                            objParty.Company_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('FirstName')).get('NodeValue')+' ';
                                        }
                                        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('PersonName')).get('OtherName')) !=null){
                                            objParty.Company_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('OtherName')).get('NodeValue')+' ';
                                        }
                                        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('PersonName')).get('Surname')) !=null){
                                            objParty.Company_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('Surname')).get('NodeValue');
                                        }
                                    }
                                }else if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Company')) != null){
                                    if(((Map<String, Object>) each) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')) != null && 
                                        ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')).get('CompanyName')) != null &&
                                        ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')).get('CompanyName')).get('BusinessName')) != null){
                                            objParty.Company_Name__c=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Company')).get('CompanyName')).get('BusinessName');
                                        }
                                }
                            objPartyMap.put(smsfAccountName,objParty);
                        }
                        
                    }
        }

        if (
                ((Map<String, Object>)partySegmentMap)!= null &&
            String.valueOf(
                ((Map<String, Object>)partySegmentMap
                ))
                .contains('Party=(')
            ) {
                List<Object> refParty = ((List<Object>) ((Map<String, Object>)partySegmentMap).get('Party'));
                for (Object each : refParty) {
                    if(((Map<String, Object>) each) != null && 
                        ((String) ((Map<String, Object>) each).get('Type')) != null &&
                        ((String)((Map<String, Object>) each).get('Type')=='SMSFMember')){
                            if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Company')) != null && 
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Identifier'))!=null &&
                                (objSMSFMemberMap.containsKey((String)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Identifier')).get('NodeValue')) || !objSMSFPartyMap.containsKey((String)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Identifier')).get('NodeValue')))){
                                
                                clcommon__Party__c objParty=objSMSFMemberPartyMap.get((String)((Map<String, Object>) ((Map<String, Object>) each).get('Identifier')).get('NodeValue'));
                                Account objAccount=objSMSFMemberAccountMap.get((String)((Map<String, Object>) ((Map<String, Object>) each).get('Identifier')).get('NodeValue'));
                                accountList.add(objAccount);
                                objPartyMap.put(objAccount.Name,objParty);
                                objPartyIdentifierMap.put(objAccount.Name,(String)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Identifier')).get('NodeValue'));
                                objIdentifierPartyMap.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Identifier')).get('NodeValue'),objParty);
                            }
                            else if(((Map<String, Object>) each) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Person')) != null && 
                            ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Identifier'))!=null &&
                            (objSMSFMemberMap.containsKey((String)((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Identifier')).get('NodeValue')) || !objSMSFPartyMap.containsKey((String)((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Identifier')).get('NodeValue')))){
                            
                                clcommon__Party__c objParty=objSMSFMemberPartyMap.get((String)((Map<String, Object>) ((Map<String, Object>) each).get('Identifier')).get('NodeValue'));
                                Account objAccount=objSMSFMemberAccountMap.get((String)((Map<String, Object>) ((Map<String, Object>) each).get('Identifier')).get('NodeValue'));
                                accountList.add(objAccount);
                                objPartyMap.put(objAccount.FirstName+objAccount.PersonEmail,objParty);
                                if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Identifier')) != null){
                                    objPartyIdentifierMap.put(objAccount.FirstName+objAccount.PersonEmail,(String)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Identifier')).get('NodeValue'));
                                    objIdentifierPartyMap.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Identifier')).get('NodeValue'),objParty);

                                }
                            }
                            if(((String) ((Map<String, Object>) each).get('Type')) != null && ((String) ((Map<String, Object>) each).get('Type')) =='SMSFMember'){
                                if(((Map<String, Object>) each)!=null && ((Map<String, Object>) ((Map<String, Object>) each).get('Identifier')) != null ){
                                    if(objSMSFPartyMap.containsKey((String)((Map<String, Object>) ((Map<String, Object>) each).get('Identifier')).get('NodeValue')) 
                                        && objSMSFPartyMap.get((String)((Map<String, Object>) ((Map<String, Object>) each).get('Identifier')).get('NodeValue'))!=null){
                                    clcommon__Party__c objParty=new clcommon__Party__c();
                                    Account objAccount=new Account();
                                    objAccount=objSMSFAccount.get('SecurityCustodian');
                                    objParty=objSMSFPartyMap.get((String)((Map<String, Object>) ((Map<String, Object>) each).get('Identifier')).get('NodeValue'));
                                    String trusteeName='';
                                    if(objAccount.Name==objSmsfAccountName &&
                                        objParty.Trustee_Name__c==null){
                                            
                                            if(((Map<String, Object>) each) != null &&
                                            ((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Person')) != null){
                                                objParty.Trustee_Type__c='Individual';
                                                countTrustee+=1;
                                                objParty.Trustee_Name__c='';
                                                if(((Map<String, Object>) each) != null &&
                                                ((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Person')) != null
                                                && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Person')).get('PersonName')) !=null){
                                                    if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Person')).get('PersonName')).get('NameTitle')) !=null){
                                                        String nameTitle=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('NameTitle')).get('Value');
                                                        if(nameTitle=='Rev'){
                                                            objParty.Trustee_Name__c+='Other'+' ';
                                                        }else if(nameTitle=='Miss'){
                                                            objParty.Trustee_Name__c+='Ms'+' ';
                                                        }else{
                                                            objParty.Trustee_Name__c+=nameTitle+' ';
                                                        }
                                                    }
                                                    if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Person')).get('PersonName')).get('FirstName')) !=null){
                                                        objParty.Trustee_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('FirstName')).get('NodeValue')+' ';
                                                        trusteeName+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('FirstName')).get('NodeValue')+' ';
                                                    }
                                                    if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Person')).get('PersonName')).get('OtherName')) !=null){
                                                        objParty.Trustee_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('OtherName')).get('NodeValue')+' ';
                                                        trusteeName+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('OtherName')).get('NodeValue')+' ';
                                                    }
                                                    if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Person')).get('PersonName')).get('Surname')) !=null){
                                                        objParty.Trustee_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('Surname')).get('NodeValue');
                                                        trusteeName+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('Surname')).get('NodeValue');

                                                    }
                                                    if(borrowerAccount==objSmsfAccountName){
                                                        borrowerAccount=trusteeName+' ATF '+objSmsfAccountName;
                                                        objAccount.Name=trusteeName+' ATF '+objSmsfAccountName;
                                                    }else{
                                                        for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                                            if(objPartyType.Name=='Co-applicant'){
                                                                objParty.clcommon__Type__c=objPartyType.id;
                                                            }
                                                        }
                                                    }
                                            }
                                            if(((Map<String, Object>) each) != null &&
                                                ((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Person')) != null
                                                && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Person')).get('ContactDetails')) !=null && 
                                                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Person')).get('ContactDetails'))!=null){
                            
                                                    addressdetailMap=(Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get('Person')).get('ContactDetails');
                                                    NextGenPartyCreation.partyAddressCreation(addressdetailMap,contactAddressMap,accountAddressMap,addressCheck,objAccount);
                                                    
                                            }
                                        }
                                        else if(((Map<String, Object>) each) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')) != null){
                                            objParty.Trustee_Type__c='Corporate';
                                            if(((Map<String, Object>) each) != null &&
                                                ((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Company')) != null && 
                                                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Company')).get('CompanyName')) != null &&
                                                ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Company')).get('CompanyName')).get('BusinessName')) != null){
                                                    objParty.Trustee_Name__c=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Company')).get('CompanyName')).get('BusinessName');
                                                }
                                                if(((Map<String, Object>) each) != null &&
                                                ((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Company')) != null && 
                                                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Company')).get('CompanyNumber')) != null &&
                                                ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Company')).get('CompanyNumber')).get('ACN')) != null){
                                                    objParty.Trustee_ACN__c=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                    .get('Company')).get('CompanyNumber')).get('ACN');
                                                    
                                                }
                                                trusteeName=objParty.Trustee_Name__c;
                                                if(borrowerAccount==objAccount.Name){
                                                    borrowerAccount=trusteeName+' ATF '+objSmsfAccountName;
                                                }else{
                                                    for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                                        if(objPartyType.Name=='Co-applicant'){
                                                            objParty.clcommon__Type__c=objPartyType.id;
                                                        }
                                                    }
                                                }
                                                objAccount.Name=trusteeName+' ATF '+objSmsfAccountName;
                            
                                                if(((Map<String, Object>) each) != null &&
                                                ((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Company')) != null
                                                && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Company')).get('ContactDetails')) !=null && 
                                                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Company')).get('ContactDetails'))!=null){
                            
                                                    addressdetailMap=(Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get('Company')).get('ContactDetails');
                                                    NextGenPartyCreation.partyAddressCreation(addressdetailMap,contactAddressMap,accountAddressMap,addressCheck,objAccount);
                                                    
                                                }
                                                    NextGenPartyCreation.companyPartyCreation((Map<String, Object>) each, objAccount, objParty, objCompanyIncomeMap);
                            
                                                }
                                            objAccount.Name=trusteeName+' ATF '+objSmsfAccountName;
                                            accountList.add(objAccount);
                                            objPartyMap.put(objAccount.Name,objParty);
                                            objPartyMap.put('SecurityCustodian',objParty);
                                            securityCusPartyList.put(objAccount.Name,objParty);
                                            smsfAccountName=objAccount.Name;    
                                    
                                    }else{
                                        clcommon__Party__c objParty1=objParty.clone(false,false,false,false);
                                        Account objAccount1=objAccount.clone(false,false,false,false);
                                        objAccount1.Name='';
                                        objParty1.Trustee_Name__c='';
                                        if(((Map<String, Object>) each) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')) != null){
                                            objParty1.Trustee_Type__c='Individual';
                                            countTrustee+=1;
                                            objParty1.Trustee_Name__c='';
                                            if(((Map<String, Object>) each) != null &&
                                            ((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Person')) != null
                                            && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Person')).get('PersonName')) !=null){
                                                if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Person')).get('PersonName')).get('NameTitle')) !=null){
                                                    String nameTitle=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('NameTitle')).get('Value');
                                                    if(nameTitle=='Rev'){
                                                        objParty1.Trustee_Name__c+='Other'+' ';
                                                    }else if(nameTitle=='Miss'){
                                                        objParty1.Trustee_Name__c+='Ms'+' ';
                                                    }else{
                                                        objParty1.Trustee_Name__c+=nameTitle+' ';
                                                    }
                                                }
                                                if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Person')).get('PersonName')).get('FirstName')) !=null){
                                                    objParty1.Trustee_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('FirstName')).get('NodeValue')+' ';
                                                    trusteeName+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('FirstName')).get('NodeValue')+' ';

                                                }
                                                if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Person')).get('PersonName')).get('OtherName')) !=null){
                                                    objParty1.Trustee_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('OtherName')).get('NodeValue')+' ';
                                                    trusteeName+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('OtherName')).get('NodeValue')+' ';

                                                }
                                                if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Person')).get('PersonName')).get('Surname')) !=null){
                                                    objParty1.Trustee_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('Surname')).get('NodeValue');
                                                    trusteeName+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('Surname')).get('NodeValue');

                                                }
                                                if(borrowerAccount==objSmsfAccountName){
                                                    borrowerAccount=trusteeName+' ATF '+objSmsfAccountName;
                                                }else{
                                                    for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                                        if(objPartyType.Name=='Co-applicant'){
                                                            objParty1.clcommon__Type__c=objPartyType.id;
                                                        }
                                                    }
                                                }
                                                objAccount1.Name=trusteeName+' ATF '+objSmsfAccountName;
                                        }
                                        if(((Map<String, Object>) each) != null &&
                                            ((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Person')) != null
                                            && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Person')).get('ContactDetails')) !=null && 
                                            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Person')).get('ContactDetails'))!=null){
                                
                                                addressdetailMap=(Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get('Person')).get('ContactDetails');
                                                NextGenPartyCreation.partyAddressCreation(addressdetailMap,contactAddressMap,accountAddressMap,addressCheck,objAccount1);
                                                
                                        }
                                    }
                                    else if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Company')) != null){
                                        objParty1.Trustee_Type__c='Corporate';
                                        if(((Map<String, Object>) each) != null &&
                                            ((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Company')) != null && 
                                            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Company')).get('CompanyName')) != null &&
                                            ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Company')).get('CompanyName')).get('BusinessName')) != null){
                                                objParty1.Trustee_Name__c=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Company')).get('CompanyName')).get('BusinessName');
                                            }
                                            if(((Map<String, Object>) each) != null &&
                                            ((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Company')) != null && 
                                            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Company')).get('CompanyNumber')) != null &&
                                            ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Company')).get('CompanyNumber')).get('ACN')) != null){
                                                objParty1.Trustee_ACN__c=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                                .get('Company')).get('CompanyNumber')).get('ACN');
                                                
                                            }
                                            trusteeName=objParty1.Trustee_Name__c;
                                            if(borrowerAccount==objAccount1.Name){
                                                borrowerAccount=trusteeName+' ATF '+objSmsfAccountName;
                                            }else{
                                                for(clcommon__Party_Type__c objPartyType:partyTypeList){
                                                    if(objPartyType.Name=='Co-applicant'){
                                                        objParty1.clcommon__Type__c=objPartyType.id;
                                                    }
                                                }
                                            }
                                            objAccount1.Name=trusteeName+' ATF '+objSmsfAccountName;
                                
                                            if(((Map<String, Object>) each) != null &&
                                            ((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Company')) != null
                                            && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Company')).get('ContactDetails')) !=null && 
                                            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Company')).get('ContactDetails'))!=null){
                                
                                                addressdetailMap=(Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get('Company')).get('ContactDetails');
                                                NextGenPartyCreation.partyAddressCreation(addressdetailMap,contactAddressMap,accountAddressMap,addressCheck,objAccount1);
                                                
                                            }
                                                NextGenPartyCreation.companyPartyCreation((Map<String, Object>) each, objAccount1, objParty1, objCompanyIncomeMap);
                                
                                            }
                                        objAccount1.Name=trusteeName+' ATF '+objSmsfAccountName;
                                        accountList.add(objAccount1);
                                        objPartyMap.put(objAccount1.Name,objParty1);
                                        objPartyMap.put('SecurityCustodian',objParty1);
                                        smsfAccountName=objAccount1.Name;
                                        securityCusPartyList.put(objAccount1.Name,objParty1);

                                    }
                                }
                                }
                            }
                    }
                    else if(((String) ((Map<String, Object>) each).get('Type')) != null &&
                        ((String) ((Map<String, Object>) each).get('Type')) =='SecurityCustodian' &&
                        objPartyMap.containsKey('SecurityCustodian') && objPartyMap.get('SecurityCustodian')!=null){
                        for(String key:securityCusPartyList.keySet()){
                            clcommon__Party__c objParty=securityCusPartyList.get(key);
                            if(((Map<String, Object>) each) !=null  && ((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null &&
                            ((String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('TrustName')) != null){
                                objParty.Property_Trust_Name__c=(String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('TrustName');
                            
                            }
                            if(((Map<String, Object>) each) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Person')) != null){
                                if(((Map<String, Object>) each) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')) != null
                                    && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                    .get('Person')).get('PersonName')) !=null){
                                        objParty.Company_Name__c='';
                                        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('PersonName')).get('NameTitle')) !=null){
                                            String nameTitle=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('NameTitle')).get('Value');
                                            if(nameTitle=='Rev'){
                                                objParty.Company_Name__c+='Other'+' ';
                                            }else if(nameTitle=='Miss'){
                                                objParty.Company_Name__c+='Ms'+' ';
                                            }else{
                                                objParty.Company_Name__c+=nameTitle+' ';
                                            }
                                        }
                                        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('PersonName')).get('FirstName')) !=null){
                                            objParty.Company_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('FirstName')).get('NodeValue')+' ';
                                        }
                                        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('PersonName')).get('OtherName')) !=null){
                                            objParty.Company_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('OtherName')).get('NodeValue')+' ';
                                        }
                                        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Person')).get('PersonName')).get('Surname')) !=null){
                                            objParty.Company_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('PersonName')).get('Surname')).get('NodeValue');
                                        }
                                }
                                }else if(((Map<String, Object>) each) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('Company')) != null){
                                    if(((Map<String, Object>) each) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')) != null && 
                                        ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')).get('CompanyName')) != null &&
                                        ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Company')).get('CompanyName')).get('BusinessName')) != null){
                                            objParty.Company_Name__c=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                                            .get('Company')).get('CompanyName')).get('BusinessName');
                                        }
                                }
                            objPartyMap.put(key,objParty);
                        }
                        
                    }
                }
            }

        for(String key:coApplicantMap.keySet()){
            if(objPartyHouseholdMap.containsKey(key) && objPartyHouseholdMap.get(key)!=null 
                    && checkDuplicateHouseHold!=null && !checkDuplicateHouseHold.contains(coApplicantMap.get(key))){
                checkDuplicateHouseHold.add(objPartyHouseholdMap.get(key));
                Account objAccount=new Account();
                clcommon__Party__c objParty = new clcommon__Party__c();
                objAccount.Name=objPartyHouseholdMap.get(key)+' & '+coApplicantMap.get(key);
                accountNameList.add(objPartyHouseholdMap.get(key));
                accountNameList.add(coApplicantMap.get(key));
                for(clcommon__Legal_Entity__c legalEntity:legalEntityList){
                    if(legalEntity.Name=='Joint'){
                        objAccount.clcommon__Legal_Entity_Type__c=legalEntity.id;
                    }
                }

                for(clcommon__Party_Type__c objPartyType:partyTypeList){
                    if(objPartyType.Name=='HouseHold'){
                        objParty.clcommon__Type__c=objPartyType.id;
                    }
                }
                objParty.Other_Expenses__c=0;
                objParty.Rent_Board_Monthly_Amount__c=0;
                accountList.add(objAccount);
                objPartyMap.put(objAccount.Name,objParty);
                objIdentifierPartyMap.put(key,objParty);
                for(String key2:objPartyHouseholdMap.keySet()){
                    if(coApplicantMap.get(key)==objPartyHouseholdMap.get(key2)){
                        objIdentifierPartyMap.put(key2,objParty);

                    }
                }

            }
        }

        Map<String,Object> loanDetailSegmentMap=new Map<String,Object>();
        if (
            ((Map<String,Object>)applicationMap) !=null &&
            ((Map<String, Object>) applicationMap.get('Application')) !=null &&
            ((Map<String, Object>) ((Map<String, Object>) applicationMap.get('Application'))
            .get('LoanDetailSegment')) != null 
            ) {
                loanDetailSegmentMap=(Map<String, Object>) ((Map<String, Object>) applicationMap.get('Application')).get('LoanDetailSegment');
        }
        List<genesis__Applications__c> objApplicationList=new List<genesis__Applications__c>();
        NextGenLoanDetailCreation.LoanDetailRecordCreation(loanDetailSegmentMap,financialSegmentMap,objApplicationList,accountList,borrowerAccount);
        if(objApplicationList.size()>0){
            String result=SkuidValuesUpdateHelper.updateFirstPaymentDate(objApplicationList[0].id);
        }
        if (
            ((Map<String,Object>)applicationMap) !=null &&
            ((Map<String, Object>) applicationMap.get('Application')) !=null &&
            ((Map<String, Object>) ((Map<String, Object>) applicationMap.get('Application'))
            .get('Identifier')) != null && objApplicationList.size()>0
            ) {
                if(((String)((Map<String, Object>) ((Map<String, Object>) applicationMap.get('Application')).get('Identifier')).get('NodeValue')).contains('-')){
                    objApplicationList[0].Originator_ID__c=(String)((Map<String, Object>) (
                                    (Map<String, Object>) applicationMap.get('Application')).get('Identifier')).get('NodeValue');
                }else{
                    objApplicationList[0].Originator_ID__c=(String)((Map<String, Object>) (
                            (Map<String, Object>) applicationMap.get('Application')).get('Identifier')).get('NodeValue')+'-NGN';
                }
            }
            if(objApplicationList.size()>0){
                NextGenLoanDetailCreation.loanSolicitorDetails(relatedPartySegmentMap, objApplicationList[0]);
            }

            Set<Account> accountSet=new Set<Account>();
            List<Account> accountList2=new List<Account>();
            List<Account> accountList3=new List<Account>();
            
            if(accountList.size()>0){
                accountList2=NextGenLoanDetailCreation.CheckDuplicateAccount(accountList,duplicateAccountList);
            }
            accountSet.addAll(accountList2);
            accountList3.addAll(accountSet);
            
            List<Contact> objContactList=[SELECT id,FirstName,Email,AccountId FROM Contact WHERE AccountId IN: duplicateAccountList];
            for(Account objAccount:accountList3){

                for(clcommon__Legal_Entity__c legalEntity:legalEntityList){
                    if(legalEntity.Name=='Individual' && objAccount.clcommon__Legal_Entity_Type__c==legalEntity.id){
                        accountIdMap.put(
                        objAccount.FirstName +
                        objAccount.PersonEmail,
                        objAccount.Id);
                        accountLegalentityMap.put(
                        objAccount.FirstName +
                        objAccount.PersonEmail,
                        legalEntity.id);
                    }else if(objAccount.clcommon__Legal_Entity_Type__c==legalEntity.id){
                        accountIdMap.put(
                            objAccount.Name,
                            objAccount.Id);
                            accountLegalentityMap.put(
                                objAccount.Name,objAccount.clcommon__Legal_Entity_Type__c);
                            if(duplicateAccountList.size()>0 &&
                                    duplicateAccountList.contains(objAccount)){
                                accountIdMap.put(
                                objAccount.Name+'ShipAt',
                                objAccount.Id);
                                accountIdMap.put(
                                objAccount.Name+'BillAt',
                                objAccount.Id);
                            }
                            
                    }
                }
                
            }
            for(genesis__Applications__c application:objApplicationList){
                application.genesis__Account__c=accountIdMap.get(borrowerAccount);
                application.Legal_Entity__c=accountLegalentityMap.get(borrowerAccount);
                if(flag ==  false){
                    application.Allow_Direct_Marketing__c = 'No';
                }
                else{
                    application.Allow_Direct_Marketing__c = 'Yes';
                }
                if(flagCreditCheck ==  false){
                    application.Allow_Credit_Check__c = 'No';
                }
                else{
                    application.Allow_Credit_Check__c = 'Yes';
                }
                if(flagThirdParty ==  false){
                    application.signed_the_Privacy_Act_Consent__c = 'No';
                }
                else{
                    application.signed_the_Privacy_Act_Consent__c = 'Yes';
                }
            }
            if(objApplicationList.size()>0){
                insert objApplicationList;
            }
            if(objApplicationList.size()>0){
                GenericUtility.createAttachment('NextGenRequest_'+String.valueOf(DateTime.now())+'.txt',
                params,
                objApplicationList[0].id
                );
            }
            for (Contact eachContact : objContactList) {
                    contactIdMap.put(
                        eachContact.FirstName +
                        eachContact.Email+'Mobile',
                        eachContact.Id
                    );
                    contactIdMap.put(
                        eachContact.FirstName +
                        eachContact.Email+'Home Phone',
                        eachContact.Id
                    );
                    contactIdMap.put(
                        eachContact.FirstName +
                        eachContact.Email+'Work Phone',
                        eachContact.Id
                    );
                    contactIdMap.put(
                        eachContact.FirstName +
                        eachContact.Email+'MailAt',
                        eachContact.Id
                    );
                    contactIdMap.put(
                        eachContact.FirstName +
                        eachContact.Email+'OtherAt',
                        eachContact.Id
                    );
                    contactIdMap.put(
                        eachContact.FirstName +
                        eachContact.Email,
                        eachContact.Id
                    );
            }
            for (String key : telephoneContactMap.keySet()) {
                Telephone_Contact_Number__c telephoneNumber = telephoneContactMap.get(key);
                telephoneNumber.Contact__c = contactIdMap.get(key);
                contactNumberList.add(telephoneNumber);
            }
            if(contactNumberList.size()>0){
                Database.insert(contactNumberList, false);
            }
            Set<clcommon__Address__c> addressSet=new Set<clcommon__Address__c>();
            for (String key :contactAddressMap2.keySet()) {
                if(contactAddressMap2.containsKey(key) && 
                        contactAddressMap2.get(key)!=null && addressCheck.containsKey(key) &&
                        addressCheck.get(key)=='MailAt' ){
                    clcommon__Address__c objAddress = new clcommon__Address__c();
                    if((contactAddressMap2.get(key)).clcommon__Contact__c==null &&
                            (contactAddressMap2.get(key)).clcommon__Account__c==null){
                        objAddress = contactAddressMap2.get(key);
                        if(contactIdMap.containsKey(key) && contactIdMap.get(key)!=null && objAddress!=null ){
                            objAddress.clcommon__Contact__c = contactIdMap.get(key);
                        }
                        objAddress.Mail_At__c=true;
                        objAddress.Other_At__c=false;
                        addressList.add(objAddress);
                    }else{
                        objAddress = (contactAddressMap2.get(key)).clone(false,false,false,false);
                        if(contactIdMap.containsKey(key) && contactIdMap.get(key)!=null && objAddress!=null ){
                            objAddress.clcommon__Contact__c = contactIdMap.get(key);
                        }
                        objAddress.clcommon__Account__c=null;
                        objAddress.Mail_At__c=true;
                        objAddress.Other_At__c=false;
                        addressList.add(objAddress);
                    }
                }
                if(contactAddressMap2.containsKey(key) && 
                        contactAddressMap2.get(key)!=null && 
                        addressCheck.containsKey(key) && 
                        addressCheck.get(key)=='OtherAt'){
                    clcommon__Address__c objAddress =new clcommon__Address__c();
                    if((contactAddressMap2.get(key)).clcommon__Contact__c==null && 
                            (contactAddressMap2.get(key)).clcommon__Account__c==null){
                        objAddress = contactAddressMap2.get(key);
                        objAddress.id=null;
                        if(contactIdMap.containsKey(key) && contactIdMap.get(key)!=null && objAddress!=null){
                            objAddress.clcommon__Contact__c = contactIdMap.get(key);
                        }
                        objAddress.Mail_At__c=false;
                        objAddress.Other_At__c=true;
                        addressList.add(objAddress);
                    }else{
                        objAddress = (contactAddressMap2.get(key)).clone(false,false,false,false);
                        if(contactIdMap.containsKey(key) && contactIdMap.get(key)!=null && objAddress!=null){
                            objAddress.clcommon__Contact__c = contactIdMap.get(key);
                        }
                        objAddress.clcommon__Account__c=null;
                        objAddress.id=null;
                        objAddress.Mail_At__c=false;
                        objAddress.Other_At__c=true;
                        addressList.add(objAddress);
                    }
                }
            
            }
            for(String key:accountAddressMap.keySet()){
                if(accountAddressMap.containsKey(key) && 
                        accountAddressMap.get(key)!=null && 
                        addressCheck.containsKey(key) && 
                        addressCheck.get(key)=='BillAt'
                ){
                    clcommon__Address__c objAddress = new clcommon__Address__c();
                    if((accountAddressMap.get(key)).clcommon__Contact__c==null &&
                            (accountAddressMap.get(key)).clcommon__Account__c==null){
                        objAddress = accountAddressMap.get(key);
                        objAddress.clcommon__Account__c = accountIdMap.get(key);
                        objAddress.Bill_At__c=true;
                        objAddress.Ship_At__c=false;
                        addressList.add(objAddress);
                    }else{
                        objAddress = (accountAddressMap.get(key)).clone(false,false,false,false);
                        objAddress.clcommon__Account__c = accountIdMap.get(key);
                        objAddress.clcommon__Contact__c =null;
                        objAddress.Bill_At__c=true;
                        objAddress.Ship_At__c=false;
                        addressList.add(objAddress);
                    }
                }
                if(accountAddressMap.containsKey(key) && accountAddressMap.get(key)!=null 
                && addressCheck.containsKey(key) && addressCheck.get(key)=='ShipAt'){
                    clcommon__Address__c objAddress =new clcommon__Address__c();
                    if((accountAddressMap.get(key)).clcommon__Contact__c==null && (accountAddressMap.get(key)).clcommon__Account__c==null){
                        objAddress = accountAddressMap.get(key);
                        objAddress.id=null;
                        objAddress.clcommon__Account__c = accountIdMap.get(key);
                        objAddress.Bill_At__c=false;
                        objAddress.Ship_At__c=true;
                        addressList.add(objAddress);
                    }else{
                        objAddress = (accountAddressMap.get(key)).clone(false,false,false,false);
                        objAddress.clcommon__Account__c = accountIdMap.get(key);
                        objAddress.clcommon__Contact__c=null;
                        objAddress.id=null;
                        objAddress.Bill_At__c=false;
                        objAddress.Ship_At__c=true;
                        addressList.add(objAddress);
                    }
                }
            }
            addressSet.addAll(addressList);
            addressList2.addAll(addressSet);
            if(addressList2.size()>0){
                Database.insert(addressList2,true);
            }
            
            clcommon__Party__c objBrokerParty = new clcommon__Party__c();
            List<Contact> objBrokerContactList=[SELECT id FROM Contact WHERE FirstName in: firstNameBrokerList AND LastName in: lastNameBrokerList];
            
            if(brokerAccountList.size()>0){
                objBrokerParty.clcommon__Account__c = brokerAccountList[0].id;
                if(objApplicationList.size()>0){
                    objBrokerParty.genesis__Application__c=objApplicationList[0].id;
                }
                for(clcommon__Party_Type__c objPartyType:partyTypeList){
                    if(objPartyType.Name==ConstantValues.BROKER_PARTY_TYPE){
                        objBrokerParty.clcommon__Type__c=objPartyType.id;
                    }
                }
                if(objBrokerContactList.size()>0){
                    objBrokerParty.Broker_Underwriter__c=objBrokerContactList[0].id;
                }
                partyList.add(objBrokerParty);
                
            }else{
                returnValue+='Broker is Missing.';
            }
            
            for(String key : objPartyMap.keySet()){
                if(key!='SecurityCustodian'){
                    clcommon__Party__c objParty = objPartyMap.get(key);
                    objParty.clcommon__Account__c = accountIdMap.get(key);
                    objParty.clcommon__Contact__c = contactIdMap.get(key);
                    if(objApplicationList.size()>0){
                        objParty.genesis__Application__c=objApplicationList[0].id;
                        if(objApplicationList[0].Document_Type__c=='Alt Doc'){
                            objParty.Document_Type__c='Alt';
                        }
                        else{
                            objParty.Document_Type__c='Full';
                        }
                    }
                    if(objParty.ABN_Company_Name__c==null && key.contains('ATF ')){
                        objParty.ABN_Company_Name__c=(key).substringAfter('ATF ');
                        if(objParty.Trustee_Type__c=='Individual'){
                            objParty.Number_Of_Trustees__c=countTrustee;
                        }
                        objParty.Total_Current_Income_Period__c=smfcurrentValue;
                    }
                    objaccountIdentifierMap.put(objPartyIdentifierMap.get(key),accountIdMap.get(key));
                    partyList.add(objParty);
                }
                
            }
            if(partyList.size()>0){
                insert partyList;
            }

            
            List<clcommon__Party__c> objPartyList=[SELECT id,
                                                        Application_ID__c,
                                                        ABN_Company_Name__c,
                                                        clcommon__Account__c,
                                                        clcommon__Account__r.Name,
                                                        clcommon__Account__r.clcommon__Legal_Entity_Type__c,
                                                        clcommon__Account__r.FirstName,
                                                        clcommon__Account__r.PersonEmail 
                                                    FROM clcommon__Party__c 
                                                    WHERE id in: partyList];
            for(clcommon__Party__c objParty:objPartyList){
                for(clcommon__Legal_Entity__c legalEntity:legalEntityList){
                    if(legalEntity.Name=='Individual' && objParty.clcommon__Account__r.clcommon__Legal_Entity_Type__c==legalEntity.id){
                        partyIdMap.put(
                            objParty.clcommon__Account__r.FirstName +
                            objParty.clcommon__Account__r.PersonEmail,
                            objParty.Id);
                        partyIdMap.put(
                            objParty.clcommon__Account__r.FirstName +
                            objParty.clcommon__Account__r.PersonEmail+'Retired',
                            objParty.Id);
                        partyIdMap.put(
                            objParty.clcommon__Account__r.FirstName +
                            objParty.clcommon__Account__r.PersonEmail+'Unemployed',
                            objParty.Id);
                    }else if(objParty.clcommon__Account__r.clcommon__Legal_Entity_Type__c==legalEntity.id){
                        partyIdMap.put(
                            objParty.clcommon__Account__r.Name+'Current'+'Profit Before Tax',
                            objParty.Id);
                        partyIdMap.put(
                            objParty.clcommon__Account__r.Name+'Previous'+'Profit Before Tax',
                            objParty.Id);
                        partyIdMap.put(
                                objParty.clcommon__Account__r.Name+'Current'+'Depreciation',
                                objParty.Id);
                        partyIdMap.put(
                        objParty.clcommon__Account__r.Name+'Previous'+'Depreciation',
                        objParty.Id);
                        partyIdMap.put(
                            objParty.clcommon__Account__r.Name+'Current'+'Non Cash Benefits',
                            objParty.Id);
                        partyIdMap.put(
                        objParty.clcommon__Account__r.Name+'Previous'+'Non Cash Benefits',
                        objParty.Id);
                        partyIdMap.put(
                            objParty.clcommon__Account__r.Name+'Current'+'Non Recurring Expenses',
                            objParty.Id);
                        partyIdMap.put(
                                objParty.clcommon__Account__r.Name+'Previous'+'Non Recurring Expenses',
                                objParty.Id);
                        
                    }
                }
                if(objParty.ABN_Company_Name__c!=null){
                    partyIdMap.put(
                            (objParty.ABN_Company_Name__c).substringAfter('ATF '),
                            objParty.Id);
                    objParty.ABN_Company_Name__c=(objParty.ABN_Company_Name__c).substringAfter('ATF ');
                }
            }
            if(objPartyList.size()>0){
                update objPartyList;
            }
            for(genesis__Employment_Information__c key :objEmploymentInfoMap.keySet()){
                genesis__Employment_Information__c objEmpInfo=key;
                objEmpInfo.Party__c=partyIdMap.get(objEmploymentInfoMap.get(key));
                if(objApplicationList.size()>0){
                    objEmpInfo.genesis__Application__c=objApplicationList[0].id;
                    if(objApplicationList[0].Document_Type__c=='Alt Doc'){
                        objEmpInfo.Document_Type__c='Alt';
                    }
                }
                objEmploymentInfoList.add(objEmpInfo);
            }
            if(objEmploymentInfoList.size()>0){
                Database.insert(objEmploymentInfoList,false);
            }
            for(Proof_Of_Identity_Do__c key : objProofMap.keySet()){
                Proof_Of_Identity_Do__c objProofIdentity=key;
                objProofIdentity.Party__c=partyIdMap.get(objProofMap.get(key));
                objProofList.add(objProofIdentity);
            }
            if(objProofList.size()>0){
                Database.insert(objProofList,false);
            }
            RecordType selfEmplRecordType=[SELECT id,Name FROM RecordType WHERE DeveloperName ='Self_Employed'];
            for(genesis__Employment_Information__c employmentInfo:objEmploymentInfoList){
                if(employmentInfo.PAYG_Employment__c==true){
                    employmentIdMap.put(employmentInfo.Company_Name__c+'PAYG',employmentInfo.id);
                }else{
                    employmentIdMap.put(employmentInfo.Company_Name__c,employmentInfo.id);
                    employmentInfo.recordTypeId=selfEmplRecordType.id;
                }
            }
            if(objEmploymentInfoList.size()>0){
                update objEmploymentInfoList;
            }
            for(genesis__Income__c key :objIncomeMap.keySet()){
                genesis__Income__c objIncome=key;
                objIncome.Employment_Information__c=employmentIdMap.get(objIncomeMap.get(key));
                if(objApplicationList.size()>0){
                    objIncome.genesis__Application__c=objApplicationList[0].id;
                    if(objApplicationList[0].Document_Type__c=='Alt Doc'){
                        objIncome.Document_Type__c='Alt';
                        if((objIncome.Business_Income_Type__c=='Profit Before Tax' || objIncome.Business_Income_Type__c==null)
                            && (objIncome.Business_Income_Period__c=='Current' || objIncome.Business_Income_Period__c==null)){
                                objIncomeList.add(objIncome);
                        }
                    }else{
                        objIncomeList.add(objIncome);
                    }
                }
                
            }
            for(String key :objIncomeMap2.keySet()){
                genesis__Income__c objIncome=objIncomeMap2.get(key);
                objIncome.Party__c=partyIdMap.get(key);
                if(objApplicationList.size()>0){
                    objIncome.genesis__Application__c=objApplicationList[0].id;
                    if(objApplicationList[0].Document_Type__c=='Alt Doc'){
                        objIncome.Document_Type__c='Alt';
                    }
                }
                objIncomeList.add(objIncome);
            }
            for(String key:objCompanyIncomeMap.keySet()){
                genesis__Income__c objIncome=objCompanyIncomeMap.get(key);
                objIncome.Party__c=partyIdMap.get(key);
                if(objApplicationList.size()>0){
                    objIncome.genesis__Application__c=objApplicationList[0].id;
                    if(objApplicationList[0].Document_Type__c=='Alt Doc'){
                        objIncome.Document_Type__c='Alt';
                    }
                }
                objIncomeList.add(objIncome);
            }
            for(genesis__Income__c key:objSMSFIncomeMap.keySet()){
                genesis__Income__c objIncome=key;
                objIncome.Party__c=partyIdMap.get(objSMSFIncomeMap.get(key));
                if(objApplicationList.size()>0){
                    objIncome.genesis__Application__c=objApplicationList[0].id;
                    if(objApplicationList[0].Document_Type__c=='Alt Doc'){
                        objIncome.Document_Type__c='Alt';
                    }else{
                        objIncome.Document_Type__c='Full';
                        objIncome.Income_Full__c=true;
                    }
                }
                objIncomeList.add(objIncome);
            }
            if(objIncomeList.size()>0){
                Database.insert(objIncomeList,false);
            }
            List<genesis__Income__c> objIncomeInfoList=[SELECT id,
                                                            Employment_Information__c,
                                                            Employment_Information__r.Party__c,
                                                            Party__c,Party__r.id 
                                                            FROM genesis__Income__c 
                                                            WHERE id in:objIncomeList];
            for(genesis__Income__c objIncomeInfo:objIncomeInfoList){
                if(objIncomeInfo.Employment_Information__c!=null){
                    objIncomeInfo.Party__c=objIncomeInfo.Employment_Information__r.Party__c;
                }
            }
            if(objIncomeInfoList.size()>0){
                update objIncomeInfoList;
            }

                Map<String,String> ownerDetailMap=new Map<String,String>();
                List<clcommon__Collateral_Owner__c> collOwnerList=new List<clcommon__Collateral_Owner__c>();
                List<clcommon__Collateral__c> objCollateralList=new List<clcommon__Collateral__c>();

                if(objApplicationList.size()>0){
                    ownerDetailMap=NextGenCollateralCreation.CollateralRecordCreation(collateralAddressMap,loanDetailSegmentMap,financialSegmentMap,objApplicationList[0].id);
                

                objCollateralList=[SELECT id,
                                        Name,
                                        clcommon__Collateral_Name__c 
                                    FROM clcommon__Collateral__c 
                                    WHERE id IN (SELECT genesis__Collateral__c 
                                                        FROM genesis__Application_Collateral__c 
                                                        WHERE genesis__Application__c =: objApplicationList[0].id)];

                }
                
                List <clcommon__Party__c> partyList2 = [SELECT Id,
                                                        Application_ID__c,
                                                        clcommon__Account__c,
                                                        Legal_Entity_Type__c,
                                                        clcommon__Account__r.FirstName,
                                                        clcommon__Account__r.LastName,
                                                        genesis__Application__r.Name,
                                                        clcommon__Type__r.Name,
                                                        Rent_Board_Monthly_Amount__c,
                                                        Clothing_Personal_Care__c,
                                                        Childcare_Monthly_Income__c,
                                                        Maintenance_Alimony__c,
                                                        Education_excluding_Private_School_Fees__c,
                                                        Education_Private_School_Fees__c,
                                                        Other_Expenses__c,
                                                        Groceries__c,
                                                        Insurance__c,Investment_Property_Costs__c,
                                                        Medical_Health__c,
                                                        Primary_Residence_Property_Costs__c,
                                                        Recreation_Entertainment__c,
                                                        Telephone_Media_Streaming_Amount__c,
                                                        Private_Health_Life_and_IP_Insurance__c,
                                                        Transport_Monthly_Amount__c,
                                                        genesis__Application__r.Legal_Entity__c
                                                        FROM clcommon__Party__c 
                                                        WHERE id in: partyList
                                                        ORDER BY genesis__Application__c];
                partyList.clear();

                for(clcommon__Party__c objParty:partyList2){
                    for(clcommon__Legal_Entity__c legalEntity:legalEntityList){
                        if(legalEntity.Name=='Trust' && objParty.genesis__Application__r.Legal_Entity__c==legalEntity.id){
                            if(objParty.clcommon__Type__r.Name=='Borrower' 
                                    || objParty.clcommon__Type__r.Name=='Co-applicant'){
                                partyList.add(objParty);
                            } 
                        }else if(objParty.genesis__Application__r.Legal_Entity__c==legalEntity.id){
                            if(objParty.clcommon__Type__r.Name=='Borrower' 
                                    || objParty.clcommon__Type__r.Name=='Co-applicant' 
                                    || objParty.clcommon__Type__r.Name=='Guarantor'){
                                partyList.add(objParty);
                            } 
                        }
                    }
                }
                for(clcommon__Collateral__c objCollateral:objCollateralList){
                    if(ownerDetailMap.get(objCollateral.clcommon__Collateral_Name__c)=='OwnedByAllApplicants'){
                        for(clcommon__Party__c objParty:partyList){
                            clcommon__Collateral_Owner__c collOwner=new clcommon__Collateral_Owner__c();
                            collOwner.clcommon__Collateral__c=objCollateral.id;
                            collOwner.clcommon__Account__c=objParty.clcommon__Account__c;
                            Integer countColl=partyList.size();
                            Decimal result = (decimal)1/countColl*100;
                            collOwner.clcommon__Ownership__c=result;
                            collOwnerList.add(collOwner);
                        }
                    }
                    if(ownerDetailMap.get(objCollateral.clcommon__Collateral_Name__c)=='PercentOwned'){
                        if(
                            ((Map<String, Object>)financialSegmentMap)!= null &&
                            String.valueOf(
                                ((Map<String, Object>)financialSegmentMap
                                ))
                                .contains('ValueItem=(')
                        ){ 
                            List<Object> refValueItem = ((List<Object>) ((Map<String, Object>)financialSegmentMap).get('ValueItem'));
                            for(Object eachValueItem : refValueItem){
                                if(((Map<String, Object>) eachValueItem) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                    .get('Asset')) !=null &&
                                    ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                    .get('Asset')).get('Class')) !=null &&
                                    ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                    .get('Asset')).get('Class'))=='CurrentSecurity'){
                                if(
                                    ((Map<String, Object>)eachValueItem)!= null &&
                                    String.valueOf(
                                    ((Map<String, Object>)eachValueItem
                                    ))
                                    .contains('PercentOwned=(')){
                                        List<Object> refPercentOwned = ((List<Object>) ((Map<String, Object>)eachValueItem).get('PercentOwned'));
                                        for(Object eachPercentOwned:refPercentOwned){
                                            clcommon__Collateral_Owner__c collOwner=new clcommon__Collateral_Owner__c();
                                            if(((Map<String,Object>)eachPercentOwned)!=null &&
                                                ((Map<String,Object>)((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')) !=null){
                                                collOwner.clcommon__Account__c=objaccountIdentifierMap.get((String)((Map<String,Object>)((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue'));
                                            }
                                            if(((Map<String,Object>)eachPercentOwned)!=null &&
                                                ((String)((Map<String,Object>)eachPercentOwned).get('Percent')) !=null){
                                                collOwner.clcommon__Ownership__c=Decimal.valueOf((String)((Map<String,Object>)eachPercentOwned).get('Percent'));
                                            }
                                            collOwner.clcommon__Collateral__c=objCollateral.id;
                                            collOwnerList.add(collOwner);
                                        }
                                    }else if(
                                        ((Map<String, Object>)eachValueItem)!= null &&
                                        String.valueOf(
                                        ((Map<String, Object>)eachValueItem
                                        ))
                                        .contains('PercentOwned={')){
                                            Object eachPercentOwned = ((Object) ((Map<String, Object>)eachValueItem).get('PercentOwned'));
                                                clcommon__Collateral_Owner__c collOwner=new clcommon__Collateral_Owner__c();
                                                if(((Map<String,Object>)eachPercentOwned)!=null &&
                                                    ((Map<String,Object>)((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')) !=null){
                                                    collOwner.clcommon__Account__c=objaccountIdentifierMap.get((String)((Map<String,Object>)((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue'));
                                                }
                                                if(((Map<String,Object>)eachPercentOwned)!=null &&
                                                    ((String)((Map<String,Object>)eachPercentOwned).get('Percent')) !=null){
                                                    collOwner.clcommon__Ownership__c=Decimal.valueOf((String)((Map<String,Object>)eachPercentOwned).get('Percent'));
                                                }
                                                collOwner.clcommon__Collateral__c=objCollateral.id;
                                                collOwnerList.add(collOwner);
                                            
                                        }
                                    }
                            }
                        }else if(
                            ((Map<String, Object>)financialSegmentMap)!= null &&
                            String.valueOf(
                                ((Map<String, Object>)financialSegmentMap
                                ))
                                .contains('ValueItem={')
                        ){ 
                            Object eachValueItem = ((Object) ((Map<String, Object>)financialSegmentMap).get('ValueItem'));
                            if(((Map<String, Object>) eachValueItem) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                        .get('Asset')) !=null &&
                                        ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                        .get('Asset')).get('Class')) !=null &&
                                        ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                        .get('Asset')).get('Class'))=='CurrentSecurity'){
                                if(
                                    ((Map<String, Object>)eachValueItem)!= null &&
                                    String.valueOf(
                                    ((Map<String, Object>)eachValueItem
                                    ))
                                    .contains('PercentOwned=(')){
                                        List<Object> refPercentOwned = ((List<Object>) ((Map<String, Object>)eachValueItem).get('PercentOwned'));
                                        
                                        for(Object eachPercentOwned:refPercentOwned){
                                            clcommon__Collateral_Owner__c collOwner=new clcommon__Collateral_Owner__c();
                                            if(((Map<String,Object>)eachPercentOwned)!=null &&
                                                ((Map<String,Object>)((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')) !=null){
                                                collOwner.clcommon__Account__c=objaccountIdentifierMap.get((String)((Map<String,Object>)(
                                                            (Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue'));
                                            }
                                            if(((Map<String,Object>)eachPercentOwned)!=null &&
                                                ((String)((Map<String,Object>)eachPercentOwned).get('Percent')) !=null){
                                                collOwner.clcommon__Ownership__c=Decimal.valueOf((String)((Map<String,Object>)eachPercentOwned).get('Percent'));
                                            }
                                            collOwner.clcommon__Collateral__c=objCollateral.id;
                                            collOwnerList.add(collOwner);
                                        }
                                    }else if(
                                        ((Map<String, Object>)eachValueItem)!= null &&
                                        String.valueOf(
                                        ((Map<String, Object>)eachValueItem
                                        ))
                                        .contains('PercentOwned={')){
                                            Object eachPercentOwned = ((Object) ((Map<String, Object>)eachValueItem).get('PercentOwned'));
                                                clcommon__Collateral_Owner__c collOwner=new clcommon__Collateral_Owner__c();
                                                if(((Map<String,Object>)eachPercentOwned)!=null &&
                                                    ((Map<String,Object>)((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')) !=null){
                                                    collOwner.clcommon__Account__c=objaccountIdentifierMap.get((String)((Map<String,Object>)((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue'));
                                                }
                                                if(((Map<String,Object>)eachPercentOwned)!=null &&
                                                    ((String)((Map<String,Object>)eachPercentOwned).get('Percent')) !=null){
                                                    collOwner.clcommon__Ownership__c=Decimal.valueOf((String)((Map<String,Object>)eachPercentOwned).get('Percent'));
                                                }
                                                collOwner.clcommon__Collateral__c=objCollateral.id;
                                                collOwnerList.add(collOwner);
                                            
                                        }
                                    }
                        }
                    }
                }
                partyList.clear();

                for(clcommon__Party__c objParty:partyList2){
                    if(objParty.clcommon__Type__r.Name=='Borrower' 
                            || objParty.clcommon__Type__r.Name=='Co-applicant' 
                            || objParty.clcommon__Type__r.Name=='Guarantor'){
                        if(!accountNameList.contains(objParty.clcommon__Account__r.FirstName+' '+objParty.clcommon__Account__r.LastName) 
                                && (objParty.Legal_Entity_Type__c=='Individual' || objParty.Legal_Entity_Type__c=='Joint')){
                            partyList.add(objParty);
                        }
                    }else if(objParty.clcommon__Type__r.Name=='HouseHold' && 
                            (objParty.Legal_Entity_Type__c=='Individual' || objParty.Legal_Entity_Type__c=='Joint')) {
                        partyList.add(objParty);
                    }              
                }
                if(objApplicationList.size()>0){
                    //Passing More than 4 parameters else the code get more complex.
                    NextGenCollateralCreation.AssetLiabilityRecordCreation(financialSegmentMap, partyList, 
                            objApplicationList[0].id, addressMap, relatedPartyMap,objIdentifierPartyMap);
                }
                
            if(collOwnerList.size()>0){
                Database.insert(collOwnerList,false);
            }
            returnValue+=''+'Application is Created Successfully';
            if(objPartyList.size()>0){
                returnValue+=' '+objPartyList[0].Application_ID__c;
                applicationId=objPartyList[0].Application_ID__c;
            }
            return returnValue;
        }catch(Exception ex){
            GenericUtility.insertLog(
                'NextGenApplicationHelper',
                ex
            );

            String body='';
            if(brokerId!='' || brokerId!=null){
                body+='NextGen Application Id: '+brokerId+'\n';
            }
            if(applicationId!=null){
                body+='Salesforce Application Id :'+applicationId+'\n';
            }
            body+='Error-> '+ex.getMessage();
            if(borrowerNameNext!=null){
                body+='\n Borrower Name :'+borrowerNameNext;
            }
            
            String subject='Application Creation Fails';
            String recieverAddressTwo=System.Label.Anna_Email;
            String recieverAddressOne=System.Label.Rosie_Johnston_Email;
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {recieverAddressOne,recieverAddressTwo};
            message.optOutPolicy = 'FILTER';
            message.subject = subject;
            message.plainTextBody = body;
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            return ConstantValues.GENERAL_ERROR;
        }
    }

    public static void relatedPartyParsing(
        Map<String,Object> each,
        Map<String,String> relatedPartyMap,
        Map<String,String> relatedEmployerABNMap,
        Map<String,String> relatedPartyACNMap,
        Map<String,String> employerName
    ){
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('CompanyName')) !=null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Identifier')) !=null &&
            ((String)((Map<String, Object>) ((Map<String, Object>) each)
            .get('CompanyName')).get('BusinessName')) !=null){
            relatedPartyMap.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Identifier')).get('NodeValue'),
                    (String)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('CompanyName')).get('BusinessName'));

                if(((String)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('CompanyName')).get('ABN')) !=null){
                    relatedEmployerABNMap.put(((String)((Map<String, Object>) ((Map<String, Object>) each)
                            .get('Identifier')).get('NodeValue')),
                            ((String)((Map<String, Object>) ((Map<String, Object>) each)
                            .get('CompanyName')).get('ABN')));
                }
        }
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('CompanyNumber')) !=null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Identifier')) !=null &&
            ((String)((Map<String, Object>) ((Map<String, Object>) each)
            .get('CompanyNumber')).get('ABN')) !=null){
            relatedEmployerABNMap.put(((String)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Identifier')).get('NodeValue')),
                    ((String)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('CompanyNumber')).get('ABN')));
        }
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('CompanyNumber')) !=null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Identifier')) !=null &&
            ((String)((Map<String, Object>) ((Map<String, Object>) each)
            .get('CompanyNumber')).get('ACN')) !=null){
            relatedPartyACNMap.put(((String)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Identifier')).get('NodeValue')),
                    ((String)((Map<String, Object>) ((Map<String, Object>) each).get('CompanyNumber')).get('ACN')));
        }
        String fullEmployerName;
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('PersonName')) !=null &&
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('PersonName')).get('NameTitle')) !=null){
                fullEmployerName=(String)((Map<String, Object>)((Map<String, Object>) 
                        ((Map<String, Object>) each).get('PersonName')).get('NameTitle')).get('Value');
        }
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('PersonName')) !=null &&
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('PersonName')).get('FirstName')) !=null){
                fullEmployerName+=' '+(String)((Map<String, Object>)((Map<String, Object>) 
                        ((Map<String, Object>) each).get('PersonName')).get('FirstName')).get('NodeValue');
        }
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('PersonName')) !=null &&
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('PersonName')).get('AlsoKnownAs')) !=null){
            fullEmployerName+=' '+(String)((Map<String, Object>)((Map<String, Object>) 
                    ((Map<String, Object>) each).get('PersonName')).get('AlsoKnownAs')).get('NodeValue');
        }
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('PersonName')) !=null &&
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('PersonName')).get('Surname')) !=null){
            fullEmployerName+=' '+(String)((Map<String, Object>)((Map<String, Object>) 
                    ((Map<String, Object>) each).get('PersonName')).get('Surname')).get('NodeValue');
        }
        if(((Map<String, Object>) each) != null &&
            fullEmployerName !=null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Identifier')) !=null){
            employerName.put((String)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Identifier')).get('NodeValue'),fullEmployerName);
            
        }
    }

    public static void questionSegmentParsing(Map<String, Object> eachquestion,Map<String, Object> each,clcommon__Party__c objParty){

        if(((Map<String, Object>) eachquestion) !=null  && 
                ((String)((Map<String, Object>) eachquestion).get('Code')) != null &&
                ((String)((Map<String, Object>) eachquestion).get('Code')) == 'bankruptcy' &&
                ((String)((Map<String, Object>) eachquestion).get('Response')) != null &&
                ((String)((Map<String, Object>) eachquestion).get('Response')) == 'Yes' &&
                ((Map<String, Object>)((Map<String, Object>) eachquestion).get('RelatedEntityRef')) != null && 
                ((String)((Map<String, Object>)((Map<String, Object>) eachquestion)
                .get('RelatedEntityRef')).get('NodeValue')) != null){
            if((String)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Identifier')).get('NodeValue')==(String)((Map<String, Object>)((Map<String, Object>) eachquestion).get('RelatedEntityRef')).get('NodeValue')){
                objParty.Applicant_ever_declared_banckrupt__c='Yes';
            }
        }
    }
}