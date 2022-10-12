public with sharing class LoanContactExtension {
    public loan__Loan_Account__c acct {get;set;}
    public loan__Coborrower__c coborrowerList { get; set; }
    public Contact objContactlist { get; set; }
    
    public LoanContactExtension(ApexPages.StandardController stdController){
        acct = [SELECT id,
                      Name,
                      Application__c,
                      Selected_Contact_to_Send_Emails__c
                  FROM loan__Loan_Account__c 
                  WHERE id = :ApexPages.currentPage().getParameters().get(ConstantValues.LOAN_ACCOUNT_ID)];
        //loan = new loan__Loan_Account__c();
        coborrowerList = new loan__Coborrower__c();
        objContactlist = new Contact();

    }
    public List<loan__Coborrower__c> getCoborrowerList(){
        List<loan__Coborrower__c> objCoborrowerList=[SELECT id,
                                                    loan__Contact__c,
                                                    loan__Contact__r.Email,
                                                    loan__Account__c,
                                                    loan__Account__r.id,
                                                    loan__Loan__c,
                                                    loan__Loan__r.Id
                                                    FROM loan__Coborrower__c 
                                                    WHERE loan__Loan__c =: acct.id 
                                                    AND loan__Party_Type__c IN ('Borrower','Co-Applicant','Director','Trustee')
                                                    AND loan__Contact__c!=null];
        List<Id> contactId=new List<Id>();
        for(loan__Coborrower__c objCoborrower:objCoborrowerList){
            contactId.add(objCoborrower.loan__Contact__c);
        }
        objContactlist=[Select id,Name FROM Contact WHERE id in:contactId];
        return objCoborrowerList;
    }
      //This method Save or Insert the Linked Loan 
    public PageReference Save() {
     try {
        List<loan__Coborrower__c> objCoborrowerList=[SELECT id,
                                                    loan__Contact__c,
                                                    loan__Contact__r.id,
                                                    loan__Contact__r.Email,
                                                    loan__Account__c,
                                                    loan__Account__r.id,
                                                    loan__Loan__c,
                                                    loan__Loan__r.Id
                                                    FROM loan__Coborrower__c 
                                                    WHERE loan__Loan__c =: acct.id
                                                    AND loan__Party_Type__c IN ('Borrower','Co-Applicant','Director','Trustee')];

        List<Id> objAccountIdList=new List<Id>();
        List<Id> objAccIdList=new List<Id>();
        List<Id> objCheckEmailIdList=new List<Id>();
        Map<Id,Id> accountLoanIdMap=new Map<Id,Id>();
        
        for(loan__Coborrower__c objCoborrower:objCoborrowerList){
            if(objCoborrower.loan__Account__c!=null && objCoborrower.loan__Contact__c==null){
                objAccountIdList.add(objCoborrower.loan__Account__r.id);
                accountLoanIdMap.put(objCoborrower.loan__Account__r.Id,objCoborrower.loan__Loan__r.Id);
            }
            if(objCoborrower.loan__Account__c!=null && objCoborrower.loan__Contact__c!=null 
                    && (objCoborrower.loan__Contact__r.Email!=null || !String.isBlank(objCoborrower.loan__Contact__r.Email))){
                objCheckEmailIdList.add(objCoborrower.loan__Contact__r.Id);
                accountLoanIdMap.put(objCoborrower.loan__Contact__r.Id,objCoborrower.loan__Loan__r.Id);
            }
        }
        if(objAccountIdList!=null){
            List<AccountContactRelation> objAccountContactRelList=[SELECT id,AccountId,ContactId,Contact.Email FROM AccountContactRelation WHERE AccountId in:objAccountIdList];
            for(AccountContactRelation objAccountContactRel:objAccountContactRelList){
                if(objAccountContactRel.AccountId!=null 
                        && objAccountContactRel.ContactId!=null && objAccountContactRel.Contact.Email!=null){
                            objAccIdList.add(objAccountContactRel.AccountId);
                            objCheckEmailIdList.add(objAccountContactRel.ContactId);
                            accountLoanIdMap.put(objAccountContactRel.ContactId,accountLoanIdMap.get(objAccountContactRel.AccountId));
                }
            }
        }
        Boolean flag=false;
        Integer count=0;
        List<Contact> objContactList=[SELECT id,Email FROM Contact WHERE id =: coborrowerList.loan__Contact__c];
        for(Id objContactId:objCheckEmailIdList){
             if(coborrowerList.loan__Contact__c==objContactId && objContactList[0].Email!=null){
                 count=0;
                 acct.Selected_Contact_to_Send_Emails__c=objContactList[0].id;
                 break;
             }else{
                 count+=1;
             }
         }
         if(count!=0){
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error, 'Select Correct Contact'));
                return null;
         }
         update acct;
          WebLink statementLink = [SELECT Id, 
                                        Name, Url 
                                    FROM WebLink 
                                    WHERE Name = 'Dishonour_Notice'
                                    LIMIT 1];
            String statementURL = statementLink.Url;
            if(acct.Application__c != null){
                statementURL = statementURL.replace('{!loan__Loan_Account__c.ApplicationId__c}',acct.Application__c);
            }
            if(acct.id!= null){
                statementURL = statementURL.replace('{!loan__Loan_Account__c.Id}',acct.id);
            }
            
            if(acct.Name != null){
                statementURL = statementURL.replace('{!loan__Loan_Account__c.Name}',acct.Name);
            }
            if(objContactList.size()>0){
                statementURL = statementURL.replace('{!loan__Loan_Account__c.loan__ContactId__c }',objContactList[0].id);
            }
            PageReference retURLPDF = new PageReference(statementURL);
            
            return retURLPDF;
        // return new Pagereference('/'+ApexPages.currentPage().getParameters().get(ConstantValues.LOAN_ACCOUNT_ID));
         }catch(Exception exe){
            insert new clcommon__Log__c(
                clcommon__Message__c = 'LoanContactExtension :Exception: '+exe.getStackTraceString()+'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Time__c = System.Now());
            return null;
        }
    }
    //Cancel button in VF page.
    public PageReference Cancel() {
        return new Pagereference('/'+ApexPages.currentPage().getParameters().get(ConstantValues.LOAN_ACCOUNT_ID)); 
    }
}