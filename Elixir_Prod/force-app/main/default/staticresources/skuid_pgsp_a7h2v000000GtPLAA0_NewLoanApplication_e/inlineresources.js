(function(skuid){
skuid.snippet.register('CloseDialog',function(args) {var params = arguments[0],
    $ = skuid.$;

var message = {
    type: 'action-loan-edit-dialog-close'
};

window.parent.postMessage(message, '*');
});
skuid.snippet.register('RefreshLoanDetails',function(args) {var params = arguments[0],
    $ = skuid.$;

var message = {
    type: 'action-loan-dashboard-loan-details-refresh'
};

window.parent.postMessage(message, '*');
});
}(window.skuid));