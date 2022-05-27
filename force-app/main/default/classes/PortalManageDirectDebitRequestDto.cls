/**
 * Created by Ethan Sargent on 11/08/2021.
 */

public with sharing class PortalManageDirectDebitRequestDto
{

        @AuraEnabled
        public String   recordId {get; set;}
        @AuraEnabled
        public String   loanAccountId {get; set;}
        @AuraEnabled
        public Boolean  isDelete {get; set;}
        @AuraEnabled
        public String   directDebitType {get; set;}
        @AuraEnabled
        public String   amountType {get; set;}
        @AuraEnabled
        public Date     debitDate {get; set;}
        @AuraEnabled
        public Decimal  transactionAmount {get; set;}
        @AuraEnabled
        public String   frequency {get; set;}

}