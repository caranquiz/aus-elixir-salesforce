(function(skuid){
skuid.snippet.register('ServicingIncomeApplicationReload',function(args) {var params = arguments[0],
	$ = skuid.$;
	var appModel = skuid.model.getModel('ServicingIncomeApplication');
    appModel.updateData();
});
}(window.skuid));