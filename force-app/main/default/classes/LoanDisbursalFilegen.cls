global with sharing class LoanDisbursalFilegen extends loan.FileGenerator {
    Long sumOfAmt = 0;
  Decimal tempAmt;
  Integer entryCount = 0;
  Map<Id, loan__Loan_Disbursal_Transaction__c> lptMap = new Map<Id, loan__Loan_Disbursal_Transaction__c>();
  Map<Id, loan__Automated_Payment_Configuration__c> apcMap = new Map<Id, loan__Automated_Payment_Configuration__c>(
    [
      SELECT
        Id,
        loan__Bank_Account__c,
        loan__Bank_Account__r.loan__Bank_Account_Number__c,
        loan__Bank_Account__r.BSB_Number__c,
        Remitter_Name__c,
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
  // Returns a Map of Detail Record with Loan Disbursal Transaction Ids
  private Map<Id, DirectEntryFileRecordGenUtil.DetailRecordData> requeryScope(
    List<SObject> scope
  ) {
    Map<Id, DirectEntryFileRecordGenUtil.DetailRecordData> detailRecordDataLDTMap = new Map<Id, DirectEntryFileRecordGenUtil.DetailRecordData>();
    DirectEntryFileRecordGenUtil.DetailRecordData obj;
    List<loan__Loan_Disbursal_Transaction__c> ldtTxns;
    Map<Id, List<Id>> loanAccountLDTIdMap = new Map<Id, List<Id>>();
    List<Id> clContractIds = new List<Id>();
    Set<Id> ids = new Set<Id>();
    try {
      if(scope == null || scope.isEmpty()){
        throw new CustomException(ConstantValues.ENTRY_SCOPE_EMPTY);
      }
      // Creating a set of Ids of the given scope
      for (SObject s : scope) {
        ids.add(s.Id);
      }
      ldtTxns = new List<loan__Loan_Disbursal_Transaction__c>(
        [
          SELECT Id, Name,
            loan__ACH_Filename__c,
            loan__Cleared__c,
            loan__Mode_of_Payment__c,
            loan__Mode_of_Payment__r.Name,
            loan__Sent_to_ACH__c,
            loan__Sent_To_ACH_On__c,
            loan__Disbursed_Amt__c,
            loan__Loan_Account__c,
            loan__Loan_Account__r.Warehouse__c,
            loan__Loan_Account__r.Warehouse__r.Institution_Name__c,
            loan__Loan_Account__r.Warehouse__r.Bank_Account_Number__c,
            loan__Loan_Account__r.Warehouse__r.BSB_Number__c,
            ORDE_Financial_Fees_Total_Amount__c
          FROM loan__Loan_Disbursal_Transaction__c
          WHERE
            Id IN :ids
            AND loan__Cleared__c = true
            AND loan__Reversed__c = false
            AND loan__Rejected__c = false
        ]
      );
      for(loan__Loan_Disbursal_Transaction__c each : ldtTxns){
        obj = new DirectEntryFileRecordGenUtil.DetailRecordData();
        obj.lodgementRef = each.Name;
        obj.transAmt = ((each.loan__Disbursed_Amt__c - each.ORDE_Financial_Fees_Total_Amount__c) * 100).round();
        obj.benfBSBNumber = each.loan__Loan_Account__r.Warehouse__r.BSB_Number__c;
        obj.benfAccNumber = each.loan__Loan_Account__r.Warehouse__r.Bank_Account_Number__c;
        obj.remitterName = each.loan__Loan_Account__r.Warehouse__r.Institution_Name__c;
        detailRecordDataLDTMap.put(each.Id, obj);
        System.debug(each.loan__Loan_Account__c);
        clContractIds.add(each.loan__Loan_Account__c);
        List<Id> ldtIds = loanAccountLDTIdMap.get(each.loan__Loan_Account__c);
        if(ldtIds == null){
            ldtIds = new List<Id>();
        }
        ldtIds.add(each.Id);
        loanAccountLDTIdMap.put(each.loan__Loan_Account__c, ldtIds);
      }
      List<loan__Coborrower__c> contractPartyList = [SELECT Id, loan__Loan__c, loan__Account__c, loan__Party_Type__c,
      loan__Account__r.Bank_Account_Name__c, loan__Account__r.Bank_Account_Number__c, loan__Account__r.BSB__c
      FROM loan__Coborrower__c WHERE loan__Loan__c IN:clContractIds AND loan__Party_Type__c =:ConstantValues.SOLICITOR_PARTY_TYPE];
      System.debug(contractPartyList);
      for(loan__Coborrower__c each : contractPartyList){
        System.debug(each);
        List<Id> ldtIds = loanAccountLDTIdMap.get(each.loan__Loan__c);
        for(Id eachId : ldtIds){
            obj = detailRecordDataLDTMap.get(eachId);
            obj.payerBSBNumber = each.loan__Account__r.BSB__c;
            obj.payerAcctNumber = each.loan__Account__r.Bank_Account_Number__c;
            obj.payerAcctName = each.loan__Account__r.Bank_Account_Name__c;
            detailRecordDataLDTMap.put(eachId, obj);
        }
      }
    } catch (Exception ex) {
      GenericUtility.insertLog('LoanDisbursalFilegen', ex);
    }
    return detailRecordDataLDTMap;
  }
  global override String getSimpleFileName() {
    return System.label.LDT_file_name + currDate;
  }
  // This method is for processing scopes for ABA file entries
  private String processScope(
    Id ldtId,
    DirectEntryFileRecordGenUtil.DetailRecordData recOneDataObj
  ) {
    String entryVal;
    loan__Loan_Disbursal_Transaction__c ldtObj = new loan__Loan_Disbursal_Transaction__c(Id = ldtId);
    if(String.isBlank(recOneDataObj.payerBSBNumber)){
        addToInvalidScope(ldtObj, ConstantValues.WRONG_BSB_PAYER);
    } else if(String.isBlank(recOneDataObj.payerAcctNumber)){
        addToInvalidScope(ldtObj, ConstantValues.WRONG_ACOUNT_NUMBER_PAYER);
    } else if(recOneDataObj.transAmt == null){
        addToInvalidScope(ldtObj, ConstantValues.TRANSACTION_AMT_NOT_FOUND);
    } else if(recOneDataObj.payerAcctName == null){
        addToInvalidScope(ldtObj, ConstantValues.PAYER_ACCOUNT_NAME_MISSING);
    } else if(recOneDataObj.lodgementRef == null){
        addToInvalidScope(ldtObj, ConstantValues.LODGMENT_REFERENCE_MISSING);
    } else if(recOneDataObj.benfBSBNumber == null){
        addToInvalidScope(ldtObj, ConstantValues.WRONG_BSB_PAYEE);
    } else if(recOneDataObj.benfAccNumber == null){
        addToInvalidScope(ldtObj, ConstantValues.WRONG_ACOUNT_NUMBER_PAYEE);
    } else if(recOneDataObj.remitterName == null){
        addToInvalidScope(ldtObj, ConstantValues.WAREHOUSE_INST_MISSING);
    } else{
        recOneDataObj.indicator = ConstantValues.INDICATOR;
        recOneDataObj.transCode = ConstantValues.TXN_CODE_CREDIT;
        recOneDataObj.amtWithholdingTax = 0;
        addToValidScope(ldtObj);
        entryVal = DirectEntryFileRecordGenUtil.getRecordOne(recOneDataObj);
        addEntry(entryVal);
    }
    return entryVal;
  }

  global override List<String> getEntries(
    loan.TransactionSweepToACHState state,
    List<SObject> scope
  ) {
    Map<Id, DirectEntryFileRecordGenUtil.DetailRecordData> detailRecordDataLDTMap = requeryScope(scope);
    List<String> totalRecords = new List<String>();
    try {
      for (Id eachKey : detailRecordDataLDTMap.keySet()) {
        System.debug(detailRecordDataLDTMap.get(eachKey));
        String entryVal = processScope(eachKey, detailRecordDataLDTMap.get(eachKey));
        if (String.isNotBlank(entryVal)) {
          totalRecords.add(entryVal);
        }
      }
    } catch (Exception ex) {
      GenericUtility.insertLog(
        'LoanDisbursalFilegen',
        ex
      );
    }
    return totalRecords;
  }
  
  global override String getHeader(
    loan.TransactionSweepToACHState state,
    List<SObject> scope
  ) {
    String headerVal;
    try {
      loan__Automated_Payment_Configuration__c apc = (loan__Automated_Payment_Configuration__c) state.o1;
      apc = apcMap.get(apc.Id);

      if (apc == null) {
        GenericUtility.insertLog(
          'LoanDisbursalFilegen',
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
      headerVal = DirectEntryFileRecordGenUtil.getDescriptiveRecord(recZeroDataObj);
    } catch (Exception ex) {
      GenericUtility.insertLog('LoanDisbursalFilegen', ex);
    }
    return headerVal;
  }

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
      GenericUtility.insertLog('LoanDisbursalFilegen', ex);
    }
    return trailerVal;
  }
}  