(function(skuid){
(function(skuid){
  var $ = skuid.$;
  $(document.body).one('pageload',function(){
    
    var appRequestModelRow = skuid.model.getModel('AppraisalAdmin_AppraisalRequest').getFirstRow();
    if(appRequestModelRow !== undefined) {
          var elem = skuid.$C('appRequestQueueId').element.data('object').list.visibleItems["0"].element;
          elem.addClass('nx-queue-item-selected');
    }

  });
})(skuid);;
skuid.snippet.register('loadPageInclude',function(args) {var params = arguments[0],
  $ = skuid.$;


var elem = skuid.$C('appRequestQueueId').element.data('object').list.visibleItems["0"].element;
elem.addClass('nx-queue-item-selected');
var pageInclude = skuid.$('#AppraisalBidsPage').data('object');
pageInclude.pagename = 'AppraisalAdminBids';
pageInclude.querystring = '?id='+skuid.model.getModel('AppraisalAdmin_AppraisalRequest').data[0].Id;
pageInclude.load(function(){ 
    
});
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