(function(skuid){
skuid.snippet.register('saveParentChildModels',function(args) {var params = arguments[0],
	$ = skuid.$;

const urlParams = new URLSearchParams(window.location.search);
const appId = urlParams.get('id');
console.log('appId'+appId);

var list = params.list;

var selectedList1 = skuid.$('#assignReasonTable').data('object').list.getSelectedItems();
debugger;
var selectedList3= [];
var descriptionList = [];
var selectedList2= skuid.$('#assignReasonTable').data('object').list.getSelectedItems();//[0].childComponents[0].list.getSelectedItems()

selectedList2.forEach(function(entry){
selectedList3.push(entry.drawers[0].childComponents[0].list.getSelectedItems());
});

selectedList1.forEach(function(item){
    descriptionList.push(item.row.Id);
});

selectedList3.forEach(function(i){
    i.forEach(function(j){
        descriptionList.push(j.row.Id);
    });
});
var result = sforce.apex.execute('genesis.AdverseAction','UpsertSelectedReasons',
{
    applicationId : appId,
    itemsList : descriptionList
});
alert(result);
window.location.reload();
});
skuid.snippet.register('expandAllDrawers',function(args) {var params = arguments[0],
	$ = skuid.$;


$('#assignReasonTable > div.nx-editor-contents > table > tbody > tr>td>div>div.nx-skootable-buttonicon').find('.fa-angle-down').click();
});
}(window.skuid));