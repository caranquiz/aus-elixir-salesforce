(function(skuid){
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