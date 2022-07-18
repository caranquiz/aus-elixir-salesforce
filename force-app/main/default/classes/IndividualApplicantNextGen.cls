/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class acts as the parser class for the request of NextGenAuthentication 
                and insert Proof Indentity,Employment Information,Income Data.
Development Date : 10/04/2022
Last Modified Date : 18/05/2022
Devloper's comment : Some part of the codes are hardcoded and not been put in Constant Classes - since
                    they are referenced only here and its a one time use.
****************************************************************************************************/

public class IndividualApplicantNextGen {

    //Passing More than 4 parameters else the code get more complex.
    public static void individualRecordCreation(
        Map<String, Object> personMap,
        Map<genesis__Employment_Information__c,String> objEmploymentInfoMap,
        Map<genesis__Income__c,String> objIncomeMap,
        Map<String,genesis__Income__c> objIncomeMap2,
        String employmentString,
        clcommon__Party__c objParty,
        Map<String,String> employerName,
        Map<String,String> relatedEmployerABNMap
        ,Map<String,String> relatedPartyMap
    ){
        if(((Map<String, Object>)personMap)!= null &&
        String.valueOf(
        ((Map<String, Object>)personMap
        ))
        .contains('Employment=(')){
            List<Object> refEmploymentList=((List<Object>) ((Map<String, Object>)personMap).get('Employment'));
            String value;
            for(Object eachEmployment:refEmploymentList){
                genesis__Employment_Information__c objEmploymentInfo=new genesis__Employment_Information__c();
                String onBenefit;
                if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('PAYE')) != null){
                        if(value==null){
                            value='PAYG';
                        }else{
                            value+=';PAYG';
                        }
                }
                if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('SelfEmployed')) != null){
                        if(value==null){
                            value='Self Employed';
                        }else{
                            value+=';Self Employed';
                        }
                }
                if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('Unemployed')) != null){
                        if(value==null){
                            value='Unemployed';
                        }else{
                            value+=';Unemployed';
                        }                                        
                        if(((String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Unemployed')).get('Student'))!=null && 
                        (String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Unemployed')).get('Student')=='Yes'){
                            value+=';Student';
                        }
                        if(((String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Unemployed')).get('HomeDuties'))!=null && 
                        (String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Unemployed')).get('HomeDuties')=='Yes'){
                            value+=';Home Duties';
                        }
                        if(((String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Unemployed')).get('OnBenefits'))!=null && (String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Unemployed')).get('OnBenefits')=='Yes'){
                            onBenefit='Yes';
                        }else{
                            onBenefit='No';
                        }
                }
                if(((Map<String, Object>) eachEmployment) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                .get('Retired')) != null){
                    if(value==null){
                        value='Retired';
                    }else{
                        value+=';Retired';
                    }
                    if(((String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Retired')).get('OnBenefits'))!=null && 
                        (String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Retired')).get('OnBenefits')=='Yes'){
                        onBenefit='Yes';
                    }else{
                        onBenefit='No';
                    }                                        
                }
                if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('PAYE')) != null){
                    objEmploymentInfo.PAYG_Employment__c=true;
                    if(((Map<String, Object>) eachEmployment) != null &&
                        ((String) ((Map<String, Object>) eachEmployment)
                        .get('PrimaryEmployment')) != null &&
                        ((String) ((Map<String, Object>) eachEmployment)
                        .get('PrimaryEmployment'))=='Yes'){
                        objEmploymentInfo.Primary_Employment__c=True;
                    }else{
                        objEmploymentInfo.Primary_Employment__c=False;
                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('StartAndEndDates')) != null &&
                        ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('StartAndEndDates')).get('StartDate')) != null){
                            String startEndDate = (String)((Map<String, Object>)((Map<String, Object>) 
                                ((Map<String, Object>) eachEmployment).get('StartAndEndDates')).get('StartDate')).get('NodeValue');
                                if (startEndDate != null && startEndDate.length() > 9) {
                                    objEmploymentInfo.genesis__Start_Date__c= Date.newInstance(
                                        Integer.valueOf(startEndDate.substring(0, 4)),
                                        Integer.valueOf(startEndDate.substring(5, 7)),
                                        Integer.valueOf(startEndDate.substring(8, 10))
                                    );
                                }
                        }
                    if(((Map<String, Object>) eachEmployment) != null &&
                        ((String) ((Map<String, Object>) eachEmployment)
                        .get('RoleDescription')) != null){
                            String roleDescription=(String) ((Map<String, Object>) eachEmployment).get('RoleDescription');
                            if(roleDescription=='General Manager'){
                                objEmploymentInfo.Occupation__c='Manager';
                            }else{
                                objEmploymentInfo.Occupation__c=roleDescription;
                            }

                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                        ((Map<String,Object>) ((Map<String, Object>) eachEmployment)
                        .get('PAYE')) != null && 
                        ((String)((Map<String,Object>) ((Map<String, Object>) eachEmployment)
                        .get('PAYE')).get('Type')) != null){
                            String payeBasis=(String)((Map<String,Object>) 
                                ((Map<String, Object>) eachEmployment).get('PAYE')).get('Type');
                            if(payeBasis=='CommissionOnly'){
                                objEmploymentInfo.Basis__c='Commission Only';
                            }else if(payeBasis=='FullTime'){
                                objEmploymentInfo.Basis__c='Full Time';
                            }else if(payeBasis=='PartTime'){
                                objEmploymentInfo.Basis__c='Part Time';
                            }
                            else{
                                objEmploymentInfo.Basis__c=payeBasis;
                            }

                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                        ((String) ((Map<String, Object>) eachEmployment)
                        .get('OnProbation')) != null &&
                        ((String) ((Map<String, Object>) eachEmployment)
                        .get('OnProbation'))=='Yes'){
                            objEmploymentInfo.On_Probation__c='Yes';
                    }else{
                        objEmploymentInfo.On_Probation__c='No';
                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('PAYE')) != null &&
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('PAYE')).get('RelatedEntityRef')) != null ){
                        objEmploymentInfo.Company_Name__c=relatedPartyMap.get((String)((Map<String, Object>)
                            ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                            .get('PAYE')).get('RelatedEntityRef')).get('NodeValue'));

                        if(relatedEmployerABNMap.get((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                            .get('PAYE')).get('RelatedEntityRef')).get('NodeValue'))!=null){
                            objEmploymentInfo.Company_ABN__c=relatedEmployerABNMap.get((String)((Map<String, Object>)
                            ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                            .get('PAYE')).get('RelatedEntityRef')).get('NodeValue'));
                        }
                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                    String.valueOf(((Map<String, Object>)
                    ((Map<String, Object>)eachEmployment
                    ).get('EmploymentIncome')))
                    .contains('ValueItem=(')){
                        List<Object> refIncomeList=((List<Object>) ((Map<String, Object>)
                                ((Map<String, Object>)eachEmployment).get('EmploymentIncome')).get('ValueItem'));
                        for(Object eachIncome:refIncomeList){
                            genesis__Income__c objIncome=new genesis__Income__c();

                            if(((Map<String, Object>) eachIncome) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) eachIncome)
                                .get('Income')) != null && 
                                ((String)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                                .get('Income')).get('Type')) != null){
                                String incomeType=(String)((Map<String, Object>) 
                                        ((Map<String, Object>) eachIncome).get('Income')).get('Type');
                            
                                if(incomeType=='GrossSalary'){
                                    objIncome.PAYG_Income_Type__c='Gross Salary';
                                }else if(incomeType=='GrossRegularOvertime'){
                                    objIncome.PAYG_Income_Type__c='Gross Regular Overtime';
                                }else if(incomeType=='CarAllowance'){
                                    objIncome.PAYG_Income_Type__c='Car Allowance';
                                }else if(incomeType=='WorkAllowance'){
                                    objIncome.PAYG_Income_Type__c='Work Allowance';
                                }else if(incomeType=='WorkersCompensation'){
                                    objIncome.PAYG_Income_Type__c='Workers Compensation';
                                }else{
                                    objIncome.PAYG_Income_Type__c=incomeType;
                                }
                            }
                            if(((Map<String, Object>) eachIncome) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) eachIncome)
                                .get('Income')) != null && 
                                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                                .get('Income')).get('Period')) != null &&
                                (String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                                .get('Income')).get('Period')).get('Unit') != null){
                                    objIncome.genesis__Frequency__c=(String)((Map<String, Object>)
                                            ((Map<String, Object>) ((Map<String, Object>) eachIncome)
                                            .get('Income')).get('Period')).get('Unit');
                            }
                            if(((Map<String, Object>) eachIncome) != null &&
                                ((String) ((Map<String, Object>) eachIncome)
                                .get('Value')) != null){
                                    objIncome.genesis__Amount__c=Decimal.valueOf(
                                            (String) ((Map<String, Object>) eachIncome).get('Value'));
                            }
                            objIncome.PAYG_Income__c=true;
                            objIncomeMap.put(objIncome,objEmploymentInfo.Company_Name__c+'PAYG');
                        }

                    }else if(((Map<String, Object>) eachEmployment) != null &&
                    String.valueOf(((Map<String, Object>)
                    ((Map<String, Object>)eachEmployment
                    ).get('EmploymentIncome')))
                    .contains('ValueItem={')){
                        genesis__Income__c objIncome=new genesis__Income__c();
                        Object eachIncome=((Object) ((Map<String, Object>)(
                            (Map<String, Object>)eachEmployment).get('EmploymentIncome')).get('ValueItem'));

                        objIncome.PAYG_Income__c=true;

                        if(((Map<String, Object>) eachIncome) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')) != null && 
                            ((String)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')).get('Type')) != null){
                            String incomeType=(String)((Map<String, Object>) (
                                (Map<String, Object>) eachIncome).get('Income')).get('Type');
                        
                            if(incomeType=='GrossSalary'){
                                objIncome.PAYG_Income_Type__c='Gross Salary';
                            }else if(incomeType=='GrossRegularOvertime'){
                                objIncome.PAYG_Income_Type__c='Gross Regular Overtime';
                            }else if(incomeType=='CarAllowance'){
                                objIncome.PAYG_Income_Type__c='Car Allowance';
                            }else if(incomeType=='WorkAllowance'){
                                objIncome.PAYG_Income_Type__c='Work Allowance';
                            }else if(incomeType=='WorkersCompensation'){
                                objIncome.PAYG_Income_Type__c='Workers Compensation';
                            }else{
                                objIncome.PAYG_Income_Type__c=incomeType;
                            }
                        }
                        if(((Map<String, Object>) eachIncome) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')) != null && 
                            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')).get('Period')) != null &&
                            (String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')).get('Period')).get('Unit') != null){
                                objIncome.genesis__Frequency__c=(String)((Map<String, Object>)((Map<String, Object>) 
                                    ((Map<String, Object>) eachIncome).get('Income')).get('Period')).get('Unit');

                        }
                        if(((Map<String, Object>) eachIncome) != null &&
                            ((String) ((Map<String, Object>) eachIncome)
                            .get('Value')) != null){
                                objIncome.genesis__Amount__c=Decimal.valueOf((String) ((Map<String, Object>) eachIncome).get('Value'));
                        }
                        if(((Map<String, Object>) eachIncome) != null &&
                        ((String) ((Map<String, Object>) eachIncome)
                        .get('Value')) != null &&
                        Decimal.valueOf(
                        (String) ((Map<String, Object>) eachIncome)
                        .get('Value'))>0){
                            objIncomeMap.put(objIncome,objEmploymentInfo.Company_Name__c+'PAYG');
                        }
                    }
                    objEmploymentInfoMap.put(objEmploymentInfo,employmentString);
                }
                if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('SelfEmployed')) != null){
                    Date startDate,endDate;
                    if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('StartAndEndDates')) != null &&
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('StartAndEndDates')).get('StartDate')) != null){
                        String startEndDate = (String)((Map<String, Object>)
                            ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                            .get('StartAndEndDates')).get('StartDate')).get('NodeValue');
                            if (startEndDate != null && startEndDate.length() > 9) {
                                startDate= Date.newInstance(
                                    Integer.valueOf(startEndDate.substring(0, 4)),
                                    Integer.valueOf(startEndDate.substring(5, 7)),
                                    Integer.valueOf(startEndDate.substring(8, 10))
                                );
                            }
                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('StartAndEndDates')) != null &&
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('StartAndEndDates')).get('EndDate')) != null){
                        String startEndDate = (String)((Map<String, Object>)((Map<String, Object>) 
                            ((Map<String, Object>) eachEmployment).get('StartAndEndDates')).get('EndDate')).get('NodeValue');
                            if (startEndDate != null && startEndDate.length() > 9) {
                                endDate= Date.newInstance(
                                    Integer.valueOf(startEndDate.substring(0, 4)),
                                    Integer.valueOf(startEndDate.substring(5, 7)),
                                    Integer.valueOf(startEndDate.substring(8, 10))
                                );
                            }
                    }else{
                        endDate=system.today();
                    }
                    if(startDate!=null && endDate!=null){
                        objEmploymentInfo.Months_Self_Employed__c = endDate.month()+12-startDate.month()+12*(endDate.Year()-startDate.Year()-1);
                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('SelfEmployed')) != null &&
                        ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('SelfEmployed')).get('RelatedEntityRef')) != null ){
                            objEmploymentInfo.Company_Name__c=relatedPartyMap.get((String)((Map<String, Object>)
                                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                                    .get('SelfEmployed')).get('RelatedEntityRef')).get('NodeValue'));
                            if(relatedEmployerABNMap.get((String)((Map<String, Object>)
                                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                                    .get('SelfEmployed')).get('RelatedEntityRef')).get('NodeValue'))!=null){
                                objEmploymentInfo.Company_ABN__c=relatedEmployerABNMap.get((String)((Map<String, Object>)
                                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                                    .get('SelfEmployed')).get('RelatedEntityRef')).get('NodeValue'));
                            }
                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('SelfEmployed')) != null &&
                        ((String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('SelfEmployed')).get('Type')) != null &&
                        (String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('SelfEmployed')).get('Type')=='FullTime'){
                            objEmploymentInfo.Document_Type__c='Full';

                    }
                    objEmploymentInfo.Total_Previous_Income_Period__c=0;
                    objEmploymentInfo.Total_Current_Income_Period__c=0;
                    if(((Map<String, Object>) eachEmployment) != null &&
                            String.valueOf(((Map<String, Object>)
                            ((Map<String, Object>)eachEmployment
                            ).get('EmploymentIncome')))
                            .contains('ValueItem=(')
                    ){
                        List<Object> refIncomeList=((List<Object>) ((Map<String, Object>)(
                            (Map<String, Object>)eachEmployment).get('EmploymentIncome')).get('ValueItem'));
                        List<Integer> count=new List<Integer>();
                        count.add(0);count.add(0);count.add(0);count.add(0);

                        for(Object eachIncome:refIncomeList){
                            genesis__Income__c objIncome=new genesis__Income__c();
                            objIncome.Document_Type__c='Full';
                            if(((Map<String, Object>) eachIncome) != null &&
                            ((String) ((Map<String, Object>) eachIncome)
                            .get('Value')) != null){
                                objIncome.genesis__Amount__c=Decimal.valueOf((String) ((Map<String, Object>) eachIncome)
                                .get('Value'));
                            }
                            if(((Map<String, Object>) eachIncome) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')) != null && (String)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')).get('Type') != null){
                                String companyType=(String)((Map<String, Object>) 
                                        ((Map<String, Object>) eachIncome).get('Income')).get('AddbackType');
                                if(((String)((Map<String, Object>) 
                                        ((Map<String, Object>) eachIncome).get('Income')).get('Description'))!=null){
                                    objIncome.Description__c=(String)((Map<String, Object>) 
                                            ((Map<String, Object>) eachIncome).get('Income')).get('Description');
                                }
                                if(companyType=='GrossSalary' || companyType=='CompanyProfitBeforeTax'){
                                    count[0]+=1;
                                    objIncome.Business_Income_Type__c='Profit Before Tax';
                                    if(count[0]==1){
                                        objIncome.Business_Income_Period__c='Current';
                                        objEmploymentInfo.Total_Current_Income_Period__c+=objIncome.genesis__Amount__c;

                                    }else{
                                        objIncome.Business_Income_Period__c='Previous';
                                        objEmploymentInfo.Total_Previous_Income_Period__c+=objIncome.genesis__Amount__c;
                                    }
                                }else if(companyType=='Depreciation'){
                                    count[1]+=1;
                                    objIncome.Business_Income_Type__c='Depreciation';
                                    if(count[1]==1){
                                        objIncome.Business_Income_Period__c='Current';
                                        objEmploymentInfo.Total_Current_Income_Period__c+=objIncome.genesis__Amount__c;

                                    }else{
                                        objIncome.Business_Income_Period__c='Previous';
                                        objEmploymentInfo.Total_Previous_Income_Period__c+=objIncome.genesis__Amount__c;
                                    }
                                }else if(companyType=='NonCashBenefits'){
                                    count[2]+=1;
                                    objIncome.Business_Income_Type__c='Non Cash Benefits';
                                    if(count[2]==1){
                                        objIncome.Business_Income_Period__c='Current';
                                        objEmploymentInfo.Total_Current_Income_Period__c+=objIncome.genesis__Amount__c;

                                    }else{
                                        objIncome.Business_Income_Period__c='Previous';
                                        objEmploymentInfo.Total_Previous_Income_Period__c+=objIncome.genesis__Amount__c;
                                    }
                                }else if(companyType=='NonRecurringExpenses'){
                                    count[3]+=1;
                                    objIncome.Business_Income_Type__c='Non Recurring Expenses';
                                    if(count[3]==1){
                                        objEmploymentInfo.Total_Current_Income_Period__c+=objIncome.genesis__Amount__c;

                                    }else{
                                        objIncome.Business_Income_Period__c='Previous';
                                        objEmploymentInfo.Total_Previous_Income_Period__c+=objIncome.genesis__Amount__c;
                                    }
                                }
                            }
                            if(((Map<String, Object>) eachIncome) != null &&
                            ((String) ((Map<String, Object>) eachIncome)
                            .get('Value')) != null &&
                            Decimal.valueOf(
                            (String) ((Map<String, Object>) eachIncome)
                            .get('Value'))>0){
                                objIncomeMap.put(objIncome,objEmploymentInfo.Company_Name__c);
                            }

                        }
                    }else if(((Map<String, Object>) eachEmployment) != null &&
                    String.valueOf(((Map<String, Object>)
                    ((Map<String, Object>)eachEmployment
                    ).get('EmploymentIncome')))
                    .contains('ValueItem={')){
                        Object eachIncome=((Object) ((Map<String, Object>)((Map<String, Object>)eachEmployment).get('EmploymentIncome')).get('ValueItem'));
                        genesis__Income__c objIncome=new genesis__Income__c();
                        objIncome.Document_Type__c='Full';
                            if(((Map<String, Object>) eachIncome) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')) != null && (String)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')).get('Type') != null){
                                String companyType=(String)((Map<String, Object>) (
                                        (Map<String, Object>) eachIncome).get('Income')).get('AddbackType');
                                if(((String)((Map<String, Object>) ((Map<String, Object>) eachIncome).get('Income')).get('Description'))!=null){
                                    objIncome.Description__c=(String)((Map<String, Object>) 
                                            ((Map<String, Object>) eachIncome).get('Income')).get('Description');
                                }
                                if(companyType.equalsIgnoreCase('GrossSalary') || 
                                    companyType.equalsIgnoreCase('CompanyProfitBeforeTax')){
                                    objIncome.Business_Income_Type__c='Profit Before Tax';
                                }else if(companyType.equalsIgnoreCase('Depreciation')){
                                    objIncome.Business_Income_Type__c='Depreciation';
                                }else if(companyType.equalsIgnoreCase('NonCashBenefits')){
                                    objIncome.Business_Income_Type__c='Non Cash Benefits';
                                }else if(companyType.equalsIgnoreCase('NonRecurringExpenses')){
                                    objIncome.Business_Income_Type__c='Non Recurring Expenses';
                                }
                            }
                            if(((Map<String, Object>) eachIncome) != null &&
                            ((String) ((Map<String, Object>) eachIncome)
                            .get('Value')) != null){
                                objIncome.genesis__Amount__c=Decimal.valueOf((String) ((Map<String, Object>) eachIncome)
                                .get('Value'));
                            }
                            objIncome.Business_Income_Period__c='Current';
                            objEmploymentInfo.Total_Current_Income_Period__c+=objIncome.genesis__Amount__c;
                            if(((Map<String, Object>) eachIncome) != null &&
                                ((String) ((Map<String, Object>) eachIncome)
                                .get('Value')) != null &&
                                Decimal.valueOf(
                                (String) ((Map<String, Object>) eachIncome)
                                .get('Value'))>0
                            ){
                            objIncomeMap.put(objIncome,objEmploymentInfo.Company_Name__c);
                            }

                    }
                    objEmploymentInfoMap.put(objEmploymentInfo,employmentString);

                }
                if(((Map<String, Object>) eachEmployment) != null &&
                (((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                .get('Retired')) != null) || (((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                .get('Unemployed')) != null)){
                    if(((Map<String, Object>) eachEmployment) != null &&
                        String.valueOf(((Map<String, Object>)
                        ((Map<String, Object>)eachEmployment
                        ).get('EmploymentIncome')))
                        .contains('ValueItem=(')){
                            List<Object> refhIncomeList=((List<Object>) ((Map<String, Object>)(
                                (Map<String, Object>)eachEmployment).get('EmploymentIncome')).get('ValueItem'));
                            for(Object eachIncome:refhIncomeList){
                                genesis__Income__c objIncome=new genesis__Income__c();
                                objIncome.Unemployed_Income__c=true;
                                if(((Map<String, Object>) eachIncome) != null &&
                                    ((String) ((Map<String, Object>) eachIncome)
                                    .get('Value')) != null){
                                        objIncome.genesis__Amount__c=Decimal.valueOf(
                                            (String) ((Map<String, Object>) eachIncome).get('Value'));
                                }
                                if(((Map<String, Object>) eachIncome) != null &&
                                    ((Map<String,Object>) ((Map<String, Object>) eachIncome)
                                    .get('Income')) != null && 
                                    ((Map<String,Object>)((Map<String,Object>) ((Map<String, Object>) eachIncome)
                                    .get('Income')).get('Period')) != null){
                                        objIncome.genesis__Frequency__c=(String)((Map<String,Object>)(
                                            (Map<String,Object>) ((Map<String, Object>) eachIncome)
                                            .get('Income')).get('Period')).get('Unit');
                                }
                                if(((Map<String, Object>) eachIncome) != null &&
                                    ((Map<String,Object>) ((Map<String, Object>) eachIncome)
                                    .get('Income')) != null && 
                                    ((String)((Map<String,Object>) ((Map<String, Object>) eachIncome)
                                    .get('Income')).get('Type')) != null){
                                        if(onBenefit=='Yes'){
                                            objIncome.Unemployed_Income_Type__c='Government Benefit';
                                        }else{
                                            objIncome.Unemployed_Income_Type__c='Other Income';
                                        }
                                }
                                if(((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                                .get('Retired')) != null){
                                    objIncomeMap2.put(employmentString+'Retired',objIncome);
                                }else if(((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                                .get('Unemployed')) != null){
                                    objIncomeMap2.put(employmentString+'Unemployed',objIncome);
                                }

                        }
                        
                    }else if(((Map<String, Object>) eachEmployment) != null &&
                    String.valueOf(((Map<String, Object>)
                    ((Map<String, Object>)eachEmployment
                    ).get('EmploymentIncome')))
                    .contains('ValueItem={')){
                        genesis__Income__c objIncome=new genesis__Income__c();
                        Object eachIncome=((Object) ((Map<String, Object>)(
                            (Map<String, Object>)eachEmployment).get('EmploymentIncome')).get('ValueItem'));
                        objIncome.Unemployed_Income__c=true;
                        if(((Map<String, Object>) eachIncome) != null &&
                            ((String) ((Map<String, Object>) eachIncome)
                            .get('Value')) != null){
                                objIncome.genesis__Amount__c=Decimal.valueOf(
                                    (String) ((Map<String, Object>) eachIncome).get('Value'));
                        }
                        if(((Map<String, Object>) eachIncome) != null &&
                            ((Map<String,Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')) != null && 
                            ((Map<String,Object>)((Map<String,Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')).get('Period')) != null){
                                objIncome.genesis__Frequency__c=(String)((Map<String,Object>)
                                    ((Map<String,Object>) ((Map<String, Object>) eachIncome)
                                    .get('Income')).get('Period')).get('Unit');
                        }
                        if(((Map<String, Object>) eachIncome) != null &&
                            ((Map<String,Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')) != null && 
                            ((String)((Map<String,Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')).get('Type')) != null){
                                if(onBenefit=='Yes'){
                                    objIncome.Unemployed_Income_Type__c='Government Benefit';
                                }else{
                                    objIncome.Unemployed_Income_Type__c='Other Income';
                                }
                        }
                        if(((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Retired')) != null){
                            objIncomeMap2.put(employmentString+'Retired',objIncome);
                        }else if(((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Unemployed')) != null){
                            objIncomeMap2.put(employmentString+'Unemployed',objIncome);
                        }
                    }
                }

            }
            objParty.Employment_Type__c=value;

        }else if(((Map<String, Object>)personMap)!= null &&
        String.valueOf(
        ((Map<String, Object>)personMap
        ))
        .contains('Employment={')){
            String onBenefit;
            Object eachEmployment=((Object) ((Map<String, Object>)personMap).get('Employment'));
            genesis__Employment_Information__c objEmploymentInfo=new genesis__Employment_Information__c();
                if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('PAYE')) != null){
                            objParty.Employment_Type__c='PAYG';
                }
                if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('SelfEmployed')) != null){
                        objParty.Employment_Type__c='Self Employed';
                }
                if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('Unemployed')) != null){
                        objParty.Employment_Type__c='Unemployed';
                        if(((String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Unemployed')).get('Student'))!=null && 
                        (String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Unemployed')).get('Student')=='Yes'){
                            objParty.Employment_Type__c+=';Student';
                        }
                        if(((String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Unemployed')).get('HomeDuties'))!=null && 
                        (String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Unemployed')).get('HomeDuties')=='Yes'){
                            objParty.Employment_Type__c+=';Home Duties';
                        }
                        if(((String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Unemployed')).get('OnBenefits'))!=null && 
                        (String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Unemployed')).get('OnBenefits')=='Yes'){
                            onBenefit='Yes';
                        }else{
                            onBenefit='No';
                        }
                }
                if(((Map<String, Object>) eachEmployment) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                .get('Retired')) != null){
                    objParty.Employment_Type__c='Retired';
                    if(((String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Retired')).get('OnBenefits'))!=null && 
                        (String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Retired')).get('OnBenefits')=='Yes'){
                            onBenefit='Yes';
                        }else{
                            onBenefit='No';
                        }
                }
                if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('PAYE')) != null){
                        objEmploymentInfo.PAYG_Employment__c=true;
                    if(((Map<String, Object>) eachEmployment) != null &&
                        ((String) ((Map<String, Object>) eachEmployment)
                        .get('PrimaryEmployment')) != null &&
                        ((String) ((Map<String, Object>) eachEmployment)
                        .get('PrimaryEmployment'))=='Yes'){
                        objEmploymentInfo.Primary_Employment__c=True;
                    }else{
                        objEmploymentInfo.Primary_Employment__c=False;
                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('StartAndEndDates')) != null &&
                        ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('StartAndEndDates')).get('StartDate')) != null){
                            String startEndDate = (String)((Map<String, Object>)((Map<String, Object>) 
                                ((Map<String, Object>) eachEmployment).get('StartAndEndDates'))
                                .get('StartDate')).get('NodeValue');
                                if (startEndDate != null && startEndDate.length() > 9) {
                                    objEmploymentInfo.genesis__Start_Date__c= Date.newInstance(
                                        Integer.valueOf(startEndDate.substring(0, 4)),
                                        Integer.valueOf(startEndDate.substring(5, 7)),
                                        Integer.valueOf(startEndDate.substring(8, 10))
                                    );
                                }
                        }
                    if(((Map<String, Object>) eachEmployment) != null &&
                        ((String) ((Map<String, Object>) eachEmployment)
                        .get('RoleDescription')) != null){
                            String roleDescription=(String) ((Map<String, Object>) eachEmployment).get('RoleDescription');
                            if(roleDescription=='General Manager'){
                                objEmploymentInfo.Occupation__c='Manager';
                            }else{
                                objEmploymentInfo.Occupation__c=roleDescription;
                            }

                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                        ((Map<String,Object>) ((Map<String, Object>) eachEmployment)
                        .get('PAYE')) != null && 
                        ((String)((Map<String,Object>) ((Map<String, Object>) eachEmployment)
                        .get('PAYE')).get('Type')) != null){
                            String payeBasis=(String)((Map<String,Object>) (
                                (Map<String, Object>) eachEmployment).get('PAYE')).get('Type');
                            if(payeBasis=='CommissionOnly'){
                                objEmploymentInfo.Basis__c='Commission Only';
                            }else if(payeBasis=='FullTime'){
                                objEmploymentInfo.Basis__c='Full Time';
                            }else if(payeBasis=='PartTime'){
                                objEmploymentInfo.Basis__c='Part Time';
                            }
                            else{
                                objEmploymentInfo.Basis__c=payeBasis;
                            }

                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                        ((String) ((Map<String, Object>) eachEmployment)
                        .get('OnProbation')) != null &&
                        ((String) ((Map<String, Object>) eachEmployment)
                        .get('OnProbation'))=='Yes'){
                            objEmploymentInfo.On_Probation__c='Yes';
                    }else{
                        objEmploymentInfo.On_Probation__c='No';
                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('PAYE')) != null &&
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('PAYE')).get('RelatedEntityRef')) != null ){
                        objEmploymentInfo.Company_Name__c=relatedPartyMap.get((String)((Map<String, Object>)
                                ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                                .get('PAYE')).get('RelatedEntityRef')).get('NodeValue'));
                        
                        if( relatedEmployerABNMap.get((String)((Map<String, Object>)
                            ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                            .get('PAYE')).get('RelatedEntityRef')).get('NodeValue'))!=null){
                            objEmploymentInfo.Company_ABN__c=relatedEmployerABNMap.get(
                                (String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                                .get('PAYE')).get('RelatedEntityRef')).get('NodeValue'));
                        }
                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                    String.valueOf(((Map<String, Object>)
                    ((Map<String, Object>)eachEmployment
                    ).get('EmploymentIncome')))
                    .contains('ValueItem=(')){
                        List<Object> refIncomeList=((List<Object>) ((Map<String, Object>)(
                            (Map<String, Object>)eachEmployment).get('EmploymentIncome')).get('ValueItem'));
                        for(Object eachIncome:refIncomeList){
                            genesis__Income__c objIncome=new genesis__Income__c();
                            objIncome.PAYG_Income__c=true;
                            if(((Map<String, Object>) eachIncome) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) eachIncome)
                                .get('Income ')) != null && 
                                ((String)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                                .get('Income ')).get('Type')) != null){
                                String incomeType=(String)((Map<String, Object>) (
                                    (Map<String, Object>) eachIncome).get('Income ')).get('Type');
                            
                                if(incomeType.equalsIgnoreCase('GrossSalary')){
                                    objIncome.PAYG_Income_Type__c='Gross Salary';
                                }else if(incomeType.equalsIgnoreCase('GrossRegularOvertime')){
                                    objIncome.PAYG_Income_Type__c='Gross Regular Overtime';
                                }else if(incomeType.equalsIgnoreCase('CarAllowance')){
                                    objIncome.PAYG_Income_Type__c='Car Allowance';
                                }else if(incomeType.equalsIgnoreCase('WorkAllowance')){
                                    objIncome.PAYG_Income_Type__c='Work Allowance';
                                }else if(incomeType.equalsIgnoreCase('WorkersCompensation')){
                                    objIncome.PAYG_Income_Type__c='Workers Compensation';
                                }else{
                                    objIncome.PAYG_Income_Type__c=incomeType;
                                }
                            }
                            if(((Map<String, Object>) eachIncome) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) eachIncome)
                                .get('Income')) != null && 
                                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                                .get('Income')).get('Period')) != null &&
                                (String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                                .get('Income')).get('Period')).get('Unit') != null){
                                    objIncome.genesis__Frequency__c=(String)((Map<String, Object>)
                                    ((Map<String, Object>) ((Map<String, Object>) eachIncome)
                                    .get('Income')).get('Period')).get('Unit');

                            }
                            if(((Map<String, Object>) eachIncome) != null &&
                                ((String) ((Map<String, Object>) eachIncome)
                                .get('Value')) != null){
                                    objIncome.genesis__Amount__c=Decimal.valueOf(
                                        (String) ((Map<String, Object>) eachIncome).get('Value'));
                            }
                            if(((Map<String, Object>) eachIncome) != null &&
                            ((String) ((Map<String, Object>) eachIncome)
                            .get('Value')) != null &&
                            Decimal.valueOf(
                            (String) ((Map<String, Object>) eachIncome)
                            .get('Value'))>0){
                                objIncomeMap.put(objIncome,objEmploymentInfo.Company_Name__c+'PAYG');
                            }
                        }

                }else if(((Map<String, Object>) eachEmployment) != null &&
                    String.valueOf(((Map<String, Object>)
                    ((Map<String, Object>)eachEmployment
                    ).get('EmploymentIncome')))
                    .contains('ValueItem={')){
                        genesis__Income__c objIncome=new genesis__Income__c();
                        Object eachIncome=((Object) ((Map<String, Object>)(
                            (Map<String, Object>)eachEmployment).get('EmploymentIncome')).get('ValueItem'));
                        objIncome.PAYG_Income__c=true;
                        if(((Map<String, Object>) eachIncome) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income ')) != null && 
                            ((String)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income ')).get('Type')) != null){
                            String incomeType=(String)((Map<String, Object>) 
                                ((Map<String, Object>) eachIncome).get('Income ')).get('Type');
                        
                            if(incomeType.equalsIgnoreCase('GrossSalary')){
                                objIncome.PAYG_Income_Type__c='Gross Salary';
                            }else if(incomeType.equalsIgnoreCase('GrossRegularOvertime')){
                                objIncome.PAYG_Income_Type__c='Gross Regular Overtime';
                            }else if(incomeType.equalsIgnoreCase('CarAllowance')){
                                objIncome.PAYG_Income_Type__c='Car Allowance';
                            }else if(incomeType.equalsIgnoreCase('WorkAllowance')){
                                objIncome.PAYG_Income_Type__c='Work Allowance';
                            }else if(incomeType.equalsIgnoreCase('WorkersCompensation')){
                                objIncome.PAYG_Income_Type__c='Workers Compensation';
                            }else{
                                objIncome.PAYG_Income_Type__c=incomeType;
                            }
                        }
                        if(((Map<String, Object>) eachIncome) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')) != null && 
                            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')).get('Period')) != null &&
                            (String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')).get('Period')).get('Unit') != null){
                                objIncome.genesis__Frequency__c=(String)((Map<String, Object>)((Map<String, Object>) 
                                    ((Map<String, Object>) eachIncome).get('Income')).get('Period')).get('Unit');

                        }
                        if(((Map<String, Object>) eachIncome) != null &&
                            ((String) ((Map<String, Object>) eachIncome)
                            .get('Value')) != null){
                                objIncome.genesis__Amount__c=Decimal.valueOf((String) ((Map<String, Object>) eachIncome).get('Value'));
                        }
                        if(((Map<String, Object>) eachIncome) != null &&
                            ((String) ((Map<String, Object>) eachIncome)
                            .get('Value')) != null &&
                            Decimal.valueOf(
                            (String) ((Map<String, Object>) eachIncome)
                            .get('Value'))>0){
                            objIncomeMap.put(objIncome,objEmploymentInfo.Company_Name__c+'PAYG');
                        }
                    }
                }
                if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('SelfEmployed')) != null){
                    Date startDate,endDate;
                    if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('StartAndEndDates')) != null &&
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('StartAndEndDates')).get('StartDate')) != null){
                        String startEndDate = (String)((Map<String, Object>)((Map<String, Object>) 
                            ((Map<String, Object>) eachEmployment).get('StartAndEndDates')).get('StartDate')).get('NodeValue');
                            if (startEndDate != null && startEndDate.length() > 9) {
                                startDate= Date.newInstance(
                                    Integer.valueOf(startEndDate.substring(0, 4)),
                                    Integer.valueOf(startEndDate.substring(5, 7)),
                                    Integer.valueOf(startEndDate.substring(8, 10))
                                );
                            }
                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('StartAndEndDates')) != null &&
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                    .get('StartAndEndDates')).get('EndDate')) != null){
                        String startEndDate = (String)((Map<String, Object>)((Map<String, Object>) 
                            ((Map<String, Object>) eachEmployment).get('StartAndEndDates')).get('EndDate')).get('NodeValue');
                            if (startEndDate != null && startEndDate.length() > 9) {
                                endDate= Date.newInstance(
                                    Integer.valueOf(startEndDate.substring(0, 4)),
                                    Integer.valueOf(startEndDate.substring(5, 7)),
                                    Integer.valueOf(startEndDate.substring(8, 10))
                                );
                            }
                    }else{
                        endDate=system.today();
                    }
                    if(startDate!=null && endDate!=null){
                        objEmploymentInfo.Months_Self_Employed__c=endDate.month()+12-startDate.month()+12*(endDate.Year()-startDate.Year()-1);
                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('SelfEmployed')) != null &&
                        ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('SelfEmployed')).get('RelatedEntityRef')) != null ){
                            objEmploymentInfo.Company_Name__c=relatedPartyMap.get(
                                (String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                                .get('SelfEmployed')).get('RelatedEntityRef')).get('NodeValue'));
                            if(relatedEmployerABNMap.get((String)((Map<String, Object>)(
                                (Map<String, Object>) ((Map<String, Object>) eachEmployment)
                                .get('SelfEmployed')).get('RelatedEntityRef')).get('NodeValue'))!=null){
                                objEmploymentInfo.Company_ABN__c=relatedEmployerABNMap.get(
                                    (String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                                    .get('SelfEmployed')).get('RelatedEntityRef')).get('NodeValue'));
                            }
                    }
                    if(((Map<String, Object>) eachEmployment) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('SelfEmployed')) != null &&
                        ((String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('SelfEmployed')).get('Type')) != null &&
                        (String)((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('SelfEmployed')).get('Type')=='FullTime'){
                            objEmploymentInfo.Document_Type__c='Full';

                    }
                    
                    if(((Map<String, Object>) eachEmployment) != null &&
                        String.valueOf(((Map<String, Object>)
                        ((Map<String, Object>)eachEmployment
                        ).get('EmploymentIncome')))
                        .contains('ValueItem=(')){
                        List<Object> refIncomeList=((List<Object>) ((Map<String, Object>)(
                            (Map<String, Object>)eachEmployment).get('EmploymentIncome')).get('ValueItem'));
                        List<Integer> count=new List<Integer>();
                        count.add(0);count.add(0);count.add(0);count.add(0);
                        objEmploymentInfo.Total_Previous_Income_Period__c=0;
                        objEmploymentInfo.Total_Current_Income_Period__c=0;
                        for(Object eachIncome:refIncomeList){
                            genesis__Income__c objIncome=new genesis__Income__c();
                            objIncome.Document_Type__c='Full';
                            if(((Map<String, Object>) eachIncome) != null &&
                            ((String) ((Map<String, Object>) eachIncome)
                            .get('Value')) != null){
                                objIncome.genesis__Amount__c=Decimal.valueOf((String) ((Map<String, Object>) eachIncome)
                                .get('Value'));
                            }
                            if(((Map<String, Object>) eachIncome) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')) != null && (String)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')).get('Type') != null && ((String)((Map<String, Object>) 
                            ((Map<String, Object>) eachIncome).get('Income')).get('AddbackType')) !=null){
                                String companyType=(String)((Map<String, Object>) 
                                    ((Map<String, Object>) eachIncome).get('Income')).get('AddbackType');
                                if(((String)((Map<String, Object>) 
                                    ((Map<String, Object>) eachIncome).get('Income')).get('Description'))!=null){
                                    objIncome.Description__c=(String)((Map<String, Object>) 
                                        ((Map<String, Object>) eachIncome).get('Income')).get('Description');
                                }
                                if(companyType.equalsIgnoreCase('GrossSalary') || 
                                        companyType.equalsIgnoreCase('CompanyProfitBeforeTax')
                                ){
                                    count[0]+=1;
                                    objIncome.Business_Income_Type__c='Profit Before Tax';
                                    if(count[0]==1){
                                        objIncome.Business_Income_Period__c='Current';
                                        objEmploymentInfo.Total_Current_Income_Period__c+=objIncome.genesis__Amount__c;

                                    }else{
                                        objIncome.Business_Income_Period__c='Previous';
                                        objEmploymentInfo.Total_Previous_Income_Period__c+=objIncome.genesis__Amount__c;
                                    }
                                }else if(companyType.equalsIgnoreCase('Depreciation')){
                                    count[1]+=1;
                                    objIncome.Business_Income_Type__c='Depreciation';
                                    if(count[1]==1){
                                        objIncome.Business_Income_Period__c='Current';
                                        objEmploymentInfo.Total_Current_Income_Period__c+=objIncome.genesis__Amount__c;

                                    }else{
                                        objIncome.Business_Income_Period__c='Previous';
                                        objEmploymentInfo.Total_Previous_Income_Period__c+=objIncome.genesis__Amount__c;
                                    }
                                }else if(companyType.equalsIgnoreCase('NonCashBenefits')){
                                    count[2]+=1;
                                    objIncome.Business_Income_Type__c='Non Cash Benefits';
                                    if(count[2]==1){
                                        objIncome.Business_Income_Period__c='Current';
                                        objEmploymentInfo.Total_Current_Income_Period__c+=objIncome.genesis__Amount__c;

                                    }else{
                                        objIncome.Business_Income_Period__c='Previous';
                                        objEmploymentInfo.Total_Previous_Income_Period__c+=objIncome.genesis__Amount__c;
                                    }
                                }else if(companyType.equalsIgnoreCase('NonRecurringExpenses')){
                                    count[3]+=1;
                                    objIncome.Business_Income_Type__c='Non Recurring Expenses';
                                    if(count[3]==1){
                                        objIncome.Business_Income_Period__c='Current';
                                        objEmploymentInfo.Total_Current_Income_Period__c+=objIncome.genesis__Amount__c;

                                    }else{
                                        objIncome.Business_Income_Period__c='Previous';
                                        objEmploymentInfo.Total_Previous_Income_Period__c+=objIncome.genesis__Amount__c;
                                    }
                                }
                            }
                            if(((Map<String, Object>) eachIncome) != null &&
                            ((String) ((Map<String, Object>) eachIncome)
                            .get('Value')) != null &&
                            Decimal.valueOf(
                            (String) ((Map<String, Object>) eachIncome)
                            .get('Value'))>0){
                            objIncomeMap.put(objIncome,objEmploymentInfo.Company_Name__c);
                            }

                        }
                    }else if(((Map<String, Object>) eachEmployment) != null &&
                    String.valueOf(((Map<String, Object>)
                    ((Map<String, Object>)eachEmployment
                    ).get('EmploymentIncome')))
                    .contains('ValueItem={')){
                        Object eachIncome=((Object) ((Map<String, Object>)
                                ((Map<String, Object>)eachEmployment).get('EmploymentIncome')).get('ValueItem'));
                        genesis__Income__c objIncome=new genesis__Income__c();
                        objIncome.Document_Type__c='Full';
                            if(((Map<String, Object>) eachIncome) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')) != null && (String)((Map<String, Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')).get('Type') != null){
                                String companyType=(String)((Map<String, Object>) 
                                    ((Map<String, Object>) eachIncome).get('Income')).get('AddbackType');
                                if(((String)((Map<String, Object>) (
                                    (Map<String, Object>) eachIncome).get('Income')).get('Description'))!=null){
                                    objIncome.Description__c=(String)((Map<String, Object>) 
                                        ((Map<String, Object>) eachIncome).get('Income')).get('Description');
                                }
                                if(companyType.equalsIgnoreCase('GrossSalary') || 
                                    companyType.equalsIgnoreCase('CompanyProfitBeforeTax')){
                                    objIncome.Business_Income_Type__c='Profit Before Tax';
                                }else if(companyType.equalsIgnoreCase('Depreciation')){
                                    objIncome.Business_Income_Type__c='Depreciation';
                                }else if(companyType.equalsIgnoreCase('NonCashBenefits')){
                                    objIncome.Business_Income_Type__c='Non Cash Benefits';
                                }else if(companyType.equalsIgnoreCase('NonRecurringExpenses')){
                                    objIncome.Business_Income_Type__c='Non Recurring Expenses';
                                }
                            }
                            if(((Map<String, Object>) eachIncome) != null &&
                            ((String) ((Map<String, Object>) eachIncome)
                            .get('Value')) != null){
                                objIncome.genesis__Amount__c=Decimal.valueOf((String) ((Map<String, Object>) eachIncome)
                                .get('Value'));
                            }
                            objIncome.Business_Income_Period__c='Current';
                            objEmploymentInfo.Total_Current_Income_Period__c=objIncome.genesis__Amount__c;
                            if(((Map<String, Object>) eachIncome) != null &&
                                ((String) ((Map<String, Object>) eachIncome)
                                .get('Value')) != null &&
                                Decimal.valueOf(
                                (String) ((Map<String, Object>) eachIncome)
                                .get('Value'))>0){
                                objIncomeMap.put(objIncome,objEmploymentInfo.Company_Name__c);
                            }

                    }

                }
                objEmploymentInfoMap.put(objEmploymentInfo,employmentString);
                if(((Map<String, Object>) eachEmployment) != null &&
                (((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                .get('Retired')) != null) || (((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                .get('Unemployed')) != null)){
                    if(((Map<String, Object>) eachEmployment) != null &&
                        String.valueOf(((Map<String, Object>)
                        ((Map<String, Object>)eachEmployment
                        ).get('EmploymentIncome')))
                        .contains('ValueItem=(')){
                            List<Object> refhIncomeList=((List<Object>) ((Map<String, Object>)(
                                (Map<String, Object>)eachEmployment).get('EmploymentIncome')).get('ValueItem'));
                            for(Object eachIncome:refhIncomeList){
                                genesis__Income__c objIncome=new genesis__Income__c();
                                objIncome.Unemployed_Income__c=true;
                                if(((Map<String, Object>) eachIncome) != null &&
                                    ((String) ((Map<String, Object>) eachIncome)
                                    .get('Value')) != null){
                                    objIncome.genesis__Amount__c=Decimal.valueOf((String) (
                                        (Map<String, Object>) eachIncome).get('Value'));
                                }
                                if(((Map<String, Object>) eachIncome) != null &&
                                    ((Map<String,Object>) ((Map<String, Object>) eachIncome)
                                    .get('Income')) != null && 
                                    ((Map<String,Object>)((Map<String,Object>) ((Map<String, Object>) eachIncome)
                                    .get('Income')).get('Period')) != null){
                                        objIncome.genesis__Frequency__c=(String)((Map<String,Object>)
                                            ((Map<String,Object>) ((Map<String, Object>) eachIncome)
                                            .get('Income')).get('Period')).get('Unit');
                                }
                                if(((Map<String, Object>) eachIncome) != null &&
                                    ((Map<String,Object>) ((Map<String, Object>) eachIncome)
                                    .get('Income')) != null && 
                                    ((String)((Map<String,Object>) ((Map<String, Object>) eachIncome)
                                    .get('Income')).get('Type')) != null){
                                        if(onBenefit=='Yes'){
                                            objIncome.Unemployed_Income_Type__c='Government Benefit';
                                        }else{
                                            objIncome.Unemployed_Income_Type__c='Other Income';
                                        }
                                }
                                if(((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                                .get('Retired')) != null){
                                    objIncomeMap2.put(employmentString+'Retired',objIncome);
                                }else if(((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                                .get('Unemployed')) != null){
                                    objIncomeMap2.put(employmentString+'Unemployed',objIncome);
                                }
                        }
                        
                    }else if(((Map<String, Object>) eachEmployment) != null &&
                    String.valueOf(((Map<String, Object>)
                    ((Map<String, Object>)eachEmployment
                    ).get('EmploymentIncome')))
                    .contains('ValueItem={')){
                        genesis__Income__c objIncome=new genesis__Income__c();
                        Object eachIncome=((Object) ((Map<String, Object>)(
                            (Map<String, Object>)eachEmployment).get('EmploymentIncome')).get('ValueItem'));
                        objIncome.Unemployed_Income__c=true;
                        if(((Map<String, Object>) eachIncome) != null &&
                            ((String) ((Map<String, Object>) eachIncome)
                            .get('Value')) != null){
                                objIncome.genesis__Amount__c=Decimal.valueOf(
                                    (String) ((Map<String, Object>) eachIncome).get('Value'));
                        }
                        if(((Map<String, Object>) eachIncome) != null &&
                            ((Map<String,Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')) != null && 
                            ((Map<String,Object>)((Map<String,Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')).get('Period')) != null){
                                objIncome.genesis__Frequency__c=(String)(
                                    (Map<String,Object>)((Map<String,Object>) ((Map<String, Object>) eachIncome)
                                    .get('Income')).get('Period')).get('Unit');
                        }
                        if(((Map<String, Object>) eachIncome) != null &&
                            ((Map<String,Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')) != null && 
                            ((String)((Map<String,Object>) ((Map<String, Object>) eachIncome)
                            .get('Income')).get('Type')) != null){
                                if(onBenefit=='Yes'){
                                    objIncome.Unemployed_Income_Type__c='Government Benefit';
                                }else{
                                    objIncome.Unemployed_Income_Type__c='Other Income';
                                }
                        }
                        if(((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Retired')) != null){
                            objIncomeMap2.put(employmentString+'Retired',objIncome);
                        }else if(((Map<String, Object>) ((Map<String, Object>) eachEmployment)
                        .get('Unemployed')) != null){
                            objIncomeMap2.put(employmentString+'Unemployed',objIncome);
                        }
                    }
                }
        }
    }
    public static void proofIndentityRecord(
        Map<Proof_Of_Identity_Do__c,String> objProofMap,
        Map<String, Object> each,
        String accountName
    ){
        if(((Map<String, Object>) each) != null &&
        ((Map<String, Object>) ((Map<String, Object>) each)
        .get('Privacy')) != null &&
        String.ValueOf(((Map<String, Object>) ((Map<String, Object>) each)
        .get('Privacy'))).contains('PointVerification=(')){
            List<Object> refVerficationList=((List<Object>) ((Map<String, Object>) 
                    ((Map<String, Object>) each).get('Privacy')).get('PointVerification'));
            for(Object eachVerification:refVerficationList){
                Proof_Of_Identity_Do__c objProof=new Proof_Of_Identity_Do__c();
                if(((Map<String, Object>)eachVerification) !=null &&
                    ((String)((Map<String, Object>)eachVerification).get('DocumentType')) !=null){
                    String documentType=(String)((Map<String, Object>)eachVerification).get('DocumentType');
                    if(documentType=='DriversLicenceAust'){
                        objProof.Document_Type__c='Australian Drivers Licence';
                    }else if(documentType=='GovtIssueGunLicence'){
                        objProof.Document_Type__c='Australian Photo Firearms Licence';
                    }else if(documentType=='DefForceIdentityCard'){
                        objProof.Document_Type__c='State or Federal Government Employee Photo Identity Card';
                    }else if(documentType == 'GovtIssuePilotLicence' || documentType == 'BirthCertIntl' || 
                        documentType == 'CitizenCertIntl' || documentType == 'WrittenRefCustomer' ||
                        documentType == 'WrittenRefFinancialInst' || documentType == 'WrittenRefReferee' || 
                        documentType == 'BankCashCard' || documentType == 'FinInstCashCard' ||
                        documentType == 'DriversLicenceIntl' || documentType == 'IDFromCurrEmployer' || 
                        documentType == 'PublicServiceIDCard' ||
                        documentType == 'LetterFromCurrEmployer' || documentType == 'SecGuardIDCard' || 
                        documentType == 'BankPassbook' || documentType == 'FinInstPassbook' ||
                        documentType == 'Reference' || documentType == 'SchoolLetterOfIntro' || 
                        documentType == 'StatementFromLandlord'){
                    objProof.Document_Type__c = 'Other';
                    }else if(documentType == 'IdentityCard'){
                    objProof.Document_Type__c = 'National Identity Card';
                    }else if(documentType == 'PassportAust'){
                    objProof.Document_Type__c = 'Australian Passport';
                    }else if(documentType == 'PassportIntl'){
                    objProof.Document_Type__c = 'International Passport';
                    }else if(documentType == 'ProofOfAgeCard'){
                    objProof.Document_Type__c = 'Proof of Age Card';
                    }else if(documentType == 'BirthCertAust'){
                    objProof.Document_Type__c = 'Australian Birth Certificate';
                    }else if(documentType == 'AustCitizenshipCertificate'){
                    objProof.Document_Type__c = 'Australian Citizenship Certificate';
                    }else if(documentType == 'GovtIssueHealthCard'){
                    objProof.Document_Type__c = 'Health Care Card';
                    }else if(documentType == 'GovtPensionCard'){
                    objProof.Document_Type__c = 'Pension Card';
                    }else if(documentType == 'RateNotice'){
                    objProof.Document_Type__c = 'Rates Notice';
                    }else if(documentType == 'TaxationNoticeAust'){
                    objProof.Document_Type__c = 'Australian Taxation Office Correspondence (with TFN)';
                    }else if(documentType == 'UtilityStatementElectric'){
                    objProof.Document_Type__c = 'Electricity Bill';
                    }else if(documentType == 'UtilityStatementGas'){
                    objProof.Document_Type__c = 'Gas Bill';
                    }else if(documentType == 'UtilityStatementPhone'){
                    objProof.Document_Type__c = 'Landline Phone Bill';
                    }else if(documentType == 'UtilityStatementWater'){
                    objProof.Document_Type__c = 'Water Utility Bill';
                    }else if(documentType == 'BankStatement'){
                    objProof.Document_Type__c = 'Bank Statement';
                    }else if(documentType == 'BankCreditCard'){
                    objProof.Document_Type__c = 'Credit Card';
                    }else if(documentType == 'FinInstCreditCard'){
                    objProof.Document_Type__c = 'Credit Card';
                    }else if(documentType == 'DeedPoll'){
                    objProof.Document_Type__c = 'Deed Poll';
                    }else if(documentType == 'GovtIssueEmployeeCard'){
                    objProof.Document_Type__c = 'State or Federal Government Employee Photo Identity Card';
                    }else if(documentType == 'TertiaryStudentIDCard'){
                    objProof.Document_Type__c = 'Tertiary Education Institution Photo Identity Card';
                    }else if(documentType == 'LeaseContract'){
                    objProof.Document_Type__c = 'Property Lease or Rental Agreement';
                    }else if(documentType == 'MarriageCertificate'){
                    objProof.Document_Type__c = 'Marriage Certificate';
                    }else if(documentType == 'MedicareCard'){
                    objProof.Document_Type__c = 'Medicare Card';
                    }else if(documentType == 'RentReceipt'){
                    objProof.Document_Type__c = 'Property Lease or Rental Agreement';
                    }else if(documentType == 'OfficialStudentCard'){
                    objProof.Document_Type__c = 'Tertiary Education Institution Photo Identity Card';
                    }
                }
                if(((Map<String, Object>)eachVerification) !=null &&
                ((String)((Map<String, Object>)eachVerification).get('VerificationCategory')) !=null &&
                ((String)((Map<String, Object>)eachVerification).get('VerificationCategory')) == 'Secondary'){
                    objProof.Document_Category__c='Secondary';
                }
                else if(((Map<String, Object>)eachVerification) !=null &&
                ((String)((Map<String, Object>)eachVerification).get('VerificationCategory')) !=null &&
                ((String)((Map<String, Object>)eachVerification).get('VerificationCategory')) == 'Primary' &&
                ((String)((Map<String, Object>)eachVerification).get('Photographic')) !=null &&
                ((String)((Map<String, Object>)eachVerification).get('Photographic')) =='Yes' 
                ){
                    objProof.Document_Category__c='Photographic';
                }else if(((Map<String, Object>)eachVerification) !=null &&
                ((String)((Map<String, Object>)eachVerification).get('VerificationCategory')) !=null &&
                ((String)((Map<String, Object>)eachVerification).get('VerificationCategory')) == 'Primary'){
                    objProof.Document_Category__c='Non Photographic';
                }
                if(((Map<String, Object>)eachVerification) !=null &&
                ((Map<String,Object>)((Map<String, Object>)eachVerification).get('EndDate')) !=null){
                    String endDate=(String)((Map<String,Object>)(
                        (Map<String,Object>)eachVerification).get('EndDate')).get('NodeValue') ;
                    if (endDate != null && endDate.length() > 9) {
                        objProof.Expiry_Date__c= Date.newInstance(
                            Integer.valueOf(endDate.substring(0, 4)),
                            Integer.valueOf(endDate.substring(5, 7)),
                            Integer.valueOf(endDate.substring(8, 10))
                        );
                    }
                }
                if(((Map<String, Object>)eachVerification) !=null &&
                    ((String)((Map<String, Object>)eachVerification).get('VersionSighted')) !=null){
                    String versionSighted=(String)((Map<String, Object>)eachVerification).get('VersionSighted');
                    if(versionSighted == 'Original'){
                        objProof.Original_Sighted__c = 'Yes';
                        objProof.Certified_Copy_Sighted__c = 'No';
                    } else if(versionSighted == 'Certified'){
                        objProof.Original_Sighted__c = 'No';
                        objProof.Certified_Copy_Sighted__c = 'Yes'; 
                    }
                }
                objProofMap.put(objProof,accountName);
            }
        }else if(((Map<String, Object>) each) != null &&
        ((Map<String, Object>) ((Map<String, Object>) each)
        .get('Privacy')) != null &&
        String.ValueOf(((Map<String, Object>) ((Map<String, Object>) each)
        .get('Privacy'))).contains('PointVerification={')){
            Object eachVerification=((Object) ((Map<String, Object>) (
                (Map<String, Object>) each).get('Privacy')).get('PointVerification'));
            Proof_Of_Identity_Do__c objProof=new Proof_Of_Identity_Do__c();
            if(((Map<String, Object>)eachVerification) !=null &&
            ((String)((Map<String, Object>)eachVerification).get('DocumentType')) !=null){
                String documentType=(String)((Map<String, Object>)eachVerification).get('DocumentType');
                if(documentType=='DriversLicenceAust'){
                    objProof.Document_Type__c='Australian Drivers Licence';
                }else if(documentType=='GovtIssueGunLicence'){
                    objProof.Document_Type__c='Australian Photo Firearms Licence';
                }else if(documentType=='DefForceIdentityCard'){
                    objProof.Document_Type__c='State or Federal Government Employee Photo Identity Card';
                }else if(documentType == 'GovtIssuePilotLicence' || documentType == 'BirthCertIntl' || 
                    documentType == 'CitizenCertIntl' || documentType == 'WrittenRefCustomer' ||
                    documentType == 'WrittenRefFinancialInst' || documentType == 'WrittenRefReferee' || 
                    documentType == 'BankCashCard' || documentType == 'FinInstCashCard' ||
                    documentType == 'DriversLicenceIntl' || documentType == 'IDFromCurrEmployer' || 
                    documentType == 'PublicServiceIDCard' ||
                    documentType == 'LetterFromCurrEmployer' || documentType == 'SecGuardIDCard' || 
                    documentType == 'BankPassbook' || documentType == 'FinInstPassbook' ||
                    documentType == 'Reference' || documentType == 'SchoolLetterOfIntro' || 
                    documentType == 'StatementFromLandlord'){
                    objProof.Document_Type__c = 'Other';
                }else if(documentType == 'IdentityCard'){
                    objProof.Document_Type__c = 'National Identity Card';
                }else if(documentType == 'PassportAust'){
                    objProof.Document_Type__c = 'Australian Passport';
                }else if(documentType == 'PassportIntl'){
                    objProof.Document_Type__c = 'International Passport';
                }else if(documentType == 'ProofOfAgeCard'){
                    objProof.Document_Type__c = 'Proof of Age Card';
                }else if(documentType == 'BirthCertAust'){
                    objProof.Document_Type__c = 'Australian Birth Certificate';
                }else if(documentType == 'AustCitizenshipCertificate'){
                    objProof.Document_Type__c = 'Australian Citizenship Certificate';
                }else if(documentType == 'GovtIssueHealthCard'){
                    objProof.Document_Type__c = 'Health Care Card';
                }else if(documentType == 'GovtPensionCard'){
                    objProof.Document_Type__c = 'Pension Card';
                }else if(documentType == 'RateNotice'){
                    objProof.Document_Type__c = 'Rates Notice';
                }else if(documentType == 'TaxationNoticeAust'){
                    objProof.Document_Type__c = 'Australian Taxation Office Correspondence (with TFN)';
                }else if(documentType == 'UtilityStatementElectric'){
                    objProof.Document_Type__c = 'Electricity Bill';
                }else if(documentType == 'UtilityStatementGas'){
                    objProof.Document_Type__c = 'Gas Bill';
                }else if(documentType == 'UtilityStatementPhone'){
                    objProof.Document_Type__c = 'Landline Phone Bill';
                }else if(documentType == 'UtilityStatementWater'){
                    objProof.Document_Type__c = 'Water Utility Bill';
                }else if(documentType == 'BankStatement'){
                    objProof.Document_Type__c = 'Bank Statement';
                }else if(documentType == 'BankCreditCard'){
                    objProof.Document_Type__c = 'Credit Card';
                }else if(documentType == 'FinInstCreditCard'){
                    objProof.Document_Type__c = 'Credit Card';
                }else if(documentType == 'DeedPoll'){
                    objProof.Document_Type__c = 'Deed Poll';
                }else if(documentType == 'GovtIssueEmployeeCard'){
                    objProof.Document_Type__c = 'State or Federal Government Employee Photo Identity Card';
                }else if(documentType == 'TertiaryStudentIDCard'){
                    objProof.Document_Type__c = 'Tertiary Education Institution Photo Identity Card';
                }else if(documentType == 'LeaseContract'){
                    objProof.Document_Type__c = 'Property Lease or Rental Agreement';
                }else if(documentType == 'MarriageCertificate'){
                    objProof.Document_Type__c = 'Marriage Certificate';
                }else if(documentType == 'MedicareCard'){
                    objProof.Document_Type__c = 'Medicare Card';
                }else if(documentType == 'RentReceipt'){
                    objProof.Document_Type__c = 'Property Lease or Rental Agreement';
                }else if(documentType == 'OfficialStudentCard'){
                    objProof.Document_Type__c = 'Tertiary Education Institution Photo Identity Card';
                }
            }
            if(((Map<String, Object>)eachVerification) !=null &&
            ((String)((Map<String, Object>)eachVerification).get('VerificationCategory')) !=null &&
            ((String)((Map<String, Object>)eachVerification).get('VerificationCategory')) == 'Secondary'){
                objProof.Document_Category__c='Secondary';
            }
            else if(((Map<String, Object>)eachVerification) !=null &&
            ((String)((Map<String, Object>)eachVerification).get('VerificationCategory')) !=null &&
            ((String)((Map<String, Object>)eachVerification).get('VerificationCategory')) == 'Primary' &&
            ((String)((Map<String, Object>)eachVerification).get('Photographic')) !=null &&
            ((String)((Map<String, Object>)eachVerification).get('Photographic')) =='Yes' 
            ){
                objProof.Document_Category__c='Photographic';
            }else if(((Map<String, Object>)eachVerification) !=null &&
            ((String)((Map<String, Object>)eachVerification).get('VerificationCategory')) !=null &&
            ((String)((Map<String, Object>)eachVerification).get('VerificationCategory')) == 'Primary'){
                objProof.Document_Category__c='Non Photographic';
            }
            if(((Map<String, Object>)eachVerification) !=null &&
            ((Map<String,Object>)((Map<String, Object>)eachVerification).get('EndDate')) !=null){
                String endDate=(String)((Map<String,Object>)(
                    (Map<String,Object>)eachVerification).get('EndDate')).get('NodeValue') ;
                if (endDate != null && endDate.length() > 9) {
                    objProof.Expiry_Date__c= Date.newInstance(
                        Integer.valueOf(endDate.substring(0, 4)),
                        Integer.valueOf(endDate.substring(5, 7)),
                        Integer.valueOf(endDate.substring(8, 10))
                    );
                }
            }
            if(((Map<String, Object>)eachVerification) !=null &&
                ((String)((Map<String, Object>)eachVerification).get('VersionSighted')) !=null){
                String versionSighted=(String)((Map<String, Object>)eachVerification).get('VersionSighted');
                if(versionSighted == 'Original'){
                    objProof.Original_Sighted__c = 'Yes';
                    objProof.Certified_Copy_Sighted__c = 'No';
                } else if(versionSighted == 'Certified'){
                    objProof.Original_Sighted__c = 'No';
                    objProof.Certified_Copy_Sighted__c = 'Yes'; 
                }
            }
            objProofMap.put(objProof,accountName);
        }
        
    }
    public static string processAddressLines(Map<String, Object> address) {
        String fullAddress = '';
        if(((Map<String, Object>) address.get('POBox')) != null){
            fullAddress +=
            (String) ((Map<String, Object>) address.get('POBox'))
            .get('Type') + ' ';
            fullAddress +=
            (String) ((Map<String, Object>) address.get('POBox'))
            .get(ConstantValues.NODE_VALUE) + ' ';
        }
        if(((Map<String, Object>) address.get('NonStdAddress')) != null){
            fullAddress +=
            (String) ((Map<String, Object>) address.get('NonStdAddress'))
            .get(ConstantValues.NODE_VALUE) + ' ';
        }
        if (((Map<String, Object>) address.get('UnitNo')) != null) {
        fullAddress +=
            (String) ((Map<String, Object>) address.get('UnitNo'))
            .get(ConstantValues.NODE_VALUE) + ' ';
        }
        if (
        ((Map<String, Object>) address.get('StreetNo')) != null
        ) {
        fullAddress +=
            (String) ((Map<String, Object>) address.get('StreetNo'
            ))
            .get(ConstantValues.NODE_VALUE) + ' ';
        }
        if (
        ((Map<String, Object>) address.get('Street')) != null
        ) {
        fullAddress +=
            (String) ((Map<String, Object>) address.get('Street'
                ))
                .get('NodeValue') + ' ';
        }
        if (
        ((Map<String, Object>) address.get('Street')) !=
        null && ((String) ((Map<String, Object>) address.get('Street'
        ))
        .get('Type'))!=null
        ) {
        fullAddress +=
            (String) ((Map<String, Object>) address.get(
                'Street'
            ))
            .get('Type') + ' ';
        }
        return fullAddress;
    }
    public static clcommon__Address__c storeAddress(Map<String, Object> address) {
        clcommon__Address__c contactAddress=new clcommon__Address__c();
        String nonStdAddress;
        if (((Map<String, Object>) address.get('UnitNo')) != null) {
            contactAddress.clcommon__County__c
            =
            (String) ((Map<String, Object>) address.get('UnitNo'))
            .get(ConstantValues.NODE_VALUE) ;
        }else if(((Map<String, Object>) address.get('NonStdAddress')) != null){
            contactAddress.clcommon__County__c=((String) ((Map<String, Object>) address.get('NonStdAddress'))
            .get(ConstantValues.NODE_VALUE)).substringBefore(',') ;
            nonStdAddress=((String) ((Map<String, Object>) address.get('NonStdAddress'))
            .get(ConstantValues.NODE_VALUE)).substringAfter(', ');
        }
        if (
        ((Map<String, Object>) address.get('StreetNo')) != null
        ) {
            contactAddress.Street_No__c=
            (String) ((Map<String, Object>) address.get('StreetNo'
            ))
            .get(ConstantValues.NODE_VALUE) ;
        }else if(((Map<String, Object>) address.get('NonStdAddress')) != null &&
                nonStdAddress!=null){
            contactAddress.Street_No__c=nonStdAddress.substringBefore(' ') ;
        }else if(((Map<String, Object>) address.get('POBox')) != null){
            contactAddress.Street_No__c=
                (String) ((Map<String, Object>) address.get('POBox'))
                .get('Type') + ' '+(String) ((Map<String, Object>) address.get('POBox'))
                .get(ConstantValues.NODE_VALUE) ;
            
        }
        if (
        ((Map<String, Object>) address.get('Street')) != null
        ) {
            contactAddress.Street_Name__c=
            (String) ((Map<String, Object>) address.get('Street'
                ))
                .get('NodeValue');
        }else if(((Map<String, Object>) address.get('NonStdAddress')) != null){
            contactAddress.Street_Name__c=((String) ((Map<String, Object>) address.get('NonStdAddress'))
                .get(ConstantValues.NODE_VALUE)).substring(
                ((String) ((Map<String, Object>) address.get('NonStdAddress'))
                .get(ConstantValues.NODE_VALUE)).lastIndexOf(' ')+1) ; 
            
        }
        if (
        ((Map<String, Object>) address.get('Street')) !=
        null && ((String) ((Map<String, Object>) address.get('Street'
        ))
        .get('Type'))!=null
        ) {
            contactAddress.Street_Type__c=
            (String) ((Map<String, Object>) address.get(
                'Street'
            ))
            .get('Type') ;
            contactAddress.Duplicate_Street_Type__c=
            (String) ((Map<String, Object>) address.get(
                'Street'
            ))
            .get('Type') ;
        }
        if (((Map<String, Object>) address.get('City')) != null) {
            contactAddress.clcommon__City__c=
            (String) ((Map<String, Object>) address.get('City'))
            .get(ConstantValues.NODE_VALUE) ;
        }
        if (((Map<String, Object>) address.get('State')) != null) {
            contactAddress.State__c=
                (String) ((Map<String, Object>) address.get('State'))
                .get('Name') ;
            contactAddress.Duplicate_State_Name__c=
                (String) ((Map<String, Object>) address.get('State'))
                .get('Name') ;
            }
        if (((Map<String, Object>) address.get('Postcode')) != null) {
            contactAddress.clcommon__Zip_Code__c=
            (String) ((Map<String, Object>) address.get('Postcode'))
            .get(ConstantValues.NODE_VALUE) ;
        }
        if (((Map<String, Object>) address.get('Country')) != null) {
            contactAddress.clcommon__Country__c=
            (String) ((Map<String, Object>) address.get('Country'))
            .get('ISO3166') ;
        }
        return contactAddress;
    }
    public static clcommon__Collateral__c collateralAddress(Map<String, Object> address) {
        clcommon__Collateral__c objCollateral=new clcommon__Collateral__c();
        objCollateral.clcommon__Collateral_Name__c='';
        String nonStdAddress;
        if (((Map<String, Object>) address.get('UnitNo')) != null) {
            objCollateral.Unit_No__c
            =
            (String) ((Map<String, Object>) address.get('UnitNo'))
            .get(ConstantValues.NODE_VALUE) ;
            objCollateral.clcommon__Collateral_Name__c+=(String) ((Map<String, Object>) address.get('UnitNo'))
            .get(ConstantValues.NODE_VALUE)+' ' ;
        }else if(((Map<String, Object>) address.get('NonStdAddress')) != null){
            objCollateral.Unit_No__c=((String) ((Map<String, Object>) address.get('NonStdAddress'))
            .get(ConstantValues.NODE_VALUE)).substringBefore(',') ;
            objCollateral.clcommon__Collateral_Name__c+=((String) ((Map<String, Object>) address.get('NonStdAddress'))
            .get(ConstantValues.NODE_VALUE))+' ' ;
            nonStdAddress=((String) ((Map<String, Object>) address.get('NonStdAddress'))
            .get(ConstantValues.NODE_VALUE)).substringAfter(', ');
        }else if(((Map<String, Object>) address.get('POBox')) != null){
            objCollateral.Unit_No__c=
            (String) ((Map<String, Object>) address.get('POBox'))
            .get(ConstantValues.NODE_VALUE) + ' ';
            objCollateral.clcommon__Collateral_Name__c+=((String) ((Map<String, Object>) address.get('POBox'))
            .get(ConstantValues.NODE_VALUE))+' ' ;
        }
        if (
        ((Map<String, Object>) address.get('StreetNo')) != null
        ) {
            objCollateral.Street_No__c=
            (String) ((Map<String, Object>) address.get('StreetNo'
            ))
            .get(ConstantValues.NODE_VALUE) ;
            objCollateral.clcommon__Collateral_Name__c+=(String) ((Map<String, Object>) address.get('StreetNo'
            ))
            .get(ConstantValues.NODE_VALUE) +' ';

        }else if(((Map<String, Object>) address.get('NonStdAddress')) != null){
            objCollateral.Street_No__c=nonStdAddress.substringBefore(' ') ;

        }
        if (
        ((Map<String, Object>) address.get('Street')) != null
        ) {
            objCollateral.Street_Name__c=
            (String) ((Map<String, Object>) address.get('Street'
                ))
                .get('NodeValue');
                objCollateral.clcommon__Collateral_Name__c+=(String) ((Map<String, Object>) address.get('Street'
                ))
                .get('NodeValue') +' ';
        }else if(((Map<String, Object>) address.get('NonStdAddress')) != null){
            objCollateral.Street_Name__c=((String) ((Map<String, Object>) address.get('NonStdAddress'))
            .get(ConstantValues.NODE_VALUE)).substring(((String) ((Map<String, Object>) address.get('NonStdAddress'))
            .get(ConstantValues.NODE_VALUE)).lastIndexOf(' ')+1) ;
        }
        if (
        ((Map<String, Object>) address.get('Street')) !=
        null && ((String) ((Map<String, Object>) address.get('Street'
        ))
        .get('Type'))!=null
        ) {
            objCollateral.Street_Type__c=
            (String) ((Map<String, Object>) address.get(
                'Street'
            ))
            .get('Type') ;
            objCollateral.Duplicate_Street_Type__c=
            (String) ((Map<String, Object>) address.get(
                'Street'
            ))
            .get('Type') ;
            objCollateral.clcommon__Collateral_Name__c+=(String) ((Map<String, Object>) address.get('Street'
                ))
                .get('Type') +' ';
        }
        if (((Map<String, Object>) address.get('City')) != null) {
            objCollateral.clcommon__City__c=
            (String) ((Map<String, Object>) address.get('City'))
            .get(ConstantValues.NODE_VALUE) ;
            objCollateral.clcommon__Collateral_Name__c+=(String) ((Map<String, Object>) address.get('City'))
            .get(ConstantValues.NODE_VALUE)+' ';
        }
        if (((Map<String, Object>) address.get('State')) != null) {
            objCollateral.clcommon__State__c=
                (String) ((Map<String, Object>) address.get('State'))
                .get('Name') ;
                objCollateral.Duplicate_State_Name__c=
                (String) ((Map<String, Object>) address.get('State'))
                .get('Name') ;
                objCollateral.clcommon__Collateral_Name__c+=(String) ((Map<String, Object>) address.get('State'))
                .get('Name') +' ';
            }
        if (((Map<String, Object>) address.get('Postcode')) != null) {
            objCollateral.clcommon__Postal_Code__c=
            (String) ((Map<String, Object>) address.get('Postcode'))
            .get(ConstantValues.NODE_VALUE) ;
            objCollateral.clcommon__Collateral_Name__c+=(String) ((Map<String, Object>) address.get('Postcode'))
            .get(ConstantValues.NODE_VALUE)+' ';
        }
        if (((Map<String, Object>) address.get('Country')) != null) {
            if((String) ((Map<String, Object>) address.get('Country'))
            .get('ISO3166')=='Au'){
                objCollateral.Country__c='Australia';
                objCollateral.clcommon__Collateral_Name__c+='Australia';
            }else{
                objCollateral.Country__c=(String) ((Map<String, Object>) address.get('Country'))
            .get('ISO3166') ;
            objCollateral.clcommon__Collateral_Name__c+=(String) ((Map<String, Object>) address.get('Country'))
            .get('ISO3166');
            }
            
        }
            
        return objCollateral;
    }
    public static void addressWrapper(
        Map<String, Object> addressSegmentMap,
        Map<String,String> addressMap,
        Map<String, clcommon__Address__c> contactAddressMap,
        Map<String, clcommon__Collateral__c> collateralAddressMap
    ) {
        if(
                ((Map<String, Object>)addressSegmentMap)!= null &&
                String.valueOf(
                    ((Map<String, Object>)addressSegmentMap
                    ))
                    .contains('AddressWrapper=(')
            ){
                List<Object> refAddressList = ((List<Object>) (addressSegmentMap).get('AddressWrapper'));
                for(Object each:refAddressList){
                    if(((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Address')) !=null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Identifier')) != null){
                        addressMap.put((String)((Map<String, Object>) (
                            (Map<String, Object>) each).get('Identifier')).get('NodeValue')+'OtherStreet',
                            processAddressLines(((Map<String, Object>) ((Map<String, Object>) each).get('Address'))));
                        if (((Map<String, Object>) ((Map<String, Object>) 
                            ((Map<String, Object>) each).get('Address')).get('City')) != null) {
                            addressMap.put((String)((Map<String, Object>) 
                                    ((Map<String, Object>) each).get('Identifier')).get('NodeValue')+'City',
                                    (String) ((Map<String, Object>) ((Map<String, Object>) 
                                    ((Map<String, Object>) each).get('Address')).get('City'))
                                    .get(ConstantValues.NODE_VALUE));
                        }
                        if (((Map<String, Object>) ((Map<String, Object>) (
                            (Map<String, Object>) each).get('Address')).get('State')) != null) {
                            addressMap.put((String)((Map<String, Object>) (
                                (Map<String, Object>) each).get('Identifier')).get('NodeValue')+'State',
                                (String) ((Map<String, Object>) ((Map<String, Object>) 
                                ((Map<String, Object>) each).get('Address')).get('State'))
                                .get('Name'));
                        }
                        if (((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Address')).get('Postcode')) != null) {
                            addressMap.put((String)((Map<String, Object>) (
                                (Map<String, Object>) each).get('Identifier')).get('NodeValue')+'Postcode',
                                (String) ((Map<String, Object>) ((Map<String, Object>) (
                                (Map<String, Object>) each).get('Address')).get('Postcode'))
                                .get(ConstantValues.NODE_VALUE));
                        }
                        if (((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Address')).get('Country')) != null) {
                            addressMap.put((String)((Map<String, Object>) (
                                (Map<String, Object>) each).get('Identifier')).get('NodeValue')+'Country',
                                (String) ((Map<String, Object>) ((Map<String, Object>) (
                                (Map<String, Object>) each).get('Address')).get('Country'))
                                .get('ISO3166'));
                        }
                        contactAddressMap.put((String)((Map<String, Object>) 
                            ((Map<String, Object>) each).get('Identifier')).get('NodeValue'),
                            storeAddress(((Map<String, Object>) ((Map<String, Object>) each).get('Address'))));
                        collateralAddressMap.put((String)((Map<String, Object>) 
                            ((Map<String, Object>) each).get('Identifier')).get('NodeValue'),
                            collateralAddress(((Map<String, Object>) ((Map<String, Object>) each).get('Address'))));

                    }
                }
            }else if(
                ((Map<String, Object>)addressSegmentMap)!= null &&
                String.valueOf(
                    ((Map<String, Object>)addressSegmentMap
                    ))
                    .contains('AddressWrapper={')
            ){
                clcommon__Address__c objParty=new clcommon__Address__c();
                Object each = ((Object) (addressSegmentMap).get('AddressWrapper'));
                if(((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Address')) !=null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                    .get('Identifier')) != null){
                        addressMap.put((String)((Map<String, Object>) (
                            (Map<String, Object>) each).get('Identifier')).get('NodeValue')+'OtherStreet',
                            processAddressLines(((Map<String, Object>) ((Map<String, Object>) each).get('Address'))));
                        if (((Map<String, Object>) ((Map<String, Object>) (
                            (Map<String, Object>) each).get('Address')).get('City')) != null) {
                            addressMap.put((String)((Map<String, Object>) (
                                (Map<String, Object>) each).get('Identifier')).get('NodeValue')+'City',
                                (String) ((Map<String, Object>) ((Map<String, Object>)
                                ((Map<String, Object>) each).get('Address')).get('City'))
                                .get(ConstantValues.NODE_VALUE));
                        }
                        if (((Map<String, Object>) ((Map<String, Object>) 
                            ((Map<String, Object>) each).get('Address')).get('State')) != null) {
                            addressMap.put((String)((Map<String, Object>) (
                                (Map<String, Object>) each).get('Identifier')).get('NodeValue')+'State',
                                (String) ((Map<String, Object>) ((Map<String, Object>) 
                                ((Map<String, Object>) each).get('Address')).get('State'))
                                .get('Name'));
                        }
                        if (((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Address')).get('Postcode')) != null) {
                            addressMap.put((String)((Map<String, Object>) 
                                ((Map<String, Object>) each).get('Identifier')).get('NodeValue')+'Postcode',
                                (String) ((Map<String, Object>) ((Map<String, Object>) 
                                ((Map<String, Object>) each).get('Address')).get('Postcode'))
                                .get(ConstantValues.NODE_VALUE));
                        }
                        if (((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                                        .get('Address')).get('Country')) != null) {
                            addressMap.put((String)((Map<String, Object>) ((Map<String, Object>) each).get('Identifier')).get('NodeValue')+'Country',
                            (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each).get('Address')).get('Country'))
                                    .get('ISO3166'));
                        }
                        contactAddressMap.put((String)((Map<String, Object>) (
                            (Map<String, Object>) each).get('Identifier')).get('NodeValue'),
                            storeAddress(((Map<String, Object>) ((Map<String, Object>) each).get('Address'))));
                        collateralAddressMap.put((String)((Map<String, Object>) (
                            (Map<String, Object>) each).get('Identifier')).get('NodeValue'),
                            collateralAddress(((Map<String, Object>) ((Map<String, Object>) each).get('Address'))));

                }
            }
    }

    public static decimal smsfIncomeCreation(
        Map<String, Object> eachMember,
        Map<genesis__Income__c,String> objIncomeMap,
        String objSmsfAccountName,
        clcommon__Party__c objParty
    ){
        Decimal currentIncome=0;
        if(((Map<String, Object>)eachMember)!= null &&
            String.valueOf(
            ((Map<String, Object>)eachMember
            ))
            .contains('Contribution=(')){
            List<Object> refContributionList=((List<Object>) ((Map<String, Object>)eachMember).get('Contribution'));
            for(Object eachContribution:refContributionList){
                genesis__Income__c objIncome=new genesis__Income__c();
                objIncome.Business_Income_Period__c='Current';
                if(((Map<String,Object>)eachContribution)!=null &&
                ((String)((Map<String,Object>)eachContribution).get('Value'))!=null){
                    objIncome.genesis__Amount__c=Decimal.valueOf((String)((Map<String,Object>)eachContribution).get('Value'));
                    currentIncome+=objIncome.genesis__Amount__c;
                }
                if(((Map<String,Object>)eachContribution)!=null &&
                ((String)((Map<String,Object>)eachContribution).get('Type'))!=null){
                    if((String)((Map<String,Object>)eachContribution).get('Type')=='Employer'){
                        objIncome.Trust_Income_Type__c='Super Concessional Contribution';
                    }else if((String)((Map<String,Object>)eachContribution).get('Type')=='Additional'){
                        objIncome.Trust_Income_Type__c='Super Excess Concessional Contribution';
                    }else if((String)((Map<String,Object>)eachContribution).get('Type')=='NonConcessional'){
                        objIncome.Trust_Income_Type__c='Super Non Concessional Contribution';
                    }
                }
                if(objIncome.genesis__Amount__c>0){
                    objIncomeMap.put(objIncome,objSmsfAccountName);
                }
            }

        }else if(((Map<String, Object>)eachMember)!= null &&
            String.valueOf(
            ((Map<String, Object>)eachMember
            ))
                 .contains('Contribution={')){
                Object eachContribution=((Object) ((Map<String, Object>)eachMember).get('Contribution'));
                genesis__Income__c objIncome=new genesis__Income__c();
                objIncome.Business_Income_Period__c='Current';
                if(((Map<String,Object>)eachContribution)!=null &&
                ((String)((Map<String,Object>)eachContribution).get('Value'))!=null){
                    objIncome.genesis__Amount__c=Decimal.valueOf((String)((Map<String,Object>)eachContribution).get('Value'));
                    currentIncome+=objIncome.genesis__Amount__c;
                }
                if(((Map<String,Object>)eachContribution)!=null &&
                ((String)((Map<String,Object>)eachContribution).get('Type'))!=null){
                    if((String)((Map<String,Object>)eachContribution).get('Type')=='Employer'){
                        objIncome.Trust_Income_Type__c='Super Concessional Contribution';
                    }else if((String)((Map<String,Object>)eachContribution).get('Type')=='Additional'){
                        objIncome.Trust_Income_Type__c='Super Excess Concessional Contribution';
                    }else if((String)((Map<String,Object>)eachContribution).get('Type')=='NonConcessional'){
                        objIncome.Trust_Income_Type__c='Super Non Concessional Contribution';
                    }
                }
                if(objIncome.genesis__Amount__c>0){
                    objIncomeMap.put(objIncome,objSmsfAccountName);
                }
        }
        return currentIncome;

    }
}