/**
 * Created by caleb on 10/06/2022.
 */

public with sharing class SendInterestRateChangeEmailsQueueble implements System.Queueable, System.Finalizer
{
    public static Integer BATCH_SIZE = 100;

    public Id minimumIdExclusive;
    public List<Id> loanAccountsUpdateToMeatCriteria;

    public String formatDate(Date d)
    {
        if (d == null) return null;
        return Datetime.newInstance(d, Time.newInstance(0, 0, 0, 0)).format('dd-MM-yyyy');
    }

    public String formatInterestRate(Decimal d)
    {
        if (d == null) return null;
        return String.valueOf(d.setScale(2));
    }

    public String formatCurrency(Decimal d)
    {
        if (d == null) return null;
        return String.valueOf(d.setScale(2).format());
    }

    public void execute(QueueableContext param1)
    {
        System.attachFinalizer(this);
        loanAccountsUpdateToMeatCriteria.sort();
        System.debug('loanAccountsUpdateToMeatCriteria = ' + loanAccountsUpdateToMeatCriteria);
        System.debug('minimumIdExclusive = ' + minimumIdExclusive);
        List<loan__Coborrower__c> coborrowers;
        if (minimumIdExclusive != null)
        {
            coborrowers = [
                    SELECT
                            Id,
                            loan__Loan__r.Name,
                            loan__Contact__r.Name,
                            loan__Contact__r.FirstName,
                            loan__Contact__r.LastName,
                            loan__Contact__r.Email,
                            loan__Account__r.IsPersonAccount,
                            loan__Account__r.Name,
                            loan__Account__r.FirstName,
                            loan__Account__r.LastName,
                            loan__Account__r.PersonEmail,
                            loan__Loan__c,
                            loan__Loan__r.New_Interest_Rate__c,
                            loan__Loan__r.loan__Interest_Rate__c,
                            loan__Loan__r.New_Interest_Rate_Effective_Date__c,
                            loan__Loan__r.loan__Pmt_Amt_Cur__c,
                            loan__Loan__r.Second_Repayment_Date_After_IR_Change__c,
                            loan__Loan__r.Calculated_Upcoming_Repayment_Amount__c,
                            loan__Loan__r.First_Repayment_Date_After_IR_Change__c,
                            loan__Loan__r.Interest_Rate_Change_Notification_Date__c,
                            loan__Loan__r.Remaining_IO_Period__c
                    FROM loan__Coborrower__c
                    WHERE loan__Loan__c IN :loanAccountsUpdateToMeatCriteria
                    AND loan__Party_Type__c IN ('Borrower', 'Co-applicant', 'Guarantor')
                    AND (
                            loan__Contact__r.clcommon__Legal_Entity_Type__r.Name = 'Individual'
                            OR loan__Account__r.clcommon__Legal_Entity_Type__pr.Name = 'Individual'
                            OR loan__Account__r.clcommon__Legal_Entity_Type__r.Name = 'Individual'
                            OR loan__Contact__r.clcommon__Legal_Entity_Type__r.Name = 'individual'
                            OR loan__Account__r.clcommon__Legal_Entity_Type__pr.Name = 'individual'
                            OR loan__Account__r.clcommon__Legal_Entity_Type__r.Name = 'individual'
                    )
                    AND Id > :minimumIdExclusive
                    //ORDER BY Id
                    LIMIT :BATCH_SIZE
                    FOR UPDATE
            ];
        }
        else
        {
            coborrowers = [
                    SELECT
                            Id,
                            loan__Loan__r.Name,
                            loan__Contact__r.Name,
                            loan__Contact__r.FirstName,
                            loan__Contact__r.LastName,
                            loan__Contact__r.Email,
                            loan__Account__r.IsPersonAccount,
                            loan__Account__r.Name,
                            loan__Account__r.FirstName,
                            loan__Account__r.LastName,
                            loan__Account__r.PersonEmail,
                            loan__Loan__r.New_Interest_Rate__c,
                            loan__Loan__r.loan__Interest_Rate__c,
                            loan__Loan__r.New_Interest_Rate_Effective_Date__c,
                            loan__Loan__r.loan__Pmt_Amt_Cur__c,
                            loan__Loan__r.Second_Repayment_Date_After_IR_Change__c,
                            loan__Loan__r.Calculated_Upcoming_Repayment_Amount__c,
                            loan__Loan__r.First_Repayment_Date_After_IR_Change__c,
                            loan__Loan__r.Interest_Rate_Change_Notification_Date__c,
                            loan__Loan__r.Remaining_IO_Period__c
                    FROM loan__Coborrower__c
                    WHERE loan__Loan__c IN :loanAccountsUpdateToMeatCriteria
                    AND loan__Party_Type__c IN ('Borrower', 'Co-applicant', 'Guarantor')
                    AND (
                            loan__Contact__r.clcommon__Legal_Entity_Type__r.Name = 'Individual'
                            OR loan__Account__r.clcommon__Legal_Entity_Type__pr.Name = 'Individual'
                            OR loan__Account__r.clcommon__Legal_Entity_Type__r.Name = 'Individual'
                            OR loan__Contact__r.clcommon__Legal_Entity_Type__r.Name = 'individual'
                            OR loan__Account__r.clcommon__Legal_Entity_Type__pr.Name = 'individual'
                            OR loan__Account__r.clcommon__Legal_Entity_Type__r.Name = 'individual'
                    )
                    //ORDER BY Id
                    LIMIT :BATCH_SIZE
                    FOR UPDATE
            ];
        }


        System.debug('coborrowers.size() = ' + coborrowers.size());
        if (coborrowers.size() == 0) return;

        String template = '<!DOCTYPE html>\n' +
                '<html>\n' +
                '\n' +
                '<head>\n' +
                '</head>\n' +
                '\n' +
                '<body>\n' +
                '    <p>\n' +
                '        {14}\n' +
                '        <br>{15}\n' +
                '    </p>\n' +
                '    <h2>\n' +
                '        <span style="color: #05D7F2;">CHANGE TO YOUR INTEREST RATE</span>\n' +
                '    </h2>\n' +
                '    <p>\n' +
                '        <strong>RE: {16}</strong>\n' +
                '    </p>\n' +
                '    <p>\n' +
                '        Hi {0},\n' +
                '    </p>\n' +
                '    <p>\n' +
                '        Please be advised that the interest rate for your ORDE loan {1} will {2} from {3}% p.a. variable to {4}% p.a. variable effective {5}\n' +
                '    </p>\n' +
                '    <p>\n' +
                '        {17}\n' +
                '    </p>\n' +
                '    :begin:p1\n' +
                '    <p>\n' +
                '        Your current interest only minimum monthly repayment fluctuates from month to month as your repayment is equal to interest for the previous month calculated on the daily balances of the loan at the applicable interest rate.\n' +
                '    </p>\n' +
                '    <p>\n' +
                '        As your interest rate is {6}, so will your monthly interest charge and corresponding minimum monthly repayment. Your direct debit will continue to fluctuate and will incorporate this change.\n' +
                '    </p>\n' +
                '    :end:p1\n' +
                '    :begin:p2\n' +
                '    <p>\n' +
                '        Your current minimum monthly loan repayment is ${7}. Your new minimum monthly loan repayment, commencing {8} will be ${9}.\n' +
                '    </p>\n' +
                '    :end:p2\n' +
                '    :begin:p3\n' +
                '    <p>\n' +
                '        Your current minimum monthly loan repayment is ${10}. Your new minimum monthly loan repayment, commencing {11} will be ${12}.\n' +
                '    </p>\n' +
                '    :end:p3\n' +
                '    <p>\n' +
                '        If you have instructed ORDE to take your repayments via direct debit, the amount debited will adjust to meet the minimum monthly payment required unless you have previously instructed ORDE to take a higher amount. Direct debits taken weekly or fortnightly\n' +
                '        will also be adjusted accordingly to ensure you meet your minimum monthly repayment.\n' +
                '    </p>\n' +
                '    <p>\n' +
                '        Please note you need to maintain your ongoing repayment obligations to adhere to the terms and conditions of your mortgage. Failure to maintain your loan repayments may result in your loan facility moving into default. If you feel that you may fall behind\n' +
                '        with you loan repayments, please reach out to our Customer Assist team to see how we can support you.\n' +
                '    </p>\n' +
                '    <p>\n' +
                '        If you have any questions or require any additional information:\n' +
                '    </p>\n' +
                '    <ul>\n' +
                '        <li>\n' +
                '            <strong>My ORDE</strong> provides all your loan accounts, transaction view, statements and key account details. Interest rates will be updated at {13}.\n' +
                '        </li>\n' +
                '        <li>\n' +
                '            Our <strong>Customer Assist Team</strong> is immediately available to receive your call on <strong>03 8657 2560</strong> between the hours of 8.30 am to 5.30 pm, Monday to Friday Eastern Standard Time.\n' +
                '        </li>\n' +
                '    </ul>\n' +
                '    <p>\n' +
                '        Yours sincerely,\n' +
                '    </p>\n' +
                '    <p>\n' +
                '        <strong>ORDE Customer Assist Team</strong> ' +
                '        <br> <span style="color: #05D7F2;">Email</span> loan@orde.com.au <span style="color: #05D7F2;">Phone</span> 03 8657 2560\n' +
                '    </p>\n' +
                '    <p style="font-size: 9px;">\n' +
                '        ORDE Financial Pty Limited ACN 634 779 990 Australian Credit Licence 522079. ORDE Capital Management Limited ACN 636 165 378 Australian Financial Services Licence 523150 Australian Credit Licence 523150\n' +
                '    </p>\n' +
                '</body>\n' +
                '\n' +
                '</html>';

        String openingParagraph = Label.Interest_Change_Email_Opening_Paragraph.equalsIgnoreCase('Empty') ? '' : Label.Interest_Change_Email_Opening_Paragraph;

        Map<InvocableInterestRateChangeEmailDto, Task> emailInfoToTask = new Map<InvocableInterestRateChangeEmailDto, Task>();
        for (loan__Coborrower__c cb : coborrowers)
        {
            List<Object> dataToInterpolate = new List<Object>();
            if (cb.loan__Account__r.IsPersonAccount)
                dataToInterpolate.add(cb.loan__Account__r.FirstName);
            else
                    dataToInterpolate.add(cb.loan__Contact__r.FirstName);

            dataToInterpolate.add(cb.loan__Loan__r.Name);
            dataToInterpolate.add(cb.loan__Loan__r.New_Interest_Rate__c > cb.loan__Loan__r.loan__Interest_Rate__c ? 'increase' : 'decrease');
            dataToInterpolate.add(formatInterestRate(cb.loan__Loan__r.loan__Interest_Rate__c));
            dataToInterpolate.add(formatInterestRate(cb.loan__Loan__r.New_Interest_Rate__c));
            dataToInterpolate.add(formatDate(cb.loan__Loan__r.New_Interest_Rate_Effective_Date__c));

            dataToInterpolate.add(cb.loan__Loan__r.New_Interest_Rate__c > cb.loan__Loan__r.loan__Interest_Rate__c ? 'increasing' : 'decreasing');

            dataToInterpolate.add(formatCurrency(cb.loan__Loan__r.loan__Pmt_Amt_Cur__c));
            dataToInterpolate.add(formatDate(cb.loan__Loan__r.Second_Repayment_Date_After_IR_Change__c));
            dataToInterpolate.add(formatCurrency(cb.loan__Loan__r.Calculated_Upcoming_Repayment_Amount__c));

            dataToInterpolate.add(formatCurrency(cb.loan__Loan__r.loan__Pmt_Amt_Cur__c));
            dataToInterpolate.add(formatDate(cb.loan__Loan__r.First_Repayment_Date_After_IR_Change__c));
            dataToInterpolate.add(formatCurrency(cb.loan__Loan__r.Calculated_Upcoming_Repayment_Amount__c));

            dataToInterpolate.add(formatDate(cb.loan__Loan__r.New_Interest_Rate_Effective_Date__c));

            if (cb.loan__Account__r.IsPersonAccount)
            {
                dataToInterpolate.add(cb.loan__Account__r.Name);
                dataToInterpolate.add(cb.loan__Account__r.PersonEmail);
                dataToInterpolate.add(cb.loan__Loan__r.Name);
            }
            else
            {
                dataToInterpolate.add(cb.loan__Contact__r.Name);
                dataToInterpolate.add(cb.loan__Contact__r.Email);
                dataToInterpolate.add(cb.loan__Loan__r.Name);
            }

            dataToInterpolate.add(openingParagraph);

            InvocableInterestRateChangeEmailDto emailInfoDto = new InvocableInterestRateChangeEmailDto();
            if (cb.loan__Account__r.IsPersonAccount)
                emailInfoDto.to = cb.loan__Account__r.PersonEmail;
            else
                    emailInfoDto.to = cb.loan__Contact__r.Email;
            emailInfoDto.subject = 'CHANGE TO YOUR INTEREST RATE';

            if (cb.loan__Loan__r.Remaining_IO_Period__c > 1)
            {
                emailInfoDto.body = String.format(template, dataToInterpolate)
                        .replaceAll('\\n', '')
                        .replaceAll(':begin:p2.*:end:p2', '')
                        .replaceAll(':begin:p3.*:end:p3', '')
                        .replace(':begin:p1', '')
                        .replace(':end:p1', '');
            }
            else if (cb.loan__Loan__r.New_Interest_Rate__c > cb.loan__Loan__r.loan__Interest_Rate__c
                    && cb.loan__Loan__r.Remaining_IO_Period__c == 0
                    && Date.today().daysBetween(cb.loan__Loan__r.First_Repayment_Date_After_IR_Change__c) < 20)
            {
                emailInfoDto.body = String.format(template, dataToInterpolate)
                        .replaceAll('\\n', '')
                        .replaceAll(':begin:p1.*:end:p1', '')
                        .replaceAll(':begin:p3.*:end:p3', '')
                        .replace(':begin:p2', '')
                        .replace(':end:p2', '');
            }
            else if (cb.loan__Loan__r.Remaining_IO_Period__c == 0)
            {
                emailInfoDto.body = String.format(template, dataToInterpolate)
                        .replaceAll('\\n', '')
                        .replaceAll(':begin:p1.*:end:p1', '')
                        .replaceAll(':begin:p2.*:end:p2', '')
                        .replace(':begin:p3', '')
                        .replace(':end:p3', '');
            }
            else
            {
                continue;
            }

            System.debug('emailInfoDto.to = ' + emailInfoDto.to);
            if (emailInfoDto.to != null)
            {
                try
                {
                    if (!Test.isRunningTest())
                    {
                        Flow.Interview.Send_Email myFlow = new Flow.Interview.Send_Email(new Map<string, Object>{
                                'EmailData' => emailInfoDto
                        });
                        myFlow.start();
                        System.debug('Sent Email To: ' + emailInfoDto.to);
                    }
                }
                catch (Exception ex)
                {
                    System.debug('Failed to send Email');
                    continue;
                }
                Task t = new Task();
                t.ActivityDate = Date.today();
                t.Type = 'Email';
                t.Subject = 'Send Email';
                t.Description__c = 'Interest Rate Change Notice';
                t.WhoId = cb.loan__Contact__c;
                t.WhatId = cb.loan__Loan__c;
                t.Status = 'Completed';
                emailInfoToTask.put(emailInfoDto, t);
            }
            else
            {
                System.debug('Failed to send Email');
            }
        }

        insert emailInfoToTask.values();

        List<ContentVersion> contentVersionsToInsert = new List<ContentVersion>();
        for (InvocableInterestRateChangeEmailDto emailInfoDto : emailInfoToTask.keySet())
        {

            ContentVersion cv = new ContentVersion();
            cv.VersionData = Blob.toPdf(emailInfoDto.body);
            cv.ContentLocation = 'S';
            cv.FirstPublishLocationId = emailInfoToTask.get(emailInfoDto).Id;
            cv.Title = emailInfoDto.subject + ' ' + emailInfoDto.to + '.pdf';
            cv.PathOnClient = emailInfoDto.subject + ' ' + emailInfoDto.to + '.pdf';
            contentVersionsToInsert.add(cv);
        }
        insert contentVersionsToInsert;

        List<loan__Loan_Account__c> loanAccountsToUpdate = new List<loan__Loan_Account__c>();
        for (Id id : loanAccountsUpdateToMeatCriteria)
        {
            loan__Loan_Account__c la = new loan__Loan_Account__c();
            la.Id = id;
            la.Interest_Rate_Change_Notification_Date__c = Date.today();
            loanAccountsToUpdate.add(la);
        }
        update loanAccountsToUpdate;

        SendInterestRateChangeEmailsQueueble q = new SendInterestRateChangeEmailsQueueble();
        q.minimumIdExclusive = coborrowers[coborrowers.size() - 1].Id;
        q.loanAccountsUpdateToMeatCriteria = loanAccountsUpdateToMeatCriteria;
        if (!Test.isRunningTest())
            System.enqueueJob(q);
    }

    public void execute(FinalizerContext param1)
    {
        if (param1.getException() != null)
        {
            if (param1.getException().getMessage().contains('UNABLE_TO_LOCK_ROW'))
            {
                System.enqueueJob(this);
            }
        }
    }
}