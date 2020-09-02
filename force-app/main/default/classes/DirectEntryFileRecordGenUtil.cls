public class DirectEntryFileRecordGenUtil{
    public class DescriptiveRecordData {
        public String financialInstitutionName;
        public String username;
        public String userId;
        public String description;
    }
    public class RecordSevenData {
        public Long sumOfAmt;
        public Integer entryCount;
    }
    public class DetailRecordData {
        public String payerBSBNumber;
        public String payerAcctNumber;
        public String indicator;
        public Integer transCode;
        public Long transAmt;
        public String payerAcctName;
        public String lodgementRef;
        public String benfBSBNumber;
        public String benfAccNumber;
        public String remitterName;
        public Long amtWithholdingTax;
    }
    private static String currentDate = ((DateTime) (!Test.isRunningTest()
    ? (new loan.GlobalLoanUtilFacade()).getCurrentSystemDate() : Date.Today())).format('ddMMyy');

    // Generates Descriptive Record
    public static String getDescriptiveRecord(DescriptiveRecordData descriptiveRecordDataObj) {
        String headerVal = '';
        //  (01) Record Type |M|
        headerVal += ConstantValues.FILEGEN_HEAD_RECORD_TYPE;
        //  BLANK 17 |MBF|
        headerVal += ' '.repeat(17);
        //  (02) Reel Sequence Number |M| //  Right Justified |MZF|
        headerVal += ConstantValues.REEL_SEQ_NUMBER;
        //  (03) Name of User Financial Institiute (Abbreviation) eg. NAB |M|
        headerVal += descriptiveRecordDataObj.financialInstitutionName;
        //  BLANK 7 |MBF|
        headerVal += ' '.repeat(7);
        //  (26) Name of User supplying file |M| //  LEFT Justified |MBF|
        headerVal += descriptiveRecordDataObj.username.rightPad(26);
        //  (06) Number of User supplying file |M| //  RIGHT Justified |MZF|
        headerVal += descriptiveRecordDataObj.userId.leftPad(6, '0');
        //  (12) Description of entries on file //  LEFT Justified |MBF|
        if(descriptiveRecordDataObj.description == null){
        headerVal += ''.rightPad(12);
        }
        else{
        headerVal += descriptiveRecordDataObj.description.rightPad(12);
        }
        //  (06) Date to be processed (Current Date) |MZF|
        headerVal += currentDate;
        //  BLANK 40 |MBF|
        headerVal += ' '.repeat(40);
        headerVal += '\r\n';
        return headerVal;
    }
    // Generates File Total Record
    public static String getRecordSeven(RecordSevenData recSevenDataObj) {
        String trailerVal = '';
        //  (01) Record Type |M|
        trailerVal += ConstantValues.FILEGEN_TRAIL_RECORD_TYPE;
        //  (07) BSB Number |M|
        trailerVal += ConstantValues.TRAIL_BSB_NUM;
        //  BLANK 12 |MBF|
        trailerVal += ' '.repeat(12);
        //  (10) Net Total Amount in cents (Should be all zeros in a self balanced file) |M| //  RIGHT Justified |MZF|
        trailerVal += String.valueOf(0).leftPad(10, '0');
        //  (10) Total Credit Amount in cents |M| //  RIGHT Justified |MZF|
        trailerVal += String.valueOf(recSevenDataObj.sumOfAmt).leftPad(10, '0');
        //  (10) Total Debit Amount in cents |M| //  RIGHT Justified |MZF|
        trailerVal += String.valueOf(recSevenDataObj.sumOfAmt).leftPad(10, '0');
        //  BLANK 24 |MBF|
        trailerVal += ' '.repeat(24);
        //  (06) Count of Record Type 1 |M| //  RIGHT Justified |MZF|
        trailerVal += String.valueOf(recSevenDataObj.entryCount).leftPad(6, '0');
        //  BLANK 40 |MBF|
        trailerVal += ' '.repeat(40);
        return trailerVal;
    }
    // Generates Detail Record
    public static String getRecordOne(DetailRecordData detailRecordDataObject) {
        String entryVal = '';
        //  (01) Record Type |M|
        entryVal += ConstantValues.FILEGEN_ENTRY_RECORD_TYPE;
        //  (07) BSB Number |M|
        String payerBSBNumber =
            detailRecordDataObject.payerBSBNumber.substring(0, 3) +
            '-' +
            detailRecordDataObject.payerBSBNumber.substring(3, 6);
        entryVal += payerBSBNumber;
        //  (09) Account Number to be credited/ debited |M|
        entryVal += detailRecordDataObject.payerAcctNumber.leftPad(9);
        //  (01) Indicator |M|
        entryVal += ConstantValues.INDICATOR;
        //  (02) Transaction Code |M|
        entryVal += String.valueof(detailRecordDataObject.transCode);
        //  (10) Amount in cents |M|
        entryVal += String.valueof(detailRecordDataObject.transAmt).leftPad(10, '0');
        //  (32) Title of Account to be credited/ debited |M|
        entryVal += detailRecordDataObject.payerAcctName.rightPad(32);
        //  (18) Lodgement Reference
        entryVal += detailRecordDataObject.lodgementRef.rightPad(18);
        //  (07) Trace BSB Number |M|
        String benfBSBNumber =
            detailRecordDataObject.benfBSBNumber.substring(0, 3) +
            '-' +
            detailRecordDataObject.benfBSBNumber.substring(3, 6);
        entryVal += benfBSBNumber;
        //  (09) Trace Account Number |M|
        entryVal += detailRecordDataObject.benfAccNumber.leftPad(9, '0');
        //  (16) Name of Remitter
        entryVal += detailRecordDataObject.remitterName.rightPad(16);
        //  (08) Amount of withholding Tax
        String tempAmt = String.valueOf(detailRecordDataObject.amtWithholdingTax);
        entryVal += tempAmt.leftPad(8, '0');
        entryVal += '\r\n';
        return entryVal;
    }
}