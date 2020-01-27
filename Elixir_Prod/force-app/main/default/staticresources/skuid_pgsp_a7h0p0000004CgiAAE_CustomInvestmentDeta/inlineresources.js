(function(skuid){
skuid.snippet.register('convertToLoan',function(args) {var params = arguments[0],
	$ = skuid.$;
var appModel = skuid.model.getModel('CommonApplicationModel');
var appRow = appModel.data[0];
var agree = confirm("Are you sure?");
var shareModel = skuid.model.getModel('Shareholder');
var accModel = skuid.model.getModel('BorrowerAccount');
var accRow = accModel.data[0];
var totalShare = 0;

var wareModel = skuid.model.getModel('LoanWarehouse');
var wareRow = wareModel.data[0];

$.each(shareModel.data,function(i,row){
    totalShare = row.Share__c + totalShare;
});
if(appRow.Legal_Entity__r.Name == 'Company'){
    if(totalShare >= 75 && totalShare <= 100){
        if(agree){ 
            $.blockUI({
                message: 'Please wait! Loan Contract is being generated!',
                onBlock:function(){
                    convertAppToContract(updateWarehouse) ;
                    updateWarehouse() ;
                  //  alert(ret);
                }
            });
           // window.location.reload();
        }
    }
    else{
        alert('The share percentage should be more than 75% and less than 100%.');
    }
}
else{
    if(agree){ 
        if(accRow.Bank_Account_Name__c !== null || accRow.Bank_Account_Name__c !== undefined || accRow.Bank_Account_Number__c !== null || accRow.Bank_Account_Number__c !== undefined || accRow.BSB__c !== null || accRow.BSB__c !== undefined || accRow.Bank_Name__c || accRow.Bank_Name__c !== undefined){
            $.blockUI({
                message: 'Please wait! Loan Contract is being generated!',
                onBlock:function(){
                    convertAppToContract(updateWarehouse) ;
                    updateWarehouse() ;
                  //  alert(ret);
                }
            });
            //window.location.reload();
        }
        else{
            alert('Please add bank account details of the borrower.');
        }
    }
}
//window.location.reload();

//Apex Call
function convertAppToContract(updateWarehouse){
    var ret = sforce.apex.execute('ConvertToContract','executeFun',
    {
        appId : appRow.Id
    });
    alert(ret);
    if(ret =='Application is converted to contract successfully'){
       updateWarehouse();
       $.unblockUI();  
    }
    else{
           $.unblockUI();  
           alert('Convert to loan failed : '+ret);
           //window.location.reload();
       }
}

//Update Warehouse
function updateWarehouse(){
    //App Requery to get the Contract
    var soql = "select Id,CL_Contract__c from genesis__Applications__c where Id = '" + appRow.Id + "'";
   var resultapp = sforce.connection.query(soql);
   var apprecord = resultapp.getArray("records");
    $.each(wareModel.getRows(),function(i,row){
        if(row.Active__c === true){
            wareModel.updateRow(row,{CL_Contract__c: apprecord[0].CL_Contract__c}) ;
        //    row.CL_Contract__c = apprecord[0].CL_Contract__c ;
         }
    });
    wareModel.save();
    //window.location.reload();
    appModel.updateData();
}
});
skuid.snippet.register('LoanApplicationConvert',function(args) {var params = arguments[0],
	$ = skuid.$;
var appModel = skuid.model.getModel('CommonApplicationModel');
var appRow = appModel.data[0];


var agree = confirm("Are you sure ?");
if (agree){
    var shareModel = skuid.model.getModel('Shareholder');
    var totalShare = 0;
    $.each(shareModel.data,function(i,row){
        totalShare = row.Share__c + totalShare;
    });
    console.log('appRow.Legal_Entity__r.Name'+appRow.Legal_Entity__r.Name);
    if(appRow.Legal_Entity__r.Name == 'Company'){
        if(totalShare >= 75 && totalShare <= 100){
            console.log('Percentage is greater!');
            $.blockUI({
               message: 'Please wait!  Application is listing to marketplace...',
               onBlock:function(){
                    try {
                        var ret = sforce.apex.execute('LoanApplicationConvert','convertLoanApplicationCtrl',
                        {   
                            appId : appRow.Id
                        });
                        if(ret[0].includes('Application Converted Successfully.')){
                            alert(ret);
                            console.log('appRow.CL_Contract__c-----'+appRow.CL_Contract__c);
                            $.unblockUI();
                            //window.location.reload();
                            appModel.updateData();
                            // ======
                            
                            
                            // =====
                        }else{
                            alert(ret);
                            $.unblockUI();
                        }
                    } 
                    catch(err) {
                        alert(err);
                        $.unblockUI();
                    }
               }
            });
        }
        else{
            alert('The share percentage should be more than 75%.');
        }
    }
    else{
        $.blockUI({
           message: 'Please wait!  Application is listing to marketplace...',
           onBlock:function(){
                try {
                    if(appRow.genesis__Account__r.Bank_Account_Name__c !== null || appRow.genesis__Account__r.Bank_Account_Name__c !== undefined || appRow.genesis__Account__r.Bank_Account_Number__c !== null || appRow.genesis__Account__r.Bank_Account_Number__c !== undefined || appRow.genesis__Account__r.BSB__c !== null || appRow.genesis__Account__r.BSB__c !== undefined || appRow.genesis__Account__r.Bank_Name__c || appRow.genesis__Account__r.Bank_Name__c !== undefined){
                        console.log('Inside else block===');
                        var ret = sforce.apex.execute('LoanApplicationConvert','convertLoanApplicationCtrl',
                        {   
                            appId : appRow.Id
                        });
                        if(ret[0].includes('Application Converted Successfully.')){
                            alert(ret);
                            console.log('appRow.CL_Contract__c-----'+appRow.CL_Contract__c);
                            
                            $.unblockUI();
                            //window.location.reload();
                            appModel.updateData();
                            
                            // =======
                            
                            // =======
                        }else{
                            alert(ret);
                            $.unblockUI();
                        }
                    }
                    else{
                        alert('Please add bank account details of the borrower.');
                    }
                } 
                catch(err) {
                    alert(err);
                    $.unblockUI();
                }
           }
        });
    }
}
});
skuid.snippet.register('InvestorFunding',function(args) {var params = arguments[0],
	$ = skuid.$;
var appModel1 = skuid.model.getModel('LoanApplication');
var appRow1 = appModel1.data[0];
var appModel = skuid.model.getModel('CommonApplicationModel');
var appRow = appModel.data[0];
var ret = '';
var agree = confirm("Are you sure ?");
if (agree){
    $.blockUI({
       message: 'Please wait!  The loan is getting funded!',
       onBlock:function(){
            try {
                if(appRow.genesis__CL_Product_Name__c	!= 'Construction Development' && appRow.genesis__CL_Product_Name__c	!= 'Residential Construction'){
                        ret = sforce.apex.execute('Invest','makeAllInvestment',
                        {   
                            iden : appRow1.Id
                        });
                         //console.log('I am here 0');
                        alert(ret);
                }
                else{
                    if((appRow.genesis__CL_Product_Name__c	=== 'Construction Development' || appRow.genesis__CL_Product_Name__c === 'Residential Construction') && appRow.First_Drawdown_Complete__c === false){
                        if(appRow.genesis__Initial_Advance__c !== null && appRow.genesis__Initial_Advance__c !== undefined && appRow.First_Tranche_Prepaid_Interest__c !== null && appRow.First_Tranche_Prepaid_Interest__c !== undefined){
                            ret = sforce.apex.execute('Invest','makeAllInvestment',
                                {   
                                    iden : appRow1.Id
                                });
                             //console.log('I am here 1');
                        }
                        else{
                            ret = 'Please provide the Initial Advance Amount and Initial Tranche Amount before trying to fund the loan.';
                            //console.log('I am here 1');
                        }
                    }
                    else if((appRow.genesis__CL_Product_Name__c	=== 'Construction Development' || appRow.genesis__CL_Product_Name__c === 'Residential Construction') && appRow.First_Drawdown_Complete__c	=== true){
                        if(appRow.Subsequent_Drawdown__c !== null && appRow.Subsequent_Drawdown__c !== undefined && appRow.Drawdown_Prepaid_Interest__c !== null && appRow.Drawdown_Prepaid_Interest__c !== undefined && appRow.Construction_Progress_Payment_Fee__c !== null && appRow.Construction_Progress_Payment_Fee__c !== undefined){
                            //console.log('I am here 3');
                            if(appRow.Total_Construction_Progress_Payment_Fee__c >= (appRow.Utilised_Subsequent_Drawdown_Prepaid_Fee__c + appRow.Construction_Progress_Payment_Fee__c) && appRow.Total_Subsequent_Drawdown__c >= (appRow.Paid_Subsequent_Drawdown__c+appRow.Subsequent_Drawdown__c) && appRow.Subsequent_Drawdown_Prepaid_Interest_Sum__c >= (appRow.Paid_Subsequent_Drawdown_PrepaidInterest__c+appRow.Drawdown_Prepaid_Interest__c)){
                                ret = sforce.apex.execute('Invest','makeAllInvestment',
                                {   
                                    iden : appRow1.Id
                                });
                            //console.log('I am here 4');
                            }
                            else{
                                ret = 'The subsequent drawdown amount, progress payment fee and subsequent drawdown prepaid interest should be within limits.';
                            
                                //console.log('I am here 5');
                            }
                        }
                        else{
                            ret = 'Please provide the Subsequent Drawdown Amount, Subsequent Prepaid Interest Amount and Construction Progress Payment Fee before trying fund the tranche amount';
                        
                            //console.log('I am here 6');
                        }
                    }
                    
                }
                alert(ret);
                $.unblockUI();
            }
            catch(err) {
                alert(err);
                $.unblockUI();
            }
        }
    });
}
//window.location.reload();
appModel.updateData();
});
skuid.snippet.register('WarehouseFunding',function(args) {var params = arguments[0],
$ = skuid.$;
var appModel = skuid.model.getModel('CommonApplicationModel');
var appRow = appModel.data[0];
var loanWarehouseModel = skuid.model.getModel('ActiveWarehouseInvestor');
var loanWarehouseRow = loanWarehouseModel.data[0];
var agree = confirm('Are you sure?');
var ret;

if(agree){
    appModel.updateData();
    if(loanWarehouseRow !== undefined){
        $.blockUI({
            message: 'Thank you for your patience! Loan is getting funded by the Warehouse.',
            onBlock:function(){
                try{
                    if(appRow.genesis__CL_Product_Name__c	!= 'Construction Development' && appRow.genesis__CL_Product_Name__c	!= 'Residential Construction'){
                        ret = sforce.apex.execute('WarehouseFunding','executeFun',
                          {   
                             iden : appRow.CL_Contract__c,
                             investor : loanWarehouseRow.Warehouse__c
                         });
                         console.log('I am here 0'+appRow.CL_Contract__c);
                        alert(ret);
                    }
                    else{
                        if((appRow.genesis__CL_Product_Name__c	=== 'Construction Development' || appRow.genesis__CL_Product_Name__c === 'Residential Construction') && appRow.First_Drawdown_Complete__c === false){
                            if(appRow.genesis__Initial_Advance__c !== null && appRow.genesis__Initial_Advance__c !== undefined && appRow.First_Tranche_Prepaid_Interest__c !== null && appRow.First_Tranche_Prepaid_Interest__c !== undefined){
                                ret = sforce.apex.execute('WarehouseFunding','executeFun',
                                  {   
                                     iden : appRow.CL_Contract__c,
                                     investor : loanWarehouseRow.Warehouse__c
                                 });
                                 console.log('I am here 1');
                            }
                            else{
                                ret = 'Please provide the Initial Advance Amount and Initial Tranche Amount before trying to fund the loan.';
                                console.log('I am here 1');
                            }
                        }
                        else if((appRow.genesis__CL_Product_Name__c	=== 'Construction Development' || appRow.genesis__CL_Product_Name__c === 'Residential Construction') && appRow.First_Drawdown_Complete__c	=== true){
                             if(appRow.Subsequent_Drawdown__c !== null && appRow.Subsequent_Drawdown__c !== undefined && appRow.Drawdown_Prepaid_Interest__c !== null && appRow.Drawdown_Prepaid_Interest__c !== undefined && appRow.Construction_Progress_Payment_Fee__c !== null && appRow.Construction_Progress_Payment_Fee__c !== undefined){
                                console.log('I am here 3');
                                if(appRow.Total_Construction_Progress_Payment_Fee__c >= (appRow.Utilised_Subsequent_Drawdown_Prepaid_Fee__c + appRow.Construction_Progress_Payment_Fee__c) && appRow.Total_Subsequent_Drawdown__c >= (appRow.Paid_Subsequent_Drawdown__c+appRow.Subsequent_Drawdown__c) && appRow.Subsequent_Drawdown_Prepaid_Interest_Sum__c >= (appRow.Paid_Subsequent_Drawdown_PrepaidInterest__c+appRow.Drawdown_Prepaid_Interest__c)){
                                    ret = sforce.apex.execute('WarehouseFunding','executeFun',
                                      {   
                                         iden : appRow.CL_Contract__c,
                                         investor : loanWarehouseRow.Warehouse__c
                                     });
                                console.log('I am here 4');
                                }
                                else{
                                    ret = 'The subsequent drawdown amount, progress payment fee and subsequent drawdown prepaid interest should be within limits.';
                                
                                    console.log('I am here 5');
                                }
                            }
                            else{
                                ret = 'Please provide the Subsequent Drawdown Amount, Subsequent Prepaid Interest Amount and Construction Progress Payment Fee before trying fund the tranche amount';
                            
                                console.log('I am here 6');
                            }
                        }
                        
                    }
                    alert(ret);
                    $.unblockUI();
                }
                catch(err) {
                    alert(err);
                    console.log(err);
                    $.unblockUI();
                }
            }
        });
    }
    else{
        alert('Warehouse not attached!');
    }
}
//window.location.reload();
appModel.updateData();
});
skuid.snippet.register('updateWarehouse',function(args) {var params = arguments[0],
	$ = skuid.$;
var appModel = skuid.model.getModel('CommonApplicationModel');
var appRow = appModel.data[0];

var wareModel = skuid.model.getModel('LoanWarehouse');
var wareRow = wareModel.data[0];
console.log(wareModel);

$.each(wareModel.getRows(),function(i,row){
                                if(row.Active__c === true){
                                    console.log('inside Active row====');
                                    console.log(appRow.CL_Contract__c);
                                    row.CL_Contract__c = appRow.CL_Contract__c;
                                 }
                            });

                            wareModel.save();
});
skuid.snippet.register('LoanWarehouseReloadSnippet',function(args) {var params = arguments[0],
	$ = skuid.$;

var appModel = skuid.model.getModel('LoanWarehouse');
appModel.updateData();
var appModel1 = skuid.model.getModel('ActiveWarehouseInvestor');
appModel1.updateData();
var appModel2 = skuid.model.getModel('CommonApplicationModel');
appModel2.updateData();
});
}(window.skuid));