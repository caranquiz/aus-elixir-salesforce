(function(skuid){
skuid.snippet.register('CloseDialogue',function(args) {var params = arguments[0],
	$ = skuid.$;
	//location.reload();
	//window.location.reload();
//closeTopLevelDialogAndRefresh({iframeIds: ['document-iframe', 'party-iframe', 'deal-dashboard-iframe,document-iframe', 'deal-dashboard-iframe,party-iframe']});
closeTopLevelDialogAndRefresh({window:true});
});
}(window.skuid));