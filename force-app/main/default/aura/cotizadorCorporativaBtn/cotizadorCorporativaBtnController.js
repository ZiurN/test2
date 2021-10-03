({
	handleUploadFinished: function (component, event, helper) {
        var uploadedFiles = event.getParam("files");
        if(uploadedFiles[0].documentId){
            let documentId = uploadedFiles[0].documentId;
            let recordId = component.get("v.recordId");
            helper.sendToWS(component, documentId , recordId );
        }
	}
})