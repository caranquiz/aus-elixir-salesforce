(function(skuid){
skuid.snippet.register('Test',function(args) {var params = arguments[0],
    $ = skuid.$;
var appId = skuid.page.params.id;
var title = 'Equipment';
var skuidPage = 'addApplicationEq';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});

window.location.reload(true);
});
skuid.snippet.register('reLoad',function(args) {var params = arguments[0],
	$ = skuid.$;
window.location.reload(true);
});
skuid.snippet.register('updatePricing',function(args) {var params = arguments[0],
	$ = skuid.$;
var appId = skuid.page.params.id;

try {
    var result = sforce.apex.execute(
        'genesis.SkuidPricingCtrl',
        'generatePricing', { 
            applicationId : appId 
        }
    );

} catch (err) {
    console.log('Error getting pricing: ' + err.description);
}
});
}(window.skuid));