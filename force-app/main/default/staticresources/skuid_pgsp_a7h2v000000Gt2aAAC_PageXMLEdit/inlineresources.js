(function(skuid){
(function(skuid){
var $ = skuid.$;
skuid.componentType.register('pageXMLEditor',function(element) {

	var model = skuid.$M('page'),
	    row = model.getFirstRow(),
	    editor = new skuid.ui.Editor(element),
        xmleditor = null,
        bc = skuid.builder.core,
        pauselistening = false;

	if (model) {
		// Register that we will be editing our model.
		// This will take care of adding Save and Cancel buttons to our header.
		// However, we will hide these unless they are explicitly added in the 'actions' area.
		editor.registerModel(model);
	}
	
    function getPageLayout() {
        return model.getFieldValues(row,bc.getLayoutFields(),true).join('');
    }

	// Extend our editor's native handleCancel method
	// so that we can rerender ourself
	editor.handleCancel = function() {
		// Run the prototype method
		//skuid.ui.Editor.prototype.handleCancel.call(editor);
        
		viewBuilderLink.removeClass('disabled');
		if (xmleditor) {
			pauselistening = true;
			xmleditor.setValue(formatXml(getPageLayout()));
			xmleditor.getSession().getSelection().clearSelection();
			pauselistening = false;
		}
	};
	
	editor.handleSave = function() {
		// Run the prototype method
		//skuid.ui.Editor.prototype.handleSave.call(editor);
		viewBuilderLink.removeClass('disabled');
	};
	
	editor.handleChange = function() {
		// Run the prototype method
		//skuid.ui.Editor.prototype.handleChange.call(editor);
		viewBuilderLink.addClass('disabled');
	};
	
	function formatXml(xml) {
		var formatted = '';
		var reg = /(>)(<)(\/*)/g;
		xml = xml.replace(reg, '$1\r\n$2$3');
		var pad = 0;
		jQuery.each(xml.split('\r\n'), function(index, node) {
			var indent = 0;
			if (node.match( /.+<\/\w[^>]*>$/ )) {
				indent = 0;
			} else if (node.match( /^<\/\w/ )) {
				if (pad !== 0) {
					pad -= 1;
				}
			} else if (node.match( /^<\w[^>]*[^\/]>.*$/ )) {
				indent = 1;
			} else {
				indent = 0;
			}
	
			var padding = '';
			for (var i = 0; i < pad; i++) {
				padding += '    ';
			}
	
			formatted += padding + node + '\r\n';
			pad += indent;
		});
	
		return formatted;
	}
	
	
	function condenseXml(xml) {
		return xml.replace(/(>)(\s*)(<)(\/*)/g,'$1$3$4');
	}

	var wrapper = jQuery('<div id="wrapper">');
	var textarea = jQuery('<div id="pagexmleditorbox">').addClass('nx-code-editor');
	var invalid = jQuery('<div>Invalid XML</div>').addClass('nx-error').css({'position':'absolute','top':'4px','right':'4px'}).hide();
	var viewBuilderLink = jQuery('<a>').addClass('nx-pagebuilder-viewxmllink').prop('href','/apex/skuid__PageBuilder?id=' + row.Id).text('View/Edit in Page Builder');
	wrapper.append(textarea);
	element.append(wrapper,viewBuilderLink,invalid);
	function resize() {
		var height = ((window.innerHeight - $('.sk-headerwrapper').outerHeight() - 100)) + 'px';
		wrapper.css('height', height);
		textarea.css('height', height);
		element.css('position', 'relative').css('height', height);
		xmleditor.resize();
	}
	$(document.body).one('pageload',function() {
	    var height = ((window.innerHeight - $('.sk-headerwrapper').outerHeight() -120) * 0.85) + 'px';
	    wrapper.css('height',height);
	    textarea.css('height',height);
	    element.css('position','relative').css('height',height);

    	xmleditor = window.ace.edit('pagexmleditorbox');
    	xmleditor.getSession().setMode("ace/mode/xml");
    	xmleditor.setValue(formatXml(getPageLayout()));
    	xmleditor.getSession().getSelection().clearSelection();
    	textarea.show();
    	xmleditor.getSession().on('change',function() {
    		if (!pauselistening) {
    			var xmldoc;
    			try {
    				xmldoc = skuid.utils.makeXMLDoc(condenseXml(xmleditor.getValue()));
    				
    			}
    			catch(e) {
    				invalid.show();
    				return;
    			}
    			invalid.hide();
    			bc.save(xmldoc[0],model,row);
    		}
    	});
        resize();
    });
    $(window).resize(resize);

});
})(skuid);;
skuid.snippet.register('saveAndPreview',function(args) {var params = arguments[0],
    pageModel = params.model,
    editor = params.component.editor,
    pagePreview = skuid.snippet.getSnippet('skuid.builder.page.preview');

pagePreview && pagePreview({
    editor: editor,
    model: pageModel,
    saveFirst: true
});
});
}(window.skuid));