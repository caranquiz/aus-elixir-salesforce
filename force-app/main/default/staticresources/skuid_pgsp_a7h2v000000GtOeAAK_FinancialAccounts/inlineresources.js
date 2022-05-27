(function(skuid){
skuid.snippet.register('RenderColumnWIthExternalLink',function(args) {var field = arguments[0],
    value = arguments[1],
    $ = skuid.$;

var url = '/' + field.row.Id;
field.element.html('<a href="' + url + '" target="_blank">' + value + '</a>');
});
skuid.snippet.register('RenderAccountStatusColumn',function(args) {var field = arguments[0],
    value = arguments[1],
    $ = skuid.$;

var message = value ? 'Active' : 'Not Active';

field.element.text(message);
});
}(window.skuid));