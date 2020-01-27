(function(skuid){
skuid.snippet.register('newSnippet',function(args) {debugger
                var field = arguments[0],
                $ = skuid.$,
                id = arguments[1].Owner.Id,
                meetingSchedule=skuid.$M("PastMeetingSchedule");

                $.each(meetingSchedule.getRows(), function(index, row){
                debugger
                if(row.Id==id){
                $(field[0]).css("background-color","#"+row.CalendarColor__c);
                return false;
                }
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