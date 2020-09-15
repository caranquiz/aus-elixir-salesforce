
/****************************************************************************************************/
/* Description          : This class extends the CL loan product class ACHReturnPaymentProcessor
                          reads the LPT Return file and returns LPTs which has to be reversed or
                          rejected. This class is called by the product class in 'Upload ACH Return'
                          tab. */
/****************************************************************************************************/
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
                    if(typeOfService.equals('2')){
                        //Process Reversed Transaction
                        lptMap.put(bodyLines[i].substring(bodyLines[i].lastIndexOf(ConstantValues.LPT_PREFIX),80).trim(),bodyLines[i].substring(18,19).trim());
                    }
                    i +=1;
                } 
                if(lptMap.keySet() != null){
                    List<loan__Loan_Payment_Transaction__c> payments = new List<loan__Loan_Payment_Transaction__c>();
                    List<String> lptNameList = new List<String>();
                    List<String> excepLPT = new List<String>();
                    payments = [SELECT Id,Name
                                FROM loan__Loan_Payment_Transaction__c 
                                WHERE Name IN:lptMap.keySet()];
                    if(payments.size()>0){
                        //Adding LPTs with reason code to be reversed
                        for(loan__Loan_Payment_Transaction__c obj : payments){
                            loan.ACHReturn achRet = new loan.ACHReturn();
                            achRet.payment = obj; 
                            lptNameList.add(String.valueOf(obj.get(ConstantValues.NAME)));
                            if(lptMap.get(String.valueOf(obj.get(ConstantValues.NAME))) == '1'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_1;
                            }
                            else if(lptMap.get(String.valueOf(obj.get(ConstantValues.NAME))) == '2'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_2;
                            }
                            else if(lptMap.get(String.valueOf(obj.get(ConstantValues.NAME))) == '3'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_3;
                            }
                            else if(lptMap.get(String.valueOf(obj.get(ConstantValues.NAME))) == '4'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_4;
                            }
                            else if(lptMap.get(String.valueOf(obj.get(ConstantValues.NAME))) == '5'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_5;
                            }
                            else if(lptMap.get(String.valueOf(obj.get(ConstantValues.NAME))) == '6'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_6;
                            }
                            else if(lptMap.get(String.valueOf(obj.get(ConstantValues.NAME))) == '7'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_7;
                            }
                            else if(lptMap.get(String.valueOf(obj.get(ConstantValues.NAME))) == '8'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_8;
                            }
                            else if(lptMap.get(String.valueOf(obj.get(ConstantValues.NAME))) == '9'){
                                achRet.returnCode = ConstantValues.RET_CAUSE_9;
                            }
                            else {
                                achRet.returnCode = ConstantValues.RET_CAUSE_DEFAULT;
                            }
                            achReturns.add(achRet);
                        }
                    } 
                    if(payments.size() < (lptMap.keySet()).size()) {
                        for(String each : lptMap.keySet()){
                            if(!lptNameList.contains(each)){
                                excepLPT.add(each);
                            }
                        }
                    }
                    //Method to insert Bank Statement Exception if an LPT is not found
                    insertBankExcep(excepLPT);
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
    public static void insertBankExcep(List<String> excepLPT){
        List<peer__Bank_Recon_Exception__c> excepList = new List<peer__Bank_Recon_Exception__c>();
        if(excepLPT != null && excepLPT.size() != 0){
            for(String each : excepLPT){
                peer__Bank_Recon_Exception__c bankExcep = new peer__Bank_Recon_Exception__c();
                bankExcep.peer__Name__c = each;
                bankExcep.peer__Recon_Message__c = ConstantValues.LPT_EXCEP;
                bankExcep.peer__Statement_Date__c = Date.today();
                excepList.add(bankExcep);
            }
        }
        insert excepList;
    }
}  
