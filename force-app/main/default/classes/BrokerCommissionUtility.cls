/***********************************************************
Developer : Rameswari Barman
Development Date : 3/12/2019
Description : This class helps in broker commission calculation for hierarchy level broker
************************************************************/
global with sharing class BrokerCommissionUtility{
    public static List<loan__Broker__c> calculateCommission(Account brokerAccount,loan__Loan_Account__c loanAccount,Decimal comPercen, String txnType){
        Map<Account,loan__Commission_Plan__c> brokerCommHierarchy = new Map<Account,loan__Commission_Plan__c>();
        List <loan__Commission_Plan__c> comPlan = new List <loan__Commission_Plan__c>();
        if(txnType.equalsIgnoreCase(ConstantValues.SETTLEMENT_FEE_PLAN)){
            comPlan = [SELECT id,
                                loan__Maximum_Commission_Percentage__c,
                                loan__Factor__c,
                                loan__Plan_Description__c,
                                loan__Calculation_Method__c,
                                loan__Commission_Disbursement_Method__c,
                                loan__Buy_Rate__c,
                                loan__Upfront_Percentage__c,
                                loan__Enabled__c,
                                loan__Flat_Amount__c 
                            FROM loan__Commission_Plan__c 
                            WHERE loan__Maximum_Commission_Percentage__c =: comPercen 
                            AND loan__Plan_Description__c LIKE 'Elixir Settlement Fee Plan%'];
        }
        else{
            comPlan = [select id,
                            loan__Maximum_Commission_Percentage__c,
                            loan__Factor__c,
                            loan__Plan_Description__c,
                            loan__Calculation_Method__c,
                            loan__Commission_Disbursement_Method__c,
                            loan__Buy_Rate__c,
                            loan__Upfront_Percentage__c,
                            loan__Enabled__c,
                            loan__Flat_Amount__c 
                        FROM loan__Commission_Plan__c 
                        WHERE loan__Maximum_Commission_Percentage__c =: comPercen 
                        AND loan__Plan_Description__c LIKE 'Elixir Commission Plan%'];
        }
        if(!(comPlan != null && comPlan.size() > 0)){
            loan__Commission_Plan__c comPlanRec = new loan__Commission_Plan__c();
            comPlanRec.loan__Maximum_Commission_Percentage__c = comPercen;
            comPlanRec.loan__Factor__c = 100;
            if(txnType.equalsIgnoreCase(ConstantValues.SETTLEMENT_FEE_PLAN)){
                comPlanRec.loan__Plan_Description__c = (ConstantValues.SETTLEMENT_FEE_PLAN+' '+comPercen);
            }
            else if(txnType.equalsIgnoreCase(ConstantValues.ELIXIR_COMMISSION_PLAN)){
                comPlanRec.loan__Plan_Description__c = (ConstantValues.ELIXIR_COMMISSION_PLAN+' '+comPercen);
            }
            comPlanRec.loan__Calculation_Method__c = 'Percentage Of Financed Amount';
            comPlanRec.loan__Commission_Disbursement_Method__c = 'Upfront';
            comPlanRec.loan__Buy_Rate__c = comPercen;
            comPlanRec.loan__Upfront_Percentage__c = 100;
            comPlanRec.loan__Enabled__c = true;
            comPlanRec.loan__Flat_Amount__c = 0;
            insert comPlanRec;
            brokerCommHierarchy.put(brokerAccount,comPlanRec);
        }
        else{
            brokerCommHierarchy.put(brokerAccount,comPlan[0]);
        }
        List <loan__Broker__c> broRecs = loan.BrokerCommissionHierarchyUtil.calculateCommissionForBrokerHierarchy(loanAccount, brokerCommHierarchy);
        return broRecs;
    }
    public static List<loan__Broker__c> comUtil(Id iden, Id broIden,Decimal comPercen, String txnType){
        Schema.DescribeSObjectResult r = loan__Loan_Account__c.sObjectType.getDescribe();
        List<String>apiNames =  new list<String>();
        for(string apiName : r.fields.getMap().keySet()){
            apiNames.add(apiName);
        }
        apiNames.add('loan__Loan_Product_Name__r.Name');
        apiNames.add('loan__Loan_Product_Name__r.loan__Digits_After_Decimals__c');
        apiNames.add('loan__Loan_Product_Name__r.loan__General_Rounding_Mode__c'); 
        String loanQuery='Select '+String.join(apiNames,',')+' From loan__Loan_Account__c Where id=\''+iden+'\'';
        Schema.DescribeSObjectResult res = Account.sObjectType.getDescribe();
        List<String>apiNamesAcc =  new list<String>();
        for(string apiNameAcc : res.fields.getMap().keySet()){
            apiNamesAcc.add(apiNameAcc);
        }
        String broQuery ='Select '+String.join(apiNamesAcc,',')+' From Account Where id=\''+broIden+'\'';
        loan__Loan_Account__c loanAcc=Database.query(loanQuery);
        Account acc = Database.query(broQuery);
        List<loan__Broker__c> broRecs = BrokerCommissionUtility.calculateCommission(acc,loanAcc,comPercen,txnType);
        return broRecs;
    }
}