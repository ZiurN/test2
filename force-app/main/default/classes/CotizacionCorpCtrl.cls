public class CotizacionCorpCtrl  {
	
	private final Cotizacion__c cotizacion;
	private List<List<String>> cotTable = new List<List<String>>();
	private Integer rows = 0;

	public CotizacionCorpCtrl(){
		cotizacion = [
			SELECT Id
			FROM Cotizacion__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('id')
		];
		List<ContentDocumentLink> cotizacionLinks = [
			SELECT Id, ContentDocumentId
			FROM ContentDocumentLink
			WHERE LinkedEntityId = :cotizacion.Id
		];
		if(cotizacionLinks.isEmpty()){
			return;
		}
		List<ContentVersion> cotizacionVersion = [
			SELECT Id,VersionData,Title 
			FROM ContentVersion
			WHERE ContentDocumentId = :cotizacionLinks[0].ContentDocumentId
		];
		if(cotizacionVersion.isEmpty()){
			return;
		}
		System.debug(cotizacionVersion[0].Title);
        String myFile = cotizacionVersion[0].VersionData.toString();
        List<String> filas = myFile.split('\n');
        Integer size = filas[0].split(',').size();

		System.debug('tamaño de primer fila ' + size); 
		for(Integer i=0; i < filas.size(); i++){
			List<String> firstRow = filas[i].replaceAll('"','').split(',');
			rows = firstRow.size();
			System.debug('Fila ' + i + ' tamaño: ' + rows); 
            if(rows >= size -1 && rows < size +1){
				cotTable.add(firstRow);
            }
		}
	}

	public Cotizacion__c getCotizacion(){
		return cotizacion;
	}

	public List<List<String>> getCotTable(){
		return cotTable;
	}

	public Integer getRows(){
		return rows;
	}
}