/****************************************************************************************************/
/* Description          : This class is called from the Upload Return VF page controller. This class
is used to process return files from the bank then reverse the respective LPTs and handle the
exceptions while reversing (if any). */
/****************************************************************************************************/

public without sharing class LoanPaymentReturnFileHandler {
    private class RecordDetails {
      String returnCause;
      Integer returnCode;
      String queryString;
      Decimal amount;
      String accountNumber;
      String accountName;
    }
    class BankExcepDetails {
      loan__Loan_Payment_Transaction__c lptObj;
      String message;
      Boolean handled;
    }
    private List<RecordDetails> recDetailsList;
    private Map<String, RecordDetails> lptVsRecordDetails;
    private List<String> refLPTNameList;
    private Integer totalRecCount;
    private Date returnDate;
    // CURRENT DATE
    private Date currentDate;
    // Bank Statement Exception List
    private List<peer__Bank_Recon_Exception__c> bseList;
    // Map of LPTs with its Name
    private Map<String, loan__Loan_Payment_Transaction__c> lptMap;
    // Map<Id, loan__Loan_Account__c> clContractMap;
  
    public LoanPaymentReturnFileHandler() {
      try {
        refLPTNameList = new List<String>();
        // clContractMap = new Map<Id, loan__Loan_Account__c>(
        //   [
        //     SELECT Id, Name, loan__Last_Transaction_Id__c
        //     FROM loan__Loan_Account__c
        //   ]
        // );
        bseList = new List<peer__Bank_Recon_Exception__c>();
        currentDate = (!Test.isRunningTest()
          ? (new loan.GlobalLoanUtilFacade()).getCurrentSystemDate()
          : Date.Today());
        recDetailsList = new List<RecordDetails>();
        lptVsRecordDetails = new Map<String, RecordDetails>();
      } catch (Exception ex) {
        throw new CustomException(
          ConstantValues.INIT_ERROR +
          ' at Line : ' +
          ex.getLineNumber() +
          ', due to : ' +
          ex.getMessage()
        );
      }
    }
    // METHOD FOR PROCESSING HEADER
    private void processHeader(String headRec) {
      try {
        String val;
        //  (01) Record Type
        DirectEntryFileRecordGenUtil.checkNumeric(
          headRec.subString(0, 1),
          ConstantValues.HEADER_PROCESS_EXCEP
        );
        //  (17) Blank
        DirectEntryFileRecordGenUtil.checkBlank(
          headRec.subString(1, 18),
          ConstantValues.HEADER_PROCESS_EXCEP
        );
        //  (02) Reel Sequence Number '01'
        DirectEntryFileRecordGenUtil.checkNumeric(
          headRec.subString(18, 20),
          ConstantValues.HEADER_PROCESS_EXCEP
        );
        //  (03) Mnemonic of Financial Institution
        val = headRec.subString(20, 23);
        if (!val.isAlpha()) {
          throw new CustomException(ConstantValues.HEADER_PROCESS_EXCEP);
        }
        //  (07) Blank
        DirectEntryFileRecordGenUtil.checkBlank(
          headRec.subString(23, 30),
          ConstantValues.HEADER_PROCESS_EXCEP
        );
        //  (26) Mnemonic of Sending Member 'NAB'
        val = headRec.subString(30, 56);
        //  (06) DE User Id
        DirectEntryFileRecordGenUtil.checkNumeric(
          headRec.subString(56, 62),
          ConstantValues.HEADER_PROCESS_EXCEP
        );
        //  (12) Description or Blank 'DE Returns'
        val = headRec.subString(62, 74);
        //  (06) Date of Return
        val = headRec.subString(74, 80);
        if (val.contains(' ')) {
          throw new CustomException(ConstantValues.HEADER_PROCESS_EXCEP);
        }
        DirectEntryFileRecordGenUtil.checkNumeric(
          val,
          ConstantValues.HEADER_PROCESS_EXCEP
        );
        Date dt = System.Today();
        Integer century = (dt.year() / 100) * 100;
        returnDate = Date.newInstance(
          century + Integer.valueOf(val.subString(4, 6)),
          Integer.valueOf(val.subString(2, 4)),
          Integer.valueOf(val.subString(0, 2))
        );
        //  (40) Blank
      } catch (Exception ex) {
        throw new CustomException(ConstantValues.HEADER_PROCESS_EXCEP);
      }
    }
    public static String getReturnCause(Integer returnCode) {
      String returnCause;
      switch on
        returnCode {
        when 1 {
          returnCause = ConstantValues.RET_CAUSE_1;
        }
        when 2 {
          returnCause = ConstantValues.RET_CAUSE_2;
        }
        when 3 {
          returnCause = ConstantValues.RET_CAUSE_3;
        }
        when 4 {
          returnCause = ConstantValues.RET_CAUSE_4;
        }
        when 5 {
          returnCause = ConstantValues.RET_CAUSE_5;
        }
        when 6 {
          returnCause = ConstantValues.RET_CAUSE_6;
        }
        when 7 {
          returnCause = ConstantValues.RET_CAUSE_7;
        }
        when 8 {
          returnCause = ConstantValues.RET_CAUSE_8;
        }
        when 9 {
          returnCause = ConstantValues.RET_CAUSE_9;
        }
        when else {
          returnCause = ConstantValues.RET_CAUSE_DEFAULT;
        }
      }
      return returnCause;
    }
    // METHOD FOR PROCESSING DETAILS
    private void processDetails(String detailRec) {
      try {
        String val;
        //  (01) Record Type
        DirectEntryFileRecordGenUtil.checkNumeric(
          detailRec.subString(0, 1),
          ConstantValues.DETAILS_PROCESS_EXCEP
        );
        RecordDetails recObj = new RecordDetails();
        //  (07) BSB Number
        String bsbNumber;
        bsbNumber = detailRec.subString(1, 8);
        String ref = bsbNumber.subString(0, 3) + bsbNumber.subString(4, 7);
        DirectEntryFileRecordGenUtil.checkNumeric(
          ref,
          ConstantValues.DETAILS_PROCESS_EXCEP
        );
        //  (09) Credit/ Debit Account Number
        String acctNumber;
        acctNumber = detailRec.subString(8, 17);
        recObj.accountNumber = acctNumber.trim();
        //  (01) Return Code
        String returnCause;
        String returnCode;
        DirectEntryFileRecordGenUtil.checkNumeric(
          detailRec.subString(17, 18),
          ConstantValues.DETAILS_PROCESS_EXCEP
        );
        returnCode = detailRec.subString(17, 18);
        recObj.returnCause = getReturnCause(Integer.valueOf(returnCode));
        recObj.returnCode = Integer.valueOf(returnCode);
        //  (02) Transaction Code
        String transCode;
        transCode = detailRec.subString(18, 20);
        DirectEntryFileRecordGenUtil.checkNumeric(
          detailRec.subString(18, 20),
          ConstantValues.DETAILS_PROCESS_EXCEP
        );
        //  (10) Amount
        DirectEntryFileRecordGenUtil.checkNumeric(
          detailRec.subString(20, 30),
          ConstantValues.DETAILS_PROCESS_EXCEP
        );
        Decimal amt = Decimal.valueof(detailRec.subString(20, 30));
        amt = amt / 100;
        recObj.amount = amt;
        //  (32) Account Name
        String acctName;
        acctName = detailRec.subString(30, 62);
        recObj.accountName = acctName;
        //  (18) Lodgement Reference
        String lodgementRef;
        lodgementRef = detailRec.subString(62, 80).trim();
        recObj.queryString = lodgementRef;
        refLPTNameList.add(lodgementRef);
        //  (07) Trace BSB Number
        val = detailRec.subString(80, 87).trim();
        ref = val.subString(0, 3) + val.subString(4, 7);
        DirectEntryFileRecordGenUtil.checkNumeric(
          ref,
          ConstantValues.DETAILS_PROCESS_EXCEP
        );
        recDetailsList.add(recObj);
        lptVsRecordDetails.put(recObj.queryString, recObj);
      } catch (Exception ex) {
        throw new CustomException(ConstantValues.DETAILS_PROCESS_EXCEP);
      }
    }
    // METHOD FOR PROCESSING TRAILER
    private void processTrailer(String trailRec) {
      try {
        String val;
        //  (01) Record Type
        val = trailRec.subString(0, 1);
        DirectEntryFileRecordGenUtil.checkNumeric(
          val,
          ConstantValues.TRAILER_PROCESS_EXCEP
        );
        //  (07) BSB Code '999-999'
        val = trailRec.subString(1, 8);
        String ref = val.subString(0, 3) + val.subString(4, 7);
        DirectEntryFileRecordGenUtil.checkNumeric(
          ref,
          ConstantValues.TRAILER_PROCESS_EXCEP
        );
        //  (12) Blank
        DirectEntryFileRecordGenUtil.checkBlank(
          trailRec.subString(8, 20),
          ConstantValues.TRAILER_PROCESS_EXCEP
        );
        //  (10) Total file Net Amount
        DirectEntryFileRecordGenUtil.checkNumeric(
          trailRec.subString(20, 30),
          ConstantValues.TRAILER_PROCESS_EXCEP
        );
        //  (10) Total file Credit Amount
        DirectEntryFileRecordGenUtil.checkNumeric(
          trailRec.subString(30, 40),
          ConstantValues.TRAILER_PROCESS_EXCEP
        );
        //  (10) Total file Debit Amount
        DirectEntryFileRecordGenUtil.checkNumeric(
          trailRec.subString(40, 50),
          ConstantValues.TRAILER_PROCESS_EXCEP
        );
        //  (24) Blank
        DirectEntryFileRecordGenUtil.checkBlank(
          trailRec.subString(50, 74),
          ConstantValues.TRAILER_PROCESS_EXCEP
        );
        //  (06) Total Record Count
        DirectEntryFileRecordGenUtil.checkNumeric(
          trailRec.subString(74, 80),
          ConstantValues.TRAILER_PROCESS_EXCEP
        );
        totalRecCount = Integer.valueof(trailRec.subString(74, 80).trim());
      } catch (Exception ex) {
        throw new CustomException(ConstantValues.TRAILER_PROCESS_EXCEP);
      }
    }
  
    private void processLpts() {
      try {
        List<loan__Repayment_Transaction_Adjustment__c> txnRevList = new List<loan__Repayment_Transaction_Adjustment__c>();
        if (recDetailsList == null || recDetailsList.isEmpty()) {
          throw new CustomException(ConstantValues.NO_RECORDS);
        }
        for (RecordDetails each : recDetailsList) {
          loan__Loan_Payment_Transaction__c lptObj = lptMap.get(each.queryString);
          if (lptObj == null) {
            // TXN NOT FOUND
            BankExcepDetails beDetail = new BankExcepDetails();
            beDetail.lptObj = null;
            beDetail.message = ConstantValues.TXN_NOT_FOUND;
            beDetail.handled = false;
            peer__Bank_Recon_Exception__c bseObj = handleBankException(
              each,
              beDetail
            );
            bseList.add(bseObj);
            continue;
          }
          String lastTxnId = lptObj.loan__Loan_Account__r.loan__Last_Transaction_Id__c;
          if (lptObj.loan__Reversed__c) {
            BankExcepDetails beDetail = new BankExcepDetails();
            beDetail.lptObj = lptObj;
            beDetail.message = ConstantValues.ALREADY_REV;
            beDetail.handled = true;
            peer__Bank_Recon_Exception__c bseObj = handleBankException(
              each,
              beDetail
            );
            bseList.add(bseObj);
          } else if (lastTxnId != (String) lptObj.Id) {
            String msg =
              ConstantValues.TXN_REV_ERR + lptObj.loan__Loan_Account__r.Name;
            BankExcepDetails beDetail = new BankExcepDetails();
            beDetail.lptObj = lptObj;
            beDetail.message = msg;
            beDetail.handled = false;
            peer__Bank_Recon_Exception__c bseObj = handleBankException(
              each,
              beDetail
            );
            bseList.add(bseObj);
          } else {
            loan__Repayment_Transaction_Adjustment__c txnRev = generateRepaymentTxnReversalFor(
              lptObj
            );
            if (txnRev != null) {
              txnRevList.add(txnRev);
            }
          }
        }
        Database.insert(txnRevList, true);
      } catch (Exception ex) {
        throw new CustomException(ConstantValues.VF_GEN_ERR);
      }
    }
    // This method creates a reversal record for the specified Loan Payment Transaction
    private loan__Repayment_Transaction_Adjustment__c generateRepaymentTxnReversalFor(
      loan__Loan_Payment_Transaction__c lpt
    ) {
      if (lpt == null) {
        return null;
      }
      loan__Repayment_Transaction_Adjustment__c rtaObj;
      try {
        RecordDetails recObj = lptVsRecordDetails.get((String) lpt.Name);
        rtaObj = new loan__Repayment_Transaction_Adjustment__c(
          loan__Loan_Payment_Transaction__c = lpt.Id,
          loan__Adjustment_Txn_Date__c = returnDate,
          loan__Refund_to_Borrower__c = false,
          loan__Reason_Code__c = 'Other',
          loan__Reference__c = recObj.returnCause,
          Return_Code__c = recObj.returnCode
        );
      } catch (Exception ex) {
        throw new CustomException(ConstantValues.VF_GEN_ERR);
      }
      return rtaObj;
    }
    // THIS METHOD IS FOR HANDLING THE BANK FILE EXCEPTION
    private peer__Bank_Recon_Exception__c handleBankException(
      RecordDetails recObj,
      BankExcepDetails beDetail
    ) {
      peer__Bank_Recon_Exception__c bseObj = new peer__Bank_Recon_Exception__c(
        peer__Reason__c = 'EXCEPTION',
        peer__Recon_Message__c = beDetail.message,
        peer__Statement_Date__c = currentDate,
        peer__Transaction_Handled__c = beDetail.handled,
        peer__Transaction_Type__c = 'DEBIT'
      );
      if (recObj != null) {
        bseObj.peer__Account_Number__c = recObj.accountNumber;
        bseObj.peer__Name__c = recObj.accountName;
        bseObj.peer__Reference_Number__c = (String) recObj.queryString;
        bseObj.peer__Transaction_Amount__c = recObj.amount;
        bseObj.peer__Transaction_Date__c = beDetail.lptObj.loan__Transaction_Date__c;
      }
      return bseObj;
    }
    public List<peer__Bank_Recon_Exception__c> parse(String doc) {
      try {
        if(String.isBlank(doc)){
          throw new CustomException(ConstantValues.PARSED_DOCUMENT_NULL);
        }
        List<String> records = doc.split('\n');
        for (String each : records) {
          if (each.length() > 120) {
            throw new CustomException(ConstantValues.PROCESS_ERROR);
          }
          switch on each.subString(0, 1) {
            when '0' {
              processHeader(each);
            }
            when '1' {
              processDetails(each);
            }
            when '7' {
              processTrailer(each);
            }
            // Any other value means file is wrong
            when else {
              throw new CustomException(ConstantValues.PROCESS_ERROR);
            }
          }
        }
        List<loan__Loan_Payment_Transaction__c> lptList = new List<loan__Loan_Payment_Transaction__c>(
          [
            SELECT
              Id,
              Name,
              loan__Loan_Account__c,
              loan__Loan_Account__r.Name,
              loan__Reversed__c,
              loan__Loan_Account__r.loan__Borrower_ACH__c,
              loan__Loan_Account__r.loan__Last_Transaction_Id__c,
              loan__Transaction_Date__c,
              loan__Transaction_Time__c
            FROM loan__Loan_Payment_Transaction__c WHERE Name IN :refLPTNameList
          ]
        );
        // Map of LPTs with its Name (Reference) and TXN time
        lptMap = new Map<String, loan__Loan_Payment_Transaction__c>();
        for (loan__Loan_Payment_Transaction__c each : lptList) {
          lptMap.put(each.Name, each);
        }
        processLpts();
        if (bseList != null && bseList.size() != 0) {
          Database.insert(bseList, true);
        }
        return bseList;
      } catch (Exception ex) {
        throw new CustomException(ConstantValues.PARSE_EXCEP_MSG);
      }
    }
  }
  