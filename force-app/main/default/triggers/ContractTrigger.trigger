/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This trigger fires when Contract is created. 
Development Date : 14/09/2022
Last Modified Date : 27/09/2022
****************************************************************************************************/

trigger ContractTrigger on collect__Loan_Account__c (after insert) {
    try{
        Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
        if(!(disCustomTrigger.ContractTrigger__c)){
            if(Trigger.isInsert && Trigger.isAfter){
                List<Id> loanIdList=new List<Id>();
                for(collect__Loan_Account__c objContract:Trigger.new){
                    loanIdList.add(objContract.collect__External_ID__c);
                }
                List<loan__Loan_Account__c> objLoanAccountList=[SELECT id,
                                                                        name 
                                                                    FROM loan__Loan_Account__c 
                                                                    WHERE id in:loanIdList];
                Map<Id,loan__Loan_Account__c> objLoanIdMap=new Map<Id,loan__Loan_Account__c>();
                for(loan__Loan_Account__c objLoanAccount:objLoanAccountList){
                    objLoanIdMap.put(objLoanAccount.id,objLoanAccount);
                }
                List<collect__Loan_Account__c> objContractList=[SELECT id,
                                                                        collect__External_ID__c,
                                                                        CL_Contract__c 
                                                                    FROM collect__Loan_Account__c 
                                                                    WHERE id in: Trigger.new];
                for(collect__Loan_Account__c objContract:objContractList ){
                    if(objContract.collect__External_ID__c!=null && 
                        objLoanIdMap.containsKey(objContract.collect__External_ID__c) &&
                        objLoanIdMap.get(objContract.collect__External_ID__c)!=null){
                        objContract.CL_Contract__c=objLoanIdMap.get(objContract.collect__External_ID__c).id;
                    }
                }
                if(objContractList.size()>0){
                    Database.update(objContractList,false);
                }
            }
        }
    }catch(Exception exe){
        GenericUtility.insertLog('ContractTrigger',exe);
    }

}