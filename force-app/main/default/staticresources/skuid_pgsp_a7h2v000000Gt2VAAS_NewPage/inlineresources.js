(function(skuid){
(function(skuid){
	skuid.$(document.body).one('pageload',function(){
		var m = skuid.$M('pgs__NewPage');
		// Create a default row
		m.createRow();
		// Prevent leaving this page if our Model has unsaved changes
		m.preventUnloadIfUnsavedChanges = true;
	});
})(skuid);;
}(window.skuid));