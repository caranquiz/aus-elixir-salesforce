(function(skuid){
skuid.snippet.register('renderWithExternalLink',function(args) {var field = arguments[0],
    value = arguments[1],
    $ = skuid.$;

var url = '/' + field.row.Id;
field.element.html('<a href="' + url + '" target="_blank">' + value + '</a>');
});
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