(function(skuid){
(function(skuid) {
    var $ = skuid.$;
    $(function() {
        var RECENT_UPDATES_MODELS = [
            'AgendaTimerStatus'
        ];
        var INTERVAL_IN_SECONDS = 5;
        // Each of our Models should have a Condition named "LastModifiedDate"
        var COMMON_CONDITION_NAME = "LastModifiedDate";
        var milliseconds = INTERVAL_IN_SECONDS * 1000;
        var RecentUpdates = $.map(RECENT_UPDATES_MODELS, function(modelId) {
            return skuid.$M(modelId);
        });
        setInterval(function() {
            var now = new Date();
            var previous = new Date(now.getTime() - milliseconds);
            $.each(RecentUpdates, function(i, model) {
                var condition = model.getConditionByName(COMMON_CONDITION_NAME, true);
                model.setCondition(condition, previous);
            });
            $.when(skuid.model.updateData(RecentUpdates))
                .done(function() {
                    let timerNotProcessing = false;
                    $.each(RecentUpdates, function(i, model) {
                        if (model.getRows()[0].genesis__Timer_Status__c !== 'PROCESSING') {
                            timerNotProcessing = true;
                        }
                    });

                });
        }, milliseconds);
    });
})(skuid);;
skuid.snippet.register('clickVote',function(args) {var field = arguments[0],
                value = skuid.utils.decodeHTML(arguments[1]);
                $ = skuid.$;

                if (field) {
                var buttonID = field.component._GUID
                if (buttonID === 'upvote') {
                $('#upvote').addClass('selected')
                $('#downvote').removeClass('selected')
                } else {
                $('#downvote').addClass('selected')
                $('#upvote').removeClass('selected')
                }
                }
});
}(window.skuid));