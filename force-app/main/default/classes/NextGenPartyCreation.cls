/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class is for inserting Individual,Company,Trust Party Creation,Address Creation 
                        and checking Broker is present Party Creation.
Development Date : 10/04/2022
Last Modified Date : 18/05/2022
Devloper's comment : Some part of the codes are hardcoded and not been put in Constant Classes - since
                    they are referenced only here and its a one time use.
****************************************************************************************************/

public class NextGenPartyCreation {

    //Individual Party Record Parsing
    public static void individualPartyCreation(
        Map<String, Object> each,
        Account objAccount,
        clcommon__Party__c objParty,
        Map<String, Telephone_Contact_Number__c> telephoneContactMap
    ){
        Date currentSysDate =(Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
        Map<String,Object> homePhoneMap=new Map<String,Object>();
        Map<String,Object> addressdetailMap=new Map<String,Object>();
        Map<String,Object> workPhoneMap=new Map<String,Object>();

        objParty.Other_Expenses__c=0;
        objParty.Rent_Board_Monthly_Amount__c=0;
        
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')) != null
            && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('PersonName')) !=null){
            if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                .get('Person')).get('PersonName')).get('NameTitle')) !=null){
                String nameTitle=(String)((Map<String, Object>)
                    ((Map<String, Object>)((Map<String, Object>) 
                    ((Map<String, Object>) each).get('Person')).get('PersonName')).get('NameTitle')).get('Value');
                if(nameTitle=='Rev'){
                    objAccount.Salutation='Other';
                }else if(nameTitle=='Miss'){
                    objAccount.Salutation='Ms';
                }else{
                    objAccount.Salutation=nameTitle;
                }
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('PersonName')).get('FirstName')) !=null){
                objAccount.FirstName=(String)((Map<String, Object>)((Map<String, Object>)
                    ((Map<String, Object>) ((Map<String, Object>) each).get('Person'))
                    .get('PersonName')).get('FirstName')).get('NodeValue');
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                .get('Person')).get('PersonName')).get('OtherName')) !=null){
            objAccount.MiddleName=(String)((Map<String, Object>)((Map<String, Object>)
                    ((Map<String, Object>) ((Map<String, Object>) each).get('Person'))
                    .get('PersonName')).get('OtherName')).get('NodeValue');
        }
            if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                .get('Person')).get('PersonName')).get('Surname')) !=null){
                objAccount.LastName=(String)((Map<String, Object>)((Map<String, Object>)
                        ((Map<String, Object>) ((Map<String, Object>) each).get('Person'))
                        .get('PersonName')).get('Surname')).get('NodeValue');
            }
        }
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')) != null
            && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
        .get('Person')).get('DateOfBirth')) !=null){
            
            String dateOfBirth = (String)((Map<String, Object>)
                    ((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('DateOfBirth')).get('NodeValue');
            if (dateOfBirth != null && dateOfBirth.length() > 9) {
                objAccount.PersonBirthdate= Date.newInstance(
                    Integer.valueOf(dateOfBirth.substring(0, 4)),
                    Integer.valueOf(dateOfBirth.substring(5, 7)),
                    Integer.valueOf(dateOfBirth.substring(8, 10))
                );
            }
            
        }
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')) != null
            && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('MaritalStatus')) !=null){
                if((String)((Map<String, Object>)((Map<String, Object>) 
                    ((Map<String, Object>) each).get('Person')).get('MaritalStatus')).get('Status')=='DeFacto'){
                    objAccount.clcommon__Marital_Status__pc='De Facto';
                }else{
                    objAccount.clcommon__Marital_Status__pc=(String)((Map<String, Object>)
                        ((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('MaritalStatus')).get('Status');
                }
            }
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')) != null
            && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('ContactDetails')) !=null && 
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('ContactDetails'))!=null){

            addressdetailMap=(Map<String, Object>)((Map<String, Object>)
                    ((Map<String, Object>)each).get('Person')).get('ContactDetails');
            if (
                ((Map<String, Object>)addressdetailMap)!= null &&
                String.valueOf(
                ((Map<String, Object>)addressdetailMap
                ))
                .contains('AddressDetails=(')
            ){
                List<Object> refaddress = ((List<Object>) ((Map<String, Object>)addressdetailMap).get('AddressDetails'));
                    for (Object eachAddress : refaddress) {
                        if(((String) ((Map<String, Object>) eachAddress).get('HousingStatus')) != null){
                            String housingStatus = (String) ((Map<String, Object>) eachAddress).get('HousingStatus');
                            objAccount.Housing_Status__pc = housingStatus == 'Caravan' ? 'Other': 
                                housingStatus == 'OwnHomeMortgage' ? 'Own Home Mortgage': 
                                housingStatus == 'OwnHome' ? 'Own Home': 
                                housingStatus == 'WithParents' ? 'With Parents': housingStatus;
                        }
                        if(((Map<String, Object>) eachAddress) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachAddress)
                            .get('StartAndEndDates')) != null && 
                            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachAddress)
                            .get('StartAndEndDates')).get('StartDate')) != null){
                            String startDate = (String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachAddress).get('StartAndEndDates')).get('StartDate')).get('NodeValue');
                            Date addressYear;
                            if (startDate != null && startDate.length() > 9) {
                                addressYear= Date.newInstance(
                                    Integer.valueOf(startDate.substring(0, 4)),
                                    Integer.valueOf(startDate.substring(5, 7)),
                                    Integer.valueOf(startDate.substring(8, 10))
                                );
                            }
                            if(addressYear!=null){
                                objAccount.clcommon__Years_At_Current_Address__pc=(addressYear.monthsBetween(currentSysDate)/12);
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
                if(((String) ((Map<String, Object>) eachAddress).get('HousingStatus')) != null){
                    String housingStatus = (String) ((Map<String, Object>) eachAddress).get('HousingStatus');
                    objAccount.Housing_Status__pc = housingStatus == 'Caravan' ? 'Other': 
                            housingStatus == 'OwnHomeMortgage' ? 'Own Home Mortgage': 
                            housingStatus == 'OwnHome' ? 'Own Home': 
                            housingStatus == 'WithParents' ? 'With Parents': housingStatus;
                }
                if(((Map<String, Object>) eachAddress) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachAddress)
                    .get('StartAndEndDates')) != null && 
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachAddress)
                    .get('StartAndEndDates')).get('StartDate')) != null){
                    String startDate = (String)((Map<String, Object>)((Map<String, Object>) 
                            ((Map<String, Object>) eachAddress).get('StartAndEndDates')).get('StartDate')).get('NodeValue');
                    Date addressYear;
                    if (startDate != null && startDate.length() > 9) {
                        addressYear= Date.newInstance(
                            Integer.valueOf(startDate.substring(0, 4)),
                            Integer.valueOf(startDate.substring(5, 7)),
                            Integer.valueOf(startDate.substring(8, 10))
                        );
                    }
                    if(addressYear!=null){
                        objAccount.clcommon__Years_At_Current_Address__pc=(addressYear.monthsBetween(currentSysDate)/12);
                    }
                }
            }
        }
        if(((Map<String, Object>) each) != null &&
        ((Map<String, Object>) ((Map<String, Object>) each)
        .get('Privacy')) != null &&
        String.ValueOf(((Map<String, Object>) ((Map<String, Object>) each)
        .get('Privacy'))).contains('PointVerification=(')){
            List<Object> refVerfication=((List<Object>) ((Map<String, Object>) 
                    ((Map<String, Object>) each).get('Privacy')).get('PointVerification'));
            for(Object eachVerification:refVerfication){
                if(((Map<String, Object>)eachVerification) !=null &&
                ((String)((Map<String, Object>)eachVerification).get('DocumentType')) !=null &&
                ((String)((Map<String, Object>)eachVerification).get('DocumentNumber')) !=null){
                    String documentType=(String)((Map<String, Object>)eachVerification).get('DocumentType');
                    if(documentType=='DriversLicenceAust'){
                        objAccount.ints__Driver_License__pc=(String)(
                                    (Map<String, Object>)eachVerification).get('DocumentNumber');
                    }
                }
            }
        }else if(((Map<String, Object>) each) != null &&
        ((Map<String, Object>) ((Map<String, Object>) each)
        .get('Privacy')) != null &&
        String.ValueOf(((Map<String, Object>) ((Map<String, Object>) each)
        .get('Privacy'))).contains('PointVerification={')){
            Object eachVerification=((Object) ((Map<String, Object>) 
                    ((Map<String, Object>) each).get('Privacy')).get('PointVerification'));
            if(((Map<String, Object>)eachVerification) !=null &&
                ((String)((Map<String, Object>)eachVerification).get('DocumentType')) !=null &&
                ((String)((Map<String, Object>)eachVerification).get('DocumentNumber')) != null){
                String documentType=(String)((Map<String, Object>)eachVerification).get('DocumentType');
                if(documentType=='DriversLicenceAust'){
                    objAccount.ints__Driver_License__pc=(String)(
                                (Map<String, Object>)eachVerification).get('DocumentNumber');
                }
            }
        }
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')) != null && String.valueOf(
                ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Person')))
            .contains('Dependent=(')){
                List<Object> refDependent = ((List<Object>) ((Map<String, Object>) 
                        ((Map<String, Object>) each).get('Person')).get('Dependent'));
                objAccount.Number_Of_Dependents__pc=0;
                Integer ages;
                for(Object eachDependent:refDependent){
                    if( ((Map<String, Object>) eachDependent)!=null &&
                        ((String)((Map<String, Object>) eachDependent).get('Age'))!=null){
                            ages=Integer.valueOf((String)((Map<String, Object>) eachDependent).get('Age'));
                            objAccount.Number_Of_Dependents__pc+=1;
                    }
                    if(objAccount.Ages__pc!=null){
                        objAccount.Ages__pc+=','+String.valueOf(ages);
                    }else{
                        objAccount.Ages__pc=String.valueOf(ages);
                    }
                }                
        }else if(((Map<String, Object>) each) != null &&
        ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')) != null && String.valueOf(
                ((Map<String, Object>) ((Map<String, Object>) each)
                .get('Person')))
        .contains('Dependent={')){
            Object eachDependent = ((Object) ((Map<String, Object>) 
                    ((Map<String, Object>) each).get('Person')).get('Dependent'));
            if( ((Map<String, Object>) eachDependent)!=null &&
                ((String)((Map<String, Object>) eachDependent).get('Age'))!=null){
                    objAccount.Ages__pc=(String)((Map<String, Object>) eachDependent).get('Age');
                    objAccount.Number_Of_Dependents__pc=1;
                    
                }
        }else{
            objAccount.Number_Of_Dependents__pc=0;

        }
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')) != null
            && ((String)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('Sex')) !=null){
            objAccount.Gender__pc=(String)((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('Sex');
        }
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')) != null
            && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
        .get('Person')).get('Residency')) !=null && 
        ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('Residency')).get('Status'))!=null){
                String residenyStatus=(String)((Map<String, Object>)
                        ((Map<String, Object>) ((Map<String, Object>) each).get('Person')).get('Residency')).get('Status');
                if(residenyStatus=='Citizen'){
                    objAccount.Australian_Citizen__pc='Yes';
                }else{
                    objAccount.Australian_Citizen__pc='No';
                }
                if(residenyStatus=='Citizen' || residenyStatus=='NonResident' || residenyStatus=='PermanentResident' ){
                    objAccount.clcommon__Residential_Status__pc='Permanent';
                }else{
                    objAccount.clcommon__Residential_Status__pc='Temporary';
                }
            }
            if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')) != null
            && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('Residency')) !=null && 
            ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('Residency')).get('Country'))!=null ){
                if(((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                .get('Person')).get('Residency')).get('Country')).get('ISO3166'))!=null && 
                (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                .get('Person')).get('Residency')).get('Country')).get('ISO3166')=='AU'){
                    objAccount.Applicant_reside_in_Australia__pc='Yes';
                }else{
                    objAccount.Applicant_reside_in_Australia__pc='No';
                }

            }
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')) != null
            && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('ContactDetails')) !=null && 
            ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('ContactDetails')).get('Email'))!=null){
            objAccount.PersonEmail=(String)((Map<String, Object>)
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Person')).get('ContactDetails')).get('Email')).get('NodeValue');
        }
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')) != null
            && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('ContactDetails')) !=null && 
            ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('ContactDetails')).get('HomePhone'))!=null){
                homePhoneMap=(Map<String, Object>)((Map<String, Object>)
                        ((Map<String, Object>) ((Map<String, Object>) each)
                        .get('Person')).get('ContactDetails')).get('HomePhone');
                if (
                    ((Map<String, Object>)homePhoneMap)!= null &&
                    String.valueOf(
                        ((Map<String, Object>)homePhoneMap
                        ))
                    .contains('Phone=(')
                ){
                    List<Object> refPhone = ((List<Object>) ((Map<String, Object>)homePhoneMap).get('Phone'));
                    for (Object eachPhone : refPhone) {
                        if(((Map<String, Object>) eachPhone) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                            .get('FixedPhone')) != null){
                                Telephone_Contact_Number__c contactNumber=new Telephone_Contact_Number__c();
                                contactNumber.Phone_Type__c='Home Phone';
                                if((String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                        .get('FixedPhone')).get('AreaCode')!=null){
                                    contactNumber.Phone_Number__c=(String)((Map<String, Object>) 
                                            ((Map<String, Object>) eachPhone).get('FixedPhone')).get('AreaCode')+
                                            (String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                            .get('FixedPhone')).get('NodeValue');
                                    objAccount.Phone=(String)((Map<String, Object>) 
                                            ((Map<String, Object>) eachPhone).get('FixedPhone')).get('AreaCode')+
                                            (String)((Map<String, Object>)((Map<String, Object>) eachPhone)
                                            .get('FixedPhone')).get('NodeValue');
                                }else{
                                    contactNumber.Phone_Number__c=(String)((Map<String, Object>) 
                                            ((Map<String, Object>) eachPhone).get('FixedPhone')).get('NodeValue');
                                    objAccount.Phone=(String)((Map<String, Object>)
                                            ((Map<String, Object>) eachPhone).get('FixedPhone')).get('NodeValue');
                                }
                                
                                telephoneContactMap.put(objAccount.FirstName+objAccount.PersonEmail+'Home Phone',contactNumber);
                            }
                        if(((Map<String, Object>) eachPhone) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                            .get('Mobile')) != null){
                                Telephone_Contact_Number__c contactNumber=new Telephone_Contact_Number__c();
                                contactNumber.Phone_Type__c='Mobile';
                                contactNumber.Phone_Number__c=(String)((Map<String, Object>)
                                        ((Map<String, Object>) eachPhone).get('Mobile')).get('NodeValue');
                                objAccount.PersonMobilePhone=(String)((Map<String, Object>)
                                        ((Map<String, Object>) eachPhone).get('Mobile')).get('NodeValue');
                                telephoneContactMap.put(objAccount.FirstName+objAccount.PersonEmail+'Mobile',contactNumber);
                            }
                    }
                }else if(
                    ((Map<String, Object>)homePhoneMap)!= null &&
                    String.valueOf(
                        ((Map<String, Object>)homePhoneMap
                        ))
                    .contains('Phone={')
                ){
                    Object eachPhone = ((Object) (homePhoneMap).get('Phone'));
                    if(((Map<String, Object>) eachPhone) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                        .get('FixedPhone')) != null){
                            Telephone_Contact_Number__c contactNumber=new Telephone_Contact_Number__c();
                            contactNumber.Phone_Type__c='Home Phone';
                            if((String)((Map<String, Object>) (
                                (Map<String, Object>) eachPhone).get('FixedPhone')).get('AreaCode')!=null){
                                contactNumber.Phone_Number__c=(String)((Map<String, Object>) (
                                    (Map<String, Object>) eachPhone).get('FixedPhone')).get('AreaCode')+
                                    (String)((Map<String, Object>) ((Map<String, Object>) eachPhone).get('FixedPhone')).get('NodeValue');
                                objAccount.Phone=(String)((Map<String, Object>) (
                                    (Map<String, Object>) eachPhone).get('FixedPhone')).get('AreaCode')+
                                    (String)((Map<String, Object>)((Map<String, Object>) eachPhone).get('FixedPhone')).get('NodeValue');
                            }else{
                                contactNumber.Phone_Number__c=(String)((Map<String, Object>) 
                                        ((Map<String, Object>) eachPhone).get('FixedPhone')).get('NodeValue');
                                objAccount.Phone=(String)((Map<String, Object>)((Map<String, Object>) eachPhone)
                                        .get('FixedPhone')).get('NodeValue');
                            }
                            telephoneContactMap.put(objAccount.FirstName+objAccount.PersonEmail+'Home Phone',contactNumber);
                        }
                    if(((Map<String, Object>) eachPhone) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                        .get('Mobile')) != null){
                            Telephone_Contact_Number__c contactNumber=new Telephone_Contact_Number__c();
                            contactNumber.Phone_Type__c='Mobile';
                            contactNumber.Phone_Number__c=(String)((Map<String, Object>)
                                    ((Map<String, Object>) eachPhone).get('Mobile')).get('NodeValue');
                            objAccount.PersonMobilePhone=(String)((Map<String, Object>)
                                    ((Map<String, Object>) eachPhone).get('Mobile')).get('NodeValue');
                            telephoneContactMap.put(objAccount.FirstName+objAccount.PersonEmail+'Mobile',contactNumber);
                        }
                }         
            }

            if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')) != null
            && ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('ContactDetails')) !=null && 
            ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('ContactDetails')).get('WorkPhone'))!=null){
                workPhoneMap=(Map<String, Object>)((Map<String, Object>)
                        ((Map<String, Object>) ((Map<String, Object>) each)
                        .get('Person')).get('ContactDetails')).get('WorkPhone');
                if (
                    ((Map<String, Object>)workPhoneMap)!= null &&
                    String.valueOf(
                        ((Map<String, Object>)workPhoneMap
                        ))
                    .contains('Phone=(')
                ){
                    List<Object> refPhone = ((List<Object>) ((Map<String, Object>)workPhoneMap).get('Phone'));
                    for (Object eachPhone : refPhone) {
                        if(((Map<String, Object>) eachPhone) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                            .get('FixedPhone')) != null){
                                Telephone_Contact_Number__c contactNumber=new Telephone_Contact_Number__c();
                                contactNumber.Phone_Type__c='Work Phone';
                                if((String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                        .get('FixedPhone')).get('AreaCode')!=null){
                                    contactNumber.Phone_Number__c=(String)((Map<String, Object>) 
                                        ((Map<String, Object>) eachPhone).get('FixedPhone')).get('AreaCode')+
                                        (String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                        .get('FixedPhone')).get('NodeValue');
                                }else{
                                    contactNumber.Phone_Number__c=(String)((Map<String, Object>) 
                                            ((Map<String, Object>) eachPhone).get('FixedPhone')).get('NodeValue');
                                }
                                
                                telephoneContactMap.put(objAccount.FirstName+objAccount.PersonEmail+'Work Phone',contactNumber);
                            }
                        
                    }
                }else if(
                    ((Map<String, Object>)workPhoneMap)!= null &&
                    String.valueOf(
                        ((Map<String, Object>)workPhoneMap
                        ))
                    .contains('Phone={')
                ){
                    Object eachPhone = ((Object) (workPhoneMap).get('Phone'));
                    if(((Map<String, Object>) eachPhone) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                        .get('FixedPhone')) != null){
                            Telephone_Contact_Number__c contactNumber=new Telephone_Contact_Number__c();
                            contactNumber.Phone_Type__c='Work Phone';
                            if((String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                    .get('FixedPhone')).get('AreaCode')!=null){
                                contactNumber.Phone_Number__c=(String)((Map<String, Object>) 
                                        ((Map<String, Object>) eachPhone).get('FixedPhone')).get('AreaCode')+
                                        (String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                        .get('FixedPhone')).get('NodeValue');
                            }else{
                                contactNumber.Phone_Number__c=(String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                        .get('FixedPhone')).get('NodeValue');
                            }
                            telephoneContactMap.put(objAccount.FirstName+objAccount.PersonEmail+'Work Phone',contactNumber);
                        }
                    
                }         
            }
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')) != null
            && ((String)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('FirstHomeBuyer')) !=null){
                objParty.First_Home_Buyer__c=(String)((Map<String, Object>) 
                        ((Map<String, Object>) each).get('Person')).get('FirstHomeBuyer');
        }
        if(((Map<String, Object>) each) != null &&
            ((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')) != null
            && ((String)((Map<String, Object>) ((Map<String, Object>) each)
            .get('Person')).get('EmployeeOfLender')) !=null){
                objParty.Is_Borrower_Staff__c=(String)((Map<String, Object>) 
                        ((Map<String, Object>) each).get('Person')).get('EmployeeOfLender');
        }
        
    }

    //Company Party Record Parsing
    public static void companyPartyCreation(
        Map<String, Object> each,
        Account objAccount,
        clcommon__Party__c objParty,
        Map<String,genesis__Income__c> objCompanyIncomeMap
    ){
        
        if(((Map<String, Object>) each) != null &&
        ((Map<String, Object>) ((Map<String, Object>) each)
        .get('Trust')) == null){
            
            if(((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Company')) != null && 
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Company')).get('CompanyName')) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Company')).get('CompanyName')).get('BusinessName')) != null){
                objAccount.Name=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                .get('Company')).get('CompanyName')).get('BusinessName');
            }

            if(((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Company')) != null && 
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Company')).get('CompanyNumber')) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Company')).get('CompanyNumber')).get('ABN')) != null){
                objParty.Company_ABN__c=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                .get('Company')).get('CompanyNumber')).get('ABN');

            }
            if(((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Company')) != null && 
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Company')).get('CompanyNumber')) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Company')).get('CompanyNumber')).get('ACN')) != null){
                objParty.Company_ACN__c=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                .get('Company')).get('CompanyNumber')).get('ACN');
                
            }
        }
            
        objParty.Total_Current_Income_Period__c=0;
        objParty.Total_Previous_Income_Period__c=0;
        if(((Map<String, Object>) each) != null &&
                ((Map<String, Object>) ((Map<String, Object>) each)
                .get('Company')) != null && 
                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                .get('Company')).get('CompanyIncome')) != null &&
                String.valueOf(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                .get('Company')).get('CompanyIncome'))).contains('ValueItem=(') ){
            List<Object> refCompanyIncome = ((List<Object>) ((Map<String, Object>)((Map<String, Object>) 
                    ((Map<String, Object>) each).get('Company')).get('CompanyIncome')).get('ValueItem'));
            for(Object eachCompanyIncome:refCompanyIncome){
                if(((Map<String, Object>) eachCompanyIncome) != null &&
                    ((String) ((Map<String, Object>) eachCompanyIncome)
                    .get('Value')) != null &&
                    Decimal.valueOf(
                    (String) ((Map<String, Object>) eachCompanyIncome)
                    .get('Value'))>0)
                {
                    genesis__Income__c objIncome=new genesis__Income__c();
                    if(((Map<String, Object>) eachCompanyIncome) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachCompanyIncome)
                        .get('Income')) != null && (String)((Map<String, Object>) ((Map<String, Object>) eachCompanyIncome)
                        .get('Income')).get('Type') != null){
                            objParty.Document_Type__c='Full';
                            objIncome.Income_Full__c=true;
                        String companyType=(String)((Map<String, Object>) (
                            (Map<String, Object>) eachCompanyIncome).get('Income')).get('Type');
                        if((String)((Map<String, Object>) (
                            (Map<String, Object>) eachCompanyIncome).get('Income')).get('Description')!=null){
                            objIncome.Description__c=(String)((Map<String, Object>) (
                                (Map<String, Object>) eachCompanyIncome).get('Income')).get('Description');
                        }
                        if(companyType=='CompanyProfitBeforeTax'){
                            objIncome.Business_Income_Type__c='Profit Before Tax';
                            objIncome.Non_SMSF_Business_Income_Type__c='Profit Before Tax';
    
                        }else if(companyType=='Addback' && (String)((Map<String, Object>) 
                                ((Map<String, Object>) eachCompanyIncome).get('Income')).get('AddbackType')=='Depreciation'){
                            objIncome.Business_Income_Type__c='Depreciation';
                            objIncome.Non_SMSF_Business_Income_Type__c='Depreciation';
    
                        }else if(companyType=='Addback' && (String)((Map<String, Object>) 
                                ((Map<String, Object>) eachCompanyIncome).get('Income')).get('AddbackType')=='NonCashBenefits'){
                            objIncome.Business_Income_Type__c='Non Cash Benefits';
                            objIncome.Non_SMSF_Business_Income_Type__c='Non Cash Benefits';
    
                        }else if(companyType=='Addback' && (String)((Map<String, Object>) 
                                ((Map<String, Object>) eachCompanyIncome).get('Income')).get('AddbackType')=='NonRecurringExpenses'){
                            objIncome.Business_Income_Type__c='Non Recurring Expenses';
                            objIncome.Non_SMSF_Business_Income_Type__c='Non Recurring Expenses';
    
                        }
                    }
                    if(((Map<String, Object>) eachCompanyIncome) != null &&
                        ((String) ((Map<String, Object>) eachCompanyIncome)
                        .get('Value')) != null){
                            objIncome.genesis__Amount__c=Decimal.valueOf(
                                (String) ((Map<String, Object>) eachCompanyIncome)
                                .get('Value'));
                    }
                    if(((Map<String, Object>) eachCompanyIncome) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachCompanyIncome)
                        .get('Income')) != null && 
                        ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachCompanyIncome)
                        .get('Income')).get('RelatedEntityRef')) != null){
                            objIncome.Business_Income_Period__c='Previous';
                            objParty.Total_Previous_Income_Period__c+=objIncome.genesis__Amount__c;
    
                    }else{
                        objIncome.Business_Income_Period__c='Current';
                        objParty.Total_Current_Income_Period__c+=objIncome.genesis__Amount__c;
    
                    }
                    objCompanyIncomeMap.put(objAccount.Name+
                            objIncome.Business_Income_Period__c+objIncome.Business_Income_Type__c,objIncome);
                }
                
            }

        }else if(((Map<String, Object>) each) != null &&
                ((Map<String, Object>) ((Map<String, Object>) each)
                .get('Company')) != null && 
                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                .get('Company')).get('CompanyIncome')) != null &&
                String.valueOf(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                .get('Company')).get('CompanyIncome'))).contains('ValueItem={') ){
            Object eachCompanyIncome = ((Object) ((Map<String, Object>)(
                (Map<String, Object>) ((Map<String, Object>) each).get('Company')).get('CompanyIncome')).get('ValueItem'));
            if(((Map<String, Object>) eachCompanyIncome) != null &&
                ((String) ((Map<String, Object>) eachCompanyIncome)
                .get('Value')) != null &&
                Decimal.valueOf(
                (String) ((Map<String, Object>) eachCompanyIncome)
                .get('Value'))>0)
            {
                genesis__Income__c objIncome=new genesis__Income__c();
                if(((Map<String, Object>) eachCompanyIncome) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachCompanyIncome)
                    .get('Income')) != null && (String)((Map<String, Object>) ((Map<String, Object>) eachCompanyIncome)
                    .get('Income')).get('Type') != null){
                    objParty.Document_Type__c='Full';
                    objIncome.Income_Full__c=true;
                    String companyType=(String)((Map<String, Object>) 
                        ((Map<String, Object>) eachCompanyIncome).get('Income')).get('Type');
                    if((String)((Map<String, Object>) 
                        ((Map<String, Object>) eachCompanyIncome).get('Income')).get('Description')!=null){
                        objIncome.Description__c=(String)((Map<String, Object>) 
                            ((Map<String, Object>) eachCompanyIncome).get('Income')).get('Description');
                    }
                    if(companyType=='CompanyProfitBeforeTax'){
                        objIncome.Business_Income_Type__c='Profit Before Tax';
                        objIncome.Non_SMSF_Business_Income_Type__c='Profit Before Tax';

                    }else if(companyType=='Addback' && 
                        (String)((Map<String, Object>) ((Map<String, Object>) eachCompanyIncome)
                        .get('Income')).get('AddbackType')=='Depreciation'){
                        objIncome.Business_Income_Type__c='Depreciation';
                        objIncome.Non_SMSF_Business_Income_Type__c='Depreciation';

                    }else if(companyType=='Addback' && 
                        (String)((Map<String, Object>) ((Map<String, Object>) eachCompanyIncome)
                        .get('Income')).get('AddbackType')=='NonCashBenefits'){
                        objIncome.Business_Income_Type__c='Non Cash Benefits';
                        objIncome.Non_SMSF_Business_Income_Type__c='Non Cash Benefits';

                    }else if(companyType=='Addback' && 
                        (String)((Map<String, Object>) ((Map<String, Object>) eachCompanyIncome)
                        .get('Income')).get('AddbackType')=='NonRecurringExpenses'){
                        objIncome.Business_Income_Type__c='Non Recurring Expenses';
                        objIncome.Non_SMSF_Business_Income_Type__c='Non Recurring Expenses';

                    }
                }
                if(((Map<String, Object>) eachCompanyIncome) != null &&
                    ((String) ((Map<String, Object>) eachCompanyIncome)
                    .get('Value')) != null){
                        objIncome.genesis__Amount__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachCompanyIncome).get('Value'));
                }
                if(((Map<String, Object>) eachCompanyIncome) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachCompanyIncome)
                    .get('Income')) != null && 
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachCompanyIncome)
                    .get('Income')).get('RelatedEntityRef')) != null){
                        objIncome.Business_Income_Period__c='Previous';
                        objParty.Total_Previous_Income_Period__c+=objIncome.genesis__Amount__c;
                    }else{
                        objIncome.Business_Income_Period__c='Current';
                        objParty.Total_Current_Income_Period__c+=objIncome.genesis__Amount__c;

                    }
                objCompanyIncomeMap.put(objAccount.Name+
                        objIncome.Business_Income_Period__c+objIncome.Business_Income_Type__c,objIncome);
            }
        }
    }

    //Trust Party Record Parsing
    public static void trustPartyCreation(
        Map<String, Object> each,
        Account objAccount,
        clcommon__Party__c objParty,
        Boolean flag
    ){

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
        if(((Map<String, Object>) each) !=null  && ((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null
        && ((String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('TrustName')) != null ){
            objAccount.Name=(String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('TrustName');
        }
        
        if((String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('ABN') != null){
            objParty.Company_ABN__c = (String)((Map<String, Object>)((Map<String, Object>) each).get('Trust')).get('ABN');
            }
        
        
        if(
            ((Map<String, Object>) each) !=null && ((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null &&
            String.valueOf(
                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Trust'))))
                .contains('BeneficialOwner=(')
        ){ 
            List<Object> refBeneficial = ((List<Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Trust')).get('BeneficialOwner'));
            for(Object eachBeneficial:refBeneficial){
                if(((Map<String, Object>)eachBeneficial) != null &&
                    ((Map<String, Object>)((Map<String, Object>)eachBeneficial).get('Role')) !=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)eachBeneficial)
                    .get('Role')).get('Type')) != null){
                    if((String)((Map<String, Object>)((Map<String, Object>)eachBeneficial)
                            .get('Role')).get('Type') == 'Trustee'){
                        objParty.Is_Trustee_a_Beneficiary_Member__c = 'Yes';
                        
                    }else{
                        objParty.Is_Trustee_a_Beneficiary_Member__c = 'No';
                    }
                }
            }
        }else if(
            ((Map<String, Object>) each) !=null && ((Map<String, Object>)((Map<String, Object>) each).get('Trust')) != null &&
            String.valueOf(
                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each).get('Trust'))))
                .contains('BeneficialOwner={')
        ){ 
            Object eachBeneficial = ((Object) ((Map<String, Object>) 
                    ((Map<String, Object>) each).get('Trust')).get('BeneficialOwner'));
            if(((Map<String, Object>)eachBeneficial) != null &&
                    ((Map<String, Object>)((Map<String, Object>)eachBeneficial).get('Role')) !=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)eachBeneficial)
                    .get('Role')).get('Type')) != null){
                if((String)((Map<String, Object>)((Map<String, Object>)
                        eachBeneficial).get('Role')).get('Type') == 'Trustee'){
                    objParty.Is_Trustee_a_Beneficiary_Member__c = 'Yes';
                    
                }else{
                    objParty.Is_Trustee_a_Beneficiary_Member__c = 'No';
                }
            }
        }
    }
    //Address Record parsing
    public static void partyAddressCreation(
        Map<String, Object> addressdetailMap,
        Map<String, clcommon__Address__c> contactAddressMap,
        Map<String,clcommon__Address__c> accountAddressMap,
        Map<String,String> addressCheck,
        Account objAccount
    ){
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
                        if(((Map<String, Object>) eachAddress) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachAddress)
                    .get('RelatedEntityRef')) != null){
                        if(((String) ((Map<String, Object>) eachAddress).get('Residential')) == 'Yes'){
                            clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) 
                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                            if(objAddress!=null){
                                accountAddressMap.put(objAccount.Name+'BillAt',objAddress);
                                addressCheck.put(objAccount.Name+'BillAt','BillAt');

                            }
                        }
                        if(((String) ((Map<String, Object>) eachAddress).get('Mailing')) == 'Yes'){
                            objAccount.Is_the_postal_address__c='No';
                            clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) 
                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                            if(objAddress!=null){
                                accountAddressMap.put(objAccount.Name+'ShipAt',objAddress);
                                addressCheck.put(objAccount.Name+'ShipAt','ShipAt');

                                }
                        }
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
                            if(objAddress!=null){
                                accountAddressMap.put(objAccount.Name+'BillAt',objAddress);
                                addressCheck.put(objAccount.Name+'BillAt','BillAt');

                            }
                        }
                        if(((String) ((Map<String, Object>) eachAddress).get('Mailing')) == 'Yes'){
                            objAccount.Is_the_postal_address__c='No';
                            clcommon__Address__c objAddress = contactAddressMap.get((String)((Map<String, Object>) 
                                    ((Map<String, Object>) eachAddress).get('RelatedEntityRef')).get('NodeValue'));
                            if(objAddress!=null){
                                accountAddressMap.put(objAccount.Name+'ShipAt',objAddress);
                                addressCheck.put(objAccount.Name+'ShipAt','ShipAt');

                            }
                        }
            }         
        }
    }

    public static void partyRecordCreation(
        Map<String, Object> partySegmentMap,
        Map<String,String> relatedPartyMap,
        Map<String,String> relatedEmployerABNMap,
        List<String> identifierList
    ){
        if(
                ((Map<String, Object>)partySegmentMap)!= null &&
                String.valueOf(
                    ((Map<String, Object>)partySegmentMap
                    ))
                    .contains('Party=(')
            ){
                List<Object> refParty = ((List<Object>) ((Map<String, Object>)partySegmentMap).get('Party'));
                for(Object eachParty:refParty){
                    if(((Map<String, Object>) eachParty) != null &&
                        ((Map<String, Object>)((Map<String, Object>) eachParty).get('Company')) != null &&
                        ((Map<String, Object>) ((Map<String, Object>)((Map<String, Object>) eachParty).get('Company'))
                        .get('CompanyName')) !=null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachParty)
                        .get('Identifier')) !=null &&
                        ((String)((Map<String, Object>) ((Map<String, Object>)((Map<String, Object>) eachParty).get('Company'))
                        .get('CompanyName')).get('BusinessName')) !=null){
                        relatedPartyMap.put((String)((Map<String, Object>) 
                                ((Map<String, Object>) eachParty).get('Identifier')).get('NodeValue'),
                                (String)((Map<String, Object>) ((Map<String, Object>)
                                ((Map<String, Object>) eachParty).get('Company')).get('CompanyName')).get('BusinessName'));
                    }
                    if(((Map<String, Object>) eachParty) != null &&
                            ((Map<String, Object>)((Map<String, Object>) eachParty).get('Company')) != null &&
                            ((Map<String, Object>) ((Map<String, Object>)((Map<String, Object>) eachParty).get('Company'))
                            .get('CompanyName')) !=null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachParty)
                            .get('Identifier')) !=null &&
                            ((String)((Map<String, Object>) ((Map<String, Object>)
                            ((Map<String, Object>) eachParty).get('Company'))
                            .get('CompanyNumber')).get('ABN')) !=null){
                        relatedEmployerABNMap.put((String)((Map<String, Object>) 
                                ((Map<String, Object>) eachParty).get('Identifier')).get('NodeValue'),
                                (String)((Map<String, Object>) ((Map<String, Object>)((Map<String, Object>) 
                                eachParty).get('Company')).get('CompanyNumber')).get('ABN'));
                    }
                    if(((Map<String, Object>) eachParty) != null && 
                    ((Map<String, Object>) ((Map<String, Object>) eachParty)
                    .get('Identifier')) !=null){
                        identifierList.add((String)((Map<String, Object>) 
                                ((Map<String, Object>) eachParty).get('Identifier')).get('NodeValue'));
                    }
                }

            }else if(
                ((Map<String, Object>)partySegmentMap)!= null &&
                String.valueOf(
                    ((Map<String, Object>)partySegmentMap
                    ))
                    .contains('Party={')
            ){
                Object eachParty = ((Object) ((Map<String, Object>)partySegmentMap).get('Party'));
                if(((Map<String, Object>) eachParty) != null &&
                        ((Map<String, Object>)((Map<String, Object>) eachParty).get('Company')) != null &&
                        ((Map<String, Object>) ((Map<String, Object>)((Map<String, Object>) eachParty).get('Company'))
                        .get('CompanyName')) !=null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachParty)
                        .get('Identifier')) !=null &&
                        ((String)((Map<String, Object>) ((Map<String, Object>)
                        ((Map<String, Object>) eachParty).get('Company'))
                        .get('CompanyName')).get('BusinessName')) !=null){
                    relatedPartyMap.put((String)((Map<String, Object>) 
                            ((Map<String, Object>) eachParty).get('Identifier')).get('NodeValue'),
                            (String)((Map<String, Object>) ((Map<String, Object>)
                            ((Map<String, Object>) eachParty).get('Company')).get('CompanyName')).get('BusinessName'));
                }
                if(((Map<String, Object>) eachParty) != null &&
                        ((Map<String, Object>)((Map<String, Object>) eachParty).get('Company')) != null &&
                        ((Map<String, Object>) ((Map<String, Object>)((Map<String, Object>) eachParty).get('Company'))
                        .get('CompanyName')) !=null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachParty)
                        .get('Identifier')) !=null &&
                        ((String)((Map<String, Object>) ((Map<String, Object>)
                        ((Map<String, Object>) eachParty).get('Company'))
                        .get('CompanyNumber')).get('ABN')) !=null){
                    relatedEmployerABNMap.put((String)((Map<String, Object>) 
                            ((Map<String, Object>) eachParty).get('Identifier')).get('NodeValue'),
                            (String)((Map<String, Object>) ((Map<String, Object>)
                            ((Map<String, Object>) eachParty).get('Company')).get('CompanyNumber')).get('ABN'));
                }
                if(((Map<String, Object>) eachParty) != null && 
                    ((Map<String, Object>) ((Map<String, Object>) eachParty)
                    .get('Identifier')) !=null){
                        identifierList.add((String)((Map<String, Object>) 
                                ((Map<String, Object>) eachParty).get('Identifier')).get('NodeValue'));
                    }
                
            }
    }
    //Broker Record Parsing
    public static String salesChannelBrokerCheck(Map<String,Object> applicationMap,
        List<String> firstNameBroker,
        List<String> lastNameBroker
    ){
        String brokerName='';
        if(
                ((Map<String,Object>)applicationMap) !=null &&
                ((Map<String, Object>) applicationMap.get('Application')) !=null &&
                String.valueOf(
                ((Map<String, Object>) applicationMap.get('Application')))
                .contains('SalesChannel={')
        ){
            Object eachSalesChannel=((Object)((Map<String, Object>) 
                    applicationMap.get('Application')).get('SalesChannel'));
            if(((Map<String, Object>) eachSalesChannel) != null &&
                ((String) ((Map<String, Object>) eachSalesChannel)
                .get('SalesChannelType')) != null && 
                ((String) ((Map<String, Object>) eachSalesChannel)
                .get('SalesChannelType')) =='Broker'){
                    if(((Map<String, Object>) eachSalesChannel) != null &&
                    ((Map<String,Object>) ((Map<String, Object>) eachSalesChannel)
                    .get('CompanyName')) != null && 
                    ((String)((Map<String,Object>) ((Map<String, Object>) eachSalesChannel)
                    .get('CompanyName')).get('BusinessName')) != null){
                        brokerName=(String)((Map<String,Object>) 
                                ((Map<String, Object>) eachSalesChannel).get('CompanyName')).get('BusinessName');
                    }else{
                        if(((Map<String, Object>) eachSalesChannel) != null &&
                        ((Map<String,Object>) ((Map<String, Object>) eachSalesChannel)
                        .get('PersonName')) != null && ((Map<String,Object>)((Map<String,Object>) 
                        ((Map<String, Object>) eachSalesChannel)
                        .get('PersonName')).get('NameTitle')) != null){
                            brokerName=(String)((Map<String,Object>)((Map<String,Object>) 
                            ((Map<String, Object>) eachSalesChannel).get('PersonName')).get('NameTitle')).get('Value')+' ';
                        }
                        if(((Map<String, Object>) eachSalesChannel) != null &&
                        ((Map<String,Object>) ((Map<String, Object>) eachSalesChannel)
                        .get('PersonName')) != null && ((Map<String,Object>)((Map<String,Object>) 
                        ((Map<String, Object>) eachSalesChannel)
                        .get('PersonName')).get('FirstName')) != null){
                            brokerName+=(String)((Map<String,Object>)((Map<String,Object>) 
                            ((Map<String, Object>) eachSalesChannel).get('PersonName')).get('FirstName')).get('NodeValue')+' ';
                        }
                        if(((Map<String, Object>) eachSalesChannel) != null &&
                        ((Map<String,Object>) ((Map<String, Object>) eachSalesChannel)
                        .get('PersonName')) != null && ((Map<String,Object>)((Map<String,Object>) 
                        ((Map<String, Object>) eachSalesChannel)
                        .get('PersonName')).get('Surname')) != null){
                            brokerName+=(String)((Map<String,Object>)((Map<String,Object>) 
                            ((Map<String, Object>) eachSalesChannel).get('PersonName')).get('Surname')).get('NodeValue');
                        }
                    }
                    if(((Map<String, Object>) eachSalesChannel) != null &&
                        ((Map<String,Object>) ((Map<String, Object>) eachSalesChannel)
                        .get('PersonName')) != null && ((Map<String,Object>)((Map<String,Object>) 
                        ((Map<String, Object>) eachSalesChannel)
                        .get('PersonName')).get('FirstName')) != null){
                            firstNameBroker.add((String)((Map<String,Object>)((Map<String,Object>) 
                            ((Map<String, Object>) eachSalesChannel).get('PersonName')).get('FirstName')).get('NodeValue'));
                        }
                        if(((Map<String, Object>) eachSalesChannel) != null &&
                        ((Map<String,Object>) ((Map<String, Object>) eachSalesChannel)
                        .get('PersonName')) != null && ((Map<String,Object>)((Map<String,Object>) 
                        ((Map<String, Object>) eachSalesChannel)
                        .get('PersonName')).get('Surname')) != null){
                            lastNameBroker.add((String)((Map<String,Object>)((Map<String,Object>) 
                            ((Map<String, Object>) eachSalesChannel).get('PersonName')).get('Surname')).get('NodeValue'));
                        }
                    
                }
        }else if(
                ((Map<String, Object>) applicationMap) !=null &&
                ((Map<String, Object>) applicationMap.get('Application')) !=null &&
                ((list<Object>)((Map<String, Object>) (
                (Map<String, Object>)applicationMap).get('Application')).get('SalesChannel')) != null
        ){
            List<Object> refSalesChannel = ((List<Object>) ((Map<String, Object>) 
                    ((Map<String, Object>)applicationMap).get('Application')).get('SalesChannel'));
            for(Object each:refSalesChannel){
                if(((Map<String, Object>) each) != null &&
                ((String) ((Map<String, Object>) each)
                .get('SalesChannelType')) != null && ((String) ((Map<String, Object>) each)
                .get('SalesChannelType')) =='Broker'){
                    if(((Map<String, Object>) each) != null &&
                    ((Map<String,Object>) ((Map<String, Object>) each)
                    .get('CompanyName')) != null && ((String)((Map<String,Object>) ((Map<String, Object>) each)
                    .get('CompanyName')).get('BusinessName')) != null){
                        brokerName=(String)((Map<String,Object>) (
                                (Map<String, Object>) each).get('CompanyName')).get('BusinessName');
                    }else{
                        if(((Map<String, Object>) each) != null &&
                        ((Map<String,Object>) ((Map<String, Object>) each)
                        .get('PersonName')) != null && 
                        ((Map<String,Object>)((Map<String,Object>) ((Map<String, Object>) each)
                        .get('PersonName')).get('NameTitle')) != null){
                            brokerName=(String)((Map<String,Object>)((Map<String,Object>) (
                                (Map<String, Object>) each).get('PersonName')).get('NameTitle')).get('Value')+' ';
                        }
                        if(((Map<String, Object>) each) != null &&
                        ((Map<String,Object>) ((Map<String, Object>) each)
                        .get('PersonName')) != null && 
                        ((Map<String,Object>)((Map<String,Object>) ((Map<String, Object>) each)
                        .get('PersonName')).get('FirstName')) != null){
                            brokerName+=(String)((Map<String,Object>)((Map<String,Object>) (
                                (Map<String, Object>) each).get('PersonName')).get('FirstName')).get('NodeValue')+' ';
                        }
                        if(((Map<String, Object>) each) != null &&
                        ((Map<String,Object>) ((Map<String, Object>) each)
                        .get('PersonName')) != null && 
                        ((Map<String,Object>)((Map<String,Object>) ((Map<String, Object>) each)
                        .get('PersonName')).get('Surname')) != null){
                            brokerName+=(String)((Map<String,Object>)((Map<String,Object>) (
                                (Map<String, Object>) each).get('PersonName')).get('Surname')).get('NodeValue');
                        }
                    }
                    if(((Map<String, Object>) each) != null &&
                    ((Map<String,Object>) ((Map<String, Object>) each)
                    .get('PersonName')) != null && ((Map<String,Object>)((Map<String,Object>) 
                    ((Map<String, Object>) each)
                    .get('PersonName')).get('FirstName')) != null){
                        firstNameBroker.add((String)((Map<String,Object>)((Map<String,Object>) 
                        ((Map<String, Object>) each).get('PersonName')).get('FirstName')).get('NodeValue'));
                    }
                    if(((Map<String, Object>) each) != null &&
                    ((Map<String,Object>) ((Map<String, Object>) each)
                    .get('PersonName')) != null && ((Map<String,Object>)((Map<String,Object>) 
                    ((Map<String, Object>) each)
                    .get('PersonName')).get('Surname')) != null){
                        lastNameBroker.add((String)((Map<String,Object>)((Map<String,Object>) 
                        ((Map<String, Object>) each).get('PersonName')).get('Surname')).get('NodeValue'));
                    }
                }
            }
        }
        return brokerName;
    }
}