/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Koushik Mondal
Development Date : 29/07/2020
Last Modified By : Koushik Mondal
Last Modified Date : 29/07/2020
Description : This class query all the Rules and check the Rule Criteria for the Loan Application.
***********************************************************************************************************************************************************/

global with sharing class CheckRules {
    webService static String callCheckRulesWS(String applicationId, String tabName) {
        String returnValue = '';
        String applicationRecordId;
        List <String> rulesNameList = new List<String>();
        Savepoint sp = Database.setSavepoint();
        List<genesis__Checklist__c> checkList = new List<genesis__Checklist__c>();
        try {
            if (applicationId == null) {
                return (ConstantValues.CHECKRULES_APPLICATION_ID_NULL);
            }

            applicationRecordId = applicationId.substring(0,applicationId.length()-3);

            if(tabName == 'Loan Details'){
                rulesNameList.add('Cash Out Purpose Suitable Rule');
                rulesNameList.add('Commission Mandate Percentage Rule');
                rulesNameList.add('Interest Only Suitable Rule');
                rulesNameList.add('Exit Strategy Suitable Rule');
                rulesNameList.add('Lenders Mortgage Insurance Rule');
            }
            else if(tabName == 'Settlement'){
                rulesNameList.add('Customer Interview completed Rule');
            }
            else if(tabName == 'Securities'){
                rulesNameList.add('Distressed Asset Rule');
                rulesNameList.add('Check Val Value Rule');
            }
            else if(tabName == 'Individual Contact Details'){
                rulesNameList.add('Temporary Visa Suitability Rule');
                rulesNameList.add('ABN Status Explanation Suitable Rule');
                rulesNameList.add('Exit Strategy Suitable Rule (Contact)');
                rulesNameList.add('Borrower is a Staff Member Rule');
            }
            else if(tabName == 'Non Individual Contact Details'){
                rulesNameList.add('GST Suitable Rule');
            }
            else if(tabName == 'Credit History'){
                rulesNameList.add('Explanation of Credit Events Suitable Rule');
                rulesNameList.add('Explanation of Credit Enquiries Suitable Rule');
                rulesNameList.add('Explanation of Bankruptcy Suitable Rule');
                rulesNameList.add('Explanation of Age of Credit File Suitable Rule');
            }
            else if(tabName == 'Individual Employment Information'){
                rulesNameList.add('Confirm letter prepared by accountant Rule');
                rulesNameList.add('Confirm stated annual income Rule');
                rulesNameList.add('Accountant aware of any circumstances Rule');
                rulesNameList.add('Accountant Call Suitable Rule');
                rulesNameList.add('Employment Call Suitable Rule');
                rulesNameList.add('Income Consistent with Declaration Rule');
            }
            else if(tabName == 'Living Expense'){
                rulesNameList.add('Living Expense Explanation Suitable Rule');
                rulesNameList.add('Bank Statements Reviewed Rule');
            }
            else if(tabName == 'Company Income'){
                rulesNameList.add('Income Consistent with Declaration Rule');
                rulesNameList.add('Satisfactory Explanation Provided Rule');
                rulesNameList.add('Confirm letter prepared by accountant Rule');
                rulesNameList.add('Confirm stated annual income Rule');
                rulesNameList.add('Accountant aware of any circumstances Rule');
                rulesNameList.add('Accountant Call Suitable Rule');
            }
            Map<Id,genesis__Rule__c> mapRules = new Map<Id,genesis__Rule__c>([SELECT Id,
                                                                            Name
                                                                            FROM genesis__Rule__c
                                                                            WHERE genesis__Enabled__c = true
                                                                            AND Name =: rulesNameList]);


            genesis__Applications__c application = [SELECT  Id, 
                                                    Lenders_Mortgage_Insurance__c,
                                                    Actual_LVR__c,
                                                    Exit_Strategy_Suitable__c,
                                                    Exit_Strategy_Suitable_Rule_Check__c,
                                                    Exit_Strategy_Provided__c,
                                                    Repayment_Type__c,
                                                    Customer_Interview_Completed_Rule_Check__c,
                                                    Customer_Interview_completed__c,
                                                    genesis__CL_Product_Name__c,
                                                    NCCP_status_list__c,
                                                    Commission_Mandate_Percentage__c,
                                                    Commission_Mandate__c,
                                                    Commission_Mandate_Percentage_Rule_Check__c,
                                                    Cash_Out_Purpose_Suitable__c,
                                                    Cash_Out_Purpose_Suitable_Rule_Check__c
                                                    FROM genesis__Applications__c 
                                                    WHERE id = :applicationRecordId
                                                    LIMIT 1];                                                               
            If (application != null && mapRules != null) {                              
                if(Test.isRunningTest() == false){
                checkList = genesis.RulesAPI.evaluateRules(application, mapRules.values(), true, true);
                /*List<genesis__Checklist__c> archivedChecklistList = [SELECT Id 
                                                                  FROM genesis__Checklist__c 
                                                                  WHERE genesis__Application__c  =: applicationRecordId
                                                                  AND genesis__Is_Archived__c = TRUE];
                delete archivedChecklistList;*/
                }
                else{
                    
                    checkList = [Select Id,
                                        genesis__Application__c,
                                        genesis__Assessed_Record_Id__c,
                                        genesis__Is_Archived__c ,
                                        genesis__Level__c,
                                        genesis__Message__c,
                                        genesis__Rule__c,
                                        genesis__Rule__r.Name,
                                        genesis__Type__c
                                        From genesis__Checklist__c];
                }
                if(tabName != 'Loan Details' && tabName != 'Settlement'){
                    ChildChecklistAPI api = new ChildChecklistAPI();
                    List<Checklist_Detail__c> listOfDetail = api.processListOfChecklist(checkList, applicationRecordId);
                    
                    /*if(tabName == 'Individual Employment Information'){
                        for(Checklist_Detail__c eachCheckListDet : listOfDetail){
                            if((eachCheckListDet.Employment_Information__c != NULL
                            && 
                            && eachCheckListDet.Employment_Information__r.Previous_Employment__c == true
                            && (eachCheckListDet.Checklist__r.genesis__Rule__r.Name == 'Employment Call Suitable Rule')){
                                finalSet.add(eachCheckListDet);
                            }
                            if((eachCheckListDet.Income__c != NULL
                            && eachCheckListDet.Income__r.Document_Type__c == 'Alt')
                            && (eachCheckListDet.Checklist__r.genesis__Rule__r.Name == 'Confirm letter prepared by accountant Rule'
                            || eachCheckListDet.Checklist__r.genesis__Rule__r.Name == 'Confirm stated annual income Rule'
                            || eachCheckListDet.Checklist__r.genesis__Rule__r.Name == 'Accountant aware of any circumstances Rule'
                            || eachCheckListDet.Checklist__r.genesis__Rule__r.Name == 'Employment Call Suitable Rule')){
                                finalSet.add(eachCheckListDet);
                            }
                        }
                    }
                    if(tabName == 'Company Income'){
                        for(Checklist_Detail__c eachCheckListDet : listOfDetail){
                            if((eachCheckListDet.Income__c != NULL)
                            && eachCheckListDet.Income__r.Document_Type__c == 'Alt')
                            && (eachCheckListDet.Checklist__r.genesis__Rule__r.Name == 'Confirm letter prepared by accountant Rule'
                            || eachCheckListDet.Checklist__r.genesis__Rule__r.Name == 'Confirm stated annual income Rule'
                            || eachCheckListDet.Checklist__r.genesis__Rule__r.Name == 'Accountant aware of any circumstances Rule'
                            || eachCheckListDet.Checklist__r.genesis__Rule__r.Name == 'Employment Call Suitable Rule')){
                                finalSet.add(eachCheckListDet);
                            }
                        }
                    }
                    else{*/
                        Database.insert(listOfDetail);
                    //}
                }
            }

            returnValue = ConstantValues.Success;

        } 
        catch (Exception e) {
            Database.rollback(sp);
            returnValue = e.getMessage();
        }
      return returnValue;
    }
}