/****************************************************************************************************
Description:    This Class is the Handler Class for CollectionEmailBatch & CollectionSMS Batch
Developer:      Sayak Mukhopadhyay
Created Date:   19/09/2022
*****************************************************************************************************/
public class CollectionBatchHandler {
    public static Map<Id,Boolean> sendEmail(Map<String,List<Id> > contractAccountMap, Map<Id,String> accountIdEmailMap,Map<Id,Id> accountContactMap){
        Map<Id,Boolean> accountMailDeliveryMap = new Map<Id,Boolean>();
        try{
            if(contractAccountMap == null || accountIdEmailMap == null || accountContactMap == null){
                return accountMailDeliveryMap;
            }
            Integer c = 1;
            List<String> partyTypeList = new String[]{ConstantValues.BORROWER,ConstantValues.CO_APPLICANT}; // Custom level;
            for(Id key : accountIdEmailMap.keySet()){
                accountMailDeliveryMap.put(key,false);
            }
            Id templateId;
            String fromEmailAddressId;
            List<EmailTemplate> emailTemplateList = [SELECT id, 
                                                        Subject, 
                                                        Body 
                                                        FROM 
                                                        EmailTemplate 
                                                        WHERE Name =: ConstantValues.DISHONOUR_EMAIL_TEMPLATE];
            if(!emailTemplateList.isEmpty()){
                templateId = emailTemplateList[0].id;
            }
            Set<String> contractNameSet = contractAccountMap.keySet();
            List<Id> contactIdList=new List<Id>();
            contactRelationshipList(contractNameSet,contactIdList);
            List<loan__Loan_Account__c> objContractList = [SELECT id,
                                                            Name,
                                                            (
                                                                SELECT id,
                                                                loan__Contact__c,
                                                                loan__Account__c,
                                                                loan__Contact__r.Email,
                                                                loan__Account__r.PersonEmail,
                                                                loan__Account__r.PersonMobilePhone
                                                                FROM loan__Coborrowers__r
                                                                WHERE loan__Party_Type__c !=: ConstantValues.BROKER_PARTY_TYPE
                                                                AND loan__Contact__c in: contactIdList
                                                                AND loan__Contact__c != null
                                                                AND loan__Account__r.PersonEmail != null
                                                            )
                                                            FROM loan__Loan_Account__c
                                                            WHERE Name in: contractNameSet];
            List<OrgWideEmailAddress> orgWideEmailList = [SELECT id 
                                                            FROM OrgWideEmailAddress 
                                                            WHERE DisplayName =: ConstantValues.ASSIST_ORDE];
            if(!orgWideEmailList.isEmpty()){
                fromEmailAddressId = orgWideEmailList[0].id;
            }
            Map<String,Id> contractPartyContactMap = new Map<String,Id>();
            for(loan__Loan_Account__c objContract : objContractList){
                String contractName = objContract.Name;
                for(loan__Coborrower__c objContractParty : objContract.loan__Coborrowers__r){
                    if(objContractParty.loan__Contact__c != null){
                        String key = contractName + String.valueOf(objContractParty.loan__Contact__c); //LAI + CONTACTID
                        contractPartyContactMap.put(key,objContractParty.id);
                    }
                }
            }
            for(String key : contractAccountMap.keySet()){
                List<Id> accountIdList = contractAccountMap.get(key);
                for(Id accountId : accountIdList){
                    if(accountIdEmailMap.containsKey(accountId) && emailTemplateList.size() > 0 && accountContactMap.containsKey(accountId) && fromEmailAddressId != null){
                        String emailId = accountIdEmailMap.get(accountId);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.toAddresses = new String[] {emailId};
                        mail.setOrgWideEmailAddressId(fromEmailAddressId);  //Assist ORDE
                        mail.setTemplateId(templateId);
                        mail.setTargetObjectId(accountContactMap.get(accountId)); // contact id
                        String keyForContact = key + String.valueOf(accountContactMap.get(accountId));
                        if(contractPartyContactMap.containsKey(keyForContact)){
                            mail.setWhatId(contractPartyContactMap.get(keyForContact)); // contract id -> changed to contract party id
                        }
                        c+=1;
                        Messaging.SingleEmailMessage[] mails =   new List<Messaging.SingleEmailMessage> {mail};
                        try{
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
                            accountMailDeliveryMap.put(accountId,true);
                        }catch(Exception e){
                            accountMailDeliveryMap.put(accountId,false);
                        }
                    }
                }
            }
            return accountMailDeliveryMap;
        }catch(Exception e){
            GenericUtility.insertLog('CollectionBatchHandler', e);
            return accountMailDeliveryMap;
        }
    }
    public static Boolean sendSMS(String toNumber,String msgBody){
        try{
            if(toNumber == null || msgBody == null){
                return false;
            }
            List<clcommon__TwilioConfig__c> twilioSettings=clcommon__TwilioConfig__c.getAll().values();
            String accountSid;
            String token;
            Boolean useShortCode;
            String fromPhNumber;
            if(!twilioSettings.isEmpty()){
                accountSid=twilioSettings.get(0).clcommon__AccountSid__c;
                token=twilioSettings.get(0).clcommon__AuthToken__c;   
                useShortCode=twilioSettings.get(0).clcommon__Use_Short_Code__c;
                if(useShortCode){
                    fromPhNumber = twilioSettings.get(0).clcommon__CallerId__c;
                    if(fromPhNumber != null && !String.isBlank(fromPhNumber)){
                        fromPhNumber = ConstantValues.AUTRALIA_COUNTRY_CODE + fromPhNumber;
                    }
                }
            }
            if(accountSid != null && token != null && fromPhNumber != null && toNumber != null){
                HttpRequest req = new HttpRequest();
                String twilioEndpoint = System.Label.Twilio_Endpoint_URL;
                twilioEndpoint = twilioEndpoint.replace(ConstantValues.ACCOUNT_SID,accountSid);
                req.setEndpoint(twilioEndpoint);
                req.setMethod(ConstantValues.POST);
                String VERSION  = ConstantValues.TWILIO_VERSION;
                req.setHeader(ConstantValues.X_TWILIO_CLIENT, ConstantValues.SALESFORCE + VERSION);
                req.setHeader(ConstantValues.USER_AGENT, ConstantValues.TWILIO_SALESFORCE + VERSION);
                req.setHeader(ConstantValues.ACCEPT, ConstantValues.APPLICATION_JSON);
                req.setHeader(ConstantValues.ACCEPT_CHARSET, ConstantValues.UTF_8);
                req.setHeader(ConstantValues.AUTHORIZATION,ConstantValues.BASIC+
                    EncodingUtil.base64Encode(Blob.valueOf
                    (accountSid+':' +token)));
                    req.setBody('To='+EncodingUtil.urlEncode
                    (toNumber,'UTF-8')+'&From='+EncodingUtil.urlEncode
                    (fromPhNumber,'UTF-8')+'&Body='+msgBody);
                Http http = new Http();
                HTTPResponse res = http.send(req);
                if(res.getStatusCode()==201){
                    return true;
                }
                return false;
            }
            return false;
        }catch(Exception e){
            GenericUtility.insertLog('CollectionBatchHandler', e);
            return false;
        }
    }
    public static void cloneCollectionActivity(List<Id> collActivityIdList,Map<String,List<Id> > contractAccountMap,Map<Id,Id> accountContactMap, Map<Id,Boolean> accountMailDeliveryMap){
        try{
            if(collActivityIdList == null || contractAccountMap == null || accountContactMap == null || accountMailDeliveryMap == null){
                return;
            }
            String emailSubject;
            String emailBody;
            String smsBody = System.label.Dishonour_SMS;
            Map<Id,String> contactNameMap = new Map<Id,String>();
            List<Id> contactIdList = accountContactMap.values();
            List<collect__Collection_Activity__c> clonedCollActivityList = new List<collect__Collection_Activity__c>();
            List<String> partyTypeList = new String[]{ConstantValues.BORROWER,ConstantValues.CO_APPLICANT,ConstantValues.GUARANTOR,ConstantValues.DIRECTOR,ConstantValues.TRUSTEE};
            List<Id> contractIdList = new List<Id>();
            Map<String,loan__Loan_Account__c> contractDetailsMap = new Map<String,loan__Loan_Account__c>();
            Map<String,String> contractPartyAddressMap = new Map<String,String>();
            Map<Id,String> objContactFirstNameMap=new Map<Id,String>();
            List<Contact> contactList = [SELECT id,
                                            Salutation,
                                            FirstName,
                                            Name 
                                            FROM 
                                            Contact 
                                            WHERE id in: contactIdList];
            for(Contact objContact : contactList){
                if(objContact.Salutation!=null){
                    contactNameMap.put(objContact.id,objContact.Salutation+' '+objContact.Name);
                }else{
                    contactNameMap.put(objContact.id,objContact.Name);
                }
                if(objContact.FirstName!=null){
                    objContactFirstNameMap.put(objContact.id,objContact.FirstName);
                }
            }
            List<collect__Collection_Activity__c> objCollectionActivityList = [SELECT id,
                                                                                collect__Oldest_Due_Date__c,
                                                                                collect__Days_Past_Due__c,
                                                                                collect__Loan_Account_Id__c,
                                                                                collect__Collection_Configuration__c,
                                                                                collect__Principal_Interest_Due__c,
                                                                                collect__Fees_Due__c,
                                                                                collect__Template_Configuration_common__c,
                                                                                collect__Collection_Configuration_Action__c,
                                                                                collect__Delinquent_Amount__c,
                                                                                CL_Contract__c,
                                                                                collect__Dev_Contract__c,
                                                                                collect__Action__c,
                                                                                collect__Account__c,
                                                                                collect__Contact__c,
                                                                                collect__Contact__r.Name,
                                                                                collect__Loan_Account_Name__c,
                                                                                Subject__c,
                                                                                Body__c,
                                                                                collect__Completed__c,
                                                                                Mail_Sent__c
                                                                                FROM collect__Collection_Activity__c
                                                                                WHERE id in: collActivityIdList];
            List<EmailTemplate> emailTemplateList = [SELECT id, 
                                                        Subject, 
                                                        Body 
                                                        FROM 
                                                        EmailTemplate 
                                                        WHERE Name =: ConstantValues.DISHONOUR_EMAIL_TEMPLATE];
            if(!emailTemplateList.isEmpty()){
                emailSubject = emailTemplateList[0].Subject;
                emailBody = emailTemplateList[0].Body;
            }
            for(collect__Collection_Activity__c objCollActivity : objCollectionActivityList){
                if(objCollActivity.CL_Contract__c != null){
                    contractIdList.add(objCollActivity.CL_Contract__c);
                }
            }
            List<loan__Loan_Account__c> objContractList = [SELECT id,
                                                            Name,
                                                            loan__Pmt_Amt_Cur__c,
                                                            loan__Next_Installment_Date__c,
                                                            Assign_to_Queue__c,
                                                            All_Security_Addresses__c,
                                                            Individual_Borrower_Names__c,
                                                            (
                                                                SELECT id,
                                                                loan__Contact__c,
                                                                loan__Account__c,
                                                                Contact_Address__c
                                                                FROM loan__Coborrowers__r
                                                                WHERE loan__Party_Type__c in: partyTypeList
                                                                AND loan__Party_Type__c !=: ConstantValues.BROKER_PARTY_TYPE 
                                                                AND loan__Contact__c != null
                                                                AND loan__Account__r.PersonEmail != null
                                                            ),
                                                            (
                                                                SELECT id,
                                                                loan__Transaction_Amount__c,
                                                                loan__Transaction_Date__c 
                                                                FROM loan__Loan_Payment_Transactions__r 
                                                                WHERE loan__Rejected__c = true 
                                                                AND Dishonour_Override__c =: ConstantValues.NO_TAG 
                                                                ORDER BY LastModifiedDate DESC LIMIT 1
                                                            )
                                                            Send_Email_Dishonor_Notice_to_Customer__c
                                                            FROM loan__Loan_Account__c
                                                            WHERE id in: contractIdList];
            for(loan__Loan_Account__c objContract : objContractList){
                contractDetailsMap.put(objContract.Name,objContract);
                objContract.Assign_to_Queue__c = False;
                objContract.Send_Email_Dishonor_Notice_to_Customer__c = False;
                for(loan__Coborrower__c objContractParty : objContract.loan__Coborrowers__r){
                    String key = objContract.Name + String.valueOf(objContractParty.loan__Account__c);
                    contractPartyAddressMap.put(key,objContractParty.Contact_Address__c);
                }
            }

            for(collect__Collection_Activity__c objCollActivity : objCollectionActivityList){
                if(contractAccountMap.containsKey(objCollActivity.collect__Loan_Account_Name__c)){
                    List<Id> accountIdList = contractAccountMap.get(objCollActivity.collect__Loan_Account_Name__c);
                    Date oldestDueDate = objCollActivity.collect__Oldest_Due_Date__c;
                    Decimal daysPastDue = objCollActivity.collect__Days_Past_Due__c;
                    String loanAccountId = objCollActivity.collect__Loan_Account_Id__c;
                    Id collectionConfigurationId = objCollActivity.collect__Collection_Configuration__c;
                    Decimal principleDue = objCollActivity.collect__Principal_Interest_Due__c;
                    Decimal feesDue = objCollActivity.collect__Fees_Due__c;
                    Id templateConfiguration = objCollActivity.collect__Template_Configuration_common__c;
                    Decimal delinquentAmount = objCollActivity.collect__Delinquent_Amount__c;
                    Id clContractId = objCollActivity.CL_Contract__c;
                    Id contract = objCollActivity.collect__Dev_Contract__c;
                    String action = objCollActivity.collect__Action__c;
                    objCollActivity.collect__Activity_Date__c=Date.today();
                    objCollActivity.collect__Completed__c = True;
                    objCollActivity.collect__Completion_Date__c=Date.today();
                    objCollActivity.Mail_Sent__c = True;
                    if(emailSubject != null && emailBody != null){
                        objCollActivity.Subject__c = emailSubject;
                        objCollActivity.Body__c = emailBody;
                    }
                    Integer flag = 0;
                    for(Integer i = 0; i<accountIdList.size(); i++){                     
                        if(accountMailDeliveryMap.containsKey(accountIdList[i]) && accountMailDeliveryMap.get(accountIdList[i]) == true){
                            objCollActivity.collect__Account__c = accountIdList[i];
                            if(accountContactMap.containsKey(accountIdList[i])){
                                objCollActivity.collect__Contact__c = accountContactMap.get(accountIdList[i]);
                            }
                            if(objCollActivity.collect__Action__c == ConstantValues.MESSAGE){
                                objCollActivity.Body__c = smsBody;
                                if(contactNameMap.containsKey(accountContactMap.get(accountIdList[i])) &&
                                objContactFirstNameMap.containsKey(accountContactMap.get(accountIdList[i]))){
                                    String contactName =objContactFirstNameMap.get(accountContactMap.get(accountIdList[i]));
                                    String firstName = contactName;
                                    objCollActivity.Body__c = objCollActivity.Body__c.replace(ConstantValues.PERSON_ACCOUNT_NAME,firstName);
                                    if(contractDetailsMap.containsKey(objCollActivity.collect__Loan_Account_Name__c)){
                                        objCollActivity.Body__c = manupulateNotificationBody(objCollActivity.Body__c,contractDetailsMap.get(objCollActivity.collect__Loan_Account_Name__c),action);
                                    }
                                }
                            }else if(objCollActivity.collect__Action__c == ConstantValues.EMAIL){
                                objCollActivity.Body__c = emailBody;
                                if(contactNameMap.containsKey(accountContactMap.get(accountIdList[i])) &&
                                objContactFirstNameMap.containsKey(accountContactMap.get(accountIdList[i]))){
                                    String contactName =objContactFirstNameMap.get(accountContactMap.get(accountIdList[i]));
                                    String firstName = contactName;
                                    objCollActivity.Body__c = objCollActivity.Body__c.replace(ConstantValues.CONTACT_FIRST_NAME,firstName);
                                    objCollActivity.Body__c = objCollActivity.Body__c.replace(ConstantValues.LOAN_COBORROWER_CONTACT_NAME,contactNameMap.get(accountContactMap.get(accountIdList[i])));
                                    objCollActivity.Body__c = objCollActivity.Body__c.replace(ConstantValues.CONTACT_NAME,contactNameMap.get(accountContactMap.get(accountIdList[i])));
                                    String keyForAddress = objCollActivity.collect__Loan_Account_Name__c + String.valueOf(accountIdList[i]);
                                    if(contractPartyAddressMap.containsKey(keyForAddress)){
                                        objCollActivity.Body__c = objCollActivity.Body__c.replace(ConstantValues.LOAN_COBORROWER_CONTACT_ADDRESS,contractPartyAddressMap.get(keyForAddress));
                                    }
                                    if(contractDetailsMap.containsKey(objCollActivity.collect__Loan_Account_Name__c)){
                                        objCollActivity.Body__c = manupulateNotificationBody(objCollActivity.Body__c,contractDetailsMap.get(objCollActivity.collect__Loan_Account_Name__c),action);
                                    }
                                    
                                }
                            }
                            flag = i;
                            break;
                        }
                    }
                    for(Integer i = 1; i<accountIdList.size(); i++){
                        if(i == flag){
                            continue;
                        }
                        if(accountMailDeliveryMap.containsKey(accountIdList[i]) && accountMailDeliveryMap.get(accountIdList[i]) == true){
                            collect__Collection_Activity__c newCollActivity = objCollActivity.clone(false, true);
                            newCollActivity.collect__Account__c = accountIdList[i];
                            if(accountContactMap.containsKey(accountIdList[i])){
                                newCollActivity.collect__Contact__c = accountContactMap.get(accountIdList[i]);
                                String contactName = contactNameMap.get(accountContactMap.get(accountIdList[i]));
                                if(emailBody != null){
                                    String body = emailBody.replace(ConstantValues.CONTACT_NAME,contactName);
                                    newCollActivity.Body__c = emailBody;
                                }
                            }
                            /// Copy Field Values ///
                            newCollActivity.collect__Oldest_Due_Date__c = oldestDueDate;
                            newCollActivity.collect__Days_Past_Due__c = daysPastDue;
                            newCollActivity.collect__Loan_Account_Id__c = loanAccountId;
                            newCollActivity.collect__Collection_Configuration__c = collectionConfigurationId;
                            newCollActivity.collect__Principal_Interest_Due__c = principleDue;
                            newCollActivity.collect__Fees_Due__c = feesDue;
                            newCollActivity.collect__Template_Configuration_common__c = templateConfiguration;
                            newCollActivity.CL_Contract__c = clContractId;
                            newCollActivity.collect__Dev_Contract__c = contract;
                            newCollActivity.collect__Action__c = action;
                            newCollActivity.collect__Completed__c = True;
                            newCollActivity.Mail_Sent__c = True;
                            if(emailSubject != null){
                                newCollActivity.Subject__c = emailSubject;
                            }
                            if(action == ConstantValues.MESSAGE){
                                newCollActivity.Body__c = smsBody;
                                if(contactNameMap.containsKey(accountContactMap.get(accountIdList[i])) &&
                                objContactFirstNameMap.containsKey(accountContactMap.get(accountIdList[i]))){
                                    String contactName =objContactFirstNameMap.get(accountContactMap.get(accountIdList[i]));
                                    //List<String> nameList = contactName.split(' ');
                                    //if(nameList.size()>0){
                                    String firstName = contactName;                                    //}
                                    newCollActivity.Body__c = newCollActivity.Body__c.replace(ConstantValues.PERSON_ACCOUNT_NAME,firstName);
                                    if(contractDetailsMap.containsKey(newCollActivity.collect__Loan_Account_Name__c)){
                                        newCollActivity.Body__c = manupulateNotificationBody(newCollActivity.Body__c,contractDetailsMap.get(newCollActivity.collect__Loan_Account_Name__c),action);
                                    }
                                    
                                }
                            }else if(action == ConstantValues.EMAIL){
                                newCollActivity.Body__c = emailBody;
                                if(contactNameMap.containsKey(accountContactMap.get(accountIdList[i]))
                                && objContactFirstNameMap.containsKey(accountContactMap.get(accountIdList[i]))){
                                    String contactName = objContactFirstNameMap.get(accountContactMap.get(accountIdList[i]));
                                    //List<String> nameList = contactName.split(' ');
                                    //if(nameList.size()>0){
                                        String firstName = contactName;
                                        newCollActivity.Body__c = newCollActivity.Body__c.replace(ConstantValues.CONTACT_FIRST_NAME,firstName);
                                    //}
                                    newCollActivity.Body__c = newCollActivity.Body__c.replace(ConstantValues.LOAN_COBORROWER_CONTACT_NAME,contactNameMap.get(accountContactMap.get(accountIdList[i])));
                                    newCollActivity.Body__c = newCollActivity.Body__c.replace(ConstantValues.CONTACT_NAME,contactNameMap.get(accountContactMap.get(accountIdList[i])));
                                    String keyForAddress = newCollActivity.collect__Loan_Account_Name__c + String.valueOf(accountIdList[i]);
                                    if(contractPartyAddressMap.containsKey(keyForAddress)){
                                        newCollActivity.Body__c = newCollActivity.Body__c.replace(ConstantValues.LOAN_COBORROWER_CONTACT_ADDRESS,contractPartyAddressMap.get(keyForAddress));
                                    }
                                    if(contractDetailsMap.containsKey(newCollActivity.collect__Loan_Account_Name__c)){
                                        newCollActivity.Body__c = manupulateNotificationBody(newCollActivity.Body__c,contractDetailsMap.get(newCollActivity.collect__Loan_Account_Name__c),action);
                                    }
                                    
                                }
                            }
                            clonedCollActivityList.add(newCollActivity);
                        }
                    }
                }
            }
            if(objContractList.size()>0){
                DataBase.update(objContractList,false);
            }
            DataBase.update(objCollectionActivityList,false);
            if(clonedCollActivityList.size()>0){
                DataBase.insert(clonedCollActivityList,false);
            }
        }catch(Exception e){
            GenericUtility.insertLog('CollectionBatchHandler', e);
        }
    }
    public static String manupulateNotificationBody(String body,loan__Loan_Account__c objContract, String notification){
        String returnString = 'manupulateNotificationBody';
        try{
            if(body == null || objContract == null || notification == null){
                return returnString;
            }
            Datetime dT;
            Date dToday;
            String strDate;
            if(objContract.loan__Loan_Payment_Transactions__r.size()>0 && objContract.loan__Loan_Payment_Transactions__r[0].loan__Transaction_Amount__c != null){
                dT = (Datetime) objContract.loan__Loan_Payment_Transactions__r[0].loan__Transaction_Date__c;
                dToday = (Date) date.newinstance(dT.year(), dT.month(), dT.day());
                // String dtDay = String.valueOf(dToday.day());
                // if(dtDay.length() == 1){
                //     dtDay = '0' + dt;
                // }
                // String dtMonth = String.valueOf(dToday.month());
                // if(dtMonth.length() == 1){
                //     dtMonth = '0' + dt;
                // }
                // strDate = dtDay + '/' + dtMonth + '/' + dToday.year();
                strDate = dToday.day() + '/' + dToday.month() + '/' + dToday.year();
            }
            if(notification == ConstantValues.MESSAGE){
                if(objContract.loan__Loan_Payment_Transactions__r.size()>0 && objContract.loan__Loan_Payment_Transactions__r[0].loan__Transaction_Amount__c != null){
                    body = body.replace(ConstantValues.LOAN_CURRENT_PAYMENT_AMOUNT,String.valueOf(objContract.loan__Loan_Payment_Transactions__r[0].loan__Transaction_Amount__c));
                }
                if(strDate != null){
                    body = body.replace(ConstantValues.NEXT_DUE_DATE,strDate);
                }
                body = body.replace(ConstantValues.LAI_NAME,String.valueOf(objContract.Name));
                return body;
            }else if(notification == ConstantValues.EMAIL){
                System.debug('notification == Email');
                String currentSystemDate = String.valueOf(System.today());
                //String currentSystemDate = ((DateTime) (!Test.isRunningTest()?(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate().addDays(0): Date.Today()))
                if(objContract.loan__Loan_Payment_Transactions__r.size()>0 && objContract.loan__Loan_Payment_Transactions__r[0].loan__Transaction_Amount__c != null){
                    body = body.replace(ConstantValues.DISHONOUR_LPT_AMOUNT,String.valueOf(objContract.loan__Loan_Payment_Transactions__r[0].loan__Transaction_Amount__c));
                }
                if(strDate != null){
                    body = body.replace(ConstantValues.DISHONOUR_LPT_DATE,strDate);
                }
                body = body.replace(ConstantValues.CURRENT_BRANCH_SYSTEM_DATE,currentSystemDate);
                body = body.replace(ConstantValues.COBORROWER_CONTRACT_NAME,String.valueOf(objContract.Name));
                if(objContract.All_Security_Addresses__c != null){
                    body = body.replace(ConstantValues.COBORROWER_CONTRACT_SECURITY_NAMES,objContract.All_Security_Addresses__c);
                }
                if(objContract.Individual_Borrower_Names__c != null){
                    body = body.replace(ConstantValues.COBORROWER_CONTRACT_INDIVIDUAL_PARTY_NAMES,objContract.Individual_Borrower_Names__c);
                }
                return body;
            }
            return returnString;
        }catch(Exception e){
            GenericUtility.insertLog('CollectionBatchHandler', e);
            return returnString;
        }
    }
    public static void contactRelationshipList(Set<String> contractNameSet,List<Id> contactIdList){

        List<String> partyTypeList = new String[]{ConstantValues.BORROWER,ConstantValues.CO_APPLICANT}; // Custom level;
        List<String> roleList = new String[]{'Director','Trustee'}; 
        List<loan__Coborrower__c> objCoborrowerList=[SELECT id,
                                                        loan__Contact__c,
                                                        loan__Account__c,
                                                        loan__Contact__r.id,
                                                        loan__Account__r.id,
                                                        loan__Account__r.PersonMobilePhone
                                                        FROM loan__Coborrower__c
                                                        WHERE loan__Party_Type__c in: partyTypeList
                                                        AND loan__Party_Type__c !=: ConstantValues.BROKER_PARTY_TYPE
                                                        AND Contract_Name__c in: contractNameSet];
        List<Id> objAccountIdList = new List<Id>();
        for(loan__Coborrower__c objCoborrower:objCoborrowerList){
            if(objCoborrower.loan__Contact__c!=null){
                contactIdList.add(objCoborrower.loan__Contact__r.id);
            }else{
                objAccountIdList.add(objCoborrower.loan__Account__r.id);
            }
        }
        List<AccountContactRelation> objAccountContactRelList=[SELECT id,
                                                                AccountId,
                                                                ContactId
                                                                FROM AccountContactRelation 
                                                                WHERE AccountId in: objAccountIdList AND Roles in : roleList];

        for(AccountContactRelation objAccountContactRel:objAccountContactRelList){
            contactIdList.add(objAccountContactRel.ContactId);
        }
    }
}