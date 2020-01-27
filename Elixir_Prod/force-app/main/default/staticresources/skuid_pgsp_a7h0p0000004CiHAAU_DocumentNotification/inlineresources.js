(function(skuid){
skuid.snippet.register('sendNotification',function(args) {var params = arguments[0],
            	$ = skuid.$;
var selectedList = skuid.$('#documentCategoryList').data('object').list.getSelectedItems();
    if(selectedList.length == 0){
        alert('Please select documents for notification');
        return false;
    }else{
        var docuList;
        var seq = 1;
        var appAccountId = skuid.model.getModel('DocumentCategoryList').data[0].genesis__Application__r.genesis__Account__c;
        var documentCategoryId = skuid.model.getModel('DocumentCategoryList').data[0].clcommon__Parent_Document_Category__c;
        selectedList.forEach(function(item){
            if(!docuList){
                docuList = seq + '.  ' + item.row.clcommon__Category_Name__c;
            }else{
               docuList = docuList+'\n' + seq + '.  ' +item.row.clcommon__Category_Name__c
            }
            seq++;
        });
        var documentNotification = sforce.apex.execute('genesis.DocumentCategoryNotification','sendDocumentCategoryNotification',{
             documentList : docuList ,
             accountId : appAccountId,
             documentCategoryId : documentCategoryId
        });
        alert(documentNotification);
        closeTopLevelDialogAndRefresh({iframeIds: ['nx-page-content']});
       
    }
});
}(window.skuid));