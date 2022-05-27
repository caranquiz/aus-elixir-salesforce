(function(skuid){
skuid.snippet.register('CreditScoreSimpleView',function(args) {var params = arguments[0],
        $ = skuid.$;

    var simpleView = {
        render: function(item) {
            item.element.html('<div class="credit-score-row"><span class="credit-score-value">'+item.row.genesis__Score__c+'</span><span class="credit-score-type">'+item.row.ints__ModelNameType__c+'</span>');
        }
    };

    return simpleView;
});
skuid.snippet.register('DisplayDefaultZero',function(args) {var field = arguments[0],
    value = arguments[1],
    $ = skuid.$;

    value = (value === null || value == undefined) ? 0 : value;
var renderer = skuid.ui.fieldRenderers[field.metadata.displaytype];
renderer.readonly(field, value);
});
skuid.snippet.register('LaunchCreditHistoryView',function(args) {var params = arguments[0],
    $ = skuid.$;

var party = skuid.model.getModel('NGParty');
var model = party.getFirstRow();
var partyId = model.Id;
var partyName = model.clcommon__Account__r.Name;
var title = 'Credit Report History of ' + partyName;
var skuidPage = 'CreditHistoryPage';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + partyId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('getCreditReport',function(args) {var params = arguments[0],
    $ = skuid.$;

var partyModel = skuid.model.getModel('NGParty');
var party = partyModel.data[0];
console.log(party);

var contactModel = skuid.model.getModel('PartiesContact');
var contact = contactModel.data[0];
console.log(contact);

var appId = party.genesis__Application__c;
var partyId = contact.Id;
var partyName = party.clcommon__Account__r.Name;

console.log(appId, partyId, partyName);

//callbacks.getCreditReport(appId, partyId, partyName);

var displayMessage = function (message, severity) {

    var editor = $('#errorPanelCreditPull ').data('object').editor;
    editor.messages.empty();
    editor.handleMessages([
        {
            message: message,
            severity: severity.toUpperCase()
        }
    ]);

    return false;
};


var result = sforce.apex.execute('genesis.SkuidCreditPullCtrl', 'pullCreditForPartyV2', {
                applicationId: appId,
                partyId: party.Id
            });


if (result && result == 'Credit Pull Successful') {
    window.location.reload(true);
} else {
    var err = 'Cannot get credit report. ' + result;
    return displayMessage(err, 'ERROR');
}
});
(function(skuid){
    var $ = skuid.$;
    $(document.body).one('pageload',function(){
        calculateColor();
        adjustMark();
    });
})(skuid);


function adjustMark() {
    var width = $('.credit-score-bar').width();
    var score = parseInt($('.credit-score-number').text());
    var left = width * (score - 300) / (850 - 300);
    $('.credit-score-number').css('left', (left - $('.credit-score-number').outerWidth() / 2) + 'px');
    $('.credit-score-mark').css('left', (left - 3) + 'px');
    $('.credit-score-mark-top').css('left', (left - 7) + 'px');
    return score;
}

function calculateColor() {
    var score = parseInt($('.credit-score-bg').text());
    var low = 300, middle = 575, high = 850;
    var lowRed = 230, middleRed = 255, highRed = 72;
    var lowGreen = 60, middleGreen = 162, highGreen = 206;
    var lowBlue = 0, middleBlue = 29, highBlue = 148;

    var alpha, red, green, blue;

    if (score < middle) {
        alpha = (score - low) / (middle - low);
        red = Math.floor(alpha * middleRed + (1 - alpha) * lowRed);
        green = Math.floor(alpha * middleGreen + (1 - alpha) * lowGreen);
        blue = Math.floor(alpha * middleBlue + (1 - alpha) * lowBlue);
    } else {
        alpha = (score - middle) / (high - middle);
        red = Math.floor(alpha * highRed + (1 - alpha) * middleRed);
        green = Math.floor(alpha * highGreen + (1 - alpha) * middleGreen);
        blue = Math.floor(alpha * highBlue + (1 - alpha) * middleBlue);
    }

    var color = 'rgb(' + red + ', ' + green + ', ' + blue + ')';
    $('.credit-score-bg').css('background-color', color);
};
}(window.skuid));