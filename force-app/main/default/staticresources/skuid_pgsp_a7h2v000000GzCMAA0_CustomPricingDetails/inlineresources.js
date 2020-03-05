(function(skuid){
skuid.snippet.register('generateSchedule',function(args) {var params = arguments[0],
    $ = skuid.$;
	$xml = skuid.utils.makeXMLDoc;
	var context = {};
    var scModels = skuid.model.getModel('CommonApplicationModelPricing');
    var scRow = scModels.data[0]; 
    var agree = confirm("Are you sure ?");
    if (agree){
        $.blockUI({
       message: 'Please wait!  Schedule is generating...',
       onBlock:function(){
        var result = sforce.apex.execute('genesis.SkuidNewApplication','generateSchedule',
        {   
                applicationId : scRow.Id
        });
        var appModel2 = skuid.model.getModel('AmortizationScheduleCheck');
        appModel2.updateData();
        $.unblockUI();
        alert(result);
       }
       });
    }
});
}(window.skuid));