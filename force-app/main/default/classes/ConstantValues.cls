/********************************************************************************
Description:    This class stores all the constant values used
Developer:      Rameswari Barman
Created Date:   05/10/2018
*********************************************************************************/
global class ConstantValues{

    //Lending Calculator Constant Values 
    global static final string TERM_VALIDATION_MSG='Please define the loan term.'; 
    global static final string APP_ALREADY_CONVERTED_MSG='Application has already been converted to Loan Application.';
    global static final string INTEREST_RATE_VALIDATION_MSG='Interest Rate can not be left blank or a negative value.';
    global static final string PAYMENT_FREQUENCY_VALIDATION_MSG='Please define the payment frequency.';
    global static final string LOAN_AMT_VALIDATION_MSG='Please provide a valid loan amount.';
    global static final string INVESTMENT_AMT_CANNOT_BE_LESS_MSG = 'Investment amount cannot be less than requested loan amount for this single tranche loan.';
    global static final string DISBURSEMENT = 'Disbursement';
    global static final string APPROVED = 'Approved';
    global static final string AVER = 'aver';
    global static final string FEE_AMNT = 'feeAmnt';

    //Personal Info Api Constant values
    global static final string gmtFormat = 'yyyy-MM-dd HH:mm:ss.SSS';
    global static final string personal = 'Personal';
    global static final string company = 'Company';
    global static final string smsf = 'Self Managed Super Fund (SMSF)';
    global static final string family = 'Family Trust';
    global static final string indType = 'Individual';
    global static final string jointType ='Joint Account';
    global static final string compType = 'Company';
    global static final string smsfInd = 'Individual Trustee of SMSF';
    global static final string smsfCorp = 'Corporate Trustee of SMSF';
    global static final string famInd = 'Individual Trustee of Family Trust';
    global static final string famCorp = 'Corporate Trustee of Family Trust';
    global static final string emailEncodingKey = 'ISO-8859-1';
    global static final string langLocalKey = 'en_US';
    global static final string localesidkey = 'en_AU';
    global static final string timezonesidkey = 'Australia/Sydney'; 
    global static final string RESPONSE  = 'RESPONSE';
    global static final String financialPending = 'Financial Pending';
    global static final String companyPending = 'Company Pending';
    global static final String smsfPending = 'SMSF Pending';
    global static final string trustPending = 'Trust Pending';
    global static final string pdsPending = 'PDS Pending';
    global static final string idPending = 'Identification Pending';
    
      
    
    //Financial Info Api
    global static final string validTfnNum= 'Please enter valid tfn number';
    global static final string validExempType= 'Please enter valid exemption type';
    global static final string validBankAccNum= 'Please enter valid bank account number';
    global static final string validBankAccName= 'Please enter valid bank account name';
    global static final string validBsbNum= 'Please enter valid bsb number';
    global static final string validBankName='Please enter valid bank name';
    
    
    //Payment frequency
    global static final string biWeekly = 'Bi-weekly';
    global static final string weekly = 'Weekly';
    global static final string monthly = 'Monthly';
    
    //Field map
    global static final string status = 'status';
    global static final string msg = 'SUCCESS';
        
    //Custom Messages
    global static final string noActiveInFound = 'No Active Investment Found';
    global static final string investmentAmountCannotBeGreater = 'Investment amount cannot be greater than requested loan amount for this single tranche loan.';
    global static final string fundingSuccessful = 'Funding has been successful!';
    global static final string noActiveInvestmentFound = 'No Active Investment has been found!';
    global static final string SP_Invalid_Postcode = 'S&P Postcode invalid';
    global static final string QBE_Invalid_Postcode = 'QBE Postcode invalid';
    global static final string EXCEPTION_OCCURED = 'Exception Occured'; 
    global static final string ABN_GENERATED = 'ABN Information Generated Successfully';
    global static final string ACN_GENERATED = 'ACN Information Generated Successfully';
    global static final string validTitle = 'Please Enter Valid Title';
    global static final string validFirstName = 'Please Enter Valid First Name';
    global static final string validLastName = 'Please Enter Valid Last Name';
    global static final string validEmail = 'Please Enter Valid Email';
    global static final string futureDOB = 'Date of Birth should not be in future';
    global static final string validDOB = 'Please Enter Valid Birth Date';
    global static final string validMobile = 'Please Enter Valid Mobile Number';
    global static final string validStreet = 'Please Enter Valid Street Name';
    global static final string validCity = 'Please Enter Valid City';
    global static final string validState = 'Please Enter Valid State';
    global static final string validPostCode = 'Please Enter Postal Code';
    global static final string validCountry = 'Please Enter Country';
    global static final string validateAddress = 'Please enter valid Address';
    global static final string validPass = 'Please Enter Valid Password';
    global static final string validconPass = 'Please Enter Confirm Password';
    global static final string validconEmail = 'Please Enter Confirm Email';
    global static final string mailMatch = 'Email And Confirmation Email does not match';
    global static final string passMatch = 'Password And Confirmation Password does not match';
    global static final string accExist = 'Account Does not exist';
    global static final string minAge = 'Applicant Should be minimum 18 years of age'; 
    global static final string sameEmail = 'First and Second applicant should give different email';
    global static final string sameMobileNum = 'First and Second applicant should give different phone number';
    global static final string diffrentValue = 'Not expecting this value';
    global static final string userExist = 'User already Exists !!';
    global static final string provideAccId = 'Please provide account id';
    global static string validType = 'Please Enter Valid Type';
    
    
    
    //Constant exception msg values for ABNName API   
    global static final string exceptionNoType = 'Could not determine which entity to relate to.';
    global static final string partyNotFound = 'Party Record Not Found';
    global static final string employeeNotFound = 'Employee Record Not Found';
    global static final string genericExceptionmsg = 'Something went wrong. Please contact System Administrator';
    global static final string genericException2 = 'Something went wrong in ABNName API. Please contact System Administrator. Reason: ';
    global static final string genericResponseError = 'Something went wrong while receiving response. Reason: ';
    global static final string abnAPIemptyMap = 'Service Layer Provided an Empty Request Map';
    global static final string recordCreationException = 'Something went wrong during record creation. Reason: ';
    global static final string responseParsingException = 'Something went wrong in Response Parsing. Reason: ';
    global static final string uniqueBlank = '/00/';

    //Constant Values for ABNNameAPI
    global static final string serviceName = 'ID Verification';
    global static final string abnAPIservice = 'service';
    global static final string abnAPIcompanyABN = 'companyABN';
    global static final string abnAPIpostcode = 'postcode';
    global static final string abnAPItradingName = 'tradingName';
    global static final string abnAPIbusinessName = 'businessName';
    global static final string abnAPIlegalName = 'legalName';
    global static final string abnAPIactiveABNsOnly = 'activeABNsOnly';
    global static final string abnAPInsw = 'NSW';
    global static final string abnAPIsa = 'SA';
    global static final string abnAPIact = 'ACT';
    global static final string abnAPIvic = 'VIC';
    global static final string abnAPIwa = 'WA';
    global static final string abnAPInt = 'NT';
    global static final string abnAPIqld = 'QLD';
    global static final string abnAPItas = 'TAS';
    global static final string abnAPIsearchWidth = 'searchWidth';
    global static final string abnAPIminimumScore = 'minimumScore';
    global static final string abnAPImaxSearchResults = 'maxSearchResults';
    global static final string testString1 = 'ABRSearchByNameAdvancedSimpleProtocol2017';
    global static final string partyInfo = 'partyInfo';
    
    //Constant Exception Msg for ABN API
    global static final string abnInfoException = 'ABN Information record not found';
    global static final string effectiveDateError = 'Proper Organization Name could not be determined based on effective date. Please contact System Administrator';
    global static final string lookupConflict = 'Conflicting lookup relationship found. Please contact System Administrator' ;
    global static final string parentRecordLookupException = 'Error occurred while relating to parent record. Please contact System Administrator';
    global static final string companyNotFound = 'Company List ID Not Found';
    global static final string OrganizationNameNotfound = 'Proper Organization Name could not be determined based on effective date. Please contact System Administrator';
    
    
    //Constant Values for ABN_API
    global static final string abn_API_service = 'service';
    global static final string abn_API_companyABN = 'companyABN';
    global static final string abn_API_histdetails = 'histdetails';
    global static final string abn_API_controlField = '12345';
    global static final string CompanyInfo = 'companyInfo';
    
    
    //Constant Exception Message for ACN API
    global static final string acn_API_service = 'service';
    global static final string acn_API_companyACN = 'companyACN';
    global static final string acn_API_histdetails = 'histdetails';
    global static final string acn_API_controlField = '12345';
    
    //Constant Exception Message for ACN API
    
    global static final string acnAPIemptyMap = 'Service Layer Provided an Empty Request Map';
    global static final string Success = 'Success';
    global static final string acnInfoNotFound = 'ACN Information record not found';
    global static final string acnInfoError = 'This indicates that we did not get the expected response from ACN API';
    global static final string acnResponseError  = 'This indicates that we did not get the expected response parsing from ACN API';
    global static final string abnResponseError  = 'This indicates that we did not get the expected response parsing from ABN API';
    global static final string acnPartyInfo  = 'partyInfo';
    global static final string acnNotFound = 'ACN Not Found';
    global static final string Exception_Description = 'exceptionDescription';
    global static final string ExceptionCode = 'exceptionCode';


    //For IncomeSummary class 

    global static final string FullDocType = 'Full';
    global static final string SelfEmpRecordType = 'Self_Employed';
    
    //Constant values for FetchJointApplicantDetails
    
    global static final String JointAptResponse = 'JointAplicantDetailsResp';

    //Constant values for FetchTFNDetails

    global static final String TFNBankResponse = 'TFNResp';
    global static final String ABNACNDetilsResponse = 'ABNACNDetilsResp';
    global static final String PartnerTFNAndBankdetailsResponse = 'PartnerTFNAndBankdetailsResp';  

    //Constant values for ABNSubmitApi    
    
    global static final String validateABN = 'Please Provide ABN Number';

    //Constant values for ACNSubmitApi    
    
    global static final String validateACN = 'Please Provide ACN Number';
    
    //Constant Values for PricingUpdate
    public static final String APPLICATION_ID_NULL = 'Pricing Update Failed: Application ID is null';
    public static final String USER_DOES_NOT_HAVE_ACCESS = 'User does not have access to proceed.';
    public static final String NO_PRICING_RECORDS_FOUND = 'No pricing records found';
    public static final String PRICING_SUCCESSFULLY_UPDATED = 'Pricing successfuly updated.';
    public static final String UNABLE_UPDATE_PRICING = 'Unable to update the pricing';

    //General constant
    public static final String GENERAL_ERROR = 'Something went wrong';

    //Constant Values for EquifaxSearchTitleByAddressCallout
    public static final String EQUIFAX_FAMILY = 'Equifax';
    public static final String TITLE_SEARCH_API_TYPE = 'Title Search by Address';
    public static final String ORDER_DOCUMENT_API_TYPE = 'Order Document';
    public static final String DELIVER_DOCUMENT_API_TYPE = 'Deliver Document';
    public static final String COLLATERAL_ID = 'collateralId';
    public static final String HS_LANDTITLE = '-landTitle';
    public static final String US_LANDTITLE = 'LandTitle';
    public static final String HS_TITLE = '-title';
    public static final String US_TITLE = 'Title';
    public static final String HS_HEADER = '-header';
    public static final String US_HEADER = 'Header';
    public static final String HS_RESPONSE = '-response';
    public static final String US_RESPONSE = 'Response';
    public static final String HS_DATA = '-data';
    public static final String US_DATA = 'Data';
    public static final String HS_PAID = '-paid';
    public static final String US_PAID = 'Paid';
    public static final String HS_TERRITORY = '-territory';
    public static final String US_TERRITORY = 'Territory';
    public static final String HS_LAND = '-land';
    public static final String US_LAND = 'Land';
    public static final String HS_REGISTRY = '-registry';
    public static final String US_REGISTRY = 'Registry';
    public static final String HS_REFERENCE = '-reference';
    public static final String US_REFERENCE = 'Reference';
    public static final String HS_DESCRIPTION = '-description';
    public static final String US_DESCRIPTION = 'Description';
    public static final String HS_PRICE = '-price';
    public static final String US_PRICE = 'Price';
    public static final String HS_VALUE = '-value';
    public static final String US_VALUE = 'Value';
    public static final String HS_DOCUMENT = '-document';
    public static final String US_DOCUMENT = 'Document';
    public static final String HS_DETAIL = '-detail';
    public static final String US_DETAIL = 'Detail';
    public static final String HS_TIME = '-time';
    public static final String US_TIME = 'TimeV';
    public static final String HS_ID = '-id';
    public static final String US_ID = 'Id';
    public static final String HS_STATUS = '-status';
    public static final String US_STATUS = 'Status';
    public static final String LANDTITLE_KEY = '"landTitle"';
    public static final String ERROR_KEY = '"error"';
    public static final String NO_COLLATERAL = 'No collateral found';
    public static final String NO_ENQUIRY_ID = 'Document Enquiry Id missing';
    public static final String ORDER_DOC_SUCCESS = 'Order Successfully Placed';
    public static final String INVALID_RESPONSE = 'Invalid Response Structure';
    public static final String DOCUMENT_ATTACHMENT_PREFIX = 'TITLE||DOCUMENT||';
    public static final String TITLE_SEARCH_DOCUMENT_CATEGORY_NAME = 'Title Search Document';
    public static final String DELIVER_DOCUMENT_BATCH_CALLED = 'Document Status Check Batch Successfully called ';

    //Integration Request Structure
    public static final String REQ_ENVELOPE_START = '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:land="http://vedaxml.com/vxml2/land-titles-v1-0.xsd" xmlns:vh="http://vedaxml.com/soap/header/v-header-v1-10.xsd" xmlns:wsa="http://www.w3.org/2005/08/addressing">';
    public static final String REQ_HEADER = '<soap:Header>' +
    '<wsse:Security mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
    + '<wsse:UsernameToken>' + '<wsse:Username>{!$Credential.UserName}</wsse:Username>'
    + '<wsse:Password>{!$Credential.Password}</wsse:Password>' + '</wsse:UsernameToken>'
    + '</wsse:Security>'
    + '<wsa:To>https://vedaxml.com/sys2/soap12/land-titles-v1</wsa:To>';
    public static final String REQ_SLT_ACTION = '<wsa:Action>http://vedaxml.com/land-titles/searchLandTitlesRequest</wsa:Action></soap:Header>';
    public static final String REQ_OD_ACTION = '<wsa:Action>http://vedaxml.com/land-titles/orderDocumentRequest</wsa:Action></soap:Header>';
    public static final String REQ_DD_ACTION = '<wsa:Action>http://vedaxml.com/land-titles/deliverDocumentRequest</wsa:Action></soap:Header>';
    public static final String REQ_ENVELOPE_END = '</soap:Body></soap:Envelope>';
    public static final String REQ_BODY = '<soap:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">';
}