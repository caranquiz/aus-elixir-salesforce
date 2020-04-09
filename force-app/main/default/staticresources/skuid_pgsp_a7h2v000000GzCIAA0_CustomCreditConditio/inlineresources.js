(function(skuid){
skuid.snippet.register('FieldRenderer2',function(args) {var field = arguments[0],
    value = arguments[1];
var renderMode = skuid.page.params.mode;
fieldModeToRender(field,value,renderMode);
});
}(window.skuid));