(function(skuid){
skuid.snippet.register('UpdateRelationshipIFrame',function(args) {var params = arguments[0],
  $ = skuid.$;

var url = $('#relationship-iframe').attr('src');
if (url.lastIndexOf('&id=') >= 0) {
    url = url.substring(0, url.lastIndexOf('&id=')) + '&id=' + params.row.Id;
} else {
    url += '&id=' + params.row.Id;
}

$('#relationship-iframe').attr('src', url);
$('#relationship-iframe').hide();
$('#relationship-iframe').on('load', function() {
    $("#relationship-iframe").show();
});
});
skuid.snippet.register('CustomPickList',function(args) {var field = arguments[0];


var value = arguments[1];



if (field.mode === 'edit') {


    //  Build the Options for the PICKLIST


        var customOpts = [];
         console.log(skuid.model.getModel('StatementParameters').getRows());

        skuid.$.each(skuid.model.getModel('StatementParameters').getRows(), function(i,row) {

             console.log(row.Type);
             console.log(row.Account);
            customOpts.push({


                value : 'ab',         // Will be stored in target object 


                label : 'b'        // Will display in the PICKLIST


            });


        });


    //  Render the options as a PICKLIST


        var customSelect = skuid.ui.renderers.PICKLIST.edit({


            entries : customOpts,


            required : false,


            value : value


        }).change(function() {


            console.log(skuid.$(this));



            //  Update the row in the target object


            //field.model.updateRow(field.row,'Contact__c',skuid.$(this).val());


        });


    //  Append the PICKLIST to the DOM element


        field.element.append(customSelect);


} else {


    //  If the mode is anything other than edit, display the field as Text


    skuid.ui.fieldRenderers.TEXT[field.mode](field,field.model.getFieldValue(field.row,'Account'));


}
});
}(window.skuid));