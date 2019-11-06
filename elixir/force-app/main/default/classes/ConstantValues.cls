/********************************************************************************
Description:    This class stores all the constant values used
Developer:      Rameswari Barman
Created Date:   05/10/2018
*********************************************************************************/
global class ConstantValues{

    //Lending Calculator Constant Values 
    global static final String TERM_VALIDATION_MSG='Please define the loan term.'; 
    global static final String APP_ALREADY_CONVERTED_MSG='Application has already been converted to Loan Application.';
    global static final String INTEREST_RATE_VALIDATION_MSG='Interest Rate can not be left blank or a negative value.';
    global static final String PAYMENT_FREQUENCY_VALIDATION_MSG='Please define the payment frequency.';
    global static final String LOAN_AMT_VALIDATION_MSG='Please provide a valid loan amount.';
    global static final String INVESTMENT_AMT_CANNOT_BE_LESS_MSG = 'Investment amount cannot be less than requested loan amount for this single tranche loan.';
    global static final String DISBURSEMENT = 'Disbursement';
    global static final String APPROVED = 'Approved';
    global static final String AVER = 'aver';
    global static final String FEE_AMNT = 'feeAmnt';

    //Personal Info Api Constant values
    global static string gmtFormat = 'yyyy-MM-dd HH:mm:ss.SSS';
    global static string personal = 'Personal';
    global static string company = 'Company';
    global static string smsf = 'Self Managed Super Fund (SMSF)';
    global static string family = 'Family Trust';
    global static string indType = 'Individual';
    global static string jointType ='Joint Account';
    global static string compType = 'Company';
    global static string smsfInd = 'Individual Trustee of SMSF';
    global static string smsfCorp = 'Corporate Trustee of SMSF';
    global static string famInd = 'Individual Trustee of Family Trust';
    global static string famCorp = 'Corporate Trustee of Family Trust';
    global static string emailEncodingKey = 'ISO-8859-1';
    global static string langLocalKey = 'en_US';
    global static string localesidkey = 'en_AU';
    global static string timezonesidkey = 'Australia/Sydney'; 
    global static final String RESPONSE  = 'RESPONSE';
    
      
    
    //Financial Info Api
    global static string validTfnNum= 'Please enter valid tfn number';
    global static string validExempType= 'Please enter valid exemption type';
    global static string validBankAccNum= 'Please enter valid bank account number';
    global static string validBankAccName= 'Please enter valid bank account name';
    global static string validBsbNum= 'Please enter valid bsb number';
    global static string validBankName='Please enter valid bank name';
    
    
    //Payment frequency
    global static string biWeekly = 'Bi-weekly';
    global static string weekly = 'Weekly';
    global static String monthly = 'Monthly';
    
    //Field map
    global static string status = 'status';
    global static string msg = 'SUCCESS';
        
    //Custom Messages
    global static string noActiveInFound = 'No Active Investment Found';
    global static string investmentAmountCannotBeGreater = 'Investment amount cannot be greater than requested loan amount for this single tranche loan.';
    global static string fundingSuccessful = 'Funding has been successful!';
    global static string noActiveInvestmentFound = 'No Active Investment has been found!';
    global static string SP_Invalid_Postcode = 'S&P Postcode invalid';
    global static string QBE_Invalid_Postcode = 'QBE Postcode invalid';
    global static string EXCEPTION_OCCURED = 'Exception Occured'; 
    global static string ABN_GENERATED = 'ABN Information Generated Successfully';
    global static string ACN_GENERATED = 'ACN Information Generated Successfully';
    global static string validTitle = 'Please Enter Valid Title';
    global static string validFirstName = 'Please Enter Valid First Name';
    global static string validLastName = 'Please Enter Valid Last Name';
    global static string validEmail = 'Please Enter Valid Email';
    global static string futureDOB = 'Date of Birth should not be in future';
    global static string validDOB = 'Please Enter Valid Birth Date';
    global static string validMobile = 'Please Enter Valid Mobile Number';
    global static string validStreet = 'Please Enter Valid Street Name';
    global static string validCity = 'Please Enter Valid City';
    global static string validState = 'Please Enter Valid State';
    global static string validPostCode = 'Please Enter Postal Code';
    global static string validCountry = 'Please Enter Country';
    global static string validateAddress = 'Please enter valid Address';
    global static string validPass = 'Please Enter Valid Password';
    global static string validconPass = 'Please Enter Confirm Password';
    global static string validconEmail = 'Please Enter Confirm Email';
    global static string mailMatch = 'Email And Confirmation Email does not match';
    global static string passMatch = 'Password And Confirmation Password does not match';
    global static string accExist = 'Account Does not exist';
    global static string minAge = 'Applicant Should be minimum 18 years of age'; 
    global static string sameEmail = 'First and Second applicant should give different email';
    global static string sameMobileNum = 'First and Second applicant should give different phone number';
    global static string diffrentValue = 'Not expecting this value';
    global static string userExist = 'User already Exists !!';
    global static string provideAccId = 'Please provide account id';
    
    
    
    
    //Constant exception msg values for ABNName API   
    global static final String exceptionNoType = 'Could not determine which entity to relate to.';
    global static final String partyNotFound = 'Party Record Not Found';
    global static final String employeeNotFound = 'Employee Record Not Found';
    global static final String genericExceptionmsg = 'Something went wrong. Please contact System Administrator';
    global static final String genericException2 = 'Something went wrong in ABNName API. Please contact System Administrator. Reason: ';
    global static final String genericResponseError = 'Something went wrong while receiving response. Reason: ';
    global static final String abnAPIemptyMap = 'Service Layer Provided an Empty Request Map';
    global static final String recordCreationException = 'Something went wrong during record creation. Reason: ';
    global static final String responseParsingException = 'Something went wrong in Response Parsing. Reason: ';
    global static final String uniqueBlank = '/00/';
    
    //Constant Values for ABNNameAPI
    global static final String serviceName = 'ID Verification';
    global static final String abnAPIservice = 'service';
    global static final String abnAPIcompanyABN = 'companyABN';
    global static final String abnAPIpostcode = 'postcode';
    global static final String abnAPItradingName = 'tradingName';
    global static final String abnAPIbusinessName = 'businessName';
    global static final String abnAPIlegalName = 'legalName';
    global static final String abnAPIactiveABNsOnly = 'activeABNsOnly';
    global static final String abnAPInsw = 'NSW';
    global static final String abnAPIsa = 'SA';
    global static final String abnAPIact = 'ACT';
    global static final String abnAPIvic = 'VIC';
    global static final String abnAPIwa = 'WA';
    global static final String abnAPInt = 'NT';
    global static final String abnAPIqld = 'QLD';
    global static final String abnAPItas = 'TAS';
    global static final String abnAPIsearchWidth = 'searchWidth';
    global static final String abnAPIminimumScore = 'minimumScore';
    global static final String abnAPImaxSearchResults = 'maxSearchResults';
    global static final String testString1 = 'ABRSearchByNameAdvancedSimpleProtocol2017';
    global static final String partyInfo = 'partyInfo';
    
    //Constant Exception Msg for ABN API
    global static final String abnInfoException = 'ABN Information record not found';
    global static final String effectiveDateError = 'Proper Organization Name could not be determined based on effective date. Please contact System Administrator';
    global static final String lookupConflict = 'Conflicting lookup relationship found. Please contact System Administrator' ;
    global static final String parentRecordLookupException = 'Error occurred while relating to parent record. Please contact System Administrator';
    global static final String companyNotFound = 'Company List ID Not Found';
    global static final String OrganizationNameNotfound = 'Proper Organization Name could not be determined based on effective date. Please contact System Administrator';
    
    
    //Constant Values for ABN_API
    global static final String abn_API_service = 'service';
    global static final String abn_API_companyABN = 'companyABN';
    global static final String abn_API_histdetails = 'histdetails';
    global static final String abn_API_controlField = '12345';
    global static final String CompanyInfo = 'companyInfo';
    
    
    //Constant Exception Message for ACN API
    global static final String acn_API_service = 'service';
    global static final String acn_API_companyACN = 'companyACN';
    global static final String acn_API_histdetails = 'histdetails';
    global static final String acn_API_controlField = '12345';
    
    //Constant Exception Message for ACN API
    
    global static final String acnAPIemptyMap = 'Service Layer Provided an Empty Request Map';
    global static final String Success = 'Success';
    global static final String acnInfoNotFound = 'ACN Information record not found';
    global static final String acnInfoError = 'This indicates that we did not get the expected response from ACN API';
    global static final String acnResponseError  = 'This indicates that we did not get the expected response parsing from ACN API';
    global static final String abnResponseError  = 'This indicates that we did not get the expected response parsing from ABN API';
    global static final String acnPartyInfo  = 'partyInfo';
    global static final String acnNotFound = 'ACN Not Found';
    
    

    
    
    
}