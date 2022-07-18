/**
 * Created by caleb on 10/06/2022.
 */

trigger LoanAccountTrigger2 on loan__Loan_Account__c (after update)
{
    List<Id> loanAccountIds = new List<Id>();
    for (loan__Loan_Account__c la : Trigger.new)
    {
        if (la.New_Interest_Rate__c != null
            && la.New_Interest_Rate_Effective_Date__c != null
            && la.First_Repayment_Date_After_IR_Change__c != null
            && la.Second_Repayment_Date_After_IR_Change__c != null
            && la.Calculated_Upcoming_Repayment_Amount__c != null
            && (
                Trigger.oldMap.get(la.Id).New_Interest_Rate__c == null
                || Trigger.oldMap.get(la.Id).New_Interest_Rate_Effective_Date__c == null
                || Trigger.oldMap.get(la.Id).First_Repayment_Date_After_IR_Change__c == null
                || Trigger.oldMap.get(la.Id).Second_Repayment_Date_After_IR_Change__c == null
                || Trigger.oldMap.get(la.Id).Calculated_Upcoming_Repayment_Amount__c == null
            )
        )
        {
            loanAccountIds.add(la.Id);
        }
    }
    if (loanAccountIds.size() > 0)
    {
        SendInterestRateChangeEmailsQueueble q = new SendInterestRateChangeEmailsQueueble();
        q.minimumIdExclusive = null;
        q.loanAccountsUpdateToMeatCriteria = loanAccountIds;
        System.enqueueJob(q);
    }

}