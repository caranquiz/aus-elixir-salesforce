/**
 * Created by Ethan Sargent on 5/08/2021.
 */

trigger ContentVersionTrigger on ContentVersion (after insert)
{
    // link contentVersions to loan account specified in Loan_Account_fileupload__c
    // workaround for sharing rules
    List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();

    List<Redraw_Request__c> redrawRequestsForInsert = new List<Redraw_Request__c>();
    Map<Id, List<Redraw_Request__c>> redrawRequestsByIds = new Map<Id, List<Redraw_Request__c>>();
    for (ContentVersion version : Trigger.new)
    {
        String loanAccountId = version.Loan_Account_fileupload__c;
        if (String.isNotBlank(loanAccountId))
        {
            List<Redraw_Request__c> redrawRequests = redrawRequestsByIds.get(loanAccountId);
            if (redrawRequests == null)
            {
                redrawRequests = new List<Redraw_Request__c>();
                redrawRequestsByIds.put(loanAccountId, redrawRequests);
            }
            Redraw_Request__c redrawRequest = new Redraw_Request__c();
            redrawRequest.CL_Contract__c = loanAccountId;
            redrawRequests.add(redrawRequest);
            redrawRequestsForInsert.add(redrawRequest);
        }
    }
    insert redrawRequestsForInsert;
    for (ContentVersion version : Trigger.new)
    {
        if (String.isNotBlank(version.Loan_Account_fileupload__c))
        {

            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = version.Loan_Account_fileupload__c;
            cdl.ShareType = 'V';
            cdl.ContentDocumentId = version.ContentDocumentId;
            contentDocumentLinks.add(cdl);
            List<Redraw_Request__c> redrawRequests = redrawRequestsByIds.get(version.Loan_Account_fileupload__c);
            for (Redraw_Request__c redrawRequest : redrawRequests)
            {
                cdl = new ContentDocumentLink();
                cdl.LinkedEntityId = redrawRequest.Id;
                cdl.ShareType = 'V';
                cdl.ContentDocumentId = version.ContentDocumentId;
                contentDocumentLinks.add(cdl);
            }
        }
    }

    Database.insert(contentDocumentLinks, false);
}