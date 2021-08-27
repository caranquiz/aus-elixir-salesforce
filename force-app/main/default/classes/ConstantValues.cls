/********************************************************************************
Description: This class stores all the constant values used
Developer: Rameswari Barman
Created Date: 05/10/2018
*********************************************************************************/
global class ConstantValues {
  //Check Rules Constant Values
  global static final string CHECKRULES_APPLICATION_ID_NULL = 'Application ID is null';

  //Lending Calculator Constant Values
  global static final string TERM_VALIDATION_MSG = 'Please define the loan term.';
  global static final string APP_ALREADY_CONVERTED_MSG = 'Application has already been converted to Loan Application.';
  global static final string INTEREST_RATE_VALIDATION_MSG = 'Interest Rate can not be left blank or a negative value.';
  global static final string PAYMENT_FREQUENCY_VALIDATION_MSG = 'Please define the payment frequency.';
  global static final string LOAN_AMT_VALIDATION_MSG = 'Please provide a valid loan amount.';
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
  global static final string jointType = 'Joint Account';
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
  global static final string validTfnNum = 'Please enter valid tfn number';
  global static final string validExempType = 'Please enter valid exemption type';
  global static final string validBankAccNum = 'Please enter valid bank account number';
  global static final string validBankAccName = 'Please enter valid bank account name';
  global static final string validBsbNum = 'Please enter valid bsb number';
  global static final string validBankName = 'Please enter valid bank name';

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
  global static final string lookupConflict = 'Conflicting lookup relationship found. Please contact System Administrator';
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
  public static final String SAMPLE_TITLE_SEARCH_RES = 'Sample_Title_Search_Response';
  public static final String SAMPLE_ORDER_DOCUMENT_RES = 'Sample_Order_Document_Response';
  public static final String SAMPLE_DELIVER_DOCUMENT_SUCCESS_RES = 'Sample_Deliver_Document_Success_Response';
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
  public static final String CLIENT_REFERENCE = '__clientReference';
  public static final String ENQ_CLIENT_REFERENCE = '__enquiryClientReference';
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
  public static final String RES_HEADER =
    '<soap:Envelope xmlns:evnt="http://veda-services/event-notify-v1-0.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
    '<soap:Header/><soap:Body><evnt:notify-event-response><evnt:notify-event-data>';
  public static final String RES_FOOTER = '</evnt:notify-event-data></evnt:notify-event-response></soap:Body></soap:Envelope>';
  // Exceptions
  public static final String REQ_SLT_ACTION = '<wsa:Action>http://vedaxml.com/land-titles/searchLandTitlesRequest</wsa:Action></soap:Header>';
  public static final String REQ_OD_ACTION = '<wsa:Action>http://vedaxml.com/land-titles/orderDocumentRequest</wsa:Action></soap:Header>';
  public static final String REQ_DD_ACTION = '<wsa:Action>http://vedaxml.com/land-titles/deliverDocumentRequest</wsa:Action></soap:Header>';
  public static final String REQ_ENVELOPE_END = '</soap:Body></soap:Envelope>';
  public static final String REQ_BODY = '<soap:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">';
  public static final String REQ_HEADER =
    '<soap:Header>' +
    '<wsse:Security mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">' +
    '<wsse:UsernameToken>' +
    '<wsse:Username>{!$Credential.UserName}</wsse:Username>' +
    '<wsse:Password>{!$Credential.Password}</wsse:Password>' +
    '</wsse:UsernameToken>' +
    '</wsse:Security>' +
    '<wsa:To>https://vedaxml.com/sys2/soap12/land-titles-v1</wsa:To>';
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
  public static final String COUNTRY_MISSING = 'Country is missing or wrong';
  public static final String GENDER_MISSING = 'Gender is missing';
  public static final String DOB_MISSING = 'Date of Birth is missing';
  public static final String APP_REF_MISSING = 'Application Reference is missing';
  public static final String APPLY_IND_SUCCESS = 'Individual Enquiry Report has been fetched Successfully';
  public static final String NO_DIRECTORSHIPS = 'No Directorship found';
  public static final String APPLY_IND_PARAM_NULL = 'Equifax Apply Individual Party Update null check exception';
  public static final String RESPONSE_PARSE_ERR = 'There is Something wrong while parsing the response.';

  //SMSF ABN Integration
  public static final String GUID_VALUE = 'c4726ad0-af04-4d8d-987b-d15966cd1cfd';
  public static final String GUID = 'guid';
  public static final String GUID_STRUCTURE = '&guid=';
  public static final String ABN_STRUCTURE = '?abn=';
  public static final String SMSFSEARCHCLASS = 'SMSFSearchByABNNumberAdapter';
  public static final String CALLOUT_STRUCTURE = 'callout:';
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
  public static final String NUMBER_REQUEST_MAPPING = '{"thirdPartySystem":{"name":"abnRequest","dynamicDataParameters":[{"externalField":"abnnumber"}],"filters":[{"objectAPI":"ABN_Search_SMSF__c","objectAlias":"guidInfo","fields":[{"externalField":"guid","fieldAPI":"GUID__c"}],"whereClause":""}]}}';
  public static final String NAME_PROVIDER = 'ABNSearchSMSF';
  public static final String NAME_CONFIGURATION = 'ABNSearchSMSF config';
  public static final String NAME_ADAPTER_CLASS = 'SMSFABNNameSearchAdapter';
  public static final String NAME_REQUEST_MAPPING = '{"thirdPartySystem":{"name":"ABNSearchSMSF","dynamicDataParameters":[{"externalField":"abndata"}],"filters":[{"objectAPI":"clcommon__Party__c","objectAlias":"partyInfo","fields":[{"externalField":"name","fieldAPI":"ABN_Company_Name__c"}],"whereClause":"Id = :partyId"},{"objectAPI":"ABN_Search_SMSF__c","objectAlias":"guidInfo","fields":[{"externalField":"guid","fieldAPI":"GUID__c"},{"externalField":"activeFundsOnly","fieldAPI":"Active_Funds_Only__c"},{"externalField":"maxSearchResults","fieldAPI":"Maximum_Search_Results__c"}],"whereClause":""}]}}';

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
  public static final String ABN_NUMBER_EMPTY = 'ABN field is empty';

  //Equifax Director Org Id Search
  public static final String EQUIFAX_CREDS = 'credentials';
  public static final String SUBSCRIBER_IDENTIFIER = 'subscriberIdentifier';
  public static final String SECURITY = 'security';
  public static final String PARTY_NAME = 'name';
  public static final String EQUIFAX_API_TYPE = 'Equifax Org Id Search API';
  public static final String EQUIFAX_FAMILY_NAME = 'Equifax Org Id Search';
  public static final String INVALID_REQUEST = 'Invalid Request';
  public static final String EQUIFAX_ACN_NUMBER = 'abnNumber';
  public static final String EQUIFAX_XML_REQUEST_BODY = 'equifaxXMLRequestBody';
  public static final String EQUIFAX_XML_BODY = 'EquifaxXMLBody';
  public static final String BCA_ERROR = 'BCAerror';
  public static final String BCA_ERROR_DESCRIPTION_TAG = '<BCAerror-description>';
  public static final String BCA_ERROR_DESCRIPTION_CLOSE_TAG = '</BCAerror-description>';
  public static final String ERROR = '<error>';
  public static final String ERRORKEY = 'error';
  public static final String ERROR_DESCRIPTION_TAG = '<error-description';
  public static final String ERROR_DESCRIPTION_CLOSE_TAG = '/error-description>';
  public static final String OPEN_TAG = '>';
  public static final String CLOSE_TAG = '<';
  public static final String CS_SUBSCRIBER_IDENTIFIER = 'CSsubscriberIdentifier';
  public static final String CS_SECURITY = 'CSsecurity';
  public static final String REQUEST_BODY_PARTY_NAME = 'partyName';
  public static final String USERNAME = 'username';
  public static final String PASSWORD = 'password';
  public static final String REQUEST_ACN_NUMBER = 'ACNNumber';
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
  public static final String COMMISSION_MANADATE_PERCENTAGE_WARNING = 'Commission Mandate Percentage Warning';
  public static final String INTEREST_ONLY_SUITABE_RULE = 'Interest Only Suitable Rule';
  public static final String EXIT_STRATEGY_SUITABLE_RULE = 'Exit Strategy Suitable Rule';
  public static final String LENDERS_MORTAGE_INSURANCE_RULE = 'Lenders Mortgage Insurance Rule';
  public static final String SETTLEMENT = 'Settlement';
  public static final String CUSTOMER_INTERVIEW = 'Customer Interview';
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
  public static final String SELF_EMPLOYMENT_ABN_EFFECTIVE_FROM_RULE = 'Self Employment ABN Effective From Rule';
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
  public static final String PERCENT_CHECK = 'PERCENT';
  public static final String CURRENCY_CHECK = 'CURRENCY';
  public static final String ACL_VERIFIED_RULE = 'ACL/ACR Verified Rule';
  public static final String COMMISSION_STATUS_RULE = 'Commission Status Rule';
  public static final String BROKER_CONTACT_DETAILS = 'Broker Contact Details';
  public static final String ASSET_LIABILITY = 'AssetLiabilties';
  public static final String REVIEW = 'Review';
  public static final String WARNING = 'Warning';
  public static final String WARNING2 = 'Warning2';
  public static final String XCEPTION = 'Exception';
  public static final String CONDITION = 'Condition';

  public static final String PREVIOUS_CONDUCT_SUITABLE = 'Previous Conduct Suitable Rule';
  public static final String GST_EFFECTIVE_FROM_RULE = 'GST Effective from Rule';
  public static final String ABN_EFFECTIVE_RULE = 'ABN Effective From Rule';
  public static final String LMI_RULE = 'LMI and LMI Approved both should be yes rule';
  public static final String ABN_ACN_NO_FOUND = 'ABN or ACN not found';

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
  public static final String WAREHOUSE_MISSING = 'Warehouse not attached with CL Contract.';

  //Return File processor
  public static final String NAME = 'Name';
  public static final String LPT_PREFIX = 'LPT-';
  public static final String LPT_EXCEP = 'LPT not present';
  public static final String LPT_AMOUNT_EXCEP = 'Amount does not match';

  //Equifax Company Enquiry
  public static final String NO_PARTY_ID = 'No partyID found';
  public static final String NO_APPLICATION_FOUND = 'No ApplicationID found';
  public static final String NO_ENRICHMENT = 'No enrichment found';
  public static final String PARTY_TYPE_ID = 'partyTypeId';
  public static final String ENTITY_ID = 'entityID';
  public static final String APPLICATION_ID = 'applicationID';
  public static final String BORROWER = 'Borrower';
  public static final String CO_APPLICANT = 'Co-applicant';
  public static final String ENRICHMENT_REQUIRED = 'enrichmentRequired';
  public static final String IS_JOINT = 'isJoint';
  public static final String NO_RESPONSE_MAP = 'No response map';
  public static final String NO_RESPONSE_OBJECT = 'No response object';
  public static final String NO = 'no';
  public static final String YES = 'yes';
  public static final String APPLICATION_INFO = 'applicationInfo';
  public static final String APPLICATION_NAME = 'applicationName';
  public static final String LOAN_AMOUNT = 'loanAmount';
  public static final String PARTY_RELATED_INFO = 'partyRelatedInfo';
  public static final String NAME_KEY = 'name';
  public static final String PARTY_TYPE_NAME = 'partyTypeName';
  public static final String GUARANTOR = 'Guarantor';
  public static final String GUARANTOR_PARTY_UPDATE = 'guarantor';
  public static final String JOINT = 'joint';
  public static final String PRINCIPAL = 'principal';
  public static final String ENTITY_RELATED_INFO = 'entityRelatedInfo';
  public static final String ENTITY_NAME = 'entityName';
  public static final String COMPANY_ACN = 'companyACN';
  public static final String ENQUIRY_COMPANY = 'Company';
  public static final String FAMILY_TRUST = 'Family Trust';
  public static final String ENQUIRY_SMSF = 'SMSF';
  public static final String TRUST = 'Trust';
  public static final String TRUSTEE_ACN = 'trusteeACN';
  public static final String COMPANY_ENQUIRY_RESPONSE_RECEIVED_SUCCESSFULLY = 'Company Enquiry Response Received Successfully';
  public static final String DIRECTOR = 'Director';
  public static final String NO_DIRECTORS_FOUND = ' \nNo Directors found';
  public static final String SHAREHOLDER = 'Shareholder';
  public static final String NO_SHAREHOLDERS_FOUND = '\nNo Shareholders found';
  public static final String NO_CREDIT_ENQUIRIES_FOUND = '\nNo Credit Enquiries found';
  public static final String NO_PAYMENT_DEFAULTS_FOUND = '\nNo Payment Defaults found';
  public static final String NO_PPSR_REGISTRATIONS_FOUND = '\nNo ppsr Registartions Found';
  public static final String PARTY_INFO_MAP = 'partyinfo';
  public static final String SUMMARY_NAME = 'summary-name';
  public static final String NODE_VALUE = 'NodeValue';
  public static final String ADDRESS_PREFIX = 'address-prefix';
  public static final String STREET_DETAILS = 'street-details';
  public static final String LOCALITY_DETAILS = 'locality-details';
  public static final String STATE = 'state';
  public static final String POSTCODE = 'postcode';
  public static final String UNIT_NUMBER = 'unit-number';
  public static final String STREET_NUMBER = 'street-number';
  public static final String STREET_NAME = 'street-name';
  public static final String STREET_TYPE = 'street-type';
  public static final String SUBURB = 'suburb';
  public static final String FAULT = 'Fault';
  public static final String DETAIL = 'detail';
  public static final String DESCRIPTION = 'description';
  public static final String COMPANY_ENQUIRY_REPORT = 'company-enquiry-report';
  public static final String COMPANY_RESPONSE = 'company-response';
  public static final String COMPANY_IDENTITY = 'company-identity';
  public static final String BUREAU_INFO = 'bureau-info';
  public static final String BUREAU_REFERENCE = 'bureau-reference';
  public static final String ORGANISATION_REPORT_HEADER = 'organisation-report-header';
  public static final String REQUEST_ID = 'request-id';
  public static final String REPORT_CREATE_DATE = 'report-create-date';
  public static final String DATE_NOT_DEFINED = 'date not defined';
  public static final String NULL_VALUE = 'Null value';
  public static final String SUMMARY_DATA = 'summary-data';
  public static final String SUMMARY_ENTRY = 'summary-entry';
  public static final String SUMMARY_VALUE = 'summary-value';
  public static final String CREDIT_ENQUIRIES_VALUE = 'Credit_Enquiries_Value';
  public static final String CREDIT_ENQUIRIES_LESS_THAN_12_MONTHS = 'Credit_Enquiries_Less_Than_12_Months';
  public static final String CREDIT_ENQUIRIES_LESS_THAN_12_MONTHS_VALUE = 'Credit_Enquiries_Less_Than_12_Months_Value';
  public static final String CREDIT_ENQUIRIES_MORE_THAN_12_MONTHS = 'Credit_Enquiries_More_Than_12_Months';
  public static final String CREDIT_ENQUIRIES_MORE_THAN_12_MONTHS_VALUE = 'Credit_Enquiries_More_Than_12_Months_Value';
  public static final String EXTERNAL_ADMIN = 'External_Admin';
  public static final String DEFAULTS = 'Defaults';
  public static final String DEFAULTS_VALUE = 'Defaults-Value';
  public static final String DEFAULTS_LESS_THAN_12 = 'Defaults-12';
  public static final String DEFAULTS_LESS_THAN_12_VALUE = 'Defaults-12-Value';
  public static final String DEFAULTS_MORE_THAN_12 = 'Defaults_More_Than_12_Months';
  public static final String DEFAULTS_MORE_THAN_12_VALUE = 'Defaults_More_Than_12_Months_Value';
  public static final String EXTRACT_DATE = 'extract-date';
  public static final String ASIC_EXTRACT_DATE = 'asic-extract-date';
  public static final String INCORPORATION = 'incorporation';
  public static final String INCORPORATION_DATE = 'incorporation-date';
  public static final String ORGANISATION_STATUS = 'organisation-status';
  public static final String TYPE = 'type';
  public static final String ACCOUNT_TYPE = 'account-type';
  public static final String ADDRESS_LINES = 'address-lines';
  public static final String REGISTERED_OFFICE = 'registered-office';
  public static final String FILE_CREATION_DATE = 'file-creation-date';
  public static final String WRITS_AND_SUMMONS = 'Writs_and_Summons';
  public static final String WRITS_AND_SUMMONS_VALUE = 'Writs_and_Summons_Value';
  public static final String JUDGEMENTS = 'Judgements';
  public static final String JUDGEMENTS_VALUE = 'Judgements_Value';
  public static final String PETITIONS = 'Petitions';
  public static final String DIRECTORS_ADVERSE = 'Directors_Adverse';
  public static final String DIRECTORS_RELATED_ENTITY_ADVERSE = 'Directors_Related_Entity_Adverse';
  public static final String FIRST_GIVEN_NAME = 'first-given-name';
  public static final String INDIVIDUAL_NAME = 'individual-name';
  public static final String OWNERSHIP_OFFICERS = 'ownership-officers';
  public static final String DIRECTORS_LIST = 'directors-list';
  public static final String DIRECTORS = 'directors';
  public static final String DIRECTORS_ARRAY = 'directors=(';
  public static final String DIRECTORS_OBJECT = 'directors={';
  public static final String FAMILY_NAME_DIRECTOR = 'family-name';
  public static final String OTHER_GIVEN_NAME = 'other-given-name';
  public static final String FAMILY_NAME_SHAREHOLDER = 'family-name';
  public static final String ADDRESS = 'address';
  public static final String DATE_OF_BIRTH = 'date-of-birth';
  public static final String GENDER = 'gender';
  public static final String RESIDENCY_OVERSEAS = 'residency-overseas';
  public static final String EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER = 'EquifaxCompanyEnquiryResponseHelper';
  public static final String SHARE_HOLDER_LIST = 'share-holder-list';
  public static final String SHARE_HOLDER = 'share-holder';
  public static final String SHARE_HOLDER_ARRAY = 'share-holder=(';
  public static final String SHARE_HOLDER_ARRAY_LIST = 'share-holder=({';
  public static final String SHARE_HOLDER_OBJECT = 'share-holder={';
  public static final String SINGLE_SHARE_HOLDER_OBJECT = '{NodeValue=, share-holder={NodeValue=';
  public static final String INDIVIDUAL_SHARE_HOLDER = 'individual-share-holder';
  public static final String INDIVIDUAL_SHARE_HOLDER_ARRAY = 'individual-share-holder=(';
  public static final String INDIVIDUAL_SHARE_HOLDER_OBJECT = 'individual-share-holder={';
  public static final String ORGANISATION_SHARE_HOLDER = 'organisation-share-holder';
  public static final String ORGANISATION_NAME = 'organisation-name';
  public static final String BENEFICIAL_OWNERSHIP = 'beneficial-ownership';
  public static final String JOINTLY_HELD = 'joint-holding';
  public static final String SHARE_CLASS_CODE = 'share-class-code';
  public static final String SHARES_HELD = 'shares-held';
  public static final String ORGANISATION_CREDIT_HISTORY = 'organisation-credit-history';
  public static final String ALL_CREDIT_ENQUIRY_LIST = 'all-credit-enquiry-list';
  public static final String CREDIT_ENQUIRY_LIST = 'credit-enquiry-list';
  public static final String CREDIT_ENQUIRY = 'credit-enquiry';
  public static final String ENQUIRER = 'enquirer';
  public static final String AMOUNT = 'amount';
  public static final String ENQUIRY_DATE = 'enquiry-date';
  public static final String PPSR_REGISTRATIONS = 'ppsr-registrations';
  public static final String REPORT_INFORMATION = 'report-information';
  public static final String GRANTOR_SEARCH_CRITERIA = 'grantor-search-criteria';
  public static final String ORGANISATION_NUMBER = 'organisation-number';
  public static final String SEARCH_DATE = 'search-date';
  public static final String SEARCH_NUMBER = 'search-number';
  public static final String SEARCH_TYPE = 'search-type';
  public static final String REGISTRATION_SUMMARY = 'registration-summary';
  public static final String TOTAL_PMSI_REGISTRATIONS = 'total-pmsi-registrations';
  public static final String TOTAL_REGISTRATIONS = 'total-registrations';
  public static final String TOTAL_REGISTRATIONS_DESIGNATED_SECURED_PARTIES = 'total-registrations-designated-secured-parties';
  public static final String TOTAL_REGISTRATIONS_OTHER_FINANCIER_SECURED_PARTIES = 'total-registrations-other-financier-secured-parties';
  public static final String PAYMENT_DEFAULT_LIST = 'payment-default-list';
  public static final String PAYMENT_DEFAULT_ARRAY = 'payment-defaults=(';
  public static final String PAYMENT_DEFAULT_OBJECT = 'payment-defaults={';
  public static final String PAYMENT_DEFAULTS = 'payment-defaults';
  public static final String ROLE = 'role';
  public static final String ACCOUNT_NUMBER = 'account-number';
  public static final String PROVIDER = 'provider';
  public static final String ORIGINAL_PROVIDER = 'original-provider';
  public static final String DEFAULT_DATE = 'default-date';
  public static final String ORIGINAL_DEFAULT_DATE = 'original-default-date';
  public static final String REPORT_REASON = 'report-reason';
  public static final String ORIGINAL_REPORT_REASON = 'original-report-reason';
  public static final String ORIGINAL_AMOUNT = 'original-amount';
  public static final String PAYMENT_STATUS = 'payment-status';
  public static final String STATUS_DATE = 'status-date';
  public static final String REF_NUMBER = 'ref-number';
  public static final String SOMETHING_WENT_WRONG = 'Something went wrong';
  public static final String EQUIFAX_COMPANY_ENQUIRY_CALLOUT = 'EquifaxCompanyEnquiryCallout';
  public static final String REGISTRATION_LIST = 'registration-list';
  public static final String REGISTRATION_LIST_ARRAY = 'registration-detail=(';
  public static final String REGISTRATION_LIST_OBJECT = 'registration-detail={';
  public static final String REGISTRATION_DETAIL = 'registration-detail';
  public static final String REGISTRATION_NUMBER = 'registration-number';
  public static final String REGISTRATION_START_DATE = 'registration-start-date';
  public static final String MIGRATED_FLAG = 'migrated-flag';
  public static final String COLLATERAL_CLASS = 'collateral-class';
  public static final String PMSI_FLAG = 'pmsi-flag';
  public static final String SECURED_PARTIES = 'secured-parties';
  public static final String SECURED_PARTY = 'secured-party';
  public static final String ORGANISATION = 'organisation';
  public static final String ORGANISATION_NUMBER_TYPE = 'organisation-number-type';
  public static final String REGISTRATIONS = 'Registrations';
  public static final String NO_REGISTRATION_LIST_FOUND = '\nNo Registration List Found';
  public static final String LEGAL_ENTITY_TYPE_NOT_SUPPORTED = 'legal entity type not supported';
  public static final String PROBLEM_IN_REQUEST_MAPPING = 'Problem in RequestMapping';
  public static final String NO_PARTY_INFO_FOUND = 'No party Info found';
  public static final String SECURED_PARTY_LIST = 'secured-party=(';
  public static final String COMPANY_ENQUIRY_API_TYPE = 'Company Enquiry';
  public static final String CARE_OF = 'careof';
  public static final String COUNTRY = 'country';
  public static final String COMPANY_KEY = 'Company';

  //Warning, Exceptions and Condition names
  public static final String TRAIL_EXCEPTION = 'Trail (%) Exception';
  public static final String UPFRONT_EXCEPTION = 'Upfront Payment (%) Exception';
  public static final String ARMS_LENGTH_EXCEPTION = 'Arms Length Valuer Commentary Exception';
  public static final String HUNDRED_CHECK_EXCEPTION = '110% Check Exception';
  public static final String VALUATION_REQUIRED_EXCEPTION = 'Valuation Required Exception';
  public static final String VALUATION_RECEIVED_EXCEPTION = 'Valuation Received Exception';
  public static final String LICENSED_BUILDER_EXCEPTION = 'Licenced Builder Exception';
  public static final String ABN_STATUS_EXCEPTION = 'ABN Status Exception';
  public static final String OVERRIDE_EMPLOYMENT_EXCEPTION = 'Override Employment Exception';
  public static final String BAS_WARNING = 'BAS % Warning';
  public static final String EMPLOYMENT_CALL_MADE_EXCEPTION = 'Employment Call Made Exception';
  public static final String ABN_EFFECTIVE_SELF_EMPLOYEMENT_EXCEPTION = 'ABN Effective from Exception Self Employment';
  public static final String BROKER_DOCS_WARNING = 'Broker Documents Warning';
  public static final String POLITICALLY_EXPOSED_WARNING = 'Politically Exposed Person Warning';
  public static final String KYC_AML_WARNING = 'KYC/AML Verified Warning';
  public static final String RISK_WARNING = 'Risk Grade Warning';
  public static final String EXPLANATION_PROVIDED_WARNING = 'Explanation Provided Warning';
  public static final String EXIT_STRATEGY_WARNING = 'Exit Strategy Provided Applicant Warning';
  public static final String ABN_STATUS_WARNING = 'ABN Status Explanation Provided Warning';
  public static final String LIVING_EXPENSE_WARNING = 'Living Expense Explanation Received Warning';
  public static final String TELEPHONE_WARNING = 'Telephone, Internet, Pay TV & Media Streaming Warning';
  public static final String GROCERIES_WARNING = 'Groceries Warning';
  public static final String RECREATION_ENTERTAINMENT_WARNING = 'Recreation and Entertainment Warning';
  public static final String CLOTHING_AND_PERSONAL_WARNING = 'Clothing and Personal Care Warning';
  public static final String MEDICAL_AND_HEALTH_WARNING = 'Medical and Health Warning';
  public static final String TRANSPORT_WARNING = 'Transport Warning';
  public static final String INSURANCE_WARNING = 'Insurance (Excluding Private Health, Life, IP) Warning';
  public static final String CONTRACT_OF_SALE_WARNING = 'Contract Of Sale Warning';
  public static final String VALUED_DATE_WARNING = 'Valued Date Warning';
  public static final String LICENSED_REAL_ESTATE_WARNING = 'Licenced Real Estate Agent Contract Warning';
  public static final String COMPARABLE_SALES_EVIDENT_WARNING = 'Comparable Sales Evident Warning';
  public static final String VALUER_RISK_GRADINGS_WARNING = 'Valuer Risk Gradings Commentary Warning';
  public static final String LAND_AREA_WARNING = 'Land Area Warning';
  public static final String FLOOR_AREA_WARING = 'Floor Area Warning';
  public static final String ABN_EFFECTIVE_FROM_WARNING = 'ABN Effective From Warning';
  public static final String ABN_EFFECTIVE_FROM_ECEPTION = 'ABN Effective From Exception';
  public static final String ESTIMATED_COMPLETION_DATE = 'Estimated Completion Date Warning';
  public static final String HEM_WARNING = 'HEM Warning';
  public static final String GST_EFFECTIVE_FROM_WARNING = 'GST Effective From Warning';
  public static final String ACCOUNTANT_ABN_STATUS_WARNING = 'Accountant ABN Status Warning';
  public static final String ACCOUNTANT_PHONE_NUMBER_WARNING = 'Accountant Phone Number Verified Warning';
  public static final String ACCOUNTANT_CALL_WARNING = 'Accountant Call Warning';
  public static final String ACCOUNTANT_ABN_SEARCH_CONDUCTED_WARNING = 'Accountant ABN Search Conducted Warning';
  public static final String PRIMARY_RESIDENCE_PROPERTY_COST_WARNING = 'Primary Residence Property Cost Warning';
  public static final String EMPLOYER_PHONE_VERIFIED_WARNING = 'Employer Phone Independently Verified Warning';
  public static final String INCOME_VERIFICATEOION_SIGHTED = 'Income Verification Sighted Warning';
  public static final String EMPLOYMENT_DURATION_WARNING = 'Employment Duration (Months) Warning';
  public static final String EMPLOYER_VERIFIED_WARNING = 'Employer Verified Warning';
  public static final String IS_DIRECTOR_A_BENEFICIARY_WARNING = 'Is Director a Beneficiary / Member Warning';
  public static final String IS_TRUSTEE_A_BENEFICIARY_WARNING = 'Is Trustee a Beneficiary / Member Warning';
  public static final String GSA_WARNING = 'Is General Security Agreement Being Taken over this Applicant Warning Check';
  public static final String EDUCATION_WARNING = 'Education and Childcare Warning';
  public static final String INVETSMENT_PROPERTY_WARNING = 'Investment Property Warning Check';
  public static final String RENT_BOARD_WARNING = 'Rent/Board (post settlement of this facility) Warning';
  public static final String IS_PURCHASOR_MORTGAGOR_CONDITION = 'Is Purchaser the Mortgagor Condition';
  public static final String HOME_INSURANCE_CERTIFICATE_PROVIDED_CONDITION = 'Home Insurance Certificate Provide Warning';
  public static final String HMI_BODY_CORPORATE_CONDITION = 'Home Insurance Certificate Provide and Body Corporate Condition';
  public static final String HMI_STANDARD_CONDITION = 'Home Insurance Certificate Provide and Standard Condition';
  public static final String SIGNED_CONTRACT_CONDITION = 'Signed Contract Condition';
  public static final String FIXED_PRICE_CONTRACT_CONDITION = 'Fixed Price Contract Condition';
  public static final String DETAILED_COSTINGS_HELD_DEFINITION = 'Detailed Costings Held Condition';
  public static final String COPY_BUILDERS_LICENSE_HELD_CONDITION = 'Copy Builders Licence Held Condition';
  public static final String COPY_HOME_OWNERS_WARRANTY_CONDITION = 'Copy Home Owners Warranty Certificate Held Condition';
  public static final String COUNCIL_APPROVAL_CONDITON = 'Council Approval Held Condition';
  public static final String SMSF_STATUS_CONDITION = 'SMSF Status Condition';
  public static final String TRUST_DEED_PROVIDED_CONDITION = 'Trust Deed Provided Condition';
  public static final String ABN_EFFECTIVE_FROM_LIVING_EXPENSE_WARING = 'ABN Effective From Living Expense Warning';
  public static final String GST_EFFECTIVE_FROM_EMPLOYMENT_WARNING = 'GST Effective From Employment Warning';
  public static final String PRVATE_PENSION_AMT_WARNING = 'Private Pension Amount Warning';
  public static final String OTHER_INCOME_AMOUNT_WARNING = 'Other Income Amount Warning';
  public static final String SUPERANUATION_AMOUNT_WARNING = 'Superannuation Amount Warning';
  public static final String LOCATION_WARNING = 'Location Warning';
  public static final String LOCATION_NOT_ACCEPTABLE_WARNING = 'Location Not Acceptable Warning';
  public static final String TYPE_OF_DOCUMENTS_WARNING = 'Type of Documents Sighted Warning 1';
  public static final String TYPE_OF_DOCUMENTS_WARNING2 = 'Type of Documents Sighted Warning 2';
  public static final String TO_BE_REFINANCED_WARNING = 'To Be Refinance Condition';
  public static final String GIFT_STAT_DEC_RECEIVED_CONDITION = 'Gift Stat Dec Received Condition';
  public static final String RENTAL_INCOME_VERIFIED_WARNING = 'Rental Income Verified Warning';
  public static final String PREVIOUS_CONDUCT_EXLANATION_WARNING = 'Previous conduct explanation received Warning';
  public static final String PREVIOUS_CONDUCT_REFERENCING_COMPLETED_WARNING = 'Previous conduct referencing completed Warning';
  public static final String ABN_STATUS_EMPLPYMENT_WARNING = 'ABN Status Employment Exception';
  public static final String MATRIX_RATE_EXCEPTION = 'Matrix Rate Exception';
  public static final String CONFIRM_REPAYMENTS_WARNING = 'Confirm Repayments do not double Exception';
  public static final String OVERRIDE_EXCEPTION = 'Override Exception';
  public static final String IO_WARNING = 'Interest Only Reason Warning';
  public static final String EXIT_STRATEGY_PROVIEDED_WARNING = 'Exit Strategy Provided Warning';
  public static final String FIXED_RATE_WARNING = 'Fixed Rate Lock In Date Warning';
  public static final String MATRIX_RATE_WARNING = 'Matrix Rate Warning';
  public static final String ACTUAL_LVR_80_WARNING = 'Actual LVR > 80% Warning';
  public static final String ACTUAL_LVR_70_WARNING = 'Actual LVR > 70% Warning';
  public static final String ACTUAL_LVR_75_WARNING = 'Actual LVR > 75% Warning';
  public static final String CASH_OUT_PURPOSE_WARNING = 'Cash Out Purpose Explanation Provided Warning';
  public static final String APPLICATION_FEE_WARNING = 'Application Fee Warning';
  public static final String APPLICATION_FEE_PERCENTAGE_WARNING = 'Application Fee % Warning';
  public static final String DOES_APPLICANT_UNDERSTAND_ENGLISH_WARNING = 'Does applicant understand English Condition';
  public static final String APPLICATION_FORM_COMPLETED_WARNING = 'Is the Application Form fully completed? Warning';
  public static final String BANKRUPT_DISCHARGE_DATE_WARNING = 'Bankrupt Discharged Date Warning';
  public static final String EXPLANATION_OF_BAKRUPTCY_RECEIVED_WARNING = 'Explanation of Bankruptcy Received Warning';
  public static final String DATE_OF_CREDIT_REPORT_WARNING = 'Date of Credit Report Warning';
  public static final String APP_EXCEP = 'APP_XCEP';
  public static final String ERROR_TAG = 'ERROR';
  public static final String RECOMMENDED = 'Recommended';
  public static final String APPLICATION_COLLATERAL = 'Application_Collateral';
  public static final String PARTY_TAG = 'Party';
  public static final String INFO = 'INFO';
  public static final String YES_TAG = 'Yes';
  public static final String RISK_GRADE_COMPARE_WARNING = 'Risk Grade Compare Warning';
  public static final String PRIMARY_PURPOSE_WARNING = 'Primary Purpose Warning';
  public static final String DOCUMENT_TYPE_WARNING = 'Document Type Compare Warning';
  public static final String VALUATION_PAID_WARNING = 'Valuation Paid Warning';
  public static final String MONTHS_SELF_EMPLOYED_EXCEPTION = 'Months Self Employed Exception';
  public static final String GOVERNMENT_BENEFIT_AMT_WARNING = 'Government Benefit Amount Warning';
  public static final String PRIME = 'Prime';
  public static final String NEAR_PRIME = 'Near Prime';
  public static final String NEAR_PRIME_PLUS = 'Near Prime +';
  public static final String SPECIALIST = 'Specialist';
  public static final String SPECIALIST_PLUS = 'Specialist +';
  public static final String SELF_EMPLOYED = 'Self Employed';
  public static final String FULL_DOC = 'Full Doc';
  public static final String FULL = 'Full';
  public static final String ALT_DOC = 'Alt Doc';
  public static final String ALT = 'Alt';
  public static final String NO_TAG = 'No';
  public static final String CUSTOMER_ACCT_CONDITION = 'Customer Account Condition';
  public static final String CONDITION_CLASSIFICATION = 'Condition';
  public static final String RULE_CLASSIFICATION = 'Rule';
  public static final String EXCEPTION_CLASSIFICATION = 'Exception';
  public static final String WARNING_CLASSIFICATION = 'Warning';
  public static final String GURANTORS_NAME_KEY = '[guarantors names]';
  public static final String DOES_APPLICANT_UNDERSTAND_ENG_COND_TXT_KEY = '[Does applicant understand English Condition Text]';
  public static final String DOES_APPLICANT_UNDERSTAND_ENG_COND_TXT = 'Receipt of certificate from registered translator or bilingual solicitor acting for [individual applicant] confirming they have read and understood the transaction documents and Guarantors/Borrowers to obtain independent legal advice regarding this transaction';
  public static final String IND_APPLICANT_KEY = '[individual applicant]';
  public static final String GIFT_GIVER_NAME_KEY = '[add gift giver name]';
  public static final String GIFT_AMOUNT_KEY = '[add dollar amount]';
  public static final String LENDER_DETAILS_KEY = '[Lender Details]';
  public static final String REPLACEMENT_VALUE_KEY = '[Replacement Value Amount]';
  public static final String BROKER_PARTY_TYPE = 'Broker';
  public static final String AGGRERATOR_PARTY_TYPE = 'Aggregator';
  public static final String VALUER_PARTY_TYPE = 'Valuer';
  public static final String HOUSEHOLD_PARTY_TYPE = 'Household';
  public static final String SUCCESS_STATUS = 'SUCCESS';
  public static final String AUS_COUNTRY = 'Australia';
  public static final String AUS_COUNTRY_CODE = 'AUS';
  public static final String NZL_COUNTRY = 'New Zealand';
  public static final String NZL_COUNTRY_CODE = 'NZL';
  public static final String GENDER_MALE = 'Male';
  public static final String ACCOUNT_TYPE_APPLY_IND_REQ = 'RM';
  public static final String AUD_CURRENCY_CODE = 'AUD';
  public static final String MALE_GENDER_CODE = 'M';
  public static final String FEMALE_GENDER_CODE = 'F';
  public static final String UNKNOWN_GENDER_CODE = 'U';
  public static final String DOCUMENT_CATEGORY_NOT_FOUND = 'Document Category not found';
  public static final String TXN_REV_ERR = 'The transaction cannot be reversed as it is not the last transaction of the Loan Contract : ';
  public static final String TITLE_SEARCH_DOC = 'EquifaxLandTitleSearchResponse';
  public static final String ORDER_DOC = 'EquifaxLandTitleOrderDocumentResponse';
  public static final String DELIVER_DOC = 'EquifaxLandTitleDeliverDocumentResponse';
  public static final String UPFRONT_EXCEEDS_STANDARD_PERCENTAGE = 'Broker Upfront Exceeds Standard Upfront Warning';
  public static final String TRAIL_EXCEEDS_STANDARD_PERCENTAGE = 'Broker Trail Exceeds Standard Trail Warning';
  public static final String ORG_ID_ENQUIRY_SUBJECT_NOT_FOUND = 'Subject of your enquiry was not found.';
  public static final String MODE_OF_ENVIRONMENT = 'modeOfEnvironment';
  public static final String TEST_ENVIRONMENT = 'test';
  public static final String PRODUCTION_ENVIRONMENT = 'production';
  public static final String SUCCESSFULLY_DONE = 'Successfully done';
  public static final String START_DATE_MISSING = 'Please provide the expected start Date';
  public static final String CATEGORY_3_OR_4 = 'Cat 3/Cat 4';
  public static final String DRIVERS_LICENSE_KEY = '__drivers__licence__wkey';
  public static final String MOBILE_TAG = 'Mobile';
  public static final String OWNER_OCCUPIED = 'Owner Occupied';
  public static final String ATT_DELETION_MESSAGE = 'Attachment has been deleted successfully!';
  public static final String SUBMITTED =  'Submitted';
  public static final String NEW_TAG = 'New';
  public static final String EXISTING_TAG = 'Existing';
  public static final String CREDIT_ENQUIRY_OBJECT = 'credit-enquiry={';
  public static final String CREDIT_ENQUIRY_LIST_BRACES = 'credit-enquiry=({';
  public static final String COLLATERAL_OWNER_WARNING = 'Only accounts from the same application can be added as Collateral Owners.';
  public static final String CONSUMER = 'Consumer';
  public static final String COMMERCIAL = 'Commercial';
  public static final String DEFAULT_JUDGEMENTS = 'Default Judgements';
  public static final String OTHER_COURT_ACTIONS = 'Other Court Action';
  public static final String PERSONAL_INSOLVENCIES = 'Personal Insolvencies';
  public static final Decimal CREDIT_RECORD_VALUE = 1000;
  public static final String SETTLEMENT_FEE_WARNING = 'Settlement Fee % Warning';
  public static final String APPLICATION_SETTLEMENT_FEE_WARNING = 'Settlement Fee Percentage Warning';

  //Constant of LinkedLoansExtension Class
  public static final String LINKED_LOAN_ERROR_MSG1 = 'Linked Loan can' +'\'t be same as Current Loan';
  public static final String LINKED_LOAN_ERROR_MSG2 = 'Linked Loan already exist in Current Loan';
  public static final String SEMICOLON=';';
  public static final String LOAN_ID='id';
  public static final String LOAN_ACCOUNT_ID='loanId';

  //Constant Value of LoanPaymentTxnClearingJobCustomQuery Class
  public static final String PaymentTxnClearing_Limit = ' LIMIT 0';
  public static final String BusinessHours_Name = 'Elixir Financial Holiday Setup';
  
  //LTS Migration class Constants
  public static final String DEPOSIT_SUBTRACT = 'Deposit Adjustment - Subtract';
  public static final String DEPOSIT_ADD = 'Deposit Adjustment - Add';
  public static final String PAYMENT_TRANSACTION='loan__Loan_Payment_Transaction__c';
  public static final String DISBURSAL_TRANSACTION='loan__Loan_Disbursal_Transaction__c';

  //Constant Values of ContactDetailUpdateBatch Class
  public static final String Home_Phone='Home Phone';
  public static final String None_Tag= 'None';

  //LTSRedrawUpdateBatch Constant Values
  public static final String REDRAW='Redraw';

  //GenerateStatment
  public static final String INT_RATE = 'Int Rt:';
  public static final String INVALID_LOAN= 'Invalid Loan';
  public static final String END_DATE_CANT_BE_IN_FUTURE = 'End date cant be in future';
  public static final String GENERATE_STATEMENT_DOC = 'Generate_Statement_Document';
  public static final String LOAN_ACCOUNTID = '{!loan__Loan_Account__c.loan__AccountId__c}';
  public static final String ACCOUNT_ID = '{!loan__Loan_Account__c.Id}';
  public static final String BRANCH_ID = '{!loan__Loan_Account__c.loan__BranchId__c}';
  public static final String ACCOUNT_NAME = '{!loan__Loan_Account__c.Name}';
  public static final String PAYMENT_RECEIVED = 'Payment Received';
  public static final String INTEREST_TAG = 'Interest';
  public static final String DISCOUNT_TAG = 'Discount';
  public static final String INTERNAL_TRANSFER = 'Internal Transfer';
  public static final String LOAN_PAYOFF = 'Loan Payoff';
  public static final String RATE_CHANGE = 'Rate Change';
  public static final String OTHER_TRANSACTION = 'loan__Other_Transaction__c';
  public static final String TITLE_RECEIVED = 'Title Received';
  
  //Constant Values of Secretaries EquifaxCompanyEnquiryResponseHelper Class
  public static final String SECRETARIES='Secretaries';
  public static final String SECRETARYLIST='secretary-list';
  public static final String SECRETARIES_ARRAY='secretaries=(';
  public static final String DOCUMENT_DETAILS='document-details';
  public static final String DOCUMENT_NUMBER='document-number';
  public static final String INDIVIDUAL_OFFICER='individual-officer';
  public static final String SECRETARY='Secretary';
  public static final String SECRETARIES_ARRAY_LIST='secretaries={';
  public static final String SECRETARY_NOT_FOUND='\nNo Secretary Found';
  public static final String SECRETARIES1='secretaries';
  public static final String NO_SECRETARY_APPOINTED_CONDITION='No Secretary Appointed Condition';
  public static final String BORROWER_GUARANTOR_COMPANY_NAME='[borrower/guarantor company name]';

  //Equifax Individual Response
  public static final string VARIABLE_NAME='variable-name';
  public static final string COUNTRY_CODE='country-code';
  public static final string IDENTITY='identity';
  public static final string ADDRESSES='addresses';
  public static final string ADDRESSES_OBJECT='addresses={';
  public static final string ADDRESSES_ARRAY='addresses=(';
  public static final string PRODUCT_HEADER='product-header';
  public static final string PRODUCT_DATA='product-data';
  public static final string ENQUIRY_REPORT='enquiry-report';
  public static final string PUBLIC_CONSUMER_CREDIT='public-record-or-consumer-credit-information';
  public static final string CONSUMER_CREDIT='consumer-credit-file';
  public static final string COMMERCIAL_CREDIT='commercial-credit-file';
  public static final string DATA_BLOCK='data-block';
  public static final string PRIMARY_MATCH='primary-match';
  public static final string ENQUIRY_ID='enquiry-id';
  public static final string ELE_TEXT='ele_text';
  public static final string VALUE='value';
  public static final string SCORE_DATA_ARRAY='score-data=(';
  public static final string SCORE_DATA_OBJECT='score-data={';
  public static final string SCORE_DATA='score-data';
  public static final string SCORECARD='scorecard';
  public static final string SCORECARD_ID='id';
  public static final string SCORE_MASTERSCALE='score-masterscale';
  public static final string PERMISSION_TYPE='permission-type';
  public static final string DATETIME_REQUESTED='datetime-requested';
  public static final string EMPLOYMENT='employment';
  public static final string EMPLOYMENT_ARRAY='employment=(';
  public static final string EMPLOYMENT_OBJECT='employment={';
  public static final string EMPLOYER='employer';
  public static final string POSSIBLE_MATCHES='possible-matches';
  public static final string POSSIBLE_MATCH='possible-match';
  public static final string DIRECTORSHIPS='directorships';
  public static final string DIRECTORSHIPS_ARRAY='directorships=(';
  public static final string DIRECTORSHIPS_OBJECT='directorships={';
  public static final string DIRECTORSHIPS_ABN='ABN';
  public static final string DIRECTORSHIP='directorship';
  public static final string DISQUALIFIED_DIRECTORSHIPS='disqualified-directorships';
  public static final string DISQUALIFIED_DIRECTORSHIPS_ARRAY='disqualified-directorships=(';
  public static final string DISQUALIFIED_DIRECTORSHIPS_OBJECT='disqualified-directorships={';
  public static final string DATE_DISQUALIFIED='date-disqualified';
  public static final string DATE_DISQUALIFIED_UNTIL='date-disqualified-until';
  public static final string DISQUALIFIED_DIRECTORSHIP='disqualified-directorship';
  public static final string NO_DISQUALIFIED_DIRECTORSHIP_FOUND='\nNo Disqualified Directorships found';
  public static final string CREDIT_ENQUIRIES='credit-enquiries';
  public static final string CREDIT_ENQUIRIES_ARRAY='credit-enquiries=(';
  public static final string CREDIT_ENQUIRIES_OBJECT='credit-enquiries={';
  public static final string CREDIT_ENQUIRER='credit-enquirer';
  public static final string ENQUIRY_AMOUNT='enquiry-amount';
  public static final string RELATIONSHIP='relationship';
  public static final string CODE='code';
  public static final string ENQUIRY_CLIENT='enquiry-client-reference';
  public static final string PRINCIPAL_SOLE='Principal (sole)';
  public static final string PRINCIPAL_JOINT='Principal (joint)';
  public static final string NO_CONSUMER_CREDIT_ENQUIRIES_FOUND='\nNo Consumer Credit Enquiries found';
  public static final string NO_COMMERCIAL_CREDIT_ENQUIRIES_FOUND='\nNo Commercial Credit Enquiries found';
  public static final string ACCOUNTS='accounts';
  public static final string ACCOUNTS_OBJECT='accounts={';
  public static final string ACCOUNTS_ARRAY='accounts=(';
  public static final string ACCOUNT_ID_ACCOUNT='account-id';
  public static final string ORIGINAL_CREDIT_PROVIDER='original-credit-provider';
  public static final string LATEST_CREDIT_PROVIDER='latest-credit-provider';
  public static final string DEFAULTS_LIST='defaults';
  public static final string DEFAULT_OBJECT='defaults={';
  public static final string DEFAULT_ARRAY='defaults=(';
  public static final string ORIGINAL_DEFAULT='original-default';
  public static final string DATE_RECORDED='date-recorded';
  public static final string CURRENT_DEFAULT='current-default';
  public static final string DEFAULT_AMOUNT ='default-amount';
  public static final string ACCOUNT='account';
  public static final string NO_COMMERCIAL_CREDIT_ACCOUNTS_FOUND='\nNo Commercial Credit Accounts found';
  public static final string NO_CONSUMER_CREDIT_ACCOUNTS_FOUND='\nNo Consumer Credit Accounts found';
  public static final string COURT_ACTIONS='court-actions';
  public static final string COURT_ACTIONS_ARRAY='court-actions=(';
  public static final string COURT_ACTIONS_OBJECT='court-actions={';
  public static final string DEFAULT_JUDGEMENT='default-judgement';
  public static final string CREDITOR='creditor';
  public static final string ACTION_DATE='action-date';
  public static final string COURT_ACTION_AMOUNT='court-action-amount';
  public static final string PLAINT_NUMBER='plaint-number';
  public static final string COURT_ACTION_STATUS='court-action-status';
  public static final string DATE_COURT='date';
  public static final string NO_DEFAULT_JUDGEMENT_COURT_ACTION='\nNo Default Judgements or Court Actions found';
  public static final string PERSONAL_INSOLVENCIES_LIST='personal-insolvencies';
  public static final string PERSONAL_INSOLVENCIES_ARRAY='personal-insolvencies=(';
  public static final string PERSONAL_INSOLVENCIES_OBJECT='personal-insolvencies={';
  public static final string TEXT='text';
  public static final string DATE_DECLARED='date-declared';
  public static final string ADMINISTRATION_ID='administration-id';
  public static final string NUMBER_PERSONAL='number';
  public static final string NO_PERSONAL_INSOLVENCIES_FOUND='\nNo Personal Insolvencies found';
  public static final string SETTLEMENT_FEE_PLAN = 'Settlement Fee Plan';
  public static final string ELIXIR_COMMISSION_PLAN = 'Elixir Commission Plan';
  public static final string PERSON_ACCOUNT='Person Account';
}