(function(skuid){
skuid.snippet.register('OpenPreviewDialog',function(args) {var params = arguments[0],
	$ = skuid.$;
var attachmentRow = skuid.model.getModel('NewAttachmentModel').getFirstRow();
var title = attachmentRow.Name;

const docAId = skuid.page.params.id
var iframeUrl = '/apex/genesisExtn__previewDocCategory?id=' + attachmentRow.Id+'&docAId='+docAId + '&isdtp=vw';
		
openTopLevelDialog({
    title: 'Document Viewer-'+ title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('AddAttachmentsModal',function(args) {var params = arguments[0],
	$ = skuid.$;
var selectDocument = skuid.model.getModel('DocumentCategoryDetails').data[0];
var title = 'Add Application Documents to ' + selectDocument.clcommon__Category_Name__c; 
var skuidPage = 'ApplicationAttachmentList';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + selectDocument.Id;
var prefixHtml = '<div><p>Select the following application documents that have not been added to any application document category and add them to <strong>' + selectDocument.clcommon__Category_Name__c + '</strong>.</p></div>';
openTopLevelDialog({
	title: title,
	iframeUrl: iframeUrl,
	prefixHtml: prefixHtml
});
});
skuid.snippet.register('DeleteAttachment',function(args) {var params = arguments[0],
	$ = skuid.$;
var catAssociation = skuid.model.getModel('CatDocAssociation').data[0];
var documentId = catAssociation.clcommon__Attachment_Id__c;
var parentId = catAssociation.clcommon__Document_Category__c;
var documentName = catAssociation.Name;


var title = 'Delete ' + documentName + '?';
var message = '<p>Are you sure you want to Delete this Application Document'
			+ ', <strong>\'' + documentName + '\'</strong>?</p>';
var cancelText = 'No, do not Delete anything.';
var okText = 'Yes, Delete Application Document'
			+ ' \'' + documentName + '\'';

var okAction = {
	func: 'generateDeleteDocumentMessage',
	parameters: [documentId, parentId]
};

openTopLevelConfirmation({
	title: title,
	message: message,
	cancelText: cancelText,
	okText: okText,
	okAction: okAction
});
});
skuid.snippet.register('DeleteDocumentCategory',function(args) {var params = arguments[0],
	$ = skuid.$;
var selectDocument = skuid.model.getModel('DocumentCategoryDetails').data[0];
var documentCategoryId = selectDocument.Id;	
var documentCategoryName = selectDocument.clcommon__Category_Name__c

var title = 'Delete ' + documentCategoryName + '?';
var message = '<p>Are you sure you want to Delete this Application Document Category'
			+ ', <strong>\'' + documentCategoryName + '\'</strong>?</p>';
var cancelText = 'No, do not Delete anything.';
var okText = 'Yes, Delete Application Document Category'
			+ ' \'' + documentCategoryName + '\'';

var okAction = {
	func: 'generateDeleteDocumentCategoryMessage',
	parameters: [documentCategoryId]
};

openTopLevelConfirmation({
	title: title,
	message: message,
	cancelText: cancelText,
	okText: okText,
	okAction: okAction
});
});
skuid.snippet.register('DocumentListForNotification',function(args) {var params = arguments[0],
	$ = skuid.$;
var selectDocument = skuid.model.getModel('DocumentCategoryDetails').data[0];
var title = 'Document Request'; 
var skuidPage = 'DocumentNotification';
var rootId = selectDocument.clcommon__Account__c !=null ? selectDocument.clcommon__Account__c : selectDocument.clcommon__Collateral__c;
if(rootId == '' || rootId == undefined){
    rootId = selectDocument.genesis__Application__c;
}
var iframeUrl = '/apex/skuid__ui?page='+skuidPage + '&id=' + selectDocument.genesis__Application__c +'&rootId=' +rootId  ;
var prefixHtml = '<div><p><strong>Select Documents For Notification </strong>.</p></div>';
openTopLevelDialog({
    title: title,
	iframeUrl: iframeUrl,
	prefixHtml: prefixHtml
});
});
skuid.snippet.register('SendDocuments',function(args) {var params = arguments[0],
	$ = skuid.$;
var appdata = skuid.model.getModel('ApplicationModel');
var approw = appdata.data[0];

var partyData = skuid.model.getModel('BorrowerModel');
var partyRow = partyData.data[0];
var copartyData = skuid.model.getModel('CoBorrowerModel');
var copartyRow = copartyData.data[0];
try{
    var creditdata = sforce.connection.query("SELECT Id,Name,genesis__Applications__c,genesis__Fico_Score__c FROM ints__Credit_Report__c WHERE genesis__Applications__c ='"+ approw.Id +"' ORDER BY CreatedDate DESC LIMIT 1 ");
    var creditrow = creditdata.getArray("records");
    
    var copartyData = sforce.connection.query("SELECT Id,Name,clcommon__Account__c,genesis__Application__c,clcommon__Contact__c FROM clcommon__Party__c WHERE genesis__Application__c ='"+ approw.Id +"' AND clcommon__Type__r.Name = 'CO-BORROWER' ORDER BY CreatedDate DESC LIMIT 1 ");
    var copartyRow = copartyData.getArray("records");
    
    var partyData = sforce.connection.query("SELECT Id,Name,clcommon__Account__c,genesis__Application__c,clcommon__Contact__c FROM clcommon__Party__c WHERE genesis__Application__c ='"+ approw.Id +"' AND clcommon__Type__r.Name = 'BORROWER' ORDER BY CreatedDate DESC LIMIT 1 ");
    var partyRow = partyData.getArray("records");
    
    var QuerydataResults = sforce.connection.query("SELECT Id,Name,APXTConga4__Name__c FROM APXTConga4__Conga_Merge_Query__c ");
    Querydata = QuerydataResults.getArray("records");
    console.log(Querydata);
    
    var templatesdataResults = sforce.connection.query("SELECT Id,Name,APXTConga4__Name__c FROM APXTConga4__Conga_Template__c ");
    Templatedata = templatesdataResults.getArray("records");
    console.log(Templatedata);
    
    var link1= '/apex/APXTConga4__Conga_Composer?&SolMgr=1';
    var date = new Date();
    var i,
    link2= '&Id='+approw.Id+
               '&QueryId=';
    var len = Querydata.length;
    for(i=0;i<len;i++){
        if(Querydata[i].APXTConga4__Name__c == 'Application Query')
            link2 += '[AQ]'+Querydata[i].Id+'%3Fpv0%3D'+approw.Id;
       
        if(Querydata[i].APXTConga4__Name__c == 'Adverse Action Query')
            link2 += ',[ADVACTION]'+Querydata[i].Id+'%3Fpv0%3D'+approw.Id;
        
        if(creditrow.length>0 &&  Querydata[i].APXTConga4__Name__c == 'Credit Report Query')
            link2 += ',[CREDITSCORE]'+Querydata[i].Id+'%3Fpv0%3D'+creditrow[0].Id;
        
        if(Querydata[i].APXTConga4__Name__c == 'Contact Query'){
            if(partyRow.length > 0)
                link2 += ',[CONTACT]'+Querydata[i].Id+'%3Fpv0%3D'+partyRow[0].clcommon__Contact__c;
            if(copartyRow.length > 0)
                link2 += ',[COBORROWER]'+Querydata[i].Id+'%3Fpv0%3D'+copartyRow[0].clcommon__Contact__c;
        }
        if(Querydata[i].APXTConga4__Name__c == 'Employer Query'){
            if(partyRow.length > 0)
                link2 += ',[EMPLOYER]'+Querydata[i].Id+'%3Fpv0%3D'+approw.Id+'%7Epv1%3D'+partyRow[0].clcommon__Contact__c;
            if(copartyRow.length > 0)    
                link2 += ',[COEMPLOYER]'+Querydata[i].Id+'%3Fpv0%3D'+approw.Id+'%7Epv1%3D'+copartyRow[0].clcommon__Contact__c;
        }
        
        if(Querydata[i].APXTConga4__Name__c == 'Previous Employer Query'){
            if(partyRow.length > 0)
                link2 += ',[PREEMPLOYER]'+Querydata[i].Id+'%3Fpv0%3D'+approw.Id+'%7Epv1%3D'+partyRow.clcommon__Contact__c;
            if(copartyRow.length > 0)
                link2 += ',[PRECOEMPLOYER]'+Querydata[i].Id+'%3Fpv0%3D'+approw.Id+'%7Epv1%3D'+copartyRow.clcommon__Contact__c;
        } 
        
        if(Querydata[i].APXTConga4__Name__c == 'Other Source Of Income Query'){
            if(partyRow.length > 0)
                link2 += ',[OTHERINCOME]'+Querydata[i].Id+'%3Fpv0%3D'+approw.Id+'%7Epv1%3D'+partyRow.clcommon__Contact__c;
            if(copartyRow.length > 0)
                link2 += ',[COOTHERINCOME]'+Querydata[i].Id+'%3Fpv0%3D'+approw.Id+'%7Epv1%3D'+copartyRow.clcommon__Contact__c;
        } 
        if(Querydata[i].APXTConga4__Name__c == 'Outstanding debts'){
            link2 += ',[DEBTS]'+Querydata[i].Id+'%3Fpv0%3D'+approw.Id;
        }
        if(Querydata[i].APXTConga4__Name__c == 'Asset Information'){
            link2 += ',[ASSETS]'+Querydata[i].Id+'%3Fpv0%3D'+approw.Id;
        }
        if(Querydata[i].APXTConga4__Name__c == 'Driver License Query'){
            if(partyRow.length > 0)
                link2 += ',[BORROWERDL]'+Querydata[i].Id+'%3Fpv0%3D'+approw.Id+'%7Epv1%3D'+partyRow.clcommon__Account__c;
            if(copartyRow.length > 0)
                link2 += ',[COBORROWERDL]'+Querydata[i].Id+'%3Fpv0%3D'+approw.Id+'%7Epv1%3D'+copartyRow.clcommon__Account__c;
        }
    }
    for(i=0;i<Templatedata.length;i++){
        if(params.row.clcommon__Category_Name__c == 'Adverse Action notice' &&  Templatedata[i].APXTConga4__Name__c == 'Adverse Action Letter - Non Real Estate')
            link2 += '&TemplateId='+Templatedata[i].Id;
        if(params.row.clcommon__Category_Name__c == 'Credit Application' && Templatedata[i].APXTConga4__Name__c == 'Consumer Credit Application - Non-Real Estate')
            link2 += '&TemplateId='+Templatedata[i].Id;
    }
    link2 +=  '&SC0=1&SC1=Attachments&DefaultPDF=1&DS7=7';    
    var finallink = link1+link2;
    window.open(finallink);
}catch(Exception){
    alert('Conga is not configured in this org.');
}
});
}(window.skuid));