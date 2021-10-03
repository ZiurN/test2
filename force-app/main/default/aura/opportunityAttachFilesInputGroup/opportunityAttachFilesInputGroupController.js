({
	handleUploadFinished: function (cmp, event,helper) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        
        var documentId = uploadedFiles[0].documentId;
        var prefix = event.getSource().get("v.name");
		var entity = cmp.get('v.entityId');
        
		
		var fileName = prefix + '_' + entity;
		var opId = cmp.get('v.recordId');
		
        helper.updateDocument(cmp,event,documentId,fileName,opId);
    },
	init: function (cmp, event, helper) {
        console.log('input group ' + cmp.get("v.isProfileVentas"));
		helper.getFiles(cmp,event,cmp.get('v.recordId'));
    }
})