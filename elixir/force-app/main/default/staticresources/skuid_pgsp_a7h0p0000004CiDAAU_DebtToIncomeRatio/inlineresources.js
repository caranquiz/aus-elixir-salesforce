(function(skuid){
skuid.snippet.register('computeDTI',function(args) {var params = arguments[0],
				$ = skuid.$;
				var appId = skuid.model.getModel('ApplicationData').data[0].Id;
				var returnMsg = sforce.apex.execute('genesis.ComputeDebtToIncomeRatio', 'computeDebtToIncomeRatio', { objectID : appId });
                var dfd = new $.Deferred();
				if (returnMsg[0].includes("success")) {
                    return dfd.resolve( {
                        message : returnMsg[0]
                    });
                }
                else {
                    alert(returnMsg);
                    return dfd.resolve( {
                        message : 'Loading...'
                    });
                }
});
}(window.skuid));