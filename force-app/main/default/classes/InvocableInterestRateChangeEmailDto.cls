/**
 * Created by caleb on 08/06/2022.
 */

public with sharing class InvocableInterestRateChangeEmailDto
{
    @InvocableVariable
    @AuraEnabled
    public String to;
    @InvocableVariable
    @AuraEnabled
    public String subject;
    @InvocableVariable
    @AuraEnabled
    public String body;
}