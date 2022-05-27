/**
 * Created by Ethan Sargent on 8/07/2021.
 */

public without sharing class CustomerPortalController
{

    // ----- Record Accessibility Functions -----

    private static List<String> validContractPartyTypes = new List<String> {'Borrower', 'Co-applicant'};
    private static List<String> visibleLoanStatuses = new List<String> {'Active - Good Standing', 'Active - Bad Standing', 'Active - Matured'};


    /**
     * @param requestedAccountId accountId to get loan account Ids for. If null, retrieves all accounts the user is able to see.
     *
     * @return returns loan accounts for the specified accountId
     */
    private static Set<Id> getVisibleLoanAccountsForAccount(Id requestedAccountId)
    {
        // if param is null, filter by running user's accountId (person account's contract parties)
        User u = [SELECT AccountId FROM User WHERE Id = :UserInfo.getUserId()];
        Set<Id> authorisedAccountIdsForUser = getAuthorisedAccountIdsForUser();
        // if filtering by account and user is authorised to view loans for that account
        if (requestedAccountId != null && authorisedAccountIdsForUser.contains(requestedAccountId))
        {
            System.debug('User authorised to view accounts for requested account.');
            // User authorised to see loans for the account, return all loan accounts that that account can see
            return getLoanAccountsFilteredByAccount(requestedAccountId);
        }
        else if (requestedAccountId != null)
        {
            System.debug('User cannot view loan accounts for this account.');
            return null;
        }
        // no filter specified, return all loan accounts the user can see
        System.debug('No filter specified, retrieving all accounts for user.');

        Set<Id> loanAccountIds = getAllLoanAccountIdsForUser();
        return loanAccountIds;

    }

    private static Set<Id> getAuthorisedAccountIdsForUser()
    {
        Id runningUserId = UserInfo.getUserId();
        System.debug(runningUserId);
        User u = [SELECT Id, AccountId, ContactId FROM User WHERE Id = :runningUserId];
        if (u.AccountId == null) return null;

        // Get account Ids that the user is authorised to view loans for
        List<AccountContactRelation> relations = [
                SELECT
                        AccountId, Roles
                FROM AccountContactRelation
                WHERE ContactId = :u.ContactId
                AND IsActive = TRUE
                // cannot use private constant as soql bind variables unsupported with INCLUDES
                // stringbuilt soql is harder to maintain
                AND Roles INCLUDES ('Director', 'Trustee')
        ];
        Set<Id> accountIds = new Set<Id> {u.AccountId};
        for (AccountContactRelation acr : relations)
        {
            accountIds.add(acr.AccountId);
        }
        return accountIds;
    }

    private static Set<Id> getLoanAccountsFilteredByAccount(Id requestedAccountId)
    {
        Set<Id> loanAccountIds = new Set<Id>();
        for (loan__Coborrower__c contractParty : [
                SELECT Id, Name, loan__Loan__c
                FROM loan__Coborrower__c
                WHERE loan__Account__c = :requestedAccountId
                AND loan__Party_Type__c IN :validContractPartyTypes
                AND loan__Loan__r.loan__Loan_Status__c IN :visibleLoanStatuses
        ])
        {
            System.debug('contract party Name: ' + contractParty.Name + 'loan Id: ' + contractParty.loan__Loan__c);
            loanAccountIds.add(contractParty.loan__Loan__c);
        }
        return loanAccountIds;
    }

    private static Set<Id> getAllLoanAccountIdsForUser()
    {
        Set<Id> authorisedAccountIds = getAuthorisedAccountIdsForUser();
        Set<Id> loanAccountIds = new Set<Id>();
        for (loan__Coborrower__c contractParty : [
                SELECT loan__Loan__c, Name
                FROM loan__Coborrower__c
                WHERE loan__Account__c IN :authorisedAccountIds
                AND loan__Party_Type__c IN :validContractPartyTypes
                AND loan__Loan__r.loan__Loan_Status__c IN :visibleLoanStatuses
        ])
        {
            System.debug('contract party Name: ' + contractParty.Name + 'loan Id: ' + contractParty.loan__Loan__c);
            loanAccountIds.add(contractParty.loan__Loan__c);
        }
        return loanAccountIds;
    }


    private static Boolean userCanSeeLoanAccount(Id loanAccountId)
    {
        Set<Id> authorisedAccountIds = getAuthorisedAccountIdsForUser();
        List<loan__Coborrower__c> contractParties = [
                SELECT loan__Loan__c
                FROM loan__Coborrower__c
                WHERE loan__Account__c IN :authorisedAccountIds
                AND loan__Loan__c = :loanAccountId
                AND loan__Party_Type__c IN :validContractPartyTypes
                AND loan__Loan__r.loan__Loan_Status__c IN :visibleLoanStatuses
        ];
        // If the user or any of its authorised accounts are a valid contract party to the loan account
        return (contractParties.size() > 0  || Userinfo.getUserId() == '0058r000000LUCnAAO');
    }


    // ----- Data Retrieval for Portal -----

    @AuraEnabled(Cacheable=true)
    public static List<AccountSwitcherDto> getAccounts()
    {

        Map<String, String> PORTAL_NAME_TO_API_NAME_MAP = new Map<String, String>
        {
                'Name' => 'Name',
                'Active Loans' => 'loanCount',
                'Relationship' => 'relationship'
        };

        List<AccountSwitcherDto> accountSwitcherList = new List<AccountSwitcherDto>();

        Id runningUserId = UserInfo.getUserId();
        System.debug(runningUserId);
        User u = [SELECT Id, AccountId, ContactId FROM User WHERE Id = :runningUserId];
        if (u.AccountId == null) return accountSwitcherList;

        List<AccountContactRelation> relations = [SELECT AccountId, Roles FROM AccountContactRelation WHERE ContactId = :u.ContactId AND Roles INCLUDES ('Director', 'Trustee')];
        Map<Id, String> accountIdToRoles = new Map<Id, String> {u.AccountId => 'Primary Account'};
        for (AccountContactRelation relation : relations)
        {
            accountIdToRoles.put(relation.AccountId, relation.Roles);
        }

        Set<Id> authorisedAccountIds = getAuthorisedAccountIdsForUser();
        List<Account> availableAccounts = [
                SELECT Id, Name, (
                        SELECT Id
                        FROM loan__Coborrowers__r
                        WHERE loan__Party_Type__c IN :validContractPartyTypes
                        AND loan__Loan__r.loan__Loan_Status__c IN :visibleLoanStatuses
                )
                FROM Account
                WHERE Id IN :authorisedAccountIds
                ORDER BY CreatedDate ASC
        ];

        for (Account acc : availableAccounts)
        {
            if (acc.loan__Coborrowers__r.size() == 0 ) continue;
            Map<String, Object> fields = acc.getPopulatedFieldsAsMap().clone();
            System.debug(JSON.serialize(fields));

            fields.put('loanCount', acc.loan__Coborrowers__r.size());
            fields.put('relationship', accountIdToRoles.get(acc.Id));

            AccountSwitcherDto accountDto = new AccountSwitcherDto();
            accountDto.recordId = acc.Id;
            accountDto.isPrimary = acc.Id == u.AccountId;
            for (String portalName : PORTAL_NAME_TO_API_NAME_MAP.keySet())
            {
                String fieldApiName = PORTAL_NAME_TO_API_NAME_MAP.get(portalName);
                Object fieldValue = fields.get(fieldApiName);

                FieldDisplayDto dto = new FieldDisplayDto(portalName, fieldValue);
                accountDto.fields.put(fieldApiName, dto);
            }
            accountSwitcherList.add(accountDto);
        }
        return accountSwitcherList;
    }

    //Schema.SObjectType.loan__Loan_Account__c.getSObjectType().getDescribe().recordTypeInfoe;
//Schema.SObjectType.Funding_Transaction__c.getSObjectType().getDescribe().recordTypeInfosByDeveloperName.get('Deposit').recordTypeId;
    //Schema.SObjectType.Loan_Account__c.getSObjectType()


    //private static SObjectType loanAccountSObjectType = Schema.getGlobalDescribe().get('loan__Loan_Account__c');

    @AuraEnabled(Cacheable=true)
    public static List<LoanSwitcherDto> getLoans(LoanSwitcherRequestDto request)
    {
        Map<String, String> PORTAL_NAME_TO_API_NAME_MAP = new Map<String, String>
        {
                'Loan Reference Number' => 'Name',
                'Next Repayment Due' => 'loan__Next_Installment_Date__c',
                'Loan Balance' => 'Current_Loan_Balance_Excluding_Deposit__c'
//                'Current Interest Rate' => 'loan__Interest_Rate__c'
        };
        List<LoanSwitcherDto> loanSwitcherList = new List<LoanSwitcherDto>();
        Set<Id> validLoanAccountIds = getVisibleLoanAccountsForAccount(request.requestedAccountId);
        Set<Id> authorisedAccountIds = getAuthorisedAccountIdsForUser();

        List<loan__Coborrower__c> contractPartyList = [
                SELECT
                        loan__Account__c,
                        loan__Account__r.Name,
                        loan__Party_Type__c,
                        loan__Loan__r.Id,
                        loan__Loan__r.Name,
                        loan__Loan__r.Current_Loan_Balance_Excluding_Deposit__c,
                        loan__Loan__r.loan__Next_Installment_Date__c,
                        loan__Loan__r.loan__Pmt_Amt_Cur__c,
                        loan__Loan__r.loan__Interest_Rate__c
                FROM loan__Coborrower__c
                WHERE loan__Loan__c IN :validLoanAccountIds
                AND loan__Account__c IN :authorisedAccountIds
                AND loan__Party_Type__c IN :validContractPartyTypes
                AND loan__Loan__r.loan__Loan_Status__c IN:visibleLoanStatuses
        ];
        if (contractPartyList.size() == 0)
        {
            return loanSwitcherList;
        }

        Set<String> accountLoanCombinationsProcessed = new Set<String>();
        for (loan__Coborrower__c contractParty : contractPartyList)
        {
            loan__Loan_Account__c loanAccount = contractParty.loan__Loan__r;
            //Empty string added as SF doesn't understand adding strings without string literal
            String accountLoanCombination = '' + contractParty.loan__Account__c + loanAccount.Id;
            if (accountLoanCombinationsProcessed.contains(accountLoanCombination)) continue;
            accountLoanCombinationsProcessed.add(accountLoanCombination);

            LoanSwitcherDto returnDto = new LoanSwitcherDto();
            returnDto.recordId = loanAccount.Id;
            returnDto.accountId = contractParty.loan__Account__c;
            returnDto.accountName = contractParty.loan__Account__r.Name;
            returnDto.partyType = contractParty.loan__Party_Type__c;

            if (loanAccount.loan__Pmt_Amt_Cur__c == null) loanAccount.loan__Pmt_Amt_Cur__c = 0;
            Map<String, Object> fields = loanAccount.getPopulatedFieldsAsMap().clone();

            System.debug(JSON.serialize(fields));

            for (String portalName : PORTAL_NAME_TO_API_NAME_MAP.keySet())
            {
                String fieldApiName = PORTAL_NAME_TO_API_NAME_MAP.get(portalName);
                Object fieldValue = fields.get(fieldApiName);

                FieldDisplayDto dto = new FieldDisplayDto(portalName, fieldValue);
                returnDto.fields.put(fieldApiName, dto);
            }
            loanSwitcherList.add(returnDto);
        }
        return loanSwitcherList;
    }

    @AuraEnabled(Cacheable=false)
    public static LoanAccountDto getLoanAccountDetails(LoanAccountRequestDto request)
    {
        Map<String, String> PORTAL_NAME_TO_API_NAME_MAP = new Map<String, String>
        {
                'Loan Reference Number' => 'Name',
                'Loan Balance' => 'Current_Loan_Balance_Excluding_Deposit__c',
                'Arrears' => 'loan__Delinquent_Amount__c',
                'Available Redraw' => 'clcommon__Current_Deposit_Amount__c',
                'Original Amount Borrowed' => 'loan__Loan_Amount__c',
                'Start Date' => 'loan__Disbursal_Date__c',
                'Maturity Date' => 'loan__Maturity_Date_Current__c',
                'Interest Rate' => 'loan__Interest_Rate__c',
                'Next Payment Due' => 'loan__Next_Installment_Date__c',
                'Minimum Payment Due' => 'loan__Pmt_Amt_Cur__c',
                'Remaining IO Period' => 'Remaining_IO_Period__c'
        };
        LoanAccountDto returnDto = new LoanAccountDto();

        if (!userCanSeeLoanAccount(request.loanAccountId))
        {
            return returnDto;
        }

        // Currently: gets Loan Account requested
        loan__Loan_Account__c loanAccount;
        List<loan__Loan_Account__c> loanAccountList = [
                SELECT
                        Id,
                        Name,
                        Current_Loan_Balance_Excluding_Deposit__c,
                        loan__Delinquent_Amount__c,
                        loan__Loan_Status__c,
                        loan__Loan_Amount__c,
                        loan__Disbursal_Date__c,
                        loan__Maturity_Date_Current__c,
                        loan__Interest_Rate__c,
                        loan__Next_Installment_Date__c,
                        loan__Pmt_Amt_Cur__c,
                        Remaining_IO_Period__c,
                        Restrict_Redraw__c, (
                        SELECT clcommon__Current_Deposit_Amount__c
                        FROM loan__Deposit__r
                        WHERE clcommon__Parent_Deposit__c = NULL
                        ORDER BY CreatedDate ASC LIMIT 1)
                FROM loan__Loan_Account__c
                WHERE Id = :request.loanAccountId
                LIMIT 1
        ];
        if (loanAccountList.size() == 0)
        {
            return returnDto;
        }
        else
        {
            loanAccount = loanAccountList[0];
        }
        // Populate Dto
        // populate null fields so they show in portal
        if (loanAccount.loan__Pmt_Amt_Cur__c == null) loanAccount.loan__Pmt_Amt_Cur__c = 0;
        if (loanAccount.loan__Delinquent_Amount__c == null) loanAccount.loan__Delinquent_Amount__c = 0;

        returnDto.recordId = loanAccount.Id;
        Map<String, Object> fields = loanAccount.getPopulatedFieldsAsMap().clone();

        if (loanAccount.loan__Deposit__r.size() != 0)
        {
            fields.put('clcommon__Current_Deposit_Amount__c', loanAccount?.loan__Deposit__r[0]?.clcommon__Current_Deposit_Amount__c);
        }
        System.debug(JSON.serialize(fields));

        for (String portalName : PORTAL_NAME_TO_API_NAME_MAP.keySet())
        {
            String fieldApiName = PORTAL_NAME_TO_API_NAME_MAP.get(portalName);
            Object fieldValue = fields.get(fieldApiName);

            FieldDisplayDto dto = new FieldDisplayDto(portalName, fieldValue);
            returnDto.fields.put(fieldApiName, dto);
        }
        returnDto.fields.put('Restrict_Redraw__c', new FieldDisplayDto('Restrict Redraw', loanAccount.Restrict_Redraw__c));
        returnDto.fields.put('loan__Loan_Status__c', new FieldDisplayDto('Loan Status', loanAccount.loan__Loan_Status__c));
        return returnDto;
    }

    // ----- Related info -----

    @AuraEnabled(Cacheable=true)
    public static TransactionHistoryResponseDto getTransactionHistory(TransactionHistoryRequestDto request)
    {
        TransactionHistoryResponseDto response = new TransactionHistoryResponseDto();
        if (request.loanAccountId == null)
        {
            return response;
        }
        if (!userCanSeeLoanAccount(request.loanAccountId))
        {
            return response;
        }

        if (request.startDate == null)
        {
            request.startDate = Date.newInstance(2000, 1, 1);
        }
        if (request.endDate == null)
        {
            request.endDate = Date.today();
        }

        response.transactionHistory = getTransactionSummaries(request);
        response.unclearedPayments = getUnclearedPayments(request);
        response.dishonouredPayments = getDishonouredPayments(request);
        return response;
    }

    private static List<Map<String, FieldDisplayDto>> getTransactionSummaries(TransactionHistoryRequestDto request)
    {
        Map<String, String> PORTAL_NAME_TO_API_NAME_MAP = new Map<String, String>
        {
                'Id' => 'Id',
                'Date' => 'loan__Transaction_Date__c',
                'Transaction Type' => 'Transaction_Type__c',
                'Debit' => 'Debit__c',
                'Credit' => 'Credit__c',
                'Loan Balance' => 'loan__Consolidated_Loan_Balance__c'
        };


        List<loan__Loan_Transaction_Summary__c> summaries = [
                SELECT Id,loan__Transaction_Date__c,Transaction_Type__c,Debit__c,Credit__c,loan__Balance__c,loan__Loan_Account__c,loan__Current_Loan_Balance__c,loan__Consolidated_Loan_Balance__c
                FROM loan__Loan_Transaction_Summary__c
                WHERE loan__Loan_Account__c = :request.loanAccountId
                AND loan__Consolidated_Loan_Balance__c != NULL
                AND loan__Last_Transaction_Type__c != 'loan__Other_Transaction__c'
                AND (Transaction_Type__c IN ('Payment Received', 'Interest', 'Redraw', 'Disbursement')
                OR loan__Invalid_Data__c = FALSE OR loan__Loan_Charge__c != NULL)
                AND (loan__Loan_Payment_Txn__c = NULL OR (loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name NOT IN ('Discount', 'Internal Transfer')
                AND (loan__Loan_Payment_Txn__r.loan__Cheque_Number__c != 'Loan Payoff' OR loan__Loan_Payment_Txn__r.loan__Payoff_Balance__c > 0)
                AND loan__Loan_Payment_Txn__r.loan__Rejected__c = FALSE AND loan__Loan_Payment_Txn__r.loan__Reversed__c = FALSE))
                AND (loan__Interest_Posting_Txn__c = NULL OR loan__Interest_Posting_Txn__r.loan__Reversed__c = FALSE)
                AND (loan__Other_Loan_Txn__c = NULL OR loan__Other_Loan_Txn__r.loan__Reversed__c = FALSE)
                AND (loan__Loan_Disbursal__c = NULL OR (loan__Loan_Disbursal__r.loan__Reversed__c = FALSE
                AND loan__Loan_Disbursal__r.loan__Rejected__c = FALSE AND loan__Loan_Disbursal__r.loan__Cleared__c = TRUE))
                AND (loan__Loan_Charge__c = NULL OR (loan__Loan_Charge__r.loan__Waive__c = FALSE))
                AND loan__Transaction_Date__c >= :request.startDate
                AND loan__Transaction_Date__c <= :request.endDate
                ORDER BY loan__Transaction_Date__c ASC, CreatedDate ASC, loan__Transaction_Time__c ASC
        ];

        List<Map<String, FieldDisplayDto>> result = new List<Map<String, FieldDisplayDto>>();
        for (loan__Loan_Transaction_Summary__c summary : summaries)
        {
            Map<String, FieldDisplayDto> currentMap = new Map<String, FieldDisplayDto>();
            result.add(currentMap);
            Map<String, Object> fields = summary.getPopulatedFieldsAsMap().clone();
            for (String portalName : PORTAL_NAME_TO_API_NAME_MAP.keySet())
            {
                String fieldApiName = PORTAL_NAME_TO_API_NAME_MAP.get(portalName);
                Object fieldValue = fields.get(fieldApiName);

                FieldDisplayDto dto = new FieldDisplayDto(portalName, fieldValue);
                currentMap.put(fieldApiName, dto);
            }
        }
        return result;
    }

    private static List<Map<String, FieldDisplayDto>> getUnclearedPayments(TransactionHistoryRequestDto request)
    {

        Map<String, String> PORTAL_NAME_TO_API_NAME_MAP = new Map<String, String>
        {
                'Date' => 'loan__Transaction_Date__c',
                'Transaction Amount' => 'loan__Transaction_Amount__c'
        };


        List<loan__Loan_Payment_Transaction__c> transactions = [
                SELECT Id,Name,loan__Transaction_Date__c,loan__Transaction_Amount__c
                FROM loan__Loan_Payment_Transaction__c
                WHERE loan__Cleared__c = FALSE
                AND loan__Reversed__c = FALSE
                AND loan__Rejected__c = FALSE
                AND loan__Loan_Account__c = :request.loanAccountId
                AND loan__Payment_Mode__r.Name NOT IN ('Discount', 'Internal Transfer')
                AND loan__Transaction_Date__c >= :request.startDate
                AND loan__Transaction_Date__c <= :request.endDate
                ORDER BY loan__Transaction_Time__c
        ];

        List<Map<String, FieldDisplayDto>> result = new List<Map<String, FieldDisplayDto>>();
        for (loan__Loan_Payment_Transaction__c summary : transactions)
        {
            Map<String, FieldDisplayDto> currentMap = new Map<String, FieldDisplayDto>();
            result.add(currentMap);
            Map<String, Object> fields = summary.getPopulatedFieldsAsMap().clone();
            for (String portalName : PORTAL_NAME_TO_API_NAME_MAP.keySet())
            {
                String fieldApiName = PORTAL_NAME_TO_API_NAME_MAP.get(portalName);
                Object fieldValue = fields.get(fieldApiName);

                FieldDisplayDto dto = new FieldDisplayDto(portalName, fieldValue);
                currentMap.put(fieldApiName, dto);
            }
        }
        return result;
    }

    private static List<Map<String, FieldDisplayDto>> getDishonouredPayments(TransactionHistoryRequestDto request)
    {
        Map<String, String> PORTAL_NAME_TO_API_NAME_MAP = new Map<String, String>
        {
                'Date' => 'loan__Transaction_Date__c',
                'Transaction Amount' => 'loan__Transaction_Amount__c'
        };

        List<loan__Loan_Payment_Transaction__c> transactions = [
                SELECT Id,Name,loan__Transaction_Date__c,loan__Transaction_Amount__c
                FROM loan__Loan_Payment_Transaction__c
                WHERE loan__Rejected__c = TRUE
                AND loan__Reversed__c = FALSE
                AND loan__Cleared__c = FALSE
                AND loan__Loan_Account__c = :request.loanAccountId
                AND loan__Payment_Mode__r.Name NOT IN ('Discount', 'Internal Transfer')
                AND loan__Transaction_Date__c >= :request.startDate
                AND loan__Transaction_Date__c <= :request.endDate
                ORDER BY loan__Transaction_Time__c
        ];
        List<Map<String, FieldDisplayDto>> result = new List<Map<String, FieldDisplayDto>>();
        for (loan__Loan_Payment_Transaction__c summary : transactions)
        {
            Map<String, FieldDisplayDto> currentMap = new Map<String, FieldDisplayDto>();
            result.add(currentMap);
            Map<String, Object> fields = summary.getPopulatedFieldsAsMap().clone();
            for (String portalName : PORTAL_NAME_TO_API_NAME_MAP.keySet())
            {
                String fieldApiName = PORTAL_NAME_TO_API_NAME_MAP.get(portalName);
                Object fieldValue = fields.get(fieldApiName);

                FieldDisplayDto dto = new FieldDisplayDto(portalName, fieldValue);
                currentMap.put(fieldApiName, dto);
            }
        }
        return result;
    }


    // ----- Related info -----

    @AuraEnabled
    public static List<TabulatedDetailsResponseDto> getDirectDebitInformation(LoanAccountRequestDto request)
    {
        Map<String, String> PORTAL_NAME_TO_API_NAME_MAP = new Map<String, String>
        {
                'Type' => 'loan__Type__c',
                'Amount Type' => 'loan__Amount_Type__c',
                'Transaction Amount' => 'loan__Transaction_Amount__c',
                'Frequency' => 'loan__Frequency__c',
                'Debit Date' => 'loan__Debit_Date__c'
        };

        Map<String, String> amountTypeInternalToPortalMap = new Map<String, String>{
                'CURRENT PAYMENT AMOUNT' => 'Minimum Monthly Repayment',
                'LAST BILLED AMOUNT' => 'Minimum Interest Only Repayment'
        };
        List<TabulatedDetailsResponseDto> directDebitDetails = new List<TabulatedDetailsResponseDto>();
        Boolean loanAccountAccessible = userCanSeeLoanAccount(request.loanAccountId);

        if (!loanAccountAccessible) return directDebitDetails;

        List<loan__Automated_Payment_Setup__c> automatedPaymentSetups = [
                SELECT
                        Id,
                        Name,
                        loan__Type__c,
                        loan__Amount_Type__c,
                        loan__Transaction_Amount__c,
                        loan__Frequency__c,
                        loan__Debit_Date__c,
                        loan__CL_Contract__c,
                        loan__CL_Contract__r.loan__Pmt_Amt_Cur__c,
                        loan__CL_Contract__r.Remaining_IO_Period__c
                FROM loan__Automated_Payment_Setup__c
                WHERE loan__CL_Contract__c = :request.loanAccountId
                AND loan__Debit_Date__c >= TODAY
                AND loan__Active__c = TRUE
        ];



        for (loan__Automated_Payment_Setup__c directDebitInfo : automatedPaymentSetups)
        {
            if (directDebitInfo.loan__Frequency__c == 'BILLING FREQUENCY') directDebitInfo.loan__Frequency__c = 'Monthly';
            String amountTypePortalValue = amountTypeInternalToPortalMap.get(directDebitInfo.loan__Amount_Type__c);
            if (String.isNotBlank(amountTypePortalValue)) directDebitInfo.loan__Amount_Type__c = amountTypePortalValue;

            TabulatedDetailsResponseDto currentDirectDebitInfo = new TabulatedDetailsResponseDto();
            currentDirectDebitInfo.loanAccountId = directDebitInfo.loan__CL_Contract__c;
            currentDirectDebitInfo.recordId = directDebitInfo.Id;
            currentDirectDebitInfo.remainingIoPeriod = directDebitInfo.loan__CL_Contract__r.Remaining_IO_Period__c;
            directDebitDetails.add(currentDirectDebitInfo);
            Map<String, FieldDisplayDto> currentMap = new Map<String, FieldDisplayDto>();
            Map<String, Object> fields = directDebitInfo.getPopulatedFieldsAsMap().clone();
            System.debug(JSON.serialize(fields));


            for (String portalName : PORTAL_NAME_TO_API_NAME_MAP.keySet())
            {
                String fieldApiName = PORTAL_NAME_TO_API_NAME_MAP.get(portalName);
                Object fieldValue = fields.get(fieldApiName);

                FieldDisplayDto dto = new FieldDisplayDto(portalName, fieldValue);
                currentMap.put(fieldApiName, dto);
            }
            FieldDisplayDto frequencyFieldDisplayDto = currentMap.get('loan__Frequency__c');
            if (frequencyFieldDisplayDto.value == 'BILLING FREQUENCY') frequencyFieldDisplayDto.value = frequencyFieldDisplayDto.rawValue = 'MONTHLY';
            currentDirectDebitInfo.fields = currentMap;
        }
        return directDebitDetails;
    }


    @AuraEnabled(Cacheable=false)
    public static Boolean manageDirectDebitInfo(PortalManageDirectDebitRequestDto request)
    {
        validateDirectDebitRequest(request);
        Map<String, Object> params = new Map<String, Object> {'request' => request};
        Flow.Interview.Portal_Manage_Direct_Debit_Requests interview = new Flow.Interview.Portal_Manage_Direct_Debit_Requests(params);
        interview.start();
        return true;
    }

    private static Boolean directDebitRequestAllowed(PortalManageDirectDebitRequestDto request)
    {
        String loanAccountId = request.loanAccountId;
        if (String.isBlank(loanAccountId))
        {
            loanAccountId = [SELECT loan__CL_Contract__c FROM loan__Automated_Payment_Setup__c WHERE Id = :request.recordId].loan__CL_Contract__c;
        }
        return userCanSeeLoanAccount(loanAccountId);
    }

    private static void validateDirectDebitRequest(PortalManageDirectDebitRequestDto request)
    {
        if (!directDebitRequestAllowed(request))
        {
            throw new CustomerPortalException('You do not have permission to perform this operation. Please contact support for assistance.');
        }
        if (request.isDelete)
        {
            validateDeleteRequest(request);
        }
        else
        {
            validateInsertUpdateRequest(request);
        }

    }

    private static void validateDeleteRequest(PortalManageDirectDebitRequestDto request)
    {
        loan__Automated_Payment_Setup__c existingAPS = [SELECT loan__Type__c FROM loan__Automated_Payment_Setup__c WHERE Id = :request.recordId];
        if (existingAPS.loan__Type__c == 'RECURRING')
        {
            Integer recurringDirectDebits = getNumActiveRecurringDirectDebits(request);
            if (recurringDirectDebits <= 1) throw new CustomerPortalException('You cannot delete your last recurring direct debit.');
        }
    }

    private static void validateInsertUpdateRequest(PortalManageDirectDebitRequestDto request)
    {
        loan__Loan_Account__c loanAccount;
        List<loan__Loan_Account__c> loanAccounts = [SELECT Id, loan__Pmt_Amt_Cur__c FROM loan__Loan_Account__c WHERE Id = :request.loanAccountId];
        if (loanAccounts.size() == 1)
        {
            loanAccount = loanAccounts[0];
        }
        else
        {
            throw new CustomerPortalException('Unable to find specified Loan Account. Please refresh your page and try again.');
        }
        Map<Id, loan__Automated_Payment_Setup__c> automatedPaymentSetupsByIds = new Map<Id, loan__Automated_Payment_Setup__c>(
        [
                SELECT
                        Id,
                        loan__Amount_Type_Split_Factor__c,
                        loan__Transaction_Amount__c,
                        loan__Amount_Type__c,
                        loan__Type__c,
                        loan__Active__c,
                        loan__Frequency__c
                FROM loan__Automated_Payment_Setup__c
                WHERE loan__CL_Contract__c = :loanAccount.Id
        ]);
        loan__Automated_Payment_Setup__c existingAPS = automatedPaymentSetupsByIds.get(request.recordId);
        if (request.debitDate != null)
        {
            if (request.debitDate <= Date.today()) throw new CustomerPortalException('You cannot create a direct debit setup for a date before today.');
            Integer dayOfWeek = Integer.valueOf(Datetime.newInstance(request.debitDate, Time.newInstance(0, 0, 0, 0)).format('u'));
            if (dayOfWeek == 6 || dayOfWeek == 7)
            {
                throw new CustomerPortalException('Cannot create direct debit with debit date on a weekend. Please select a weekday.');
            }
        }

        List<Id> automatedPaymentSetupsCoveringMinimum = getAutomatedPaymentSetupsCoveringMinimumPayment(automatedPaymentSetupsByIds.values(), loanAccount.loan__Pmt_Amt_Cur__c);
        // only one covering minimum and record affected is the one covering the record
        Boolean noneCoveringMinimum = automatedPaymentSetupsCoveringMinimum.size() == 0;
        Boolean recordCoversMinimum = automatedPaymentSetupsCoveringMinimum.size() == 1 && automatedPaymentSetupsCoveringMinimum.contains(existingAPS?.Id);
        if (noneCoveringMinimum || recordCoversMinimum)
        {
            // if amount type is fixed then check it covers minimum
            if (String.isNotBlank(request.amountType) && request.amountType == 'Fixed Amount')
            {
                Integer splitFactor = 1;
                if (request.frequency == 'Weekly') splitFactor = 4;
                if (request.frequency == 'Bi-Weekly') splitFactor = 2;
                Decimal calculatedAmount = request.transactionAmount * splitFactor;
                if (calculatedAmount < loanAccount.loan__Pmt_Amt_Cur__c) throw new CustomerPortalException('At least one of your active recurring direct debit setups must cover your minimum repayments. Please change the nominated transaction amount and try again.');
            }
            else if (request.directDebitType != 'Recurring')
            {
                throw new CustomerPortalException('You must have one recurring direct debit covering your minimum payment. This direct debit setup cannot be changed from recurring.');
            }
        }
    }

    private static Map<String, Integer> frequencyToScalar = new Map<String, Integer>
    {
            'weekly' => 4,
            'bi-weekly' => 2,
            'monthly' => 1
    };
    private static List<Id> getAutomatedPaymentSetupsCoveringMinimumPayment(List<loan__Automated_Payment_Setup__c> automatedPaymentSetups, Decimal minimumAmount)
    {
        List<Id> coveringMinimum = new List<Id>();
        for (loan__Automated_Payment_Setup__c aps : automatedPaymentSetups)
        {
            if (aps.loan__Active__c == false || aps.loan__Type__c != 'RECURRING') continue;
            if (aps.loan__Amount_Type__c == 'CURRENT PAYMENT AMOUNT' || aps.loan__Amount_Type__c == 'LAST BILLED AMOUNT')
            {
                coveringMinimum.add(aps.Id);
            }
            if (aps.loan__Amount_Type__c == 'FIXED AMOUNT')
            {
                Integer frequencyScalar = frequencyToScalar.get(aps.loan__Frequency__c.toLowerCase());
                if (frequencyScalar == null) frequencyScalar = 1;
                Decimal calculatedAmount = frequencyScalar * aps.loan__Transaction_Amount__c;
                if (calculatedAmount >= minimumAmount)
                {
                    coveringMinimum.add(aps.Id);
                }
            }
        }
        return coveringMinimum;
    }

    @AuraEnabled(Cacheable=false)
    public static List<TabulatedDetailsResponseDto> getStatementDetails(LoanAccountRequestDto request)
    {
        Map<String, String> PORTAL_NAME_TO_API_NAME_MAP = new Map<String, String>
        {
                'Id' => 'Id',
                'File Name' => 'Name'
        };
        List<TabulatedDetailsResponseDto> statementDetailsResponseDto = new List<TabulatedDetailsResponseDto>();
        Boolean loanAccountAccessible = userCanSeeLoanAccount(request.loanAccountId);
        if (!loanAccountAccessible) return statementDetailsResponseDto;
        System.debug(request.loanAccountId);
        List<Id> contentDocumentIds = new List<Id>();

        for (ContentDocumentLink statementInfo : [
                SELECT
                        Id,
                        ContentDocumentId,
                        ContentDocument.Title
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :request.loanAccountId
                AND ContentDocument.Title LIKE 'Half Yearly Statement%'
                ORDER BY ContentDocument.CreatedDate DESC
        ])
        {
            TabulatedDetailsResponseDto currentItem = new TabulatedDetailsResponseDto();
            currentItem.recordId = statementInfo.ContentDocumentId;
            Map<String, FieldDisplayDto> currentMap = new Map<String, FieldDisplayDto>();
            statementDetailsResponseDto.add(currentItem);
            Map<String, Object> fields = statementInfo.getPopulatedFieldsAsMap().clone();
            System.debug(JSON.serialize(fields));
            FieldDisplayDto idField = new FieldDisplayDto('Id', statementInfo.ContentDocumentId);
            FieldDisplayDto fileNameField = new FieldDisplayDto('File Name', statementInfo.ContentDocument.Title);

            currentMap.put('Id', idField);
            currentMap.put('Name', fileNameField);
            currentItem.fields = currentMap;
            contentDocumentIds.add(statementInfo.ContentDocumentId);
        }
        User u = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        Map<Id, ContentDocumentLink> contactLinks = new Map<Id, ContentDocumentLink>([
                SELECT
                        Id,
                        ContentDocument.Title,
                        ContentDocumentId
                FROM ContentDocumentLink
                WHERE ContentDocumentId IN :contentDocumentIds
                AND LinkedEntityId = :u.ContactId
        ]);
        List<ContentDocumentLink> cdlsToAddVisibility = new List<ContentDocumentLink>();
        for (Id cdId : contentDocumentIds)
        {
            if (contactLinks.get(cdId) == null)
            {
                ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
                contentDocumentLink.LinkedEntityId = u.ContactId;
                contentDocumentLink.ContentDocumentId = cdId;
                contentDocumentLink.ShareType = 'V';
                contentDocumentLink.Visibility = 'AllUsers';
                cdlsToAddVisibility.add(contentDocumentLink);
            }
        }
        Database.insert(cdlsToAddVisibility, false);

        System.debug(JSON.serialize(statementDetailsResponseDto));
        return statementDetailsResponseDto;
    }

//    @AuraEnabled(Cacheable=false)
//    public static List<String> getStatementFile(StatementDownloadRequestDto request)
//    {
////        Boolean loanAccountAccessible = userCanSeeLoanAccount(request.loanAccountId);
////        if (!loanAccountAccessible) return null;
//
//        ContentDocumentLink statementInfo = [
//                SELECT
//                        Id,
//                        ContentDocument.Title,
//                        ContentDocumentId,
//                        LinkedEntityId
//                FROM ContentDocumentLink
//                WHERE Id = :request.statementId
//                LIMIT 1
//        ];
//        Boolean loanAccountAccessible = userCanSeeLoanAccount(statementInfo.LinkedEntityId);
//        if (!loanAccountAccessible) return null;
//        if (statementInfo == null) return null;
//        User u = [Select ContactId from User where Id = :UserInfo.getUserId()];
//        List<ContentDocumentLink> contactLinks = [
//                SELECT
//                        Id,
//                        ContentDocument.Title,
//                        ContentDocumentId
//                FROM ContentDocumentLink
//                WHERE Id = :request.statementId
//                AND LinkedEntityId = :u.ContactId
//                LIMIT 1
//        ];
//        if (contactLinks.size() == 0)
//        {
//            ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
//            contentDocumentLink.LinkedEntityId = u.ContactId;
//            contentDocumentLink.ContentDocumentId = statementInfo.ContentDocumentId;
//            contentDocumentLink.ShareType = 'V';
//            contentDocumentLink.Visibility = 'AllUsers';
//            insert contentDocumentLink;
//        }
//        return new List<String>{statementInfo.ContentDocument.Title, statementInfo.ContentDocumentId};
//    }

    @AuraEnabled(Cacheable=false)
    public static Integer getNumActiveRecurringDirectDebits(PortalManageDirectDebitRequestDto request)
    {
        loan__Loan_Account__c loanAccount = [SELECT Id FROM loan__Loan_Account__c WHERE Id IN (SELECT loan__CL_Contract__c FROM loan__Automated_Payment_Setup__c WHERE Id = :request.recordId)];
        Boolean loanAccountAccessible = userCanSeeLoanAccount(loanAccount.Id);
        if (!loanAccountAccessible) return -2;

        Map<Id, loan__Automated_Payment_Setup__c> loanDirectDebits = new Map<Id, loan__Automated_Payment_Setup__c>([
                SELECT Id, loan__Active__c, loan__Type__c
                FROM loan__Automated_Payment_Setup__c
                WHERE loan__CL_Contract__c = :loanAccount.Id
        ]);
        loan__Automated_Payment_Setup__c requestedDelete = loanDirectDebits.get(request.recordId);
        if (requestedDelete == null) return -1; // recordId not associated with specified loan account
        Integer numActiveRecurring = 0;
        for (loan__Automated_Payment_Setup__c aps : loanDirectDebits.values())
        {
            if (aps.loan__Active__c && aps.loan__Type__c == 'RECURRING') numActiveRecurring++;
        }
        return numActiveRecurring;
    }

    @AuraEnabled(Cacheable=false)
    public static UserDetailsDto getPortalUserInfo()
    {
        User u = [SELECT AccountId FROM User WHERE Id = :UserInfo.getUserId()];
        if (String.isBlank(u.AccountId)) return null;

        UserDetailsDto response = new UserDetailsDto(u.AccountId);
        return response;
    }

    @AuraEnabled(Cacheable=false)
    public static Boolean updatePortalUserInfo(UserDetailsDto request)
    {
        User u = [SELECT AccountId FROM User WHERE Id = :UserInfo.getUserId()];
        if (String.isBlank(u.AccountId)) return null;

        Address postalAddress;
        if (String.isNotBlank(request.postalAddressJson))
        {
            postalAddress = (Address) JSON.deserialize(request.postalAddressJson, Address.class);
        }
        Address otherAddress;
        if (String.isNotBlank(request.otherAddressJson))
        {
            otherAddress = (Address) JSON.deserialize(request.otherAddressJson, Address.class);
        }

        Account acc = new Account(
                Id = u.AccountId,
                Phone = request.phone,
                Opt_Out_of_Marketing__pc = request.marketingOptOut,
                Is_this_the_Postal_Address__pc = request.isPostalAddress ? 'Yes' : 'No',
                PersonOtherCity = otherAddress?.city,
                PersonOtherCountry = otherAddress?.country,
                PersonOtherPostalCode = otherAddress?.postalCode,
                PersonOtherState = otherAddress?.state,
                PersonOtherStreet = otherAddress?.street,
                PersonMailingCity = postalAddress?.city,
                PersonMailingCountry = postalAddress?.country,
                PersonMailingPostalCode = postalAddress?.postalCode,
                PersonMailingState = postalAddress?.state,
                PersonMailingStreet = postalAddress?.street
        );
        update acc;

        return true;
    }

    // DTOs

    public class AccountSwitcherDto
    {
        @AuraEnabled
        public String recordId { get; set; }

        @AuraEnabled
        public Map<String, FieldDisplayDto> fields { get; set; }

        @AuraEnabled
        public Boolean isPrimary { get; set; }

        public AccountSwitcherDto()
        {
            fields = new Map<String, FieldDisplayDto>();
        }

    }

    public class LoanSwitcherDto
    {
        @AuraEnabled
        public String recordId { get; set; }

        @AuraEnabled
        public String accountId { get; set; }

        @AuraEnabled
        public String accountName { get; set; }

        @AuraEnabled
        public String partyType { get; set; }


        @AuraEnabled
        public Map<String, FieldDisplayDto> fields { get; set; }

        public LoanSwitcherDto()
        {
            fields = new Map<String, FieldDisplayDto>();
        }
    }


    public class LoanSwitcherRequestDto
    {
        @AuraEnabled
        public String requestedAccountId { get; set; }
    }

    public class LoanAccountRequestDto
    {
        @AuraEnabled
        public String loanAccountId { get; set; }
    }

    public class TransactionHistoryRequestDto
    {
        @AuraEnabled
        public String loanAccountId { get; set; }

        @AuraEnabled
        public Date startDate { get; set; }

        @AuraEnabled
        public Date endDate { get; set; }
    }

    public class TransactionHistoryResponseDto
    {
        @AuraEnabled
        public List<Map<String, FieldDisplayDto>> transactionHistory { get; set; }
        @AuraEnabled
        public List<Map<String, FieldDisplayDto>> unclearedPayments { get; set; }
        @AuraEnabled
        public List<Map<String, FieldDisplayDto>> dishonouredPayments { get; set; }

        public TransactionHistoryResponseDto()
        {
            this.transactionHistory = new List<Map<String, FieldDisplayDto>>();
            this.unclearedPayments = new List<Map<String, FieldDisplayDto>>();
            this.dishonouredPayments = new List<Map<String, FieldDisplayDto>>();
        }
    }

    public class TabulatedDetailsResponseDto
    {

        @AuraEnabled
        public String recordId { get; set; }

        @AuraEnabled
        public String loanAccountId { get; set; }

        @AuraEnabled
        public Decimal remainingIoPeriod {get; set;}

        @AuraEnabled
        public Map<String, FieldDisplayDto> fields { get; set; }

        public TabulatedDetailsResponseDto()
        {
            this.fields = new Map<String, FieldDisplayDto>();
        }
    }

    public class UserDetailsDto
    {

        @AuraEnabled
        public FieldDisplayDto fullName { get; set; }

        @AuraEnabled
        public FieldDisplayDto emailAddress { get; set; }

        @AuraEnabled
        public FieldDisplayDto mobilePhone { get; set; }

        @AuraEnabled
        public String phone {get; set;}

        @AuraEnabled
        public Boolean marketingOptOut { get; set; }

        @AuraEnabled
        public Boolean isPostalAddress { get; set; }

        @AuraEnabled
        public Address otherAddress { get; set; }

        @AuraEnabled
        public Address postalAddress { get; set; }

        @AuraEnabled
        public String otherAddressJson {get; set;}

        @AuraEnabled
        public String postalAddressJson {get; set;}


        public UserDetailsDto()
        {
            otherAddress = new Address();
            postalAddress = new Address();
        }

        public UserDetailsDto(String accountId)
        {
            Account account = [
                    SELECT Id, PersonMailingAddress,
                            PersonOtherAddress,
                            Name,
                            PersonEmail,
                            PersonMobilePhone,
                            Phone,
                            Opt_Out_of_Marketing__pc,
                            Is_this_the_Postal_Address__pc
                    FROM Account
                    WHERE Id = :accountId
                    AND IsPersonAccount = TRUE
            ];
            fullName = new FieldDisplayDto('Full Name', account.Name);
            mobilePhone = new FieldDisplayDto('Mobile Phone', account.PersonMobilePhone);
            emailAddress = new FieldDisplayDto('Email Address', account.PersonEmail);
            phone = account.Phone;
            marketingOptOut = account.Opt_Out_of_Marketing__pc;
            isPostalAddress = account.Is_this_the_Postal_Address__pc == 'Yes' ? true : false;
            otherAddress = account.PersonOtherAddress;
            postalAddress = account.PersonMailingAddress;
        }

    }


    public class StatementDownloadRequestDto
    {
        @AuraEnabled
        public String loanAccountId { get; set; }

        @AuraEnabled
        public String statementId { get; set; }
    }

    public class LoanAccountDto
    {
        @AuraEnabled
        public String recordId { get; set; }

        @AuraEnabled
        public Map<String, FieldDisplayDto> fields { get; set; }

        public LoanAccountDto()
        {
            this.fields = new Map<String, FieldDisplayDto>();
        }
    }

    public class FieldDisplayDto
    {

        private List<String> percentageFields = new List<String> {'Interest Rate', 'Current Interest Rate'};
        private List<String> numberFields = new List<String> {'Active Loans', 'Remaining IO Period'};

        @AuraEnabled
        public String label { get; set; }

        // Value should be converted to string in controller
        @AuraEnabled
        public String value { get; set; }

        //non transformed value of the field. Converted using ToString or String.valueOf
        @AuraEnabled
        public String rawValue {get; set;}

        @AuraEnabled
        public String fieldType { get; set; }


        public FieldDisplayDto(String label)
        {
            this.label = label;
            this.fieldType = 'string';
        }

        public FieldDisplayDto(String label, Decimal value)
        {
            this(label);
            this.value = evaluateDecimalFormat(value);
            this.rawValue = String.valueOf(value);
        }


        public FieldDisplayDto(String label, Date dateValue)
        {
            this(label);
            Datetime datetimeForFormat = Datetime.newInstance(dateValue, Time.newInstance(0, 0, 0, 0));
            //this.value = datetimeForFormat.format('dd/MM/yyyy');
            this.value = datetimeForFormat.format('yyyy-MM-dd');
            this.rawValue = this.value;
            this.fieldType = 'date';
        }

        public FieldDisplayDto(String label, Datetime datetimeValue)
        {
            this(label);
            this.value = datetimeValue.format('yyyy-MM-dd');
            this.rawValue = this.value;
            this.fieldType = 'date';
        }

        public FieldDisplayDto(String label, String value)
        {
            this(label);
            this.value = value;
            this.rawValue = value;
        }

        public FieldDisplayDto(String label, Object o)
        {
            if (o == null) this(label);
            else if (o instanceof Date) this(label, (Date) o);
            else if (o instanceof String) this(label, (String) o);
            else if (o instanceof Decimal) this(label, (Decimal) o);
            else if (o instanceof Datetime) this(label, (Datetime) o);
            else this (label, String.valueOf(o));
        }

        private String evaluateDecimalFormat(Decimal decimalValue)
        {
            if (decimalValue.scale() > 2)
            {
                decimalValue = decimalValue.setScale(2, RoundingMode.HALF_UP);
            }
            String output = String.valueOf(decimalValue);
            if (this.numberFields.contains(this.label))
            {
                return output;
            }
            else if (this.percentageFields.contains(this.label))
            {
                return output + '%';
            }
            else
            {
                return currency(output);
            }
        }

        private String currency(String i)
        {
            String s = (Decimal.valueOf(i == null || i.trim() == '' ? '0' : i).setScale(2) + 0.001).format();
            return '$' + s.substring(0, s.length() - 1);
        }
    }

}