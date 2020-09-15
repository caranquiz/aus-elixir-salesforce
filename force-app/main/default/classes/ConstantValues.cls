/********************************************************************************
Description: This class stores all the constant values used
Developer: Rameswari Barman
Created Date: 05/10/2018
*********************************************************************************/
global class ConstantValues{

   //Check Rules Constant Values   
   global static final string CHECKRULES_APPLICATION_ID_NULL = 'Application ID is null';
  
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
   global static final string RESPONSE = 'RESPONSE';
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
   global static final string acnResponseError = 'This indicates that we did not get the expected response parsing from ACN API';
   global static final string abnResponseError = 'This indicates that we did not get the expected response parsing from ABN API';
   global static final string acnPartyInfo = 'partyInfo';
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
   public static final String PRICING_RATE_DOES_MATCH = 'The current matrix rate is not in accordance with the interest obtained from Pricing table. Please click on the Generate Pricing button on Loan Details tab to proceed.'; 
  
   //General constant
   public static final String GENERAL_ERROR = 'Something went wrong';
  
   //Constant Values for EquifaxSearchTitleByAddressCallout
   public static final String EQUIFAX_FAMILY = 'Equifax';
   public static final String TITLE_SEARCH_API_TYPE = 'Title Search by Address';
   public static final String ORDER_DOCUMENT_API_TYPE = 'Order Document';
   public static final String DELIVER_DOCUMENT_API_TYPE = 'Deliver Document';
   public static final String APPLY_INDIVIDUAL_API_TYPE = 'Apply Individual';
   public static final String PREVIOUS_ENQUIRY_API_TYPE = 'Previous Enquiry';
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
   public static final String HS_CODE = '-code';
   public static final String US_CODE = 'Code';
   public static final String HS_RECORD = '-record';
   public static final String US_RECORD = 'Record';
   public static final String LANDTITLE_KEY = '"landTitle"';
   public static final String ERROR_KEY = '"error"';
   public static final String NO_COLLATERAL = 'No collateral found';
   public static final String NO_ENQUIRY_ID = 'Document Enquiry Id missing';
   public static final String ORDER_DOC_SUCCESS = 'Order has been Successfully Placed';
   public static final String APPLY_INDIVIDUAL_SUCCESS = 'Individual Credit Report fetched successfully';
   public static final String INVALID_RESPONSE = 'Invalid Response Structure';
   public static final String DOCUMENT_ATTACHMENT_PREFIX = 'TITLE||DOCUMENT||';
   public static final String TITLE_SEARCH_DOCUMENT_CATEGORY_NAME = 'Title Search Document';
   public static final String DELIVER_DOCUMENT_BATCH_CALLED = 'Document Status Check Batch Successfully called ';
   public static final String NCCP_REGULATED = 'Regulated';	
   public static final String NCCP_NON_REGULATED = 'Unregulated';	
   public static final String APPLY_IND_REQUEST_SR = 'ApplyIndividualRequest';
   public static final String PDF_REPORT_DOWNLOADED = 'PDF Report downloaded successfully';
   //Integration Request Structure
   public static final String NC_USERNAME = '{!$Credential.UserName}';
   public static final String NC_PASSWORD = '{!$Credential.Password}';
   public static final String USERNAME_KEY = '__Username';
   public static final String PASSWORD_KEY = '__Password';
   public static final String CLIENT_REFERENCE = '__partyReference';
   public static final String PERMISSION_TYPE_CODE = '__permissionTypeCode';
   public static final String PRODUCT_DATA_LEVEL_CODE = '__productDataLevelCode';
   public static final String SCORECARD_ID1 = '__scorecardId1';
   public static final String SCORECARD_ID2 = '__scorecardId2';
   public static final String CUSTOM_IP_PARAM_KEY = '__cipKey';
   public static final String CUSTOM_IP_PARAM_VALUE = '__cipValue';
   public static final String IND_LASTNAME = '__lastName';
   public static final String IND_FIRSTNAME = '__firstName';
   public static final String IND_MIDNAME_WKEY = '__middleName__wKey';
   public static final String ADDR_TYPE = '__addressType';
   public static final String ADDR_UNITNUMBER_WKEY = '__unitNumber__wkey';
   public static final String ADDR_STREETNUMBER = '__streetNumber';
   public static final String ADDR_STREETNAME = '__streetName';
   public static final String ADDR_STREETTYPE = '__streetType';
   public static final String ADDR_SUBURB = '__suburb';
   public static final String ADDR_STATE = '__state';
   public static final String ADDR_POSTCODE = '__postalCode';
   public static final String ADDR_COUNTRYCODE = '__countryCode';
   public static final String IND_GENDERCODE = '__genderCode';
   public static final String IND_DOB = '__dateOfBirth';
   public static final String ACCOUNT_TYPE_CODE = '__accountTypeCode';
   public static final String CURRENCY_CODE = '__currencyCode';
   public static final String ENQ_AMT = '__enquiryAmount';
   public static final String RELATIONSHIP_CODE = '__relationshipCode';
   public static final String ENQUIY_ID_CODE = '__enquiryId';
   public static final String CONTENT_TYPE_CODE = '__contentType';
   public static final String REQ_ENVELOPE_START = '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:land="http://vedaxml.com/vxml2/land-titles-v1-0.xsd" xmlns:vh="http://vedaxml.com/soap/header/v-header-v1-10.xsd" xmlns:wsa="http://www.w3.org/2005/08/addressing">';
   public static final String RES_HEADER = '<soapenv:Envelope xmlns:soapenv="http://www.w3.org/2003/05/soap-envelope" xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'	
   + '<SOAP-ENV:Body xmlns:SOAP-ENV="http://www.w3.org/2003/05/soap-envelope"><notify-event-response xmlns="http://veda-services/event-notify-v1-0.xsd" xmlns:xmime="http://www.w3.org/2005/05/xmlmime"><notify-event-data>';
   public static final String RES_FOOTER ='</notify-event-data></notify-event-response></SOAP-ENV:Body></soapenv:Envelope>';
   // Exceptions
   public static final String REQ_SLT_ACTION = '<wsa:Action>http://vedaxml.com/land-titles/searchLandTitlesRequest</wsa:Action></soap:Header>';
   public static final String REQ_OD_ACTION = '<wsa:Action>http://vedaxml.com/land-titles/orderDocumentRequest</wsa:Action></soap:Header>';
   public static final String REQ_DD_ACTION = '<wsa:Action>http://vedaxml.com/land-titles/deliverDocumentRequest</wsa:Action></soap:Header>';
   public static final String REQ_ENVELOPE_END = '</soap:Body></soap:Envelope>';
   public static final String REQ_BODY = '<soap:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">';
   public static final String REQ_HEADER = '<soap:Header>' +
   '<wsse:Security mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
   + '<wsse:UsernameToken>' + '<wsse:Username>{!$Credential.UserName}</wsse:Username>'
   + '<wsse:Password>{!$Credential.Password}</wsse:Password>' + '</wsse:UsernameToken>'
   + '</wsse:Security>'
   + '<wsa:To>https://vedaxml.com/sys2/soap12/land-titles-v1</wsa:To>';
   public static final String ENVELOPE_KEY = 'Envelope';
   public static final String BODY_KEY = 'Body';
   public static final String RESPONSE_KEY = 'response';
   public static final String BINARYDATA_KEY = 'binaryData';
   public static final String NODEVALUE_KEY = 'NodeValue';

   // Exceptions
   public static final String NO_APPLICATION = 'No Application found';
   public static final String NO_PARTY = 'No Party found';
   public static final String NO_CONTACT = 'No Contact found';
   public static final String NO_ADDRESS = 'No Address found';
   public static final String NCCP_STATUS_NOT_FOUND = 'NCCP Status of the Application data not found';
   public static final String LOAN_AMOUNT_MISSING = 'Loan Amount is missing';
   public static final String FIRST_NAME_MISSING = 'First name is missing';
   public static final String LAST_NAME_MISSING = 'Last name is missing';
   public static final String STREET_NUMBER_MISSING = 'Street number is missing';
   public static final String STREET_NAME_MISSING = 'Street name is missing';
   public static final String STREET_TYPE_MISSING = 'Street type is missing';
   public static final String SUBURB_MISSING = 'Suburb is missing';
   public static final String STATE_MISSING = 'State is missing';
   public static final String POST_CODE_MISSING = 'Postal code is missing';
   public static final String COUNTRY_MISSING ='Country is missing or wrong';
   public static final String GENDER_MISSING ='Gender is missing';
   public static final String DOB_MISSING ='Date of Birth is missing';
   public static final String PARTY_REF_MISSING ='Party Reference is missing';
   public static final String APPLY_IND_SUCCESS = 'Individual Enquiry Report has been fetched Successfully';
   public static final String NO_DIRECTORSHIPS = 'No Directorship found';
   public static final String APPLY_IND_PARAM_NULL ='Equifax Apply Individual Party Update null check exception';
   public static final String RESPONSE_PARSE_ERR = 'There is Something wrong while parsing the response.';
   
   //SMSF ABN Integration
   public static final String GUID_VALUE = 'c4726ad0-af04-4d8d-987b-d15966cd1cfd';
   public static final String GUID = 'guid';
   public static final String ACTIVE_FUNDS_ONLY = 'activeFundsOnly';
   public static final String ACTIVE_FUNDS_ONLY_VALUE = 'Y';
   public static final String MAX_SEARCH_RESULTS = 'maxSearchResults';
   public static final String MAX_SEARCH_RESULTS_VALUE = '200';
   public static final String ABN_DATA = 'abndata';
   public static final String GUID_INFO = 'guidInfo';
   public static final String PARTY_INFO = 'partyInfo';
   public static final String NAME_NAMED_CREDENTIAL = 'https://superfundlookup.gov.au/xmlsearch/SflXmlSearch.asmx/SearchByName201911';
   public static final String NUMBER_NAMED_CREDENTIAL = 'https://superfundlookup.gov.au/xmlsearch/SflXmlSearch.asmx/SearchByABN2015';
   public static final String ABN_TRUST_NAME = 'name';
   public static final String HTTP_METHOD = 'GET';
   public static final Integer REQUEST_TIMEOUT = 12000;
   public static final String ABN_NUMBER = 'abnnumber';
   public static final String PARTY_ID = 'partyId';
   public static final String NAME_API_TYPE = 'ABNSearchSMSFAPI';
   public static final String NUMBER_API_TYPE = 'SearchByABNNumberAPI';
   public static final String FAMILY_NAME = 'ABNSearchSMSF';
   public static final String NUMBER_PROVIDER = 'SearchByABNNumber';
   public static final String NUMBER_CONFIGURATION = 'SearchByABNNumber config';
   public static final String NUMBER_ADAPTER_CLASS = 'SMSFSearchByABNNumberAdapter';
   public static final String NUMBER_REQUEST_MAPPING = '{"thirdPartySystem":{"name":"abnRequest","dynamicDataParameters":[{"externalField":"abnnumber"}],"filters":[{"objectAPI":"ABN_Search_SMSF__c","objectAlias":"guidinfo","fields":[{"externalField":"guid","fieldAPI":"GUID__c"}],"whereClause":""}]}}';
   public static final String NAME_PROVIDER = 'ABNSearchSMSF';
   public static final String NAME_CONFIGURATION = 'ABNSearchSMSF config';
   public static final String NAME_ADAPTER_CLASS = 'SMSFABNNameSearchAdapter';
   public static final String NAME_REQUEST_MAPPING = '{"thirdPartySystem":{"name":"ABNSearchSMSF","dynamicDataParameters":[{"externalField":"abndata"}],"filters":[{"objectAPI":"clcommon__Party__c","objectAlias":"partyinfo","fields":[{"externalField":"name","fieldAPI":"clcommon__Account__r.Name"}],"whereClause":"Id = :partyId"},{"objectAPI":"ABN_Search_SMSF__c","objectAlias":"guidInfo","fields":[{"externalField":"guid","fieldAPI":"GUID__c"},{"externalField":"activeFundsOnly","fieldAPI":"Active_Funds_Only__c"},{"externalField":"maxSearchResults","fieldAPI":"Maximum_Search_Results__c"}],"whereClause":""}]}}';
  
   //SMSF ABN Integration Exceptions
   public static final String GUID_EXCEPTION = ': GUID is null or blank';
   public static final String ACTIVE_FUNDS_ONLY_EXCEPTION = ': Active Funds Only is null or blank';
   public static final String MAX_SEARCH_RESULTS_EXCEPTION = ': Maximum Search Results is null or blank';
   public static final String ABN_TRUST_NAME_EXCEPTION = ': Name is null or blank';
   public static final String NAMED_CREDENTIAL_EXCEPTION = ': API named credential is null or blank';
   public static final String GENERAL_EXCEPTION = 'Something went wrong';
   public static final String INVALID_SMSF_NAME = 'Invalid SMSF Name';
   public static final String INVALID_ABN = 'Invalid ABN';
   public static final String PARTY_ID_EMPTY = 'Party Id is empty';
   public static final String ABN_NUMBER_EMPTY ='ABN field is empty';

   //Equifax Director Org Id Search
  public static final String EQUIFAX_CREDS = 'credentials';
  public static final String SUBSCRIBER_IDENTIFIER = 'subscriberIdentifier';
  public static final String SECURITY = 'security';
  public static final String PARTY_NAME = 'name';
  public static final String EQUIFAX_API_TYPE = 'Equifax Org Id Search API';
  public static final String EQUIFAX_FAMILY_NAME = 'Equifax Org Id Search';
  public static final String INVALID_REQUEST = 'Invalid Request';
  public static final String EQUIFAX_ABN_NUMBER = 'abnNumber';
  public static final String EQUIFAX_XML_REQUEST_BODY = 'equifaxXMLRequestBody';
  public static final String EQUIFAX_XML_BODY = 'EquifaxXMLBody';
  public static final String BCA_ERROR = '<BCAerror>';
  public static final String BCA_ERROR_DESCRIPTION_TAG = '<BCAerror-description>';
  public static final String BCA_ERROR_DESCRIPTION_CLOSE_TAG = '</BCAerror-description>';
  public static final String ERROR = '<error>';
  public static final String ERROR_DESCRIPTION_TAG = '<error-description';
  public static final String ERROR_DESCRIPTION_CLOSE_TAG = '/error-description>';
  public static final String OPEN_TAG = '>';
  public static final String CLOSE_TAG = '<';
  public static final String CS_SUBSCRIBER_IDENTIFIER = 'CSsubscriberIdentifier';
  public static final String CS_SECURITY = 'CSsecurity';
  public static final String REQUEST_BODY_PARTY_NAME = 'partyName';
  public static final String USERNAME = 'username';
  public static final String PASSWORD = 'password';
  public static final String REQUEST_ABN_NUMBER = 'ABNNumber';
  public static final String CREDENTIAL_USERNAME = '{!$Credential.UserName}';
  public static final String CREDENTIAL_PASSWORD = '{!$Credential.Password}';
  public static final String EQUIFAX_CRED_EXCEP = 'Equifax Credentials is null or blank';
  public static final String PARTY_NAME_EXCEP = 'Party Name is null or blank';
  public static final String SUBSCRIBER_IDENTIFIER_EXCEP = 'Subsrciber Identifier is null or blank';
  public static final String SECURITY_EXCEP = 'Security is null or blank';
  public static final String EQUIFAX_REQUEST_MAPPING = '{"thirdPartySystem":{"name":"EquifaxOrgIdSearch","dynamicDataParameters":[{"externalField":"equifaxXMLRequestBody"},{"externalField":"abnNumber"}],"filters":[{"objectAPI":"clcommon__Party__c","objectAlias":"partyInfo","fields":[{"externalField":"name","fieldAPI":"Name"}],"whereClause":"Id = :partyId"},{"objectAPI":"EquifaxOrdIdSearch__c","objectAlias":"credentials","fields":[{"externalField":"subscriberIdentifier","fieldAPI":"Subscriber_Identifier__c"},{"externalField":"security","fieldAPI":"Security__c"}],"whereClause":""}]}}';
  public static final String ABN_SEARCH_NUMBER = '46006261623';
  public static final String ASIC_REPORT_NOT_FOUND = 'ASIC Report Not found';

  public static final String US_SERVICE = '_service';
  public static final String SERVICE = 'service';
  public static final String HS_REQUEST = '-request';
  public static final String REQUEST = 'request';
  public static final String US_BCA = 'BCA';
  public static final String LS_BCA = 'bca';
  public static final String HS_RESULT = '-result';
  public static final String US_RESULT = 'Result';
  public static final String HS_BUSINESS = '-business';
  public static final String US_BUSINESS = 'Business';
  public static final String HS_NUMBER = '-number';
  public static final String US_NUMBER = 'Number';
  public static final String HS_REPORT = '-report';
  public static final String US_REPORT = 'Report';
  public static final String HS_NAME = '-name';
  public static final String US_NAME = 'Name';
  public static final String ORG_ID_RESULT = '"orgIdResult"';


  //Previous Enquiry Integration
  public static final String NO_ENQ_ID = 'Enquiry Id field cannot be blank';
  public static final String PREV_ENQ_REQ_BODY_SRNAME = 'Request body Static Resource not found';
  public static final String APP_PDF_CONTENT_TYPE = 'application/pdf';
  public static final String PREV_ENQ_STATIC_RES = 'PreviousEnquiry';
  public static final String PREV_ENQ_DOC_CAT = 'Credit Report';
  public static final String PREV_ENQ_PDF_CONTENT_TYPE = 'application/json';
  public static final String PREV_ENQ_PDF_NAME_PREF = 'Apply Individual Document for ';

  //Credit Rule Constant Values
  public static final String LOAN_DETAILS = 'Loan Details';
  public static final String CASHOUT_PURPOSE_RULE = 'Cash Out Purpose Suitable Rule';
  public static final String COMMISSION_MANADATE_PERCENTAGE_RULE = 'Commission Mandate Percentage Rule';
  public static final String INTEREST_ONLY_SUITABE_RULE = 'Interest Only Suitable Rule';
  public static final String EXIT_STRATEGY_SUITABLE_RULE = 'Exit Strategy Suitable Rule';
  public static final String LENDERS_MORTAGE_INSURANCE_RULE = 'Lenders Mortgage Insurance Rule';
  public static final String SETTLEMENT = 'Settlement';
  public static final String CUSTOMER_INTERVIEW_COMPLETED_RULE = 'Customer Interview completed Rule';
  public static final String SECURITIES = 'Securities';
  public static final String DISTRESSED_ASSET_RULE = 'Distressed Asset Rule';
  public static final String CHECK_VAL_VALUE_RULE = 'Check Val Value Rule';
  public static final String INDIVIDUAL_CONTACT_DETAILS = 'Individual Contact Details';
  public static final String TEMPORARY_VISA_SUITABILITY_RULE = 'Temporary Visa Suitability Rule';
  public static final String ABN_STATUS_EXPLANATION_SUITABLE_RULE = 'ABN Status Explanation Suitable Rule';
  public static final String EXIT_STRATEGY_SUITABLE_RULE_CONTACT = 'Exit Strategy Suitable Rule (Contact)';
  public static final String BORROWER_IS_A_STAFF_MEMBER = 'Borrower is a Staff Member Rule';
  public static final String NON_INDIVIDUAL_CONTACT_DETAILS = 'Non Individual Contact Details';
  public static final String GST_SUITABLE_RULE = 'GST Suitable Rule';
  public static final String CREDIT_HISTORY = 'Credit History';
  public static final String EXPLANATION_OF_CREDIT_EVENTS = 'Explanation of Credit Events Suitable Rule';
  public static final String EXPLANATION_OF_CREDIT_ENQUIRIES = 'Explanation of Credit Enquiries Suitable Rule';
  public static final String EXPLANATION_OF_BANKRUPTCY = 'Explanation of Bankruptcy Suitable Rule';
  public static final String EXPLANATION_OF_AGE_OF_CREDIT_FILE = 'Explanation of Age of Credit File Suitable Rule';
  public static final String INDIVIDUAL_EMPLOYMENT_INFORMATION = 'Individual Employment Information';
  public static final String CONFIRM_LETTER_PREPARED_BY_ACCOUNTANT = 'Confirm letter prepared by accountant Rule';
  public static final String CONFIRM_STATED_ANNUAL_INCOME = 'Confirm stated annual income Rule';
  public static final String ACCOUNTANT_AWARE_OF_ANY_CIRCUMSTANCE = 'Accountant aware of any circumstances Rule';
  public static final String ACCOUNTANT_CALL_SUITABLE_RULE = 'Accountant Call Suitable Rule';
  public static final String EMPLOYMENT_CALL_SUITABLE_RULE = 'Employment Call Suitable Rule';
  public static final String INCOME_INCONSISTANT_WITH_DECLARATION_RULE = 'Income Consistent with Declaration Rule';
  public static final String LIVING_EXPENSE = 'Living Expense';
  public static final String LIVING_EXPENSE_EXPLANATION_SUITABLE_RULE = 'Living Expense Explanation Suitable Rule';
  public static final String BANK_STATEMENT_REVIEWED_RULE = 'Bank Statements Reviewed Rule';
  public static final String COMPANY_INCOME = 'Company Income';
  public static final String SATISFACTORY_EXPLANATION_PROVIDED_RULE = 'Satisfactory Explanation Provided Rule';
  public static final String INVALID_RULES = 'Rules not found';
  public static final String EMPTY_CHECKLIST = 'Checklist is empty!';
  public static final String NO_RULE_FOUND = 'No rule is found!';
  public static final String RULE_CRITERIA_NOT_FOUND = 'No rule criteria found!';
  public static final String TYPE_NOT_SUPPORTED = 'Type not supported yet';
  public static final String FAIL = 'FAIL';
  public static final String PARTY_API = 'Party__c';
  public static final String EMPLOYMENT_INFORMATION_API = 'Employment_Information__r';
  public static final String RECORDS_NOT_FOUND = 'Records not found';
  public static final String DOUBLE_CHECK = 'Double';
  public static final String ACL_VERIFIED_RULE = 'ACL/ACR Verified Rule';
  public static final String COMMISSION_STATUS_RULE = 'Commission Status Rule';
  public static final String BROKER_CONTACT_DETAILS = 'Broker Contact Details';
  public static final String ASSET_LIABILITY = 'AssetLiabilties';
  public static final String PREVIOUS_CONDUCT_SUITABLE = 'Previous Conduct Suitable Rule';
  public static final String GST_EFFECTIVE_FROM_RULE = 'GST Effective from Rule';

  // ABA FileGen Class
  public static final String PAYMENT_MODE_ACH = 'ACH';
  public static final String FILEGEN_HEAD_RECORD_TYPE = '0';
  public static final String BLANK = ' ';
  public static final String REEL_SEQ_NUMBER = '01';
  public static final String FINACIAL_INST_NOT_DEFINED = 'Financial Institution is not defined';
  public static final String COMPANY_USER_NAME_NOT_DEFINED = 'Company User name not defined';
  public static final String COMPANY_USERID_NOT_DEFINED = 'Company User Id not defined';
  //APC Filegen Class Constant Values
  public static final String FILEGEN_ENTRY_RECORD_TYPE = '1';
  public static final String INDICATOR = ' ';
  public static final String FILEGEN_TRAIL_RECORD_TYPE = '7';
  public static final String TRAIL_BSB_NUM = '999-999';

  public static final String NO_USERNAME_FOUND = 'Name of User not found';
  public static final String USERID_MISSING = 'Number of User not found';
  public static final String ACCOUNT_NAME_WLEN = 'Account Name length cannot be greater than 32';
  public static final String INVESTOR_BA_MISSING = 'Investor Bank Account not found';
  public static final String INVESTOR_BA_DETAILS_MISSING = 'Investor Bank Account Holder Name or Bank Name or Account Number is Missing';
  public static final String MULTIPLE_LPTS = 'Multiple LPTs found on under same contract';
  public static final String ALREADY_REVERSED = 'This LPT is already reversed';
  public static final String SUCCESS_LPT_REV = 'This LPT is Successfully reversed';
  public static final String AMOUNT_NOT_NEGATIVE = 'Transaction amount needs to be negative';
  public static final String MULTIPLE_BANK = 'Multiple active bank accounts found';
  public static final String WITHDRAWAL = 'WITHDRAWAL';
  public static final String ENTRY_SCOPE_EMPTY = 'Entry Scope is empty';
  public static final Integer STANDARD_BSB_LENGTH = 6;
  public static final Integer STANDARD_ACCOUNT_NUMBER_LENGTH = 9;
  public static final String LPT_FILE_GEN = 'LoanPaymentTransactionFileGen';

  // ABA FileGen Class Txn Codes
  public static final Integer TXN_CODE_DEBIT = 13;
  public static final Integer TXN_CODE_CREDIT = 50;
  public static final Integer TXN_CODE_AU_GOVT_SEC_INT = 51;
  public static final Integer TXN_CODE_FAMILY_PYMNT = 52;
  public static final Integer TXN_CODE_PAY = 53;
  public static final Integer TXN_CODE_PENSION = 54;
  public static final Integer TXN_CODE_ALLOTMENT = 55;
  public static final Integer TXN_CODE_DIVIDEND = 56;
  public static final Integer TXN_CODE_DEBENTURE = 57;

  // LoanPaymentReturnFileHandler Class Return Causes
  public static final String RET_CAUSE_1 = 'due to Invalid BSB Number';
  public static final String RET_CAUSE_2 = 'as the Payment Stopped';
  public static final String RET_CAUSE_3 = 'because the Account is Closed';
  public static final String RET_CAUSE_4 = 'as the Customer has been Deceased';
  public static final String RET_CAUSE_5 = 'because there is No Account or the Account Number is incorrect';
  public static final String RET_CAUSE_6 = 'it refers to the Customer';
  public static final String RET_CAUSE_7 = 'as the account is deleted for not being used';
  public static final String RET_CAUSE_8 = 'because the user Id number is invalid';
  public static final String RET_CAUSE_9 = 'because it is technically invalid';
  public static final String RET_CAUSE_DEFAULT = 'error unidentified';

  //APC Filegen Class Exception Constant Values
  public static final Integer STANDARD_ACCOUNT_NAME_LENGTH = 32;
  public static final String SOLICITOR_PARTY_TYPE = 'Solicitor';
  public static final String BANK_ACC_MISSING_PAYER = 'Borrower Bank Account not found';
  public static final String BANK_ACC_DETAILS_MISSING_PAYER = 'Borrower Bank Account Holder Name or Bank Name or Account Number is Missing';
  public static final String WRONG_BSB_PAYEE = 'Warehouse BSB Number is missing or wrong';
  public static final String WRONG_BSB_PAYER = 'Solicitor BSB Number is missing or wrong';
  public static final String WRONG_ACOUNT_NUMBER_PAYER = 'Solicitor Account Number is missing or wrong';
  public static final String WRONG_ACOUNT_NUMBER_PAYEE = 'Warehouse Account Number is missing or wrong';
  public static final String REMITTER_NOT_FOUND = 'Remitter Name not defined';
  public static final String COMPANY_BANK_DETAILS_MISSING = 'Company Bank Details missing';
  public static final String NO_APC_FOUND = 'No Automated Payment Configured';
  public static final String TRANSACTION_AMT_NOT_FOUND = 'Transaction Amount is missing';
  public static final String PAYER_ACCOUNT_NAME_MISSING = 'Solicitor Account Name is missing or missing';
  public static final String LODGMENT_REFERENCE_MISSING = 'Disbursal Txn Reference is missing';
  public static final String WAREHOUSE_INST_MISSING = 'Warehouse Institution Name is missing';

  //Return File processor
  public static final String NAME = 'Name';
  public static final String LPT_PREFIX = 'LPT-';
  public static final String LPT_EXCEP = 'LPT not present';
}