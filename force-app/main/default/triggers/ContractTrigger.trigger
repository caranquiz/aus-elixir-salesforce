trigger ContractTrigger on collect__Loan_Account__c (after insert) {
    try{
        Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
        if(!(disCustomTrigger.LoanCollateralTrigger__c)){
            if(Trigger.isInsert && Trigger.isAfter){
                List<Id> loanIdList=new List<Id>();
                for(collect__Loan_Account__c objContract:Trigger.new){
                    loanIdList.add(objContract.collect__External_ID__c);
                }
                List<loan__Loan_Account__c> objLoanAccountList=[SELECT id,name FROM loan__Loan_Account__c WHERE id in:loanIdList];
                List<collect__Loan_Account__c> objContractList=[SELECT id,collect__External_ID__c,CL_Contract__c FROM collect__Loan_Account__c WHERE id in: Trigger.new];
                for(collect__Loan_Account__c objContract:objContractList ){
                    for(loan__Loan_Account__c objLoanAccount:objLoanAccountList){
                        if(objLoanAccount.id == objContract.collect__External_ID__c){
                            objContract.CL_Contract__c=objLoanAccount.id;
                        }
                    }
                }
                if(objContractList.size()>0){
                    update objContractList;
                }
            }
        }
    }catch(Exception exe){
         insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'ContractTrigger :'+exe.getStackTraceString()+':Error::'+exe.getMessage()+' at Line Number '+exe.getLineNumber(), clcommon__Timestamp__c = 
                    System.Now(),clcommon__Log_Level__c = 'ERROR'); 
    }

}