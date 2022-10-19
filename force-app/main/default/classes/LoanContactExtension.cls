/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This controller class search for contact and generate template. 
Development Date : 20/09/2022
Last Modified Date : 27/09/2022
****************************************************************************************************/

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
        coborrowerList = new loan__Coborrower__c();
        objContactlist = new Contact();

    }
    public List<loan__Coborrower__c> getCoborrowerList(){

        List<loan__Coborrower__c> objCoborrowerList=new List<loan__Coborrower__c>();

        if(acct!=null){
            objCoborrowerList=[SELECT id,
                                    loan__Contact__c,
                                    loan__Contact__r.Email,
                                    loan__Account__c,
                                    loan__Account__r.id,
                                    loan__Loan__c,
                                    loan__Loan__r.Id
                                    FROM loan__Coborrower__c 
                                    WHERE loan__Loan__c =: acct.id 
                                    AND loan__Party_Type__c IN ('Borrower','Co-Applicant')
                                    AND loan__Contact__c!=null];
        }
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
            List<loan__Coborrower__c> objCoborrowerList=new List<loan__Coborrower__c>();

            if(acct!=null){
                objCoborrowerList=[SELECT id,
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
            }
            
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
            Map<Id,String> objContactAccountMap=new Map<Id,String>();
            Map<Id,String> objContactAccountRoleMap=new Map<Id,String>();
            if(objAccountIdList!=null){
                List<AccountContactRelation> objAccountContactRelList=[SELECT id,AccountId,ContactId,Contact.Email,Account.Name,Contact.Name,Roles FROM AccountContactRelation WHERE AccountId in:objAccountIdList];
                for(AccountContactRelation objAccountContactRel:objAccountContactRelList){
                    if(objAccountContactRel.AccountId!=null 
                            && objAccountContactRel.ContactId!=null && objAccountContactRel.Contact.Email!=null){
                                objAccIdList.add(objAccountContactRel.AccountId);
                                objCheckEmailIdList.add(objAccountContactRel.ContactId);
                                accountLoanIdMap.put(objAccountContactRel.ContactId,accountLoanIdMap.get(objAccountContactRel.AccountId));
                    }
                    if(objContactAccountMap.containsKey(objAccountContactRel.ContactId) &&
                    objContactAccountMap.get(objAccountContactRel.ContactId)!=null){
                        objContactAccountMap.put(objAccountContactRel.ContactId,
                        objContactAccountMap.get(objAccountContactRel.ContactId) +' & '+objAccountContactRel.Account.Name);
                    }else{
                        objContactAccountMap.put(objAccountContactRel.ContactId,objAccountContactRel.Account.Name);
                    }
                    objContactAccountRoleMap.put(objAccountContactRel.ContactId,objAccountContactRel.Roles);
                    }
            }
            Boolean flag=false;
            Integer count=0;
            List<Contact> objContactList=[SELECT id,
                                                Email 
                                            FROM Contact 
                                            WHERE id =: coborrowerList.loan__Contact__c];
            for(Id objContactId:objCheckEmailIdList){
                if(coborrowerList.loan__Contact__c==objContactId && objContactList.size()>0 
                        && objContactList[0].Email!=null && acct!=null){
                    count=0;
                    acct.Selected_Contact_to_Send_Emails__c=objContactList[0].id;
                    break;
                }else{
                    count+=1;
                }
            }
            if(count!=0){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error, ConstantValues.CORRECT_CONTACT));
                return null;
            }
            List<loan__Coborrower__c> objCoborrowerList2=[SELECT id,
                                                                    loan__Contact__c,
                                                                    loan__Account__c,
                                                                    loan__Contact__r.id,
                                                                    loan__Contact__r.Name,
                                                                    loan__Account__r.id,
                                                                    Customer_Capacity__c,
                                                                    loan__Account__r.PersonMobilePhone
                                                                    FROM loan__Coborrower__c
                                                                    WHERE  loan__Party_Type__c !=: ConstantValues.BROKER_PARTY_TYPE
                                                                    AND loan__Loan__c =: acct.id
                                                                    AND loan__Contact__c!=null];

            for(loan__Coborrower__c objCoborrower:objCoborrowerList2){
                if(objContactAccountMap.containsKey(objCoborrower.loan__Contact__r.id) &&
                objContactAccountMap.get(objCoborrower.loan__Contact__r.id) !=null &&
                objContactAccountRoleMap.containsKey(objCoborrower.loan__Contact__r.id) &&
                objContactAccountRoleMap.get(objCoborrower.loan__Contact__r.id) !=null){
                    objCoborrower.Customer_Capacity__c='\n'+'In capacity as '+objContactAccountRoleMap.get(objCoborrower.loan__Contact__r.id)+' for '+objContactAccountMap.get(objCoborrower.loan__Contact__r.id);
                }
            }
            if(objCoborrowerList2.size()>0){
                update objCoborrowerList2;
            }
            if(acct!=null){
                Database.update(acct,false);
            }
            WebLink statementLink = [SELECT Id, 
                                            Name, Url 
                                        FROM WebLink 
                                        WHERE Name =: ConstantValues.DISHONOUR_NOTICE
                                        LIMIT 1];
            String statementURL;
            if(statementLink!=null){
                statementURL = statementLink.Url;
                if(acct.Application__c != null){
                    statementURL = statementURL.replace(ConstantValues.LOAN_aCCOUNT_APPLICATION,acct.Application__c);
                }
                if(acct.id!= null){
                    statementURL = statementURL.replace(ConstantValues.LOAN_LOAN_ACCOUNT_ID,acct.id);
                }
                
                if(acct.Name != null){
                    statementURL = statementURL.replace(ConstantValues.LOAN_ACCOUN_NAME,acct.Name);
                }
                if(objContactList.size()>0){
                    statementURL = statementURL.replace(ConstantValues.LOAN_ACCOUNT_CONTACT,objContactList[0].id);
                }
            }
            PageReference retURLPDF = new PageReference(statementURL);
            return retURLPDF;
        }catch(Exception exe){
            GenericUtility.insertLog('LoanContactExtension', exe);
            return null;
        }
    }
    //Cancel button in VF page.
    public PageReference Cancel() {
        return new Pagereference('/'+ApexPages.currentPage().getParameters().get(ConstantValues.LOAN_ACCOUNT_ID)); 
    }
}