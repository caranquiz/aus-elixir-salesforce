/**
 * Created by Ethan Sargent on 1/07/2021.
 */

public without sharing class CloudLendingArgoDebug
{
    @AuraEnabled(Cacheable=true)
    public static List<loan__Loan_Account__c> getData()
    {
        User u = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        List<loan__Loan_Account__c> loanAccounts = [
                SELECT Id,
                        Name,
                        loan__Contingency_Status_Code__c,
                        loan__Credit_Limit__c,
                        loan__Deposit_Interest_Accrued__c
                FROM loan__Loan_Account__c
                WHERE loan__Contact__c = :u.ContactId
        ];

        return loanAccounts;
    }
}