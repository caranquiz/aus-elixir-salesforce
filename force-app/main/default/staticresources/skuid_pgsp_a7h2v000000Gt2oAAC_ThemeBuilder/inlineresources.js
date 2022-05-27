(function(skuid){
(function(skuid){
    
	var $ = skuid.$,
	    registerSnippet = skuid.snippet.registerSnippet;
	
	// Utility functions for changing z-index
	registerSnippet('z99',function(){
	   $('#tb-holder').addClass('z99');
	   $('#tb-nav').addClass('z99');
	});
	
	registerSnippet('removeZ99',function(){
	   $('#tb-holder').removeClass('z99');
	   $('#tb-nav').removeClass('z99');
	});
	
	// Preview page
    registerSnippet('previewPage',function(){
        var params = arguments[0],
            pagePreview = skuid.snippet.get('skuid.builder.page.preview'),
            pageModel = skuid.$M('Page'),
            pageRow = params.row.PreviewPage__r;
        pageModel.adoptRow(pageRow);
        pagePreview && pagePreview({
            model: pageModel,
            row: pageRow,
            // Specify that we want to preview in context of a particular theme
            params: {
                usetheme: skuid.$M('Theme').data[0].Name
            }
        });
    });
	
})(skuid);;
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload', function(){
		$('#tb-iframe').css('height', window.innerHeight-128 + 'px');
		$('#tb-holder').css('height', window.innerHeight-110 + 'px');
	});
	$( window ).resize(function() {
	    $('#tb-iframe').css('height', window.innerHeight-128 + 'px');
	    $('#tb-holder').css('height', window.innerHeight-110 + 'px');
	});
})(skuid);;
}(window.skuid));