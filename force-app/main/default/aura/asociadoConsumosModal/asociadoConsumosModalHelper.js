({
	getConsumosHelper : function(component, event, helper) {
		component.set('v.isLoading', true);
		let id = component.get('v.codigo');
		let currentPage = component.get("v.currentPageNumber");
        LightningUtils.callApex(
        	component,
            "getAsociadoConsumos",
            function(succeed, result, errors) {
                if (succeed) {
					if(!result.hasError){
						if(result.asociadoConsumos.length > 0){
							component.set('v.consumos', result.asociadoConsumos);
							let pageSize = component.get("v.pageSize");
							component.set("v.totalPages", Math.ceil(result.paginado.total/pageSize) );
							component.set("v.currentPageNumber", result.paginado.current);
							component.set('v.isLoading', false);
							helper.generatePageList(component);
						} else {
							LightningUtils.showToast("No hay datos", 'No se encontraron consumos para este afiliado en SaludSoft', {"type":"warning"});
							component.set('v.isLoading', false);
						}
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
						component.set('v.isLoading', false);
					}
                } else {
                    LightningUtils.showToast("Error", errors[0].message, {"type":"error"});
					component.set('v.isLoading', false);
                }
				
                
            },
			{ 
				codigoDeAsociado : id,
				currentPage : currentPage
			} 
        );
	},

	generatePageList : function(component){
		let pageNumber = component.get("v.currentPageNumber");
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                }
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    }
})