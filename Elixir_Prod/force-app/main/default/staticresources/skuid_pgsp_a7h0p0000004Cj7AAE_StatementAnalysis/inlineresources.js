(function(skuid){
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
	    var templateModel = skuid.model.getModel('TemplateDetails');
	    var statementAnalysisDetailModel = skuid.model.getModel('Statement_Analysis');
        console.log("test1:"+statementAnalysisDetailModel.data);
        $('.statement-analysis-table').each(
            function(tableIndex, table) {
                $(table).find('table tbody tr').each(
                    function(index, element) {
                        if(templateModel.data[index]){
                            var level = templateModel.data[index].clcommon__Level__c;
                            if(level) {
                                $(element).attr('level', level.split('.').length);
                            } else {
                                $(element).attr('level', 0);    
                            }
                            $(element).attr('row-type', templateModel.data[index].clcommon__Type__c);
                        }
                    }
                )
            }
        )
        
        $(window.document.body).find('a').each(function(index, link) {
    		$(link).attr('target', '_blank');
    	});
    	
		$('.statement-analysis-detail').each(
    	    function(tableIndex,table){
    	        console.log(table);
    	        if(statementAnalysisDetailModel.data[tableIndex]){
    	            var tableData =  statementAnalysisDetailModel.data[tableIndex];
    	            console.log(tableData);
    	            $(table).find('.nx-field div.nx-fieldtext div.nx-template').each(
                        function(index,element){
                           
                            var level = tableData.clcommon__Statement_Analysis_Detail__r.records[index].clcommon__Template_Detail__r.clcommon__Level__c;
                            console.log(level);
                            if(level) {
                                $(element).attr('level', level.split('.').length);
                            } else {
                                $(element).attr('level', 0);    
                            }
                            $(element).attr('row-type', tableData.clcommon__Statement_Analysis_Detail__r.records[index].clcommon__Template_Detail__r.clcommon__Type__c);
                            console.log(element);
                        }
                    )
    	        }
    	        
    	    }
    	);
    	
	});
	

    /*$('.st-detail-field').each(
        function(index, element) {
                    if(statementAnalysisDetailModel.data[index]){
                        var level = statementAnalysisDetailModel.data[index].clcommon__Template_Detail__r.clcommon__Level__c;
                        if(level) {
                            $(element).attr('level', level.split('.').length);
                        } else {
                            $(element).attr('level', 0);    
                        }
                        $(element).attr('row-type', statementAnalysisDetailModel.data[index].clcommon__Type__c);   
                        console.log($(element));
                    }
                }
            );
        }
    );*/
})(skuid);;
}(window.skuid));