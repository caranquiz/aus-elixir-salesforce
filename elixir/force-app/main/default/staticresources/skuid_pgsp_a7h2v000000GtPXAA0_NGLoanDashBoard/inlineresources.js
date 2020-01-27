(function(skuid){
skuid.snippet.register('SelectFirstEntryInQueue',function(args) {var params = arguments[0],
	$ = skuid.$;

$(function() {
    var pageInclude = skuid.$('#relationship-dashboard').data('object');
    pageInclude.load(function() {
        adjustLayoutPartiesTab();
        clickQueueEntry(true, sessionStorage.selectedPartyId);

        window.addEventListener('resize', function() {
            adjustLayoutPartiesTab();
        });
    });
});

function clickQueueEntry(force, partyId) {
    sessionStorage.removeItem('selectedPartyId');
    if (partyId) {
        var clickIndex = 0;
        $.each(skuid.model.getModel('DashboardParty').data, function(index, party) {
            if (party.Id === partyId) {
                clickIndex = index;
                return false;
            }
        });
        $($('#relationship-queue .nx-item.nx-queue-item')[clickIndex]).trigger('click');
    } else {
        if (force) {
            $($('#relationship-queue .nx-item.nx-queue-item')[0]).trigger('click');
        }
    }
}
});
skuid.snippet.register('AdjustLayoutRelationshipDashboard',function(args) {var params = arguments[0],
	$ = skuid.$;

if (sessionStorage.refreshParty) {
    sessionStorage.removeItem('refreshParty');
    var pageInclude = skuid.$('#relationship-dashboard').data('object');
    pageInclude.load(function() {
        adjustLayoutPartiesTab();
        clickQueueEntry(true, sessionStorage.selectedPartyId);
    });
} else {
    adjustLayoutPartiesTab();
    clickQueueEntry(false, sessionStorage.selectedPartyId);
}

function clickQueueEntry(force, partyId) {
    if (partyId) {
        var clickIndex = 0;
        $.each(skuid.model.getModel('DashboardParty').data, function(index, party) {
            if (party.Id === partyId) {
                clickIndex = index;
                return false;
            }
        });
        $($('#relationship-queue .nx-item.nx-queue-item')[clickIndex]).trigger('click');
    } else {
        if (force) {
            $($('#relationship-queue .nx-item.nx-queue-item')[0]).trigger('click');
        }
    }
}
});
skuid.snippet.register('LaunchEditLoanDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'Edit Loan Opportunity';
var skuidPage = 'NewLoanApplication__edit';

launchSimplePopupDialog(appId, title, skuidPage);
});
skuid.snippet.register('LaunchCreditMemoDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'Manage Credit Memo';
var skuidPage = 'CreditMemo';

launchSimplePopupDialog(appId, title, skuidPage);
});
skuid.snippet.register('LaunchChangeMemoDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'Manage Change Memo';
var skuidPage = 'ChangeMemos';

launchSimplePopupDialog(appId, title, skuidPage);
});
skuid.snippet.register('LaunchFeeDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'Manage Fees';
var skuidPage = 'Fees';

launchSimplePopupDialog(appId, title, skuidPage);
});
skuid.snippet.register('LaunchPolicyExceptionDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'Manage Policy Exceptions';
var skuidPage = 'PolicyExceptions';

launchSimplePopupDialog(appId, title, skuidPage);
});
skuid.snippet.register('AddTooltipCollateralTab',function(args) {var params = arguments[0],
	$ = skuid.$;

$(function() {
    var pageInclude = skuid.$('#collateral-tab').data('object');
    pageInclude.load(function() {
        addTooltipCollateralTab();
    });
});
});
skuid.snippet.register('LaunchLoanHistoryDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'View Renewal History';
var skuidPage = 'RenewalHistory';

launchSimplePopupDialog(appId, title, skuidPage);
});
skuid.snippet.register('refreshDocument',function(args) {var params = arguments[0],
	$ = skuid.$;

adjustLayoutLoanTab();

if(sessionStorage.refreshDocument) {
    sessionStorage.removeItem('refreshDocument');
    $('#document-iframe')[0].contentWindow.postMessage({type: 'action-refresh-tree-details'}, '*');
}
});
}(window.skuid));