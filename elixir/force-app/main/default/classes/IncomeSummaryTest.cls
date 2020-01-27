@isTest
public with sharing class IncomeSummaryTest{
        static testMethod void test1() {
                Test.startTest();
                genesis__applications__c appObj = new genesis__applications__c();
                insert appObj;

                RecordType rec = [Select id, name,sobjectType,
                                                        DeveloperName 
                                                        from RecordType 
                                                        Where sobjectType = 'genesis__Employment_Information__c' 
                                                        AND DeveloperName='Self_Employed'];

                genesis__Employment_Information__c empObj = new genesis__Employment_Information__c();
                empObj.Document_Type__c= 'Full';
                empObj.RecordTypeId = rec.id;
                Insert empobj;

                genesis__Income__c incomeobj = new genesis__Income__c();
                incomeobj.genesis__Application__c =appObj.id;
                incomeobj.Employment_Information__c= empobj.id;
                Insert incomeobj;             

                IncomeSummary.summaryValue(appObj.id);
                Test.stopTest(); 
        }

        static testMethod void test2() {
                Test.startTest();
                genesis__applications__c appObj = new genesis__applications__c();
                insert appObj;

                RecordType rec = [Select id, name,sobjectType,
                                                        DeveloperName 
                                                        from RecordType 
                                                        Where sobjectType = 'genesis__Employment_Information__c' 
                                                        AND DeveloperName='Self_Employed'];

                genesis__Employment_Information__c empObj = new genesis__Employment_Information__c();
                empObj.Document_Type__c= 'Full';
                empObj.RecordTypeId = rec.id;
                Insert empobj;

                genesis__Income__c incomeobj = new genesis__Income__c();
                incomeobj.genesis__Application__c =appObj.id;
                incomeobj.Employment_Information__c= empobj.id;
                Insert incomeobj;             

                IncomeSummary.IncomeSummarySkuidCallout(appObj.id);
                Test.stopTest(); 
        }
         static testMethod void test3() {
                Test.startTest();
                genesis__applications__c appObj = new genesis__applications__c();
                insert appObj;

                RecordType rec = [Select id, name,sobjectType,
                                                        DeveloperName 
                                                        from RecordType 
                                                        Where sobjectType = 'genesis__Employment_Information__c' 
                                                        AND DeveloperName='Self_Employed'];

                genesis__Employment_Information__c empObj = new genesis__Employment_Information__c();
                empObj.Document_Type__c= 'Full';
                empObj.RecordTypeId = rec.id;
                Insert empobj;

                genesis__Income__c incomeobj = new genesis__Income__c();
                incomeobj.genesis__Application__c =appObj.id;
                incomeobj.Employment_Information__c= empobj.id;           

                IncomeSummary.summaryValue(appObj.id);
                Test.stopTest(); 
        }
}