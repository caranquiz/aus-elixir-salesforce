(function(skuid){
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
	    var templateModel = skuid.model.getModel('TemplateDetails');
	    var statements = skuid.model.getModel('FSHeader');
        $('.financial-statement-table').each(
            function(tableIndex, table) {
                $(table).find('table tbody tr').each(
                    function(index, element) {
                        if(templateModel.data[index]){
                            var level = templateModel.data[index].clcommon__Level__c;
                            if(level) {
                                $(element).attr('level', level.split('.').length);
                            } else {
                                $(element).attr('level', 0);    
                            }
                            $(element).attr('row-type', templateModel.data[index].clcommon__Type__c);
                        }
                    }
                )
            }
        )
        
        $(window.document.body).find('a').each(function(index, link) {
    		$(link).attr('target', '_blank');
    	});
    	
    	$('.statement-detail').each(
    	    function(tableIndex,table){
    	        console.log(table);
    	        if(statements.data[tableIndex]){
    	            var tableData =  statements.data[tableIndex];
    	            console.log(tableData);
    	            $(table).find('.nx-field div.nx-fieldtext div.nx-template').each(
                        function(index,element){
                           
                            var level = tableData.clcommon__Financial_Statement__r.records[index].clcommon__Template_Detail__r.clcommon__Level__c;
                            console.log(level);
                            if(level) {
                                $(element).attr('level', level.split('.').length);
                            } else {
                                $(element).attr('level', 0);    
                            }
                            $(element).attr('row-type', tableData.clcommon__Financial_Statement__r.records[index].clcommon__Template_Detail__r.clcommon__Type__c);
                            console.log(element);
                        }
                    )
    	        }
    	        
    	    }
    	);
	});
})(skuid);;
skuid.snippet.register('FinancialStatement_EditHandler',function(args) {var params = arguments[0],
	$ = skuid.$;

var statementModel = skuid.model.getModel('FSHeader');
var statementHeaders = statementModel.data;
if (!$('#edit-button + #edit-dropdown').length) {
    showDropdown();
} else {
    closeDropdown();
}

function showDropdown() {
    var dropdownList = $('<div/>', {
        id: 'edit-dropdown'
    }).css('position', 'absolute').css('right', '10px').css('border', '1px solid #7f7f7f').css('z-index', 5);
    statementHeaders.forEach(function(element) {
        var entry = $('<div>Statement ' + element.Name + '</div>').css('padding-top', '6px').css('padding-bottom', '6px').css('padding-left', '10px').css('padding-right', '10px').css('cursor', 'pointer');
        entry.click(function() {
            openEditIframe(element.Id)
        });
        dropdownList.append(entry);
    });

    $('#edit-button').after(dropdownList);
}

function closeDropdown() {
    $('#edit-button + #edit-dropdown').remove();
}

function openEditIframe(statementId) {
    closeDropdown();
    var overlay = $('<div id="edit-statement-overlay"></div>').css({
        position: 'fixed',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
    }).css("z-index", 100).css("background-color", "rgba(0, 0, 0, 0.3");
    var dialog = $('<div id="edit-statement-dialog"></div>').css("margin-top", "30px").css("margin-bottom", "30px").css("margin-left", '5%').css("margin-right", "5%").css("height", "calc(100% - 60px)");
    var closeButton = $('<div></div>').addClass('fa fa-times').css({
        position: 'absolute',
        top: '25px',
        left: '94%',
        height: '15px',
        width: '15px',
        color: '#ffffff'
    }).click(function() {
        closeEditIframe();
    });
    var src = '/apex/skuid__ui?page=StatementDetails&id=' + statementId + '&type=' + skuid.page.params.type + '&editmode=true';
    var iframe = $('<iframe width="100%" height="100%" frameBorder="0" style="background: #ffffff; padding-top: 20px; padding-right: 10px; padding-left: 10px; padding-bottom: 7px;"/>');
    iframe.attr('src', src);
    
    dialog.append(iframe).append(closeButton);
    overlay.append(dialog);
	
    $(document.body).append(overlay);
}

function closeEditIframe() {
    $('#edit-statement-overlay').remove();
}

window.addEventListener('message', function(evt) {
    if(evt.data.type == 'requery-statement-headers'){
        $.when(statementModel.updateData()).then(function(){
           closeEditIframe();
        });
    } else if(evt.data.type == 'close-edit-statement-headers'){
         closeEditIframe();
    }
});
});
}(window.skuid));