(function(skuid){
skuid.snippet.register('LaunchCollateralDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'Manage Pledged Collateral';
var skuidPage = 'PledgeCollaterals';

launchSimplePopupDialog(appId, title, skuidPage);
});
skuid.snippet.register('RenderCollateralColumn',function(args) {var field = arguments[0],
	$ = skuid.$;

var cname = field.row.Collateral__r.Name;
var cid = field.row.Collateral__r.Id;

field.element.html('<a href="/' + cid + '" target="_blank">' + cname + '</a>');
});
}(window.skuid));