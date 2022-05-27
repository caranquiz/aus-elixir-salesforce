(function(skuid){
skuid.snippet.register('DataLockingConfirmationPopupLoanDetails',function(args) {var con = false;	
var appModel2 = skuid.model.getModel('CommonApplicationLoanDetails');
var appRowRel = appModel2.data[0];
if(appRowRel.genesis__Status__c === 'Formally Approved'){
    var con = confirm('Are you sure? The application will be locked down after this action.');
    return con;
}
});
skuid.snippet.register('SumOfExpenses',function(args) {var params = arguments[0],
	$ = skuid.$;
var appModel = skuid.model.getModel('CommonApplicationLoanDetails');
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
/*appModel.updateRow(appRow ,
                {'TotalAmount': totalAmount});*/
appModel.updateRow(appRow ,
                {'Total_Loan_Purpose_Amount__c': totalAmount});
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
        
        appModel.updateRow(appRow ,
                        {'TotalAmount': totalAmount});
        });
        
})(skuid);*/;
skuid.snippet.register('approvedReload',function(args) {var params = arguments[0],
	$ = skuid.$;
var appModel = skuid.model.getModel('CommonApplicationLoanDetails');
var appRow = appModel.data[0];
if(appRow.genesis__Status__c === 'Formally Approved'){
    var collModel = skuid.model.getModel('AllCollModel');
    var spModel = skuid.model.getModel('S_P_Model');
    var qbeModel = skuid.model.getModel('QBEModel');
    if(collModel !== undefined && collModel !== null && collModel.data.length !== 0){
        $.each(collModel.data,function(i,row){
            if(row.clcommon__Postal_Code__c !== undefined && row.clcommon__Postal_Code__c !== ''){
                if(spModel !== undefined && spModel !== null && spModel.data.length !== 0){
                    $.each(spModel.data,function(i,spRow){
                        if(spRow.PostCode_High_RangeNumber__c >= row.clcommon__Postal_Code__c && spRow.PostCode_Low_RangeNumber__c <= row.clcommon__Postal_Code__c){
                            collModel.updateRow(row,'S_P_Location__c',spRow.Location__c);
                        }
                    });
                }
                if(qbeModel !== undefined && qbeModel !== null && qbeModel.data.length !== 0){
                    $.each(qbeModel.data,function(i,qbeRow){
                        if(qbeRow.PostCode_High_RangeNumber__c >= row.clcommon__Postal_Code__c && qbeRow.PostCode_Low_RangeNumber__c <= row.clcommon__Postal_Code__c){
                            collModel.updateRow(row,'QBE_Location__c',qbeRow.Location__c);
                        }
                    });
                }
            }
        });
        skuid.model.save([
               collModel
        ]) ;
    }
    window.location.reload(true);
}
});
}(window.skuid));