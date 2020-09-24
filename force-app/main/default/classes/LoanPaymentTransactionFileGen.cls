/****************************************************************************************************/
/* Description          : This class creates an ABA file for the list of Loan Payments Transaction
Generated on a particular date. The file is generated branch wise using single APC setup wise
using single APC setup for Direct debit payments by extending product class loan.FileGenerator*/
/****************************************************************************************************/

global with sharing class LoanPaymentTransactionFileGen extends loan.FileGenerator {
    Long sumOfAmt = 0;
    Decimal tempAmt;
    Integer entryCount = 0;
    Map<Id, loan__Loan_Payment_Transaction__c> lptMap = new Map<Id, loan__Loan_Payment_Transaction__c>();
    Map<Id, loan__Automated_Payment_Configuration__c> apcMap = new Map<Id, loan__Automated_Payment_Configuration__c>(
      [
        SELECT
          Id,
          User_Financial_Institution_Name__c,
          User_Id__c,
          Name_of_User__c,
          Description_of_funds__c
        FROM loan__Automated_Payment_Configuration__c LIMIT 200
      ]
    );
    Map<Id, loan__Bank_Account__c> bankAccts = new Map<Id, loan__Bank_Account__c>();
    Date currentDate = (!Test.isRunningTest()
      ? (new loan.GlobalLoanUtilFacade()).getCurrentSystemDate()
      : Date.Today());
    DateTime currentDateTime = (DateTime) currentDate;
    String currDate = currentDateTime.format('ddMMyy');
  
    class BenfDetails {
      String benfAcctName;
      String benfBSBNumber;
      String benfAccNumber;
      String remitterName;
      Integer amtWithholdingTax;
    }
    // Returns Total List of Loan Payment Transaction
    private List<loan__Loan_Payment_Transaction__c> requeryScope(
      List<SObject> scope
    ) {
      List<loan__Loan_Payment_Transaction__c> lptTxns;
      Set<Id> ids = new Set<Id>();
      try {
        if(scope == null || scope.isEmpty()){
          throw new CustomException(ConstantValues.ENTRY_SCOPE_EMPTY);
        }
        // Creating a set of Ids of the given scope
        for (SObject s : scope) {
          ids.add(s.Id);
        }
        lptTxns = new List<loan__Loan_Payment_Transaction__c>(
          [
            SELECT
              Id,
              Name,
              loan__ACH_Filename__c,
              loan__Cleared__c,
              loan__Payment_Mode__c,
              loan__Payment_Mode__r.Name,
              loan__Rejected__c,
              loan__Reversed__c,
              loan__Sent_to_ACH__c,
              loan__Sent_To_ACH_On__c,
              loan__Transaction_Amount__c,
              loan__Cheque_Number__c,
              loan__Transaction_Date__c,
              loan__Loan_Account__c,
              loan__Loan_Account__r.loan__Borrower_ACH__c,
              loan__Loan_Account__r.Warehouse__r.Collection_Bank_Account_Number__c,
              loan__Loan_Account__r.Warehouse__r.Collection_BSB_Number__c,
              loan__Loan_Account__r.Warehouse__r.Collection_Bank_Account_Name__c
            FROM loan__Loan_Payment_Transaction__c
            WHERE
              Id IN :ids
              AND loan__Reversed__c = false
              AND loan__Rejected__c = false
          ]
        );
        //Making list of Bank Account Ids in LPTs
        List<Id> refBankAccountIdList = new List<Id>();
        for(loan__Loan_Payment_Transaction__c each : lptTxns){
          if(String.isNotBlank(each.loan__Loan_Account__r.loan__Borrower_ACH__c)){
            refBankAccountIdList.add(each.loan__Loan_Account__r.loan__Borrower_ACH__c);
          }
        }
        bankAccts = new Map<Id, loan__Bank_Account__c>(
          [
            SELECT
              Id,
              loan__Bank_Account_Number__c,
              Bank_Account_Name__c,
              BSB_Number__c,
              loan__Account__c,
              loan__Account__r.Name
            FROM loan__Bank_Account__c WHERE Id IN :refBankAccountIdList
          ]
        );
      } catch (Exception ex) {
        GenericUtility.insertLog(ConstantValues.LPT_FILE_GEN, ex);
      }
      return lptTxns;
    }
    //Method to give File Name to the generated file
    global override String getSimpleFileName() {
      return System.label.LPT_File_Name + currDate;
    }
    // This method is for processing scopes for ABA file entries
    private String processScope(
      loan__Loan_Payment_Transaction__c lptObj,
      BenfDetails benfObj
    ) {
      String entryVal;
      if(!bankAccts.containsKey(lptObj.loan__Loan_Account__r.loan__Borrower_ACH__c)){
        addToInvalidScope(lptObj, ConstantValues.BANK_ACC_MISSING_PAYER);
        return null;
      }
      loan__Bank_Account__c bank = bankAccts.get(
        lptObj.loan__Loan_Account__r.loan__Borrower_ACH__c
      );
      Integer transCode = ConstantValues.TXN_CODE_DEBIT;
      Decimal tempAmt = lptObj.loan__Transaction_Amount__c.setScale(2) * 100;
      Long transAmt = tempAmt.round();
  
      if (bank == null) {
        addToInvalidScope(lptObj, ConstantValues.BANK_ACC_MISSING_PAYER);
      } else if (
        String.isBlank(bank.BSB_Number__c) ||
        String.isBlank(bank.loan__Bank_Account_Number__c)
      ) {
        addToInvalidScope(lptObj, ConstantValues.BANK_ACC_DETAILS_MISSING_PAYER);
      } else if (String.valueOf(bank.BSB_Number__c).length() != ConstantValues.STANDARD_BSB_LENGTH) {
        addToInvalidScope(lptObj, ConstantValues.WRONG_BSB_PAYER);
      } else if (String.valueOf(bank.Bank_Account_Name__c).length() > ConstantValues.STANDARD_ACCOUNT_NAME_LENGTH) {
        addToInvalidScope(lptObj, ConstantValues.ACCOUNT_NAME_WLEN);
      } else if (String.valueOf(bank.loan__Bank_Account_Number__c).length() > ConstantValues.STANDARD_ACCOUNT_NUMBER_LENGTH) {
        addToInvalidScope(lptObj, ConstantValues.WRONG_ACOUNT_NUMBER_PAYER);
      } else {
        //Using DirectEntryFileRecordGenUtil class to store data and further process
        DirectEntryFileRecordGenUtil.DetailRecordData recOneDataObj = new DirectEntryFileRecordGenUtil.DetailRecordData();
        recOneDataObj.payerBSBNumber = String.valueOf(bank.BSB_Number__c);
        recOneDataObj.payerAcctNumber = String.valueOf(
          bank.loan__Bank_Account_Number__c
        );
        recOneDataObj.indicator = ConstantValues.INDICATOR;
        recOneDataObj.transCode = transCode;
        recOneDataObj.transAmt = transAmt;
        recOneDataObj.payerAcctName = String.valueOf(bank.Bank_Account_Name__c);
        recOneDataObj.lodgementRef = lptObj.Name;
        recOneDataObj.benfBSBNumber = benfObj.benfBSBNumber;
        recOneDataObj.benfAccNumber = benfObj.benfAccNumber;
        recOneDataObj.remitterName = benfObj.remitterName;
        recOneDataObj.amtWithholdingTax = benfObj.amtWithholdingTax;
  
        entryVal = DirectEntryFileRecordGenUtil.getRecordOne(recOneDataObj);
        sumOfAmt += transAmt;
        addEntry(entryVal);
        entryCount += 1;
        addToValidScope(lptObj);
      }
      return entryVal;
    }
    //Method to process LPT records and list of detail records
    global override List<String> getEntries(
      loan.TransactionSweepToACHState state,
      List<SObject> scope
    ) {
      List<loan__Loan_Payment_Transaction__c> lptTxns = requeryScope(scope);
      List<String> totalRecords = new List<String>();
      try {
        loan__Automated_Payment_Configuration__c tempApc = (loan__Automated_Payment_Configuration__c) state.o1;
        loan__Automated_Payment_Configuration__c apc = apcMap.get(tempApc.Id);
        // Creating a Beneficiary detail object
        //Sending LPTs and corresponding beneficiary detail object for processing
        BenfDetails benfObj = new BenfDetails();
        benfObj.amtWithholdingTax = 0;
        for (loan__Loan_Payment_Transaction__c each : lptTxns) {
          if (
            String.isBlank(each.loan__Loan_Account__r.Warehouse__r.Collection_Bank_Account_Name__c)
          ) {
            GenericUtility.insertLog(
              ConstantValues.LPT_FILE_GEN,
              new CustomException(ConstantValues.REMITTER_NOT_FOUND)
            );
            return totalRecords;
          }
          if (
            String.isBlank(each.loan__Loan_Account__r.Warehouse__r.Collection_Bank_Account_Number__c)
          ) {
            GenericUtility.insertLog(
              ConstantValues.LPT_FILE_GEN,
              new CustomException(ConstantValues.COMPANY_BANK_DETAILS_MISSING)
            );
            return totalRecords;
          }
          if (String.isBlank(each.loan__Loan_Account__r.Warehouse__r.Collection_BSB_Number__c)) {
            GenericUtility.insertLog(
              ConstantValues.LPT_FILE_GEN,
              new CustomException(ConstantValues.COMPANY_BANK_DETAILS_MISSING)
            );
            return totalRecords;
          }
          if (String.valueOf(each.loan__Loan_Account__r.Warehouse__r.Collection_BSB_Number__c).length() != ConstantValues.STANDARD_BSB_LENGTH) {
            GenericUtility.insertLog(
              ConstantValues.LPT_FILE_GEN,
              new CustomException(ConstantValues.WRONG_BSB_PAYEE)
            );
            return totalRecords;
          }
          if (String.valueOf(each.loan__Loan_Account__r.Warehouse__r.Collection_Bank_Account_Number__c).length() > ConstantValues.STANDARD_ACCOUNT_NUMBER_LENGTH) {
            GenericUtility.insertLog(
              ConstantValues.LPT_FILE_GEN,
              new CustomException(ConstantValues.WRONG_ACOUNT_NUMBER_PAYEE)
            );
            return totalRecords;
          }
          benfObj.remitterName = each.loan__Loan_Account__r.Warehouse__r.Collection_Bank_Account_Name__c;
          benfObj.benfBSBNumber = String.valueOf(each.loan__Loan_Account__r.Warehouse__r.Collection_BSB_Number__c);
          benfObj.benfAccNumber = String.valueOf(each.loan__Loan_Account__r.Warehouse__r.Collection_Bank_Account_Number__c);
          String entryVal = processScope(each, benfObj);
          if (entryVal != null) {
            totalRecords.add(entryVal);
          }
        }
      } catch (Exception ex) {
        GenericUtility.insertLog(
          ConstantValues.LPT_FILE_GEN,
          ex
        );
      }
      return totalRecords;
    }
    //Method to get header for the file
    global override String getHeader(
      loan.TransactionSweepToACHState state,
      List<SObject> scope
    ) {
      String headerVal;
      try {
        if(state != null && scope != null){
          loan__Automated_Payment_Configuration__c apc = (loan__Automated_Payment_Configuration__c) state.o1;
          apc = apcMap.get(apc.Id);
    
          if (apc == null) {
            GenericUtility.insertLog(
              ConstantValues.LPT_FILE_GEN,
              new CustomException(ConstantValues.NO_APC_FOUND)
            );
            return headerVal;
          }
    
          DirectEntryFileRecordGenUtil.DescriptiveRecordData recZeroDataObj = new DirectEntryFileRecordGenUtil.DescriptiveRecordData();
          // No null check for User_Financial_Institution_Name__c, Name_of_User__c, User_Id__c as they are mandatory fields
          recZeroDataObj.financialInstitutionName = apc.User_Financial_Institution_Name__c;
          recZeroDataObj.username = apc.Name_of_User__c;
          recZeroDataObj.userId = apc.User_Id__c;
          recZeroDataObj.description = apc.Description_of_funds__c;
          //recZeroDataObj.currDate = currentDate;
          headerVal = DirectEntryFileRecordGenUtil.getDescriptiveRecord(recZeroDataObj);
        }
      } catch (Exception ex) {
        GenericUtility.insertLog(ConstantValues.LPT_FILE_GEN, ex);
      }
      return headerVal;
    }
    //Method to get trailer record for file generation
    global override String getTrailer(
      loan.TransactionSweepToACHState state,
      List<SObject> scope
    ) {
      String trailerVal;
      try {
        DirectEntryFileRecordGenUtil.RecordSevenData recSevenDataObj = new DirectEntryFileRecordGenUtil.RecordSevenData();
        recSevenDataObj.sumOfAmt = sumOfAmt;
        recSevenDataObj.entryCount = entryCount;
        trailerVal = DirectEntryFileRecordGenUtil.getRecordSeven(recSevenDataObj);
      } catch (Exception ex) {
        GenericUtility.insertLog(ConstantValues.LPT_FILE_GEN, ex);
      }
      return trailerVal;
    }
  }
  