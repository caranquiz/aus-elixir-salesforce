(function(skuid){
skuid.snippet.register('openApplication',function(args) {var params = arguments[0],
	$ = skuid.$;
var args = arguments[0],
    item = args.item,
    list = args.list,
    model = args.model,
    element = args.element,
    row = item.row;

var appId = params.row.genesis__Application__c;

/*
{BASEURL}/a472A000000MGs5
Open in new Tab
*/
 window.open('/'+appId, '_blank');
});
skuid.snippet.register('findIncludePanel',function(args) {var params = arguments[0],
	$ = skuid.$;
var params = arguments[0],
	$ = skuid.$;



var x = document.getElementById("dynamicPageInclude");

if(x === null) {
    return true;  /* display header*/
} else if(x !== undefined) {
    return false; /* hide header*/
} else {
    return true;
}
});
}(window.skuid));