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
if(accRow.Bank_Account_Name__c !== null && accRow.Bank_Account_Name__c !== undefined && accRow.Bank_Account_Number__c !== null && accRow.Bank_Account_Number__c !== undefined && accRow.BSB__c !== null && accRow.BSB__c !== undefined){
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
}
else{
    alert('Please provide the bank account details!');
}

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
    if(appRow.Legal_Entity__r.Name == 'Company'){
        if(totalShare >= 75 && totalShare <= 100){
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
                        var ret = sforce.apex.execute('LoanApplicationConvert','convertLoanApplicationCtrl',
                        {   
                            appId : appRow.Id
                        });
                        if(ret[0].includes('Application Converted Successfully.')){
                            alert(ret);
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
var branch = skuid.model.getModel('SystemBranch');
var branchRow = branch.getFirstRow();
var ret = '';
var agree = confirm("Are you sure ?");
if (agree){
    appModel.updateData();
    $.blockUI({
       message: 'Thank you for your patience! Loan is getting funded by the Investor',
       onBlock:function(){
            try {
                if(branchRow.loan__Current_System_Date__c === appRow.genesis__Expected_Start_Date__c){
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
                            }
                            else{
                                ret = 'Please provide the Initial Advance Amount and Initial Tranche Amount before trying to fund the loan.';
                            }
                        }
                        else if((appRow.genesis__CL_Product_Name__c	=== 'Construction Development' || appRow.genesis__CL_Product_Name__c === 'Residential Construction') && appRow.First_Drawdown_Complete__c	=== true){
                            if(appRow.Subsequent_Drawdown__c !== null && appRow.Subsequent_Drawdown__c !== undefined && appRow.Drawdown_Prepaid_Interest__c !== null && appRow.Drawdown_Prepaid_Interest__c !== undefined && appRow.Construction_Progress_Payment_Fee__c !== null && appRow.Construction_Progress_Payment_Fee__c !== undefined){
                               if(appRow.Total_Subsequent_Drawdown__c >= (appRow.Paid_Subsequent_Drawdown__c+appRow.Subsequent_Drawdown__c+appRow.Utilised_Subsequent_Drawdown_Prepaid_Fee__c + appRow.Construction_Progress_Payment_Fee__c) && appRow.Subsequent_Drawdown_Prepaid_Interest_Sum__c >= (appRow.Paid_Subsequent_Drawdown_PrepaidInterest__c+appRow.Drawdown_Prepaid_Interest__c)){
                                    ret = sforce.apex.execute('Invest','makeAllInvestment',
                                    {   
                                        iden : appRow1.Id
                                    });
                                }
                                else{
                                    ret = 'The subsequent drawdown amount, progress payment fee and subsequent drawdown prepaid interest should be within limits.';
                                }
                            }
                            else{
                                ret = 'Please provide the Subsequent Drawdown Amount, Subsequent Prepaid Interest Amount and Construction Progress Payment Fee before trying fund the tranche amount';
                            }
                        }
                    }
                }
                else{
                    ret = 'Please enter Settlement Date as Current System Date in order to proceed.';
                }
                alert(ret);
                $.unblockUI();
                appModel.updateData();
            }
            catch(err) {
                alert(err);
                $.unblockUI();
                appModel.updateData();
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
var branch = skuid.model.getModel('SystemBranch');
var branchRow = branch.getFirstRow();
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
                    if(branchRow.loan__Current_System_Date__c === appRow.genesis__Expected_Start_Date__c){
                        if(appRow.genesis__CL_Product_Name__c	!= 'Construction Development' && appRow.genesis__CL_Product_Name__c	!= 'Residential Construction'){
                            ret = sforce.apex.execute('WarehouseFunding','executeFun',
                              {   
                                 iden : appRow.CL_Contract__c,
                                 investor : loanWarehouseRow.Warehouse__c
                             });
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
                                }
                                else{
                                    ret = 'Please provide the Initial Advance Amount and Initial Tranche Amount before trying to fund the loan.';
                                }
                            }
                            else if((appRow.genesis__CL_Product_Name__c	=== 'Construction Development' || appRow.genesis__CL_Product_Name__c === 'Residential Construction') && appRow.First_Drawdown_Complete__c	=== true){
                                 if(appRow.Subsequent_Drawdown__c !== null && appRow.Subsequent_Drawdown__c !== undefined && appRow.Drawdown_Prepaid_Interest__c !== null && appRow.Drawdown_Prepaid_Interest__c !== undefined && appRow.Construction_Progress_Payment_Fee__c !== null && appRow.Construction_Progress_Payment_Fee__c !== undefined){
                                    if(appRow.Total_Subsequent_Drawdown__c >= (appRow.Paid_Subsequent_Drawdown__c+appRow.Subsequent_Drawdown__c+appRow.Utilised_Subsequent_Drawdown_Prepaid_Fee__c + appRow.Construction_Progress_Payment_Fee__c) && appRow.Subsequent_Drawdown_Prepaid_Interest_Sum__c >= (appRow.Paid_Subsequent_Drawdown_PrepaidInterest__c+appRow.Drawdown_Prepaid_Interest__c)){
                                        ret = sforce.apex.execute('WarehouseFunding','executeFun',
                                          {   
                                             iden : appRow.CL_Contract__c,
                                             investor : loanWarehouseRow.Warehouse__c
                                         });
                                    }
                                    else{
                                        ret = 'The subsequent drawdown amount, progress payment fee and subsequent drawdown prepaid interest should be within limits.';
                                    }
                                }
                                else{
                                    ret = 'Please provide the Subsequent Drawdown Amount, Subsequent Prepaid Interest Amount and Construction Progress Payment Fee before trying fund the tranche amount';
                                }
                            }
                            
                        }
                    }
                    else{
                        ret = 'Please enter Settlement Date as Current System Date in order to proceed.';
                    }
                    alert(ret);
                    $.unblockUI();
                    appModel.updateData();
                }
                catch(err) {
                    alert(err);
                    $.unblockUI();
                    appModel.updateData();
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

$.each(wareModel.getRows(),function(i,row){
    if(row.Active__c === true){
        row.CL_Contract__c = appRow.CL_Contract__c;
     }
});
wareModel.save();
});
skuid.snippet.register('LoanWarehouseReloadSnippet',function(args) {var params = arguments[0],
	$ = skuid.$;
var appModel2 = skuid.model.getModel('CommonApplicationModel');
appModel2.updateData();
var appModel = skuid.model.getModel('LoanWarehouse');
appModel.updateData();
var appModel1 = skuid.model.getModel('ActiveWarehouseInvestor');
appModel1.updateData();
var appRowRel = appModel2.data[0];
if(appRowRel.genesis__Status__c === 'Formally Approved' || appRowRel.genesis__Status__c === 'Recommended'){
    if(appRowRel.genesis__Status__c === 'Formally Approved'){
        var collModel = skuid.model.getModel('CheckCollateral');
        var spModel = skuid.model.getModel('CusSetSAndP');
        var qbeModel = skuid.model.getModel('CusSetQBE');
        if(collModel !== undefined && collModel.data.length !== 0){
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
    }
    window.location.reload(true);
}
});
skuid.snippet.register('DataLockingConfirmationPopup',function(args) {var con = false;	
var appModel2 = skuid.model.getModel('CommonApplicationModel');
var appRowRel = appModel2.data[0];
if(appRowRel.genesis__Status__c === 'Formally Approved'){
    var con = confirm('Are you sure? The application will be locked down after this action.');
    return con;
}
});
skuid.snippet.register('populate',function(args) {var appliModel = skuid.model.getModel('CommonApplicationModel');
var appliRow = appliModel.data[0];
var dt = new Date(appliRow.genesis__Expected_Start_Date__c);
var days = [31,28,31,30,31,30,31,31,30,31,30,31];
if((dt.getFullYear())/4 === 0 && dt.getMonth()+1 == 2){
    days[1]=29;
}
var dueDay = dt.getDate();
var mon = dt.getMonth();
var day = dt.getDate();
if(dt.getMonth() !== 11){
    if(dt.getDate() > days[(dt.getMonth()+1)]){
        if(dt.getMonth() == 11){
            appliRow.genesis__Expected_First_Payment_Date__c = dt.setDate(days[0]);
            appliRow.genesis__Expected_First_Payment_Date__c = dt.setMonth(1);
        }
        else{
            appliRow.genesis__Expected_First_Payment_Date__c = dt.setDate(days[(dt.getMonth())+1]);
            appliRow.genesis__Expected_First_Payment_Date__c = dt.setMonth(dt.getMonth()+2);
        }
    }
    else {
        if(dt.getMonth() == 11){
            appliRow.genesis__Expected_First_Payment_Date__c = dt.setDate(days[0]);
            appliRow.genesis__Expected_First_Payment_Date__c = dt.setMonth(1);
        }
        else if(dt.getMonth() == 10){
            appliRow.genesis__Expected_First_Payment_Date__c = dt.setMonth((dt.getMonth()+1));
        }
        else if(dt.getMonth() == 9){
            appliRow.genesis__Expected_First_Payment_Date__c = dt.setMonth((dt.getMonth()+1));
        }
        else if(dt.getMonth() == 8){
            appliRow.genesis__Expected_First_Payment_Date__c = dt.setMonth((dt.getMonth()+2));
        }
        else if(dt.getMonth() == 6 && dt.getDate() == 31){
            appliRow.genesis__Expected_First_Payment_Date__c = dt.setMonth(8);
            appliRow.genesis__Expected_First_Payment_Date__c = dt.setDate(31);
        }
        else{
            appliRow.genesis__Expected_First_Payment_Date__c = dt.setMonth((dt.getMonth()+2));
        }
    }
}
else{
    appliRow.genesis__Expected_First_Payment_Date__c = dt.setMonth(0);
    appliRow.genesis__Expected_First_Payment_Date__c = dt.setFullYear((dt.getFullYear()+1));
}
var firstPayDateCheck = dt;
var firstPayDate = dt;
var month = firstPayDate.getMonth();
if(month == 9 && dt.getDate() == 31){
    month = 8;
}
if(month === 0){
    month = 1;
}
if(month<10){
    month = '0'+month;
}
else if(month === 10 && mon === 9){
    month = '11';
}
else if(dt.getMonth() === 11 && day === 31 && month === 11){
    month = 11;
}
else if(month == 11){
    month = '12';
}
var fullDate = firstPayDate.getFullYear() + '-' + month + '-' + (firstPayDate.getDate() <= 9 ? '0'+firstPayDate.getDate() : firstPayDate.getDate());
var apptyObj = new sforce.SObject("genesis__applications__c");
apptyObj.Id = appliRow.Id;
apptyObj.genesis__Expected_First_Payment_Date__c = fullDate;
apptyObj.genesis__Due_Day__c=dueDay;
var result = sforce.connection.update([apptyObj]);
var apptyObjQuery = sforce.connection.query("SELECT id,genesis__Due_Day__c,genesis__Maturity_Date__c,genesis__Expected_First_Payment_Date__c,genesis__Expected_Start_Date__c from genesis__applications__c where id ='"+apptyObj.Id+"' limit 1");
$.blockUI({
    message: 'Please wait!  Due Day, Expected First Payment date and Maturity Date are getting auto populated.',
    onBlock:function(){
    var result = sforce.apex.execute('genesis.SkuidNewApplication','generateSchedule',
    {   
            applicationId : apptyObjQuery.records.Id
    });
    $.unblockUI();
    alert(result);
    }
});
var apptyObjQuery1 = sforce.connection.query("SELECT id,genesis__Due_Day__c,genesis__Maturity_Date__c,genesis__Expected_First_Payment_Date__c,genesis__Expected_Start_Date__c from genesis__applications__c where id ='"+apptyObj.Id+"' limit 1");
});
skuid.snippet.register('populate 2',function(args) {var appliModel = skuid.model.getModel('CommonApplicationModel');
var appliRow = appliModel.data[0];
var schQuery = sforce.connection.query("SELECT id,genesis__Due_Date__c FROM genesis__Amortization_Schedule__c where genesis__Application__c ='"+appliRow.Id+"' ORDER BY genesis__Due_Date__c ASC LIMIT 1 ");
if(schQuery !== null){
    var apptyObj = new sforce.SObject("genesis__applications__c");
    apptyObj.Id = appliRow.Id;
    apptyObj.genesis__Expected_First_Payment_Date__c = schQuery.records.genesis__Due_Date__c;
    var result = sforce.connection.update([apptyObj]);
}
appliModel.updateData();
});
}(window.skuid));