(function(skuid){
skuid.snippet.register('generateStatementForm',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var statementHeader = skuid.model.getModel('NewStatementHeader').data[0];
sforce.apex.execute('clcommon.CustomButtonAction', 'generateStatementsForm', {
                                statementId: statementHeader.Id,
                            }
                        );
});
skuid.snippet.register('refreshTabs',function(args) {var params = arguments[0],
	$ = skuid.$;
	skuid.component.getById('sk-YHa-434').render();
});
skuid.snippet.register('BasePeriods',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var statements = skuid.model.getModel('FinancialStatements').data;
console.log(statements);
var basePeriods = [];
var i;
for(i=0; i <statements.length ; i++){
    basePeriods.push({ label: statements[i].Name, value: statements[i].Id });
}
basePeriods.push({ label: 'Previous Period', value: 'Previous Period' });
console.log(basePeriods);
var statementModel = skuid.model.getModel('StatementDetailforSensitivity');
    console.log('here1');
    console.log(statementModel.data);
return basePeriods;
});
skuid.snippet.register('trendAnalysisRequest',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var trendAnalysisReq = skuid.model.getModel('TrendAnalysisRequest').data[0];
var acc = skuid.model.getModel('ACStatementForAccount').data[0];
sforce.apex.execute('clcommon.CustomButtonAction', 'performTrendAnalysis', {
                                accId: acc.Id,
                                statementType: trendAnalysisReq.statementType,
                                basePeriod: trendAnalysisReq.basePeriod,
                                deletePreviousAnalysis:true
                            }
                        );
console.log(skuid.model.getModel('StatementParameters').Type);
skuid.model.getModel('StatementParameters').Type = 'TREND';

skuid.component.getById('sk-YHa-434').render();
});
skuid.snippet.register('GenerateProjectedStatement',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var statementHeader = skuid.model.getModel('ProjectionStatement').data[0];
console.log(statementHeader);
var statementParams = skuid.model.getModel('StatementParameters').data;
console.log(statementParams);
var acc = skuid.model.getModel('ACStatementForAccount').data[0];

var parameters = "{";
var i;
for(i = 0; i< statementParams.length ; i++){
    console.log(statementParams[i]);
    parameters += ("\"" + statementParams[i].TemplateDetail +"\"" + ":" + "\"" + statementParams[i].PercentChange+"\""+",");
}
parameters = parameters.slice(0,-1);
parameters+="}";
console.log(parameters);

sforce.apex.execute('clcommon.CustomButtonAction', 'generateProjectedStatement', {
                                statementName : statementHeader.Name,
                                baseStatementIds : statementHeader.FinancialStatementsForProjection,
                                accId : acc.Id,
                                statementType : statementHeader.StatementType,
                                statementDate : statementHeader.StatementDate,
                                monthsCovered : statementHeader.MonthsCovered,
                                params : parameters
                            }
                        ); 
alert('generateProjectedStatement');
});
skuid.snippet.register('SensitivityAnalysisRequest',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var statementHeader = skuid.model.getModel('SensitivityAnalysis').data[0];
var statementParams = skuid.model.getModel('StatementParamsForSensitivityAnalysis').data;
var acc = skuid.model.getModel('ACStatementForAccount').data[0];

var parameters = "{";
var i;
var case1Params = "{";
var case2Params = "{";
var case3Params = "{";
for(i = 0; i< statementParams.length ; i++){
    console.log(statementParams[i]);
    case1Params += ("\"" + statementParams[i].TemplateDetail +"\""+ ": "+"\""+statementParams[i].Case1+"\""+",");
    case2Params += ("\"" + statementParams[i].TemplateDetail +"\""+ ": "+"\""+statementParams[i].Case2+"\""+",");
    case3Params += ("\"" + statementParams[i].TemplateDetail +"\""+ ": "+"\""+statementParams[i].Case3+"\""+",");
    /*parameters += ("\"" + statementParams[i].TemplateDetail +"\"" + ": {" + "\"" +"Case 1" +"\""+":"+"\""+statementParams[i].Case1+"\""+","+"\""+"Case 2"+"\""+":"+"\""+statementParams[i].Case2+"\""+","+"\""+"Case 3"+"\""+":"+"\""+statementParams[i].Case3+"\""+"}"+",");*/
}

case1Params = case1Params.slice(0,-1);
case1Params += "}";
case2Params = case2Params.slice(0,-1);
case2Params += "}";
case3Params = case3Params.slice(0,-1);
case3Params += "}";

parameters += ("\"" +"Case 1" +"\""+":"+case1Params+","+"\""+"Case 2"+"\""+":"+case2Params+","+"\""+"Case 3"+"\""+":" + case3Params);
parameters+="}";
console.log(parameters);

sforce.apex.execute('clcommon.CustomButtonAction', 'performSensitivityAnalysis', {
                                baseStatement : statementHeader.FinancialStatements,
                                accId : acc.Id,
                                statementType : statementHeader.StatementType,
                                params : parameters,
                                deletePreviousAnalysis : true
                            }
                        );
skuid.component.getById('sk-YHa-434').render();
});
skuid.snippet.register('FinancialStatement_EditHandler',function(args) {var params = arguments[0],
	$ = skuid.$;

var statementModel = skuid.model.getModel('FSHeader');
var statementHeaders = statementModel.data;
if (!$('#edit-button + #edit-dropdown').length) {
    showDropdown();
} else {
    closeDropdown();
}

function showDropdown() {
    var dropdownList = $('<div/>', {
        id: 'edit-dropdown',
        class:'sk-dropnav-dropdown'
    }).css('position', 'absolute');
    statementHeaders.forEach(function(element) {
        var entry = $('<div class="sk-navigation-item">Statement ' + element.Name + '</div>').css('margin', '0px').css('display', 'inherit');
        entry.click(function() {
            openEditIframe(element.Id)
        });
        dropdownList.append(entry);
    });

    $('#edit-button').after(dropdownList);
}

function closeDropdown() {
    $('#edit-button + #edit-dropdown').remove();
}

function openEditIframe(statementId) {
    closeDropdown();
    var overlay = $('<div id="edit-statement-overlay"></div>').css({
        position: 'fixed',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
    }).css("z-index", 100).css("background-color", "rgba(0, 0, 0, 0.3");
    var dialog = $('<div id="edit-statement-dialog"></div>').css("margin-top", "30px").css("margin-bottom", "30px").css("margin-left", '5%').css("margin-right", "5%").css("height", "calc(100% - 60px)");
    var closeButton = $('<div></div>').addClass('fa fa-times').css({
        position: 'absolute',
        top: '25px',
        left: '94%',
        height: '15px',
        width: '15px',
        color: '#ffffff'
    }).click(function() {
        closeEditIframe();
    });
    var src = '/apex/skuid__ui?page=StatementDetails&id=' + statementId + '&type=' + skuid.page.params.type + '&editmode=true';
    var iframe = $('<iframe width="100%" height="100%" frameBorder="0" style="background: #ffffff; padding-top: 20px; padding-right: 10px; padding-left: 10px; padding-bottom: 7px; max-height:450px"/>');
    iframe.attr('src', src);
    
    dialog.append(iframe).append(closeButton);
    overlay.append(dialog);
	
    $(document.body).append(overlay);
}

function closeEditIframe() {
    $('#edit-statement-overlay').remove();
}

window.addEventListener('message', function(evt) {
    if(evt.data.type == 'requery-statement-headers'){
        $.when(statementModel.updateData()).then(function(){
           closeEditIframe();
           skuid.component.getById('sk-YHa-434').render();
        });
    } else if(evt.data.type == 'close-edit-statement-headers'){
         closeEditIframe();
    }
});
});
skuid.snippet.register('FinancialStatementTemplateUpdate',function(args) {var params = arguments[0],
	$ = skuid.$;

var accountModel = skuid.model.getModel('ACStatementForAccount');
var firstAccount = accountModel.getFirstRow();
accountModel.updateRow(accountModel.getFirstRow(),{clcommon__Financial_Statement_Template__c:firstAccount.clcommon__Industry_Classification_Code__r.clcommon__Financial_Statement_Template__c});
return accountModel.save({callback: function(result){}});
});
skuid.snippet.register('UpdateNewStatementHeaderWithTemplate',function(args) {var params = arguments[0],
	$ = skuid.$;

var accountModel = skuid.model.getModel('ACStatementForAccount');
var statementModel = skuid.model.getModel('NewStatementHeader');
var firstAccount = accountModel.getFirstRow();
statementModel.updateRow(statementModel.getFirstRow(),{clcommon__Template__c:firstAccount.clcommon__Financial_Statement_Template__c});
skuid.component.getById('sk-YHa-434').render();
alert('UpdateNewStatementHeaderWithTemplate');
});
}(window.skuid));