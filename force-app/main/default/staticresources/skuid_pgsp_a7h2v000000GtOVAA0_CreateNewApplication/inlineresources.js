(function(skuid){
skuid.snippet.register('findIncludePanel',function(args) {var params = arguments[0],
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