(function(skuid){
skuid.snippet.register('SumOfExpenses',function(args) {var params = arguments[0],
	$ = skuid.$;
var appModel = skuid.model.getModel('CommonApplicationModel');
var appRow = appModel.data[0];

var mortgageModel = skuid.model.getModel('MortgageModel');
var mortgageRow = mortgageModel.data[0];

var debtModel= skuid.model.getModel('DebtConsolidation');
var debtRow = debtModel.data[0];

var totalAmount =0, mortgageSum =0, debtSum=0;

$.each(mortgageModel.getRows(),function(i,row){
       mortgageSum = mortgageSum + row.Refinance_Mortgages_Amount__c;
});
$.each(debtModel.getRows(),function(i,row){
       debtSum = debtSum + row.Refinance_Consolidation_Amount__c;
});
if(appRow.House_dewelling_Amount__c === null || appRow.House_dewelling_Amount__c === undefined || appRow.House_dewelling_Amount__c ===''){
    appRow.House_dewelling_Amount__c =0.00;
}
if(appRow.Other_dewelling_Amount__c === null || appRow.Other_dewelling_Amount__c === undefined || appRow.Other_dewelling_Amount__c ===''){
    appRow.Other_dewelling_Amount__c =0.00;
}
if(appRow.Purchase_Existing_Amount__c === null || appRow.Purchase_Existing_Amount__c === undefined || appRow.Purchase_Existing_Amount__c ===''){
    appRow.Purchase_Existing_Amount__c =0.00;
}
if(appRow.Purchase_New_Amount__c === null || appRow.Purchase_New_Amount__c === undefined || appRow.Purchase_New_Amount__c ===''){
    appRow.Purchase_New_Amount__c =0.00;
}
if(appRow.Purchase_Off_the_Plan_Amount__c === null || appRow.Purchase_Off_the_Plan_Amount__c === undefined || appRow.Purchase_Off_the_Plan_Amount__c ===''){
    appRow.Purchase_Off_the_Plan_Amount__c =0.00;
}
if(appRow.Buy_Asset_Investment_Amount__c === null || appRow.Buy_Asset_Investment_Amount__c === undefined || appRow.Buy_Asset_Investment_Amount__c ===''){
    appRow.Buy_Asset_Investment_Amount__c =0.00;
}

if(appRow.Marketing_Advertising_Amount__c === null || appRow.Marketing_Advertising_Amount__c === undefined || appRow.Marketing_Advertising_Amount__c ===''){
    appRow.Marketing_Advertising_Amount__c =0.00;
}

if(appRow.Business_Other_Amount__c === null || appRow.Business_Other_Amount__c === undefined || appRow.Business_Other_Amount__c ===''){
    appRow.Business_Other_Amount__c =0.00;
}

if(appRow.Purchase_Business_Amount__c === null || appRow.Purchase_Business_Amount__c === undefined || appRow.Purchase_Business_Amount__c ===''){
    appRow.Purchase_Business_Amount__c =0.00;
}

if(appRow.Working_Capital_Amount__c === null || appRow.Working_Capital_Amount__c === undefined || appRow.Working_Capital_Amount__c ===''){
    appRow.Working_Capital_Amount__c =0.00;
}

if(appRow.Divorce_Settlement_Amount__c === null || appRow.Divorce_Settlement_Amount__c === undefined || appRow.Divorce_Settlement_Amount__c ===''){
    appRow.Divorce_Settlement_Amount__c =0.00;
}

if(appRow.Holiday_Travel_Amount__c === null || appRow.Holiday_Travel_Amount__c === undefined || appRow.Holiday_Travel_Amount__c ===''){
    appRow.Holiday_Travel_Amount__c =0.00;
}

if(appRow.Home_Imaprovements_Amount__c === null || appRow.Home_Imaprovements_Amount__c === undefined || appRow.Home_Imaprovements_Amount__c ===''){
    appRow.Home_Imaprovements_Amount__c =0.00;
}

if(appRow.Cash_Out_Other_Amount__c === null || appRow.Cash_Out_Other_Amount__c === undefined || appRow.Cash_Out_Other_Amount__c ===''){
    appRow.Cash_Out_Other_Amount__c =0.00;
}
if(appRow.Personal_Investments_Amount__c === null || appRow.Personal_Investments_Amount__c === undefined || appRow.Personal_Investments_Amount__c ===''){
    appRow.Personal_Investments_Amount__c =0.00;
}
if(appRow.Property_Purchase_Amount__c === null || appRow.Property_Purchase_Amount__c === undefined || appRow.Property_Purchase_Amount__c ===''){
    appRow.Property_Purchase_Amount__c =0.00;
}
if(appRow.Purchase_Goods_Amount__c === null || appRow.Purchase_Goods_Amount__c === undefined || appRow.Purchase_Goods_Amount__c ===''){
    appRow.Purchase_Goods_Amount__c =0.00;
}else{
    totalAmount= appRow.House_dewelling_Amount__c + appRow.Other_dewelling_Amount__c + appRow.Purchase_Existing_Amount__c + appRow.Purchase_New_Amount__c +
                  appRow.Purchase_Off_the_Plan_Amount__c + appRow.Buy_Asset_Investment_Amount__c + appRow.Marketing_Advertising_Amount__c +
                  appRow.Business_Other_Amount__c + appRow.Purchase_Business_Amount__c + appRow.Working_Capital_Amount__c + appRow.Divorce_Settlement_Amount__c +
                  appRow.Holiday_Travel_Amount__c + appRow.Home_Imaprovements_Amount__c + appRow.Cash_Out_Other_Amount__c + appRow.Personal_Investments_Amount__c +
                  appRow.Property_Purchase_Amount__c + mortgageSum + debtSum + appRow.Purchase_Goods_Amount__c;
}
appModel.updateRow(appRow ,
                {'TotalAmount': totalAmount});
});
/*console.log('I am in inline JS');
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
		var params = arguments[0],
    	$ = skuid.$;
        var appModel = skuid.model.getModel('CommonApplicationModel');
        var appRow = appModel.data[0];
        
        var mortgageModel = skuid.model.getModel('MortgageModel');
        var mortgageRow = mortgageModel.data[0];
        
        var debtModel= skuid.model.getModel('DebtConsolidation');
        var debtRow = debtModel.data[0];
        
        var totalAmount =0, mortgageSum =0, debtSum=0;
        
        $.each(mortgageModel.getRows(),function(i,row){
               mortgageSum = mortgageSum + row.Refinance_Mortgages_Amount__c;
        });
        $.each(debtModel.getRows(),function(i,row){
               debtSum = debtSum + row.Refinance_Consolidation_Amount__c;
        });totalAmount= mortgageSum + debtSum;
        console.log('Before Timeout');
        appModel.updateRow(appRow ,
                        {'TotalAmount': totalAmount});
        });
        
})(skuid);*/;
}(window.skuid));