/****************************************************************************************************
Description:    This Class used for Send Email on Borrower ACH Change Field change
Developer:      Sayak Mukhopadhyay
Created Date:   28/03/2022
*****************************************************************************************************/


global class BorrowerACHApprovalEmail{
    @InvocableMethod (label = 'Borrower ACH Approval Email' 
                        description = 'Approval request email'
                        category = 'CL Contract')
    public static void sendEmail(List<Id>contractId){
        try{
            List<loan__Loan_Account__c>contract = [SELECT id,Name,
                                            LastModifiedBy.Email
                                            FROM loan__Loan_Account__c
                                            WHERE id in :contractId];
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>();
            for(loan__Loan_Account__c a:contract){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                String addressOne = system.Label.Rosie_Johnston_Email;
                String addressTwo = system.Label.Peter_Polemikos_Email;
                message.toAddresses = new String[] {addressOne,addressTwo};
                message.optOutPolicy = 'FILTER';
                message.subject = 'Approval Request for Borrower ACH Change for ' + a.Name;
                message.plainTextBody = 'Hi,\n\nA Borrower ACH change has been submitted for  '+a.Name+' and requires your approval.\n\nKind Regards,';
                messages.add(message);
            }
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (!results[0].success) {
                GenericUtility.insertLog('BorrowerACHApprovalEmail','Mail not sent');
            }
        }catch(Exception e){
            GenericUtility.insertLog('BorrowerACHApprovalEmail',e);
        }
    }
}