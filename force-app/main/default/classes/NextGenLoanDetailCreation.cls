/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class acts as the parser class for the request of NextGenAuthentication 
                and Insert Application Details.
Development Date : 10/04/2022
Last Modified Date : 18/05/2022
Devloper's comment : Some part of the codes are hardcoded and not been put in Constant Classes - since
                    they are referenced only here and its a one time use.
****************************************************************************************************/
public class NextGenLoanDetailCreation {

    public static void LoanDetailRecordCreation(
        Map<String, Object> loanDetailSegmentMap,
        Map<String, Object> financialSegmentMap,
        List<genesis__Applications__c> objApplicationList,
        List<Account> accountList,
        String borrowerAccount
    ){
        Date currentSysDate =(Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
        List<String> repaymentType=new List<String>();
        List<clcommon__CL_Product__c> clProductList=[SELECT id,
                                                            Name,
                                                            clcommon__Product_Name__c  
                                                        FROM clcommon__CL_Product__c ];
        if(
            ((Map<String, Object>)loanDetailSegmentMap)!= null &&
            String.valueOf(
            ((Map<String, Object>)loanDetailSegmentMap
            ))
            .contains('LoanDetails={')){
                genesis__Applications__c objApplication=new genesis__Applications__c();
                Object eachLoanDetail = ((Object) (loanDetailSegmentMap).get('LoanDetails'));
                
                if(((Map<String, Object>) eachLoanDetail) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachLoanDetail)
                    .get('LoanPurpose')) !=null &&
                    ((String)((Map<String, Object>) ((Map<String, Object>) eachLoanDetail)
                    .get('LoanPurpose')).get('PrimaryPurpose')) !=null){
                        if((String)((Map<String, Object>) ((Map<String, Object>) eachLoanDetail)
                        .get('LoanPurpose')).get('PrimaryPurpose')=='OwnerOccupied'){
                            objApplication.Primary_loan_purpose_list__c='Owner Occupied';
                        }else{
                            objApplication.Primary_loan_purpose_list__c=(String)((Map<String, Object>) 
                                    ((Map<String, Object>) eachLoanDetail).get('LoanPurpose')).get('PrimaryPurpose');
                        }
                }
                objApplication.Sales_Channel__c='Next Gen';
                objApplication.genesis__Interest_Rate__c=0;
                objApplication.genesis__Expected_Start_Date__c=currentSysDate;

                if(((Map<String, Object>) eachLoanDetail) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachLoanDetail)
                .get('LoanPurpose')) !=null &&
                ((Map<String,Object>)((Map<String, Object>) ((Map<String, Object>) eachLoanDetail)
                .get('LoanPurpose')).get('LendingPurposeCode')) !=null &&
                ((String)((Map<String,Object>)((Map<String, Object>) 
                ((Map<String, Object>) eachLoanDetail)
                .get('LoanPurpose')).get('LendingPurposeCode')).get('Description')) !=null){
                    String description=(String)((Map<String,Object>)(
                        (Map<String, Object>) ((Map<String, Object>) eachLoanDetail)
                        .get('LoanPurpose')).get('LendingPurposeCode')).get('Description');
                        if(description!=null){
                            objApplication.Primary_Loan_Purpose__c = (description.contains('125')  || description.contains('127')) ? ConstantValues.PURCHASE_NEW                                       
                                : (description.contains('129') || description.contains('131') ||
                                description.contains('231') || description.contains('329') || 
                                description.contains('330') || description.contains('331') ||
                                description.contains('332') || description.contains('335') ||
                                description.contains('336') ||description.contains('337')) ? ConstantValues.PURCHASE_EXISTING
                                : (description.contains('245') || description.contains('121') ||
                                description.contains('327')|| description.contains('320')) ? ConstantValues.CONSTRUCTION
                                : (description.contains('123') || description.contains('322') ||
                                description.contains('323') || description.contains('321')) ? ConstantValues.CONSTRUCTION
                                : (description.contains('143') || description.contains('221') ||
                                description.contains('223') || description.contains('225') ||
                                description.contains('227') || description.contains('229') ||
                                description.contains('237') || description.contains('241') ||
                                description.contains('247')) ? ConstantValues.REFINANCE_CASH_OUT
                                : (description.contains('340') || description.contains('341') ||
                                description.contains('342') || description.contains('343')) ? ConstantValues.REFINANCE_BUSINESS_PURPOSES
                                : (description.contains('243')) ? ConstantValues.REFINANCE_BUSINESS_PURPOSES
                                : (description.contains('239') || description.contains('348')) ? ConstantValues.REFINANCE_DEBT_CONSOLIDATION
                                : (description.contains('249') || description.contains('349')) ? ConstantValues.REFINANCE_CASH_OUT
                                :(description.contains('133')) ? ConstantValues.REFINANCE
                                : '';

                                objApplication.ABS_lending_purpose__c = (description.contains('125')  || description.contains('127')) ? ConstantValues.PURCHARE_NEW_LENDING                                       
                                    : (description.contains('129') || description.contains('131') ||
                                    description.contains('231') || description.contains('329') ||
                                    description.contains('330') || description.contains('331') ||
                                    description.contains('332') || description.contains('335') ||
                                    description.contains('336') || description.contains('337')) ? ConstantValues.PURCHASE_EXISTING_LENDING
                                    : (description.contains('245') || description.contains('121') ||
                                    description.contains('327')|| description.contains('320')) ? ConstantValues.CONSTRUCTION_DWELLING
                                    : (description.contains('123') || description.contains('322') ||
                                    description.contains('323') || description.contains('321')) ? ConstantValues.CONSTRUCTION_OTHER_DWELLING
                                    : (description.contains('143') || description.contains('221') ||
                                    description.contains('223') || description.contains('225') ||
                                    description.contains('227') || description.contains('229') ||
                                    description.contains('237') || description.contains('241') ||
                                    description.contains('247')) ? ConstantValues.REFINANCE_EXISTING
                                    : (description.contains('340') || description.contains('341') ||
                                    description.contains('342') || description.contains('343')) ? ConstantValues.REFINANCE_EQUITY
                                    : (description.contains('243')) ? ConstantValues.REFINANCE_DEBT_LENDING
                                    : (description.contains('239') || description.contains('348')) ? ConstantValues.REFINANCE_DEBT_LENDING
                                    : (description.contains('249') || description.contains('349')) ? ConstantValues.REFINANCE_EQUITY
                                    :(description.contains('133'))? ConstantValues.REFINANCE_EXISTING
                                    : '';
                        }
                        
                }
                if(((Map<String, Object>) eachLoanDetail) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachLoanDetail)
                    .get('EstimatedSettlement')) !=null ){
                            String settlementDate=(String)((Map<String, Object>) 
                            ((Map<String, Object>) eachLoanDetail).get('EstimatedSettlement')).get('NodeValue');
                            if (settlementDate != null && settlementDate.length() > 9) {
                                objApplication.genesis__Disbursement_Date__c= Date.newInstance(
                                    Integer.valueOf(settlementDate.substring(0, 4)),
                                    Integer.valueOf(settlementDate.substring(5, 7)),
                                    Integer.valueOf(settlementDate.substring(8, 10))
                                );
                            }
                }
                
                Map<String,Object> loanTermMap=new Map<String,Object>();
                if((Map<String, Object>) ((Map<String, Object>) eachLoanDetail).get('LoanPortion')!=null){
                    loanTermMap=(Map<String, Object>) (
                        (Map<String, Object>) eachLoanDetail).get('LoanPortion');
                }
                if(((Map<String, Object>) loanTermMap) != null &&
                    ((String) ((Map<String, Object>) loanTermMap)
                    .get('ProductName')) !=null){
                        String productName=((String) (
                            (Map<String, Object>) loanTermMap).get('ProductName')).SubStringBefore(' (');
                        for(clcommon__CL_Product__c clProduct:clProductList){
                            if(clProduct.clcommon__Product_Name__c==productName){
                                objApplication.genesis__CL_Product__c=clProduct.id;
                            }
                        }
                        if(((String) ((Map<String, Object>) loanTermMap).get(
                            'ProductName')).contains(') (')){
                            String riskGrade=((String) ((Map<String, Object>) loanTermMap).get(
                                'ProductName')).substringBetween(' (', ') (');
                            objApplication.Risk_grade_list__c=riskGrade;
                        }else{
                            String riskGrade=((String) ((
                                Map<String, Object>) loanTermMap).get('ProductName')).substringBetween(' (', ')');
                            objApplication.Risk_grade_list__c=riskGrade;
                        }
                        if(((String) ((Map<String, Object>) loanTermMap)
                            .get('ProductName')).contains(',')){
                            String documentType=((String) ((Map<String, Object>) 
                                loanTermMap).get('ProductName')).substringBetween(', ', ')');
                            objApplication.Document_Type__c=documentType;
                        }
                        else if(((String) ((Map<String, Object>) loanTermMap)
                            .get('ProductName')).contains(') (')){
                            String documentType=((String) ((Map<String, Object>) 
                                loanTermMap).get('ProductName')).substringBetween(') (', ')');
                            objApplication.Document_Type__c=documentType;
                        }
                }

                if(((Map<String, Object>) loanTermMap) != null &&
                ((Map<String, Object>) ((Map<String, Object>) loanTermMap)
                .get('PaymentPeriod')) !=null && 
                ((Map<String, Object>)((Map<String, Object>)
                ((Map<String, Object>)loanTermMap).get('PaymentPeriod')).get('Period'))!=null ){
                    if((String)((Map<String, Object>)((Map<String, Object>)
                            ((Map<String, Object>)loanTermMap).get('PaymentPeriod'))
                            .get('Period')).get('Unit')=='Fortnightly'){
                        objApplication.genesis__Payment_Frequency__c='BI-WEEKLY';
                    }else{
                        objApplication.genesis__Payment_Frequency__c=(String)((Map<String, Object>)
                                ((Map<String, Object>)((Map<String, Object>)
                                loanTermMap).get('PaymentPeriod')).get('Period')).get('Unit');

                    }
                }
                if(((Map<String, Object>) loanTermMap) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) loanTermMap)
                    .get('AmountRequested')) !=null ){
                        objApplication.genesis__Loan_Amount__c=Decimal.valueOf(
                            (String)((Map<String, Object>) ((Map<String, Object>) loanTermMap)
                            .get('AmountRequested')).get('Amount'));
                }

                /*if(((Map<String, Object>) eachLoanDetail) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachLoanDetail)
                    .get('Fees')) !=null && ((String)((Map<String, Object>) 
                    ((Map<String, Object>) eachLoanDetail)
                    .get('Fees')).get('Type')) !=null &&
                    (String)((Map<String, Object>) ((Map<String, Object>) eachLoanDetail)
                    .get('Fees')).get('Type')=='LMI'){
                    objApplication.Lenders_Mortgage_Insurance__c='Yes';
                }*/
                if(((Map<String, Object>)eachLoanDetail)!= null &&
                    String.valueOf(
                    ((Map<String, Object>)eachLoanDetail
                    ))
                    .contains('Fees=(')){
                    List<Object> refFees = ((List<Object>) (
                        (Map<String, Object>)eachLoanDetail).get('Fees'));
                    for(Object eachFees: refFees){
                        if(((Map<String, Object>) eachFees) != null &&
                            ((String) ((Map<String, Object>) eachFees)
                            .get('Type')) != null &&
                            ((String) ((Map<String, Object>) eachFees)
                            .get('Type'))=='LMI'){
                            
                            objApplication.Lenders_Mortgage_Insurance__c='Yes';
                        }
                    }

                }else if(((Map<String, Object>)eachLoanDetail)!= null &&
                String.valueOf(
                ((Map<String, Object>)eachLoanDetail
                ))
                .contains('Fees={')){
                    Object eachFees = ((Object)  ((Map<String, Object>)eachLoanDetail).get('Fees'));
                    if(((Map<String, Object>) eachFees) != null &&
                        ((String) ((Map<String, Object>) eachFees)
                        .get('Type')) != null &&
                        ((String) ((Map<String, Object>) eachFees)
                        .get('Type'))=='LMI'){
                        objApplication.Lenders_Mortgage_Insurance__c='Yes';
                    }
                }
                if(((Map<String, Object>)loanTermMap)!= null &&
                    String.valueOf(
                    ((Map<String, Object>)loanTermMap
                    ))
                    .contains('LoanTerm=(')){
                        List<Object> refloanTerm = ((List<Object>) (
                            (Map<String, Object>)loanTermMap).get('LoanTerm'));
                        for (Object loanDetail : refloanTerm) {
                            if(((Map<String, Object>) loanDetail) != null &&
                            ((String) ((Map<String, Object>) loanDetail)
                            .get('Type')) != null && ((String) ((Map<String, Object>) loanDetail)
                            .get('Type'))=='TotalTerm'){
                                if(((String) ((Map<String, Object>) loanDetail)
                                .get('Units'))=='Years'){
                                    objApplication.genesis__Term__c=Integer.valueOf(
                                        (String) ((Map<String, Object>) loanDetail).get('NodeValue'))*12;
                                }else{
                                    objApplication.genesis__Term__c=Integer.valueOf(
                                        (String) ((Map<String, Object>) loanDetail).get('NodeValue'));
                                }
                            }
                            if(((Map<String, Object>) loanDetail) != null &&
                            ((String) ((Map<String, Object>) loanDetail)
                            .get('Type')) != null && 
                            ((String) ((Map<String, Object>) loanDetail)
                            .get('PaymentType'))!=null && 
                            ((String) ((Map<String, Object>) loanDetail)
                            .get('PaymentType'))=='InterestOnly'){
                                if(((String) ((Map<String, Object>) loanDetail)
                                .get('Units'))=='Years'){
                                    objApplication.genesis__Interest_Only_Period__c=Integer.valueOf(
                                        (String) ((Map<String, Object>) loanDetail).get('NodeValue'))*12;
                                }else{
                                    objApplication.genesis__Interest_Only_Period__c=Integer.valueOf(
                                        (String) ((Map<String, Object>) loanDetail).get('NodeValue'));
                                }                                        
                                repaymentType.add('InterestOnly');
                            }
                            if(((Map<String, Object>) loanDetail) != null &&
                            ((String) ((Map<String, Object>) loanDetail)
                            .get('Type')) != null && ((String) ((Map<String, Object>) loanDetail)
                            .get('PaymentType'))!=null && ((String) ((Map<String, Object>) loanDetail)
                            .get('PaymentType'))=='PrincipalAndInterest'){
                                if(Integer.valueOf((String) ((Map<String, Object>) loanDetail).get('NodeValue'))>0){
                                    repaymentType.add('PrincipalAndInterest');
                                }                                    }
                        }

                }else if(((Map<String, Object>)loanTermMap)!= null &&
                    String.valueOf(
                    ((Map<String, Object>)loanTermMap
                    ))
                    .contains('LoanTerm={')){
                        Object loanDetail = ((Object)  ((Map<String, Object>)loanTermMap).get('LoanTerm'));
                        if(((Map<String, Object>) loanDetail) != null &&
                            ((String) ((Map<String, Object>) loanDetail)
                            .get('Type')) != null && ((String) ((Map<String, Object>) loanDetail)
                            .get('Type'))=='TotalTerm'){
                                if(((String) ((Map<String, Object>) loanDetail)
                                .get('Units'))=='Years'){
                                    objApplication.genesis__Term__c=Integer.valueOf(
                                        (String) ((Map<String, Object>) loanDetail).get('NodeValue'))*12;
                                }else{
                                    objApplication.genesis__Term__c=Integer.valueOf(
                                        (String) ((Map<String, Object>) loanDetail).get('NodeValue'));
                                }                                
                            }
                        if(((Map<String, Object>) loanDetail) != null &&
                            ((String) ((Map<String, Object>) loanDetail)
                            .get('Type')) != null && ((String) ((Map<String, Object>) loanDetail)
                            .get('PaymentType'))!=null && ((String) ((Map<String, Object>) loanDetail)
                            .get('PaymentType'))=='InterestOnly'){
                                if(((String) ((Map<String, Object>) loanDetail)
                                .get('Units'))=='Years'){
                                    objApplication.genesis__Interest_Only_Period__c=Integer.valueOf(
                                        (String) ((Map<String, Object>) loanDetail).get('NodeValue'))*12;
                                }else{
                                    objApplication.genesis__Interest_Only_Period__c=Integer.valueOf(
                                        (String) ((Map<String, Object>) loanDetail).get('NodeValue'));
                                }                                    
                                repaymentType.add('InterestOnly');
                        }
                        if(((Map<String, Object>) loanDetail) != null &&
                        ((String) ((Map<String, Object>) loanDetail)
                        .get('Type')) != null && ((String) ((Map<String, Object>) loanDetail)
                        .get('PaymentType'))!=null && ((String) ((Map<String, Object>) loanDetail)
                        .get('PaymentType'))=='PrincipalAndInterest'){
                            if(Integer.valueOf((String) ((Map<String, Object>) loanDetail).get('NodeValue'))>0){
                                repaymentType.add('PrincipalAndInterest');
                            }
                        }
                }
                if(repaymentType.size()>1){
                    objApplication.Repayment_Type__c='Interest Only reverting to Principal and Interest';
                }else if(repaymentType.size()==1 && repaymentType[0]=='PrincipalAndInterest'){
                    objApplication.Repayment_Type__c='Principal and Interest';
                }else if(repaymentType.size()==1 && repaymentType[0]=='InterestOnly'){
                    objApplication.Repayment_Type__c='Interest Only';
                }
                
                if(((Map<String, Object>) loanTermMap) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) loanTermMap)
                    .get('RepaymentMethod')) !=null && 
                    ((Map<String, Object>) ((Map<String, Object>) (
                    (Map<String, Object>) loanTermMap).get('RepaymentMethod'))
                    .get('AccountNumber')) !=null){
                        if(((String)((Map<String, Object>) ((Map<String, Object>) 
                        ((Map<String, Object>) loanTermMap).get('RepaymentMethod'))
                        .get('AccountNumber')).get('AcctName')) !=null){
                            for(Account objAccount:accountList){
                                if((objAccount.FirstName+objAccount.PersonEmail)==borrowerAccount ||
                                        (objAccount.Name)==borrowerAccount){
                                    objAccount.Bank_Account_Name__c=(String)((Map<String, Object>)(
                                        (Map<String, Object>) ((Map<String, Object>) loanTermMap)
                                        .get('RepaymentMethod'))
                                        .get('AccountNumber')).get('AcctName');
                                }
                            }
                        }
                        if(((String)((Map<String, Object>) (
                            (Map<String, Object>) ((Map<String, Object>) loanTermMap)
                            .get('RepaymentMethod'))
                            .get('AccountNumber')).get('AcctNbr')) !=null){
                            for(Account objAccount:accountList){
                                if((objAccount.FirstName+objAccount.PersonEmail)==borrowerAccount ||
                                    (objAccount.Name)==borrowerAccount){
                                    objAccount.Bank_Account_Number__c=(String)((Map<String, Object>) 
                                    ((Map<String, Object>) ((Map<String, Object>) loanTermMap)
                                    .get('RepaymentMethod'))
                                    .get('AccountNumber')).get('AcctNbr');
                                }
                            }
                        }
                        if(((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) loanTermMap)
                        .get('RepaymentMethod')).get('AccountNumber')).get('BSB')) !=null){
                            for(Account objAccount:accountList){
                                if((objAccount.FirstName+objAccount.PersonEmail)==borrowerAccount ||
                                    (objAccount.Name)==borrowerAccount){
                                    
                                    objAccount.BSB__c=(String)((Map<String, Object>) ((Map<String, Object>) 
                                    ((Map<String, Object>) loanTermMap)
                                    .get('RepaymentMethod'))
                                    .get('AccountNumber')).get('BSB');
                                }
                            }
                        }
                        
                    }
                    if(
                    ((Map<String, Object>)financialSegmentMap)!= null &&
                    String.valueOf(
                        ((Map<String, Object>)financialSegmentMap
                        ))
                        .contains('ValueItem=(')
                    ){
                    List<Object> refValueItem = ((List<Object>) ((Map<String, Object>)
                            financialSegmentMap).get('ValueItem'));

                    for(Object eachValueItem : refValueItem){
                        if(((Map<String, Object>) eachValueItem) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                            .get('Asset')) !=null &&
                            ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                            .get('Asset')).get('Class')) !=null &&
                            ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                            .get('Asset')).get('Class'))=='CurrentSecurity'){

                                if(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                .get('Asset')).get('RealEstate')) !=null && 
                                ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                                ((Map<String, Object>) eachValueItem)
                                .get('Asset')).get('RealEstate')).get('EstimatedValue'))!=null ){
                                    if(objApplication.Expected_security_value__c==null){
                                        objApplication.Expected_security_value__c=Decimal.valueOf(
                                            (String)((Map<String, Object>)((Map<String, Object>)(
                                            (Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                            .get('Asset')).get('RealEstate')).get('EstimatedValue')).get('NodeValue'));
                                    }else{
                                        objApplication.Expected_security_value__c+=Decimal.valueOf(
                                            (String)((Map<String, Object>)((Map<String, Object>)(
                                            (Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                            .get('Asset')).get('RealEstate')).get('EstimatedValue')).get('NodeValue'));
                                    }
                                    
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

                                if(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                    .get('Asset')).get('RealEstate')) !=null && 
                                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) (
                                    (Map<String, Object>) eachValueItem)
                                    .get('Asset')).get('RealEstate')).get('EstimatedValue'))!=null ){
                                    
                                    objApplication.Expected_security_value__c=Decimal.valueOf(
                                        (String)((Map<String, Object>)((Map<String, Object>)
                                        ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                        .get('Asset')).get('RealEstate')).get('EstimatedValue')).get('NodeValue'));
                                    
                                    
                                }
                            }
                        }    
                objApplicationList.add(objApplication);
        }
    }

    public static void loanSolicitorDetails(Map<String,Object> relatedPartySegmentMap,genesis__Applications__c objApplication){
        if(
            ((Map<String, Object>)relatedPartySegmentMap)!= null &&
            String.valueOf(
                ((Map<String, Object>)relatedPartySegmentMap
                ))
                .contains('RelatedParty=(')
        ){
            List<Object> refRelatedParty = ((List<Object>) (
                (Map<String, Object>)relatedPartySegmentMap).get('RelatedParty'));
            for(Object each:refRelatedParty){
                if(((Map<String, Object>) each) != null &&
                    (String)((Map<String, Object>) each).get('RelPartyType')!=null &&
                    (String)((Map<String, Object>) each).get('RelPartyType')=='Lawyer'){

                    if(((Map<String, Object>) each) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) each)
                        .get('CompanyName')) !=null &&
                        ((String)((Map<String, Object>) ((Map<String, Object>) each)
                        .get('CompanyName')).get('BusinessName')) !=null){
                        objApplication.Third_Party_Company_Name__c=(String)(
                            (Map<String, Object>) ((Map<String, Object>) each)
                            .get('CompanyName')).get('BusinessName');
                    }
                    if(((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('PersonName')) !=null &&
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('PersonName')).get('NameTitle')) !=null){
                        objApplication.Name_Title__c=(String)((Map<String, Object>)(
                            (Map<String, Object>) ((Map<String, Object>) each).get('PersonName'))
                            .get('NameTitle')).get('NodeValue');

                    }
                    if(((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('PersonName')) !=null &&
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('PersonName')).get('FirstName')) !=null){
                        objApplication.First_Name__c=(String)((Map<String, Object>)(
                            (Map<String, Object>) ((Map<String, Object>) each)
                            .get('PersonName')).get('FirstName')).get('NodeValue');

                    }
                    if(((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('PersonName')) !=null &&
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('PersonName')).get('Surname')) !=null){
                        objApplication.Surname__c=(String)((Map<String, Object>)(
                            (Map<String, Object>) ((Map<String, Object>) each)
                            .get('PersonName')).get('Surname')).get('NodeValue');

                    }
                    if(((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Email')) !=null ){
                        objApplication.Email__c=(String)((Map<String, Object>) (
                            (Map<String, Object>) each).get('Email')).get('NodeValue');

                    }
                    if(((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('WorkPhone')) !=null 
                    ){
                        if (
                            ((Map<String, Object>) each) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('WorkPhone')) !=null &&
                            String.valueOf(
                                ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('WorkPhone')))
                            .contains('Phone=(')                                
                            ){
                                List<Object> refPhone = ((List<Object>)((Map<String, Object>) 
                                ((Map<String, Object>) each)
                                .get('WorkPhone')).get('Phone'));
                                for (Object eachPhone : refPhone) {
                                    if(((Map<String, Object>) eachPhone) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                        .get('FixedPhone')) != null){
                                        objApplication.Third_Party_Office_Phone__c=(String)(
                                            (Map<String, Object>) ((Map<String, Object>) eachPhone)
                                            .get('FixedPhone')).get('NodeValue');
                                    }
                                    if(((Map<String, Object>) eachPhone) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                        .get('Mobile')) != null){
                                            objApplication.Mobile__c=(String)((Map<String, Object>) 
                                            ((Map<String, Object>) eachPhone)
                                            .get('Mobile')).get('NodeValue');
                                    }
                                }
                        }else if (
                            ((Map<String, Object>) each) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('WorkPhone')) !=null &&
                            String.valueOf(
                                ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('WorkPhone')))
                            .contains('Phone={')                                
                            ){
                                Object eachPhone = ((Object)  ((Map<String, Object>) (
                                    (Map<String, Object>) each).get('WorkPhone')).get('Phone'));
                                if(((Map<String, Object>) eachPhone) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                    .get('FixedPhone')) != null){
                                    objApplication.Third_Party_Office_Phone__c=(String)(
                                        (Map<String, Object>) ((Map<String, Object>) eachPhone)
                                    .get('FixedPhone')).get('NodeValue');
                                }
                                if(((Map<String, Object>) eachPhone) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                    .get('Mobile')) != null){
                                        objApplication.Mobile__c=(String)((Map<String, Object>) 
                                        ((Map<String, Object>) eachPhone)
                                        .get('Mobile')).get('NodeValue');
                                }
                        }

                    }
                }
                
            }
        }else if(
            ((Map<String, Object>)relatedPartySegmentMap)!= null &&
            String.valueOf(
                ((Map<String, Object>)relatedPartySegmentMap
                ))
                .contains('RelatedParty={')
        ){
            Object each = ((Object) ((Map<String, Object>)relatedPartySegmentMap).get('RelatedParty'));
            if(((Map<String, Object>) each) != null &&
                    (String)((Map<String, Object>) each).get('RelPartyType')!=null &&
                    (String)((Map<String, Object>) each).get('RelPartyType')=='Lawyer'){

                    if(((Map<String, Object>) each) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) each)
                        .get('CompanyName')) !=null &&
                        ((String)((Map<String, Object>) ((Map<String, Object>) each)
                        .get('CompanyName')).get('BusinessName')) !=null){
                        objApplication.Third_Party_Company_Name__c=(String)((Map<String, Object>) 
                        ((Map<String, Object>) each)
                        .get('CompanyName')).get('BusinessName');
                    }
                    if(((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('PersonName')) !=null &&
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('PersonName')).get('NameTitle')) !=null){
                        objApplication.Name_Title__c=(String)((Map<String, Object>)((Map<String, Object>) 
                        ((Map<String, Object>) each).get('PersonName')).get('NameTitle')).get('NodeValue');

                    }
                    if(((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('PersonName')) !=null &&
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('PersonName')).get('FirstName')) !=null){
                        objApplication.First_Name__c=(String)((Map<String, Object>)(
                            (Map<String, Object>) ((Map<String, Object>) each).get('PersonName'))
                            .get('FirstName')).get('NodeValue');

                    }
                    if(((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('PersonName')) !=null &&
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) each)
                    .get('PersonName')).get('Surname')) !=null){
                        objApplication.Surname__c=(String)((Map<String, Object>)(
                            (Map<String, Object>) ((Map<String, Object>) each)
                            .get('PersonName')).get('Surname')).get('NodeValue');

                    }
                    if(((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Email')) !=null ){
                        objApplication.Email__c=(String)((Map<String, Object>) (
                            (Map<String, Object>) each).get('Email')).get('NodeValue');

                    }
                    if(((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('WorkPhone')) !=null 
                    ){
                        if (
                            ((Map<String, Object>) each) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('WorkPhone')) !=null &&
                            String.valueOf(
                                ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('WorkPhone')))
                            .contains('Phone=(')                                
                            ){
                                List<Object> refPhone = ((List<Object>)  ((Map<String, Object>) 
                                ((Map<String, Object>) each)
                                .get('WorkPhone')).get('Phone'));
                                for (Object eachPhone : refPhone) {
                                    if(((Map<String, Object>) eachPhone) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                    .get('FixedPhone')) != null){
                                        if((String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                        .get('FixedPhone')).get('AreaCode')!=null){
                                            objApplication.Third_Party_Office_Phone__c=(String)(
                                                (Map<String, Object>) ((Map<String, Object>) eachPhone)
                                                .get('FixedPhone')).get('AreaCode')+
                                                (String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                                .get('FixedPhone')).get('NodeValue');
                                        }else{
                                            objApplication.Third_Party_Office_Phone__c=(String)(
                                                (Map<String, Object>) ((Map<String, Object>) eachPhone)
                                                .get('FixedPhone')).get('NodeValue');
                                        }
                                    
                                    }
                                    if(((Map<String, Object>) eachPhone) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                        .get('Mobile')) != null){
                                            objApplication.Mobile__c=(String)((Map<String, Object>) 
                                            ((Map<String, Object>) eachPhone)
                                            .get('Mobile')).get('NodeValue');
                                    }
                                }
                        }else if (
                            ((Map<String, Object>) each) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('WorkPhone')) !=null &&
                            String.valueOf(
                                ((Map<String, Object>) ((Map<String, Object>) each)
                            .get('WorkPhone')))
                            .contains('Phone={')                                
                            ){
                                Object eachPhone = ((Object)  ((Map<String, Object>) ((Map<String, Object>) each)
                                .get('WorkPhone')).get('Phone'));
                                if(((Map<String, Object>) eachPhone) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                    .get('FixedPhone')) != null){
                                        if((String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                        .get('FixedPhone')).get('AreaCode')!=null){
                                            objApplication.Third_Party_Office_Phone__c=(String)((Map<String, Object>) 
                                            ((Map<String, Object>) eachPhone).get('FixedPhone')).get('AreaCode')+
                                            (String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                            .get('FixedPhone')).get('NodeValue');
                                        }else{
                                            objApplication.Third_Party_Office_Phone__c=(String)((Map<String, Object>) 
                                            ((Map<String, Object>) eachPhone)
                                            .get('FixedPhone')).get('NodeValue');
                                        }
                                    
                                }
                                if(((Map<String, Object>) eachPhone) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                                    .get('Mobile')) != null){
                                        objApplication.Mobile__c=(String)((Map<String, Object>) 
                                        ((Map<String, Object>) eachPhone)
                                        .get('Mobile')).get('NodeValue');
                                }
                        }

                    }
                }
        }

    }

    public static List<Account> CheckDuplicateAccount(List<Account> accountList,List<Account> duplicateAccountList){

        List<clcommon__Legal_Entity__c> indivilegalEntityList=[SELECT id,
                                                                    Name 
                                                                FROM clcommon__Legal_Entity__c 
                                                                WHERE Name='Individual'];
    
        List<String> firstName=new List<String>();
        List<String> lastName=new List<String>();
        List<String> accountName=new List<String>();
        List<String> email=new List<String>();
        List<String> accountABN=new List<String>();
        List<Account> objAccountList=new List<Account>();
        List<Date> dateOfBirthCheck=new List<Date>();
        for(Account objAccount:accountList){
            if(indivilegalEntityList.size()>0 && 
                    objAccount.clcommon__Legal_Entity_Type__c==indivilegalEntityList[0].id){
                firstName.add(objAccount.FirstName);
                lastName.add(objAccount.LastName);
                email.add(objAccount.PersonEmail);
                dateOfBirthCheck.add(objAccount.PersonBirthdate);
            }else{
                accountName.add(objAccount.Name);
            }
        }
        List<Account> objIndividualAccountList=[SELECT id,
                                                    FirstName,
                                                    LastName,
                                                    PersonEmail,
                                                    ints__Driver_License__pc,
                                                    clcommon__Marital_Status__pc,
                                                    clcommon__Years_At_Current_Address__pc,
                                                    Housing_Status__pc,
                                                    Number_Of_Dependents__pc,
                                                    Phone,
                                                    PersonMobilePhone,
                                                    Ages__pc,
                                                    clcommon__Legal_Entity_Type__c 
                                                FROM Account 
                                                WHERE FirstName in: firstName 
                                                AND LastName in: lastName 
                                                AND PersonEmail in: email 
                                                AND PersonBirthdate in: dateOfBirthCheck];

        List<Account> objCompanyAccountList=[SELECT id,
                                                Name,
                                                clcommon__Legal_Entity_Type__c,
                                                ints__Driver_License__pc 
                                                FROM Account 
                                                WHERE Name in: accountName];
    
        List<Account> objDuplicateAccount=new List<Account>();
        for(Account objIndividualAccount:objIndividualAccountList){
            for(Account objAccount: accountList){
                if(objAccount.clcommon__Legal_Entity_Type__c==objIndividualAccount.clcommon__Legal_Entity_Type__c && 
                        objAccount.FirstName==objIndividualAccount.FirstName &&
                        objAccount.LastName==objIndividualAccount.LastName && 
                        objAccount.PersonEmail==objIndividualAccount.PersonEmail
                ){
                    objDuplicateAccount.add(objAccount);
                    if(objAccount.ints__Driver_License__pc!=null){
                        objIndividualAccount.ints__Driver_License__pc=objAccount.ints__Driver_License__pc;
                    }
                    if(objAccount.clcommon__Marital_Status__pc!=null){
                        objIndividualAccount.clcommon__Marital_Status__pc=objAccount.clcommon__Marital_Status__pc;
                    }
                    if(objAccount.Housing_Status__pc!=null){
                        objIndividualAccount.Housing_Status__pc=objAccount.Housing_Status__pc;
                    }
                    if(objAccount.clcommon__Years_At_Current_Address__pc!=null){
                        objIndividualAccount.clcommon__Years_At_Current_Address__pc=objAccount.clcommon__Years_At_Current_Address__pc;
                    }
                    if(objAccount.Number_Of_Dependents__pc!=null){
                        objIndividualAccount.Number_Of_Dependents__pc=objAccount.Number_Of_Dependents__pc;
                    }
                    if(objAccount.Ages__pc!=null){
                        objIndividualAccount.Ages__pc=objAccount.Ages__pc;
                    }
                    if(objAccount.Phone!=null){
                        objIndividualAccount.Phone=objAccount.Phone;
                    }
                    if(objAccount.PersonMobilePhone!=null){
                        objIndividualAccount.PersonMobilePhone=objAccount.PersonMobilePhone;
                    }
                    objAccountList.add(objIndividualAccount);
                    break;
                }
            }
        }
        for(Account objIndividualAccount:objCompanyAccountList){
            for(Account objAccount: accountList){
                if(objAccount.clcommon__Legal_Entity_Type__c==objIndividualAccount.clcommon__Legal_Entity_Type__c && 
                    objAccount.Name==objIndividualAccount.Name){
                    objDuplicateAccount.add(objAccount);
                    if(objAccount.ints__Driver_License__pc!=null){
                        objIndividualAccount.ints__Driver_License__pc=objAccount.ints__Driver_License__pc;
                    }
                    objAccountList.add(objIndividualAccount);
                    break;
                }
            }
        }
    
        for(Account objDuplicate:objDuplicateAccount){
            if(accountList.size()>0){
                for (Integer iterator = accountList.size() - 1; iterator >= 0 ; --iterator) {
                    if(accountList.get(iterator) == objDuplicate){
                        accountList.remove(iterator);
                    }
                }
            }
        }

        if(objAccountList.size()>0){
            Database.update(objAccountList,false);
        }
        if(accountList.size()>0){
            Database.insert(accountList,false);
            duplicateAccountList.addAll(accountList);
            objAccountList.addAll(accountList);
        }
        
        return objAccountList;
    }

}