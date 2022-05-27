(function(skuid){
skuid.snippet.register('skuid.pageBuilder.preview',function(args) {var params = arguments[0],
    pagePreview = skuid.snippet.getSnippet('skuid.builder.page.preview');
pagePreview && pagePreview({
    model: params.model,
    row: params.item ? params.item.row : params.row
});
});
skuid.snippet.register('ShowGrowlNotification_Saving',function(args) {skuid.$.growlUI(skuid.$L('saving'));
});
(function(skuid){
    var $ = skuid.$;
    
	$(document.body).one('pageload',function(){
	    var titles = $('.nx-pagebuilder-title-main'); 
	    // Theres a weird bug where if you're editing the pagebuilder
	    // with the pagebuilder, 2 titles will appear. So we just remove
	    // the second one
	    /*
		if(titles[1]){
		    titles[1].remove();
		}
		*/
		titles.prependTo('.nx-pagebuilder-toolbar-wrapper');
	});
	
	//  Set the new Child Page XML
	skuid.snippet.register('skuid.pagebuilder.setChildPageXML',function(config){
        var model = config.model,
            row = config.row,
            pageXML = '<skuidpage unsavedchangeswarning="yes">' +
            	'<models/>' +
            	'<pageregioncontents/>' +
            	'<components/>' + // Shouldn't be needed, but...
            	'<resources>' +
            		'<labels/>' +
            		'<css/>' +
            		'<javascript/>' +
            	'</resources>' +
            	'</skuidpage>';
        
        skuid.utils.writeXmlToPageLayoutFields(pageXML,model,row);
	});
})(skuid);;
// When cloning Pages in protected modules,
// we want to set the default Module to be '' instead.
// Also, when the Owner.Name is 'Skuid',
// we want to set the OwnerId to be the running user.
$j().ready(function(){
    var model = skuid.model.getModel('PageData');

    if (model && model.data.length) {
        var row = model.getFirstRow(),
            needToRedraw = false;
        if (model.getFieldValue(row,'Owner.Name') == 'Skuid') {
            model.updateRow(row,'OwnerId',skuid.utils.userInfo.userId);
            model.updateRow(row,'Owner',{Name:skuid.utils.userInfo.name});
            needToRedraw = true;
        }
        
        if (model.getFieldValue(row,'skuid__Module__c') == 'Skuid') {
            model.updateRow(row,'skuid__Module__c',null);
            needToRedraw = true;
        }

        // Now redraw our list, if necessary
        if (needToRedraw) {
            $j.each(model.registeredLists,function(listId,list){
                list.render({doNotCache:true});
            });
        }

    }
});;
}(window.skuid));