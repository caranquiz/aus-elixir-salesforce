global class LoanPaymentReturnFileProcessor extends loan.ACHReturnPaymentProcessor{

    public List<loan.ACHReturn> achReturns = new List<loan.ACHReturn>();
    global override List<loan.ACHReturn> parseFile(String fileContent,String objectType){ 
        try{
            if(fileContent != null){
                List<String> bodyLines = fileContent.split('\n');
                achReturns.clear();
                String typeOfTask;  
                Map<String,String> lptMap = new Map<String,String>();
                Integer i=1;
                while (i<bodyLines.size()-1){
                    String typeOfService = bodyLines[i].substring(0,1); 
                    System.debug(typeOfService);
                    if(typeOfService.equals('2')){
                        System.debug(bodyLines[i].substring(bodyLines[i].lastIndexOf('LPT-'),80).trim());
                        System.debug(bodyLines[i].substring(18,19).trim());
                        //Process Reversed Transaction
                        lptMap.put(bodyLines[i].substring(bodyLines[i].lastIndexOf('LPT-'),80).trim(),bodyLines[i].substring(18,19).trim());
                    }
                    i +=1;
                } 
                if(lptMap.keySet() != null){
                    List<loan__Loan_Payment_Transaction__c> payments = new List<loan__Loan_Payment_Transaction__c>();
                    payments = [SELECT Id,Name
                                FROM loan__Loan_Payment_Transaction__c 
                                WHERE Name IN:lptMap.keySet()];
                if(payments.size()>0){
                        for(loan__Loan_Payment_Transaction__c obj : payments){
                            loan.ACHReturn achRet = new loan.ACHReturn();
                            achRet.payment = obj; 
                            if(lptMap.get(String.valueOf(obj.get('Name'))) == '1'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_1;
                            }
                            else if(lptMap.get(String.valueOf(obj.get('Name'))) == '2'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_2;
                            }
                            else if(lptMap.get(String.valueOf(obj.get('Name'))) == '3'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_3;
                            }
                            else if(lptMap.get(String.valueOf(obj.get('Name'))) == '4'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_4;
                            }
                            else if(lptMap.get(String.valueOf(obj.get('Name'))) == '5'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_5;
                            }
                            else if(lptMap.get(String.valueOf(obj.get('Name'))) == '6'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_6;
                            }
                            else if(lptMap.get(String.valueOf(obj.get('Name'))) == '7'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_7;
                            }
                            else if(lptMap.get(String.valueOf(obj.get('Name'))) == '8'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_8;
                            }
                            else if(lptMap.get(String.valueOf(obj.get('Name'))) == '9'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_9;
                            }
                            else {
                                achRet.returnCode = ConstantValues.RET_CAUSE_DEFAULT;
                            }
                            achReturns.add(achRet);
                        }
                    } 
                }     
                return achReturns;  
            }
            return null;
        }
        catch(Exception e){
            GenericUtility.insertLog('LoanPaymentReturnFileProcessor', e);
            Loan__Batch_Process_log__c c = new Loan__Batch_Process_log__c(loan__Message__c = 'LoanPaymentReturnFileProcessor- failed :'+e.getStackTraceString()+'Line: '+e.getLineNumber(),loan__Time__c = System.Now(),loan__Log_Level__c = 'ERROR');
            insert c;
            return null;
        }
    }
}  
