/********************************************************************************
Description:    This class stores all the constant values used
Developer:      Rameswari Barman
Created Date:   05/10/2018
*********************************************************************************/
global class ConstantValues{

    //Lending Calculator Constant Values 
    global static string TermValidationMsg='Please define the loan term.'; 
    global static string AppAlreadyConvertedMsg='Application has already been converted to Loan Application.';
    global static string IntRateValidationMsg='Interest Rate can not be left blank or a negative value.';
    global static string PmntFreqReqMsg='Please define the payment frequency.';
    global static String loanAmntValidation='Please provide a valid loan amount.';
    global static string investmentAmountCannotBeLess = 'Investment amount cannot be less than requested loan amount for this single tranche loan.';
    global static string disbursement = 'Disbursement';
    global static string inFunding = 'In Funding';
    global static string regular = 'Regular';
    global static string approved = 'Approved';
        
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
    
}