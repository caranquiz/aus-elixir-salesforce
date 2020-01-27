(function(skuid){
skuid.snippet.register('addParty',function(args) {/*var params = arguments[0],
$ = skuid.$;

var partyNameQuery1 = sforce.connection.query("SELECT id,Name from clcommon__Party_Type__c where Name = 'Director' LIMIT 1");
var partyNameQuery2 = sforce.connection.query("SELECT id,Name from clcommon__Party_Type__c where Name = 'Shareholder' LIMIT 1");
var partyNameQuery3 = sforce.connection.query("SELECT id,Name from clcommon__Party_Type__c where Name = 'Director & Shareholder' LIMIT 1");
records1 = partyNameQuery1.getArray("records"); 
records2 = partyNameQuery2.getArray("records");
records3 = partyNameQuery3.getArray("records");
var stat1 = records1[0].Id;
var stat2 = records2[0].Id;
var stat3 = records3[0].Id;

var d1 = records1[0].Name;
var s1 = records2[0].Name;
var ds = records3[0].Name;

console.log('Director-- '+d1);
console.log('Shareholder-- '+s1);
console.log('Director & Shareholder-- '+ds);

console.log('query id '+stat1);
console.log('query id '+stat2);
console.log('query id '+stat3);
var k=0;
var partyRow;
var contactModel = skuid.model.getModel('Contact');
var newContactRow = contactModel.data[0];
var accountModel = skuid.model.getModel('Account');
var newAccountRow = accountModel.data[0];
var newPartyModel = skuid.model.getModel('Party');
console.log(newPartyModel);
console.log(newPartyModel.getRows());

var partyRow = newPartyModel.data[0];
console.log('partyRow-------'+partyRow);
console.log('partyRow-------'+partyRow.Id);
var appModel = skuid.model.getModel('ApplicationModel');
var newAppRow = appModel.data[0];
console.log("ACC NO"+newAppRow.genesis__Account__c+"APP ID"+newAppRow.Id);

for (var newPartyRow of newPartyModel.getRows()){
    console.log(newPartyRow);
      console.log(newPartyModel.getRows());
    //var partyCreate = newPartyModel.data[newPartyRow];
    if(newPartyRow.Id.startsWith("sk-")){
         newContactRow = contactModel.createRow({
              additionalConditions: [
                  { field: 'AccountId', value: newPartyRow.clcommon__Account__c},
                  { field: 'FirstName', value: newPartyRow.First_Name__c},
                  { field: 'LastName', value: newPartyRow.Last_Name__c},
                  
              ]
         });
    }
}  
console.log(contactModel.getRows());
   console.log("New Row"+newContactRow.Id);
skuid.model.save([contactModel],{callback: function(resultOfSaveContact){
    console.log("New Row"+newContactRow.Id);
   if(resultOfSaveContact.totalsuccess){
       console.log("i m in"+resultOfSaveContact.totalsuccess);
    for (var allParty of newPartyModel.getRows()){
         console.log(newPartyModel.getRows());
         console.log(contactModel.getRows());
       newPartyModel.updateRow(
           partyRow,{
               
              clcommon__Contact__c : allParty.id,
            //clcommon__Contact__r.AccountId : newAccountRow.Id,
               //clcommon__Type__c : records[0].Id,
               genesis__Application__c : newAppRow.Id
               
           }
        );
       }
           //newPartyModel.Save();
           console.log("Contact ID of Party"+partyRow.clcommon__Contact__c);
           skuid.model.save([newPartyModel],{callback: function(resultOfSaveParty){
                console.log("i m in"+resultOfSaveParty.totalsuccess); 
              // window.location.reload(); 
           }});
   }
   
}});

console.log("party ID"+newPartyModel.data[0].Id);
//window.location.reload();*/
});
skuid.snippet.register('AgeCheck',function(args) {var accModel = skuid.model.getModel('Account');
var accrow = accModel.data[0];
var contactModel = skuid.model.getModel('Contact');
var newContactRow = contactModel.data[0];
var branch = skuid.model.getModel('SystemBranch');
var branchRow = branch.getFirstRow();
var birthYear = new Date(newContactRow.Birthdate);
var middleName = newContactRow.MiddleName;
var letterNumber = /^[a-zA-Z]+$/;
var curYear = new Date(branchRow.loan__Current_System_Date__c);
if((curYear.getFullYear()-birthYear.getFullYear())<18){
    //newContactRow.Is_the_applicant_s_age_less_than_18_yrs__c = true;
    //contactModel.save();
    contactModel.updateRow(newContactRow, {Is_the_applicant_s_age_less_than_18_yrs__c: true});
    contactModel.updateRow(newContactRow, {Birthdate: null});
    alert('The age of application should be above 18!') ;
    return false;
}
else{
     contactModel.updateRow(newContactRow, {Is_the_applicant_s_age_less_than_18_yrs__c: false});
     //console.log('Age'+curYear.getFullYear()-birthYear.getFullYear());
     //console.log(birthYear.getFullYear()+'birthYear');
     return true;
}
});
skuid.snippet.register('fieldRenderer2',function(args) {var field = arguments[0],
    value = arguments[1];
var renderMode = skuid.page.params.mode;
fieldModeToRender(field,value,renderMode);
});
skuid.snippet.register('generateACNDetails',function(args) {var params = arguments[0],
	$ = skuid.$;
var appModel  = skuid.model.getModel('Party');
var appRow    = appModel.data[0];
var records   = appModel.getRows().length; 
//console.log("length=="+appModel.getRows().length);
//console.log('appRow.Company_ACN__c'+appRow.Trustee_ACN__c);
var ret;

        if(appRow.Trustee_ACN__c !== undefined){
            $.blockUI({
                message: 'Please wait! ',
                onBlock: function(){
                        ret = sforce.apex.execute('ACNCallout','makeACNSkuidCallout',
                    {
                        partyId : appRow.Id
                    });
                    
                    if(ret=='SUCCESS'){
                        alert('SUCCESS');
                        $.unblockUI();
                        window.location.reload();
                    }else{
                        //console.log(ret+'==HERE==');
                        alert(ret);
                        $.unblockUI();
                        window.location.reload();
                    }
                    
                },
                
            });
            
            
            
            
        }
        else{
            alert('ACN Number has not been attached!');
        }
    
// }
// else{
//     alert('ACN Information has already been generated');
// }

window.location.reload();
});
skuid.snippet.register('generateABNDetails',function(args) {var params = arguments[0],
	$ = skuid.$;
var appModel  = skuid.model.getModel('Party');
var appRow    = appModel.data[0];
var records   = appModel.getRows().length; 
//console.log("length=="+appModel.getRows().length);
//console.log('appRow.Company_ABN__c'+appRow.Company_ABN__c);
var agree    = confirm("Are you sure?");
//if(records >=1){
    if(agree){
        if(appRow.Company_ABN__c !== undefined){
            $.blockUI({
                message: 'Please wait! ABN Information is being generated',
                onBlock: function(){
                    var ret = sforce.apex.execute('ABNAPICallout','makeABNCompanySkuidCallout',
                    {
                        companyId : appRow.Id
                    });
                    alert(ret);
                }
            });
        }
        else{
            alert('ABN Number has not been attached!');
        }
    }
// }
// else{
//     alert('ABN Information has already been generated');
// }

window.location.reload();
});
skuid.snippet.register('MiddleNameCheck',function(args) {var params = arguments[0],
	$ = skuid.$;
var accModel = skuid.model.getModel('Account');
var accrow = accModel.data[0];
//if(accRow.clcommon__Legal_Entity_Type__r.Name === 'Individual'){
    var contactModel = skuid.model.getModel('Contact');
    var newContactRow = contactModel.data[0];
    var Integer = Integer.new;
    var branch = skuid.model.getModel('SystemBranch');
    var branchRow = branch.getFirstRow();
    var MiddleName = newContactRow.MiddleName[0];
    var letterNumber = /^[a-zA-Z]+$/;
    var curYear = new Date(branchRow.loan__Current_System_Date__c);
    if((MiddleName.value.match(letterNumber)))
    {
             contactModel.save();

    }
else{
        window.alert('Middle name Invaid Type');    
    }
});
skuid.snippet.register('ABN Company Name Search',function(args) {var params = arguments[0],
	$ = skuid.$;
var appModel  = skuid.model.getModel('Party');
var appRow    = appModel.data[0];
var records   = appModel.getRows().length; 
//console.log("length=="+appModel.getRows().length);
//console.log('appRow.Company_ABN__c'+appRow.clcommon__Account__r.Name);
//var agree    = confirm("Are you sure?");
        if(appRow.clcommon__Account__r.Name !== undefined){
            
                    var ret = sforce.apex.execute('ABNNameCallout','makeABNSkuidCallout',
                    {
                        sfId : appRow.Id,
                        typeIndicator : 'P'
                       
                    });
                    if(ret != 'SUCCESS'){
                        alert('Kindly provide a valid name search for ABN search.');
                        return false;
                    }
                    else if(!ret){
                        alert('Error');
                    }
                    else{
                        return true;
                    }
                    
        }
        else{
            alert('ABN Company Name Number has not been attached!');
        }
});
skuid.snippet.register('ABN Number Check',function(args) {var params = arguments[0],
    $ = skuid.$;
    //var partyModel = skuid.model.getModel('Party');
    //var partyRow = partyModel.data[0];
    //var ABNCompanyModel = skuid.model.getModel('ABN_ComapnyName_Model');
    //var ABNCompanyRow = ABNCompanyModel.data[0];
    var records = skuid.$.map(arguments[0].list.getSelectedItems(),function(item){
        return item.row;
    });
    //console.log(records);
    //console.log(arguments[0].list);
    if ( !records[0]  || records.length < 1) {
        alert("Please select at least one Company");
    }else if(records  && records.length > 1){
        alert("Please select at only one Company");
    } else{
        var result = sforce.apex.execute('ABNAPICallout','makeABNCompanySkuidCallout',
        {  
            companyId : records[0].Id
         });
                alert(result);
                //window.location.reload();
    }
});
skuid.snippet.register('dateCheck',function(args) {//var params = arguments[0],
    $ = skuid.$;
var field = arguments[0]; var cellElem = field.element;
var value = arguments[1];
cellElem.text( value );
//console.log(value);
});
skuid.snippet.register('ValidateNoOfDependents',function(args) {var field = arguments[0];
//console.log(arguments);
    row = field.row,
    $ = skuid.$;
 var firstValue = skuid.utils.decodeHTML(arguments[1]);

skuid.ui.fieldRenderers[field.metadata.displaytype][field.mode](field,firstValue);

 var div = document.createElement('div');
$(div).attr("class", "nx-error-inline");
$(div).attr("id", "error-msg");

field.element.change(function(){
    //console.log('==changed==') ;
    var value = skuid.model.getModel('Contact').getFirstRow().Number_Of_Dependents__c ;
    //console.log('==value=='+value) ;
    var noOfDependent = /^[0-9]{1,}$/ ;  // /^[0-9]{1,}$/
    if(value){
        if(value!=undefined && value!='' && value!=null && !noOfDependent.test(value)){
            div.append('Number of Dependent can only be number.');
        }
        else{
             $("#error-msg").empty() ;
        }
        setTimeout(function(){
            ((document.getElementsByClassName("noOfDependent")[0]).getElementsByClassName("nx-field")[0]).append(div);
        },500);
    }
});
});
skuid.snippet.register('CompanyTrustSuburbCapital',function(args) {var AccountBillingAddressModel = skuid.model.getModel('AccountBillingAddress');
var AccountBillingAddressRow = AccountBillingAddressModel.data[0];
if(AccountBillingAddressRow !== null && AccountBillingAddressRow !== undefined && AccountBillingAddressRow.clcommon__City__c !== null && AccountBillingAddressRow.clcommon__City__c !== undefined){
    AccountBillingAddressRow.updateRow(AccountBillingAddressRow,(clcommon__City__c).toUpperCase(),clcommon__City__c);
}
var AccountShippingAddressModel = skuid.model.getModel('AccountShippingAddress');
var AccountShippingAddressRow = AccountShippingAddressModel.data[0];
if(AccountShippingAddressRow !== null && AccountShippingAddressRow !== undefined && AccountShippingAddressRow.clcommon__City__c !== null && AccountShippingAddressRow.clcommon__City__c !== undefined){
    AccountShippingAddressRow.updateRow(AccountShippingAddressRow,(clcommon__City__c).toUpperCase(),clcommon__City__c);
}
var AccountTradingAddressModel = skuid.model.getModel('AccountTradingAddress');
var AccountTradingAddressRow = AccountTradingAddressModel.data[0];
if(AccountTradingAddressRow !== null && AccountTradingAddressRow !== undefined && AccountTradingAddressRow.clcommon__City__c !== null && AccountTradingAddressRow.clcommon__City__c !== undefined){
    AccountTradingAddressRow.updateRow(AccountTradingAddressRow,(clcommon__City__c).toUpperCase(),clcommon__City__c);
}
return true;
});
skuid.snippet.register('DeleteUnwanted',function(args) {var abnCompanyNameModel = skuid.model.getModel('ABN_ComapnyName_Model');
var delIds = [],i=0;
$.each(abnCompanyNameModel.data,function(i,row){
    delIds[i] = row.Id;
    i=i+1;
});
try {
    var delResult = sforce.connection.deleteIds([delIds]);
}
catch (err){
    alert('Too many search results have been obtained! Please enter more specific details.');
    return false;
}
});
skuid.snippet.register('AddBrokerUnderwriter',function(args) {var params = arguments[0],
	$ = skuid.$;
var partyModel = skuid.model.getModel('Party');
var partyRow  = partyModel.data[0];
var records = arguments[0].item;
partyModel.updateRow(partyRow, {Broker_Underwriter__c: records.row.Id});
});
}(window.skuid));