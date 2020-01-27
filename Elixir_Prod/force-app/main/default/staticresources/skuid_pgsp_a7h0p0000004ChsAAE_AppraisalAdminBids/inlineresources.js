(function(skuid){
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
		
		var appAdminBidsModelRow = skuid.model.getModel('AppraisalAdminBids_AppraisalBids').getFirstRow();
		if(appAdminBidsModelRow !== undefined) {
    	    var elem = skuid.$C('appAdminBidsQueueId').element.data('object').list.visibleItems["0"].element;
    	    elem.addClass('nx-queue-item-selected');
		}

	});
})(skuid);;
}(window.skuid));