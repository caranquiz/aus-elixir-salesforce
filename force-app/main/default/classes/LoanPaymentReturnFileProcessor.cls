/****************************************************************************************************
Description          : This class extends the CL loan product class ACHReturnPaymentProcessor
                          reads the LPT Return file and returns LPTs which has to be reversed or
                          rejected. This class is called by the product class in 'Upload ACH Return'
                          tab.
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Pratik Agarwal
Development Date : 4/09/2020
Last Modified Date : 14/10/2020  
****************************************************************************************************/
global class LoanPaymentReturnFileProcessor extends loan.ACHReturnPaymentProcessor {
  public List<loan.ACHReturn> achReturns = new List<loan.ACHReturn>();
  global override List<loan.ACHReturn> parseFile(
    String fileContent,
    String objectType
  ) {
    try {
      if (fileContent != null) {
        List<String> bodyLines = fileContent.split('\n');
        achReturns.clear();
        String typeOfTask;
        Map<String, String> lptMap = new Map<String, String>();
        Map<String, Decimal> lptAmountMap = new Map<String, Decimal>();
        Integer i = 1;
        while (i < bodyLines.size() - 1) {
          String typeOfService = bodyLines[i].substring(0, 1);
          if (typeOfService.equals('2') && bodyLines[i].length() >= 80) {
            System.debug(
              Decimal.valueOf(bodyLines[i].substring(20, 30).trim())
            );
            //Process Reversed Transaction
            lptMap.put(
              bodyLines[i]
                .substring(
                  bodyLines[i].lastIndexOf(ConstantValues.LPT_PREFIX),
                  80
                )
                .trim(),
              bodyLines[i].substring(17, 18).trim()
            );
            lptAmountMap.put(
              bodyLines[i]
                .substring(
                  bodyLines[i].lastIndexOf(ConstantValues.LPT_PREFIX),
                  80
                )
                .trim(),
              Decimal.valueOf(bodyLines[i].substring(20, 30).trim())
            );
          }
          i += 1;
        }
        if (lptMap.keySet() != null) {
          List<loan__Loan_Payment_Transaction__c> payments;
          List<String> lptNameList = new List<String>();
          List<String> excepLPT = new List<String>();
          List<String> excepLPTAmount = new List<String>();
          payments = [
            SELECT Id, Name, loan__Transaction_Amount__c
            FROM loan__Loan_Payment_Transaction__c
            WHERE Name IN :lptMap.keySet()
          ];
          //Adding LPTs with reason code to be reversed
          for (loan__Loan_Payment_Transaction__c lPTobj : payments) {
            System.debug(
              lptAmountMap.get(String.valueOf(lPTobj.get(ConstantValues.NAME)))
            );
            if (
              (lPTobj.loan__Transaction_Amount__c * 100) !=
              (lptAmountMap.get(
                String.valueOf(lPTobj.get(ConstantValues.NAME))
              ))
            ) {
              excepLPTAmount.add(
                String.valueOf(lPTobj.get(ConstantValues.NAME))
              );
              continue;
            }
            loan.ACHReturn achRet = new loan.ACHReturn();
            achRet.payment = lPTobj;
            lptNameList.add(String.valueOf(lPTobj.get(ConstantValues.NAME)));
            if (
              lptMap.get(String.valueOf(lPTobj.get(ConstantValues.NAME))) == '1'
            ) {
              achRet.returnCode = ConstantValues.RET_CAUSE_1;
            } else if (
              lptMap.get(String.valueOf(lPTobj.get(ConstantValues.NAME))) == '2'
            ) {
              achRet.returnCode = ConstantValues.RET_CAUSE_2;
            } else if (
              lptMap.get(String.valueOf(lPTobj.get(ConstantValues.NAME))) == '3'
            ) {
              achRet.returnCode = ConstantValues.RET_CAUSE_3;
            } else if (
              lptMap.get(String.valueOf(lPTobj.get(ConstantValues.NAME))) == '4'
            ) {
              achRet.returnCode = ConstantValues.RET_CAUSE_4;
            } else if (
              lptMap.get(String.valueOf(lPTobj.get(ConstantValues.NAME))) == '5'
            ) {
              achRet.returnCode = ConstantValues.RET_CAUSE_5;
            } else if (
              lptMap.get(String.valueOf(lPTobj.get(ConstantValues.NAME))) == '6'
            ) {
              achRet.returnCode = ConstantValues.RET_CAUSE_6;
            } else if (
              lptMap.get(String.valueOf(lPTobj.get(ConstantValues.NAME))) == '7'
            ) {
              achRet.returnCode = ConstantValues.RET_CAUSE_7;
            } else if (
              lptMap.get(String.valueOf(lPTobj.get(ConstantValues.NAME))) == '8'
            ) {
              achRet.returnCode = ConstantValues.RET_CAUSE_8;
            } else if (
              lptMap.get(String.valueOf(lPTobj.get(ConstantValues.NAME))) == '9'
            ) {
              achRet.returnCode = ConstantValues.RET_CAUSE_9;
            } else {
              achRet.returnCode = ConstantValues.RET_CAUSE_DEFAULT;
            }
            achReturns.add(achRet);
          }
          if (payments.size() <= (lptMap.keySet()).size()) {
            for (String eachLpt : lptMap.keySet()) {
              if (!lptNameList.contains(eachLpt)) {
                excepLPT.add(eachLpt);
              }
            }
          }
          //Method to insert Bank Statement Exception if an LPT is not found
          insertBankExcep(excepLPT, excepLPTAmount);
        }
        return achReturns;
      }
      return null;
    } catch (Exception e) {
      GenericUtility.insertLog('LoanPaymentReturnFileProcessor', e);
      Loan__Batch_Process_log__c c = new Loan__Batch_Process_log__c(
        loan__Message__c = 'LoanPaymentReturnFileProcessor- failed :' +
          e.getStackTraceString() +
          'Line: ' +
          e.getLineNumber(),
        loan__Time__c = System.Now(),
        loan__Log_Level__c = 'ERROR'
      );
      insert c;
      return null;
    }
  }
  public static void insertBankExcep(
    List<String> excepLPT,
    List<String> excepLPTAmount
  ) {
    List<peer__Bank_Recon_Exception__c> excepList = new List<peer__Bank_Recon_Exception__c>();
    if (excepLPT != null && excepLPT.size() != 0) {
      for (String eachExceptLPT : excepLPT) {
        peer__Bank_Recon_Exception__c bankExcep = new peer__Bank_Recon_Exception__c();
        bankExcep.peer__Name__c = eachExceptLPT;
        bankExcep.peer__Recon_Message__c = ConstantValues.LPT_EXCEP;
        bankExcep.peer__Statement_Date__c = Date.today();
        excepList.add(bankExcep);
      }
    }
    if (excepLPTAmount != null && excepLPTAmount.size() != 0) {
      for (String eachExcepLPTAmount : excepLPTAmount) {
        peer__Bank_Recon_Exception__c bankExcep = new peer__Bank_Recon_Exception__c();
        bankExcep.peer__Name__c = eachExcepLPTAmount;
        bankExcep.peer__Recon_Message__c = ConstantValues.LPT_AMOUNT_EXCEP;
        bankExcep.peer__Statement_Date__c = Date.today();
        excepList.add(bankExcep);
      }
    }
    insert excepList;
  }
}