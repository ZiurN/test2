public without sharing class CotizadorBtnCtrl {
    @AuraEnabled
    public static Response sendToWSCotizadorCorp(ID opportunityId, ID fileId){
        ContentVersion fileData = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId = :fileId];
		Opportunity opp = [
			SELECT Plan_Grupo_Corporativo__c,Tipo_de_mercado__c,CUIT__c,Oportunidad_Corporativa__r.Codigo_de_empresa__c,
				Name, Owner.Name
			FROM Opportunity
			WHERE Id = :opportunityId
		];

		System.debug('opp.Owner.Name' + opp.Owner.Name);
		
		User usuario = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId()];
		System.debug('usuario.Name' + usuario.Name);

		Map<String,Object> bodyMap = new Map<String,Object>{
			'archivo' => 'data:text/plain;base64,'+ EncodingUtil.base64Encode(fileData.VersionData),
			'transaccionId' => 123,
			'tipoMercado' => opp.Tipo_de_mercado__c,
			'cuit' => opp.CUIT__c,
			'empresa' => opp.Name,
			'responsable' => opp.Owner.Name,
			'cotizador' => usuario.Name
		};
		if(opp.CUIT__c != null){
			bodyMap.put('cuit',opp.CUIT__c);
		}
		if(opp.Oportunidad_Corporativa__r.Codigo_de_empresa__c != null){
			bodyMap.put('empresa',opp.Oportunidad_Corporativa__r.Codigo_de_empresa__c);
		}
        String body = JSON.serialize(bodyMap);
		System.debug(body);
		List<ContentDocument> docs = [SELECT Id FROM ContentDocument WHERE Id = :fileId];
		List<ContentDocumentLink> links = [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :fileId AND LinkedEntityId = :opportunityId];
		if(opp.Plan_Grupo_Corporativo__c == null){
			delete docs;
			return new Response(true, 'Debe seleccionar un plan para cotizar');
		}

		if(opp.Tipo_de_mercado__c == null){
			delete docs;
			return new Response(true, 'Debe seleccionar un tipo de mercado para cotizar');
		}
        WSCotizador.ResponseCorporativa wsResponse = WSCotizador.cotizarCorporativa(body);
        if(!wsResponse.hasError) {
		//------------------------------------------ *** NUEVO *** -----------------------------------------------
			WSCotizador.ResponseCorporativaPDF wsResponsePDF = WSCotizador.getCorporativaPDF(
				wsResponse.cotizacion.data.idCotizacion
			);
			if(!wsResponsePDF.hasError) {
				
		//--------------------------------------------------------------------------------------------------------

            String archivo = wsResponse.cotizacion.data.archivo.substringAfter(',');
            Cotizacion__c cotizacionCorpToInsert = new Cotizacion__c ();
            cotizacionCorpToInsert.recordTypeId = XappiaHelper.getRecordType('Cotizacion__c','Cotizacion_Corporativos').Id;
            cotizacionCorpToInsert.Oportunidad__c = opportunityId;
            cotizacionCorpToInsert.Nro_Cotizacion_Corporativa__c = wsResponse.cotizacion.data.idCotizacion;
            insert cotizacionCorpToInsert;
			
			//ContentVersion ver = new ContentVersion();
			//ver.VersionData = EncodingUtil.base64Decode(archivo);
			//ver.Title = 'Cotizacion-' + String.valueOf(Date.today()) + '.csv';
			//ver.PathOnClient = '/cotizacion' + cotizacionCorpToInsert.Id;
			//insert ver;

			//ver = [
				//SELECT ContentDocumentId
				//FROM ContentVersion
				//WHERE Id = :ver.Id
			//];			
 
			//ContentDocumentLink newLink = new ContentDocumentLink();
			//newLink.LinkedEntityId = cotizacionCorpToInsert.Id;
			//newLink.ContentDocumentId = ver.ContentDocumentId;
			//newLink.ShareType = 'V';
			//insert newLink;
			//------------------------------------------ *** NUEVO *** -----------------------------------------------
			String archivoPdf = wsResponsePDF.cotizacion.data.base64.substringAfter(',');

			attachFile(cotizacionCorpToInsert.Id, archivo, 'xlsx');
			attachFile(cotizacionCorpToInsert.Id, archivoPdf, 'pdf');

			//ContentVersion verPDF = new ContentVersion();
			//verPDF.VersionData = EncodingUtil.base64Decode(archivoPdf);
			//verPDF.Title = 'Cotizacion-pdf-' + String.valueOf(Date.today());
			//verPDF.PathOnClient = '/cotizacion_pdf_' + cotizacionCorpToInsert.Id + '.pdf';
			//insert verPDF;

			//verPDF = [
				//SELECT ContentDocumentId
				//FROM ContentVersion
				//WHERE Id = :verPDF.Id
			//];			
 
			//ContentDocumentLink newLinkPDF = new ContentDocumentLink();
			//newLinkPDF.LinkedEntityId = cotizacionCorpToInsert.Id;
			//newLinkPDF.ContentDocumentId = verPDF.ContentDocumentId;
			//newLinkPDF.ShareType = 'V';
			//insert newLinkPDF;
			
			}
			//--------------------------------------------------------------------------------------------------------
            delete docs;
			/*Opportunity oportunidadCorp = [SELECT Cotizacion_Corporativa_elegida__c FROM Opportunity WHERE ID = :opportunityId];
            oportunidadCorp.Cotizacion_Corporativa_elegida__c = cotizacionCorpToInsert.Id;
            update oportunidadCorp;*/
            return new Response(false, 'Carga de cotizacion exitosa');
        } else {
            return new Response(true, wsResponse.message);
        }
        
    }

    public static void attachFile(Id LinkedEntityId, String base64, String fileType) {
		ContentVersion ver = new ContentVersion();
		ver.VersionData = EncodingUtil.base64Decode(base64);
		ver.Title = 'Cotizacion_' + fileType + '_' + String.valueOf(Date.today());
		ver.PathOnClient = '/cotizacion' + LinkedEntityId + '.' + fileType;
		insert ver;

		ver = [
			SELECT ContentDocumentId
			FROM ContentVersion
			WHERE Id = :ver.Id
		];			
 
		ContentDocumentLink newLink = new ContentDocumentLink();
		newLink.LinkedEntityId = LinkedEntityId;
		newLink.ContentDocumentId = ver.ContentDocumentId;
		newLink.ShareType = 'V';
		insert newLink;
	}
	
	@AuraEnabled
    public static Response sendToWSCotizadorInd(ID cotizacionId){

        Cotizacion__c cotizacion = [SELECT Id,Nombre_y_Apellido__c,Edad__c,LocId__c,
                Tipo_de_Documento__c,Nro_de_Documento__c,Estado_Civil__c,Precio_1er_hijo_menor_21_aos__c,
                Edad_conyuge__c, Telfono__c, Tipo_de_afiliado__c, Pago_con_debito__c,Deduccin_de_aportes_Monotributo__c,
                Sueldo_bruto__c, Tipo_de_contacto__c, Hijos_hasta_20_aos__c, Hijos_entre_21_y_25_aos__c,
                Correo_electronico__c, Monotributista_conyuge__c, Plan_a_cotizar__c,Grupo_de_Afinidad__c,
                Oportunidad__r.Piso__c, Oportunidad__r.Calle__c, Oportunidad__r.Numero__c, Nro_cotizacion_individual__c,
                Precio_Titular__c, Precio_Conyuge__c, Precio_hijo_entre_21_y_25_aos__c,Precio_2do_hijo_menor_21_aos__c,
                Precio_total__c, Deduccion_de_aportes__c, Bonif_especial_6_meses__c,Precio_3er_hijo_menor_21_aos__c,
                Diferencia_a_pagar__c, Total_de_capitas_cotizadas__c,Dto_pago_con_tarjeta_de_credito__c,Localidad__c,
				Localidad_new__r.Loc_Id__c,Grupo_de_potencialidad__c,Aporta_por_hijos__c,Bonif_Grupo_potencialidad__c,
                Bonif_Especial_por_Grupo_de_Afinidad__c,Bonificacion_por_region__c,Grupo_de_Afinidad__r.Id_Externo_G_Afinidad__c,
				Oportunidad__r.Agencia__c
                FROM Cotizacion__c WHERE Id = :cotizacionId];

		List<Account> agenciaOpp = [SELECT Id,Codigo_de_delegacion__c FROM Account WHERE Id = :cotizacion.Oportunidad__r.Agencia__c];
		Map<String,Object> bodyDom = new Map<String, Object>{
			'direccion' => cotizacion.Oportunidad__r.Calle__c + ' ' + cotizacion.Oportunidad__r.Numero__c,
			'localidadId' => cotizacion.Localidad_new__r.Loc_Id__c != null ? Integer.valueOf(cotizacion.Localidad_new__r.Loc_Id__c) : null
		};

		Map<String,Object> bodyMap = new Map<String,Object>{
				'nombrePersona' => cotizacion.Nombre_y_Apellido__c,
				'edad' => cotizacion.Edad__c,
				'tipoDniId' => cotizacion.Tipo_de_Documento__c,
				'numeroDni' => cotizacion.Nro_de_Documento__c,
				'domicilio' => bodyDom,
				'estadoCivilId' => cotizacion.Estado_Civil__c,
				'tipoAfiliadoId' => codigoTipoAfiliado(cotizacion.Tipo_de_afiliado__c),
				'sueldoBruto' => cotizacion.Sueldo_bruto__c != null ? cotizacion.Sueldo_bruto__c : 0,
				'tipoContactoId' => cotizacion.Tipo_de_contacto__c != null ? Integer.valueOf(cotizacion.Tipo_de_contacto__c) : null,
				'cantHijosHasta20' => cotizacion.Hijos_hasta_20_aos__c != null ? cotizacion.Hijos_hasta_20_aos__c : 0,
				'cantHijosEntre21y25' => cotizacion.Hijos_entre_21_y_25_aos__c != null ? cotizacion.Hijos_entre_21_y_25_aos__c : 0,
				'email' => cotizacion.Correo_electronico__c,
				'conyugeMonotributista' => cotizacion.Monotributista_conyuge__c == 'Si',
				'formaDePagoId' => cotizacion.Pago_con_debito__c != null ? Integer.valueOf(cotizacion.Pago_con_debito__c) : null,
				'planId' => cotizacion.Plan_a_cotizar__c,
                'potencialidad' => cotizacion.Grupo_de_potencialidad__c,
				'aportaPorHijos' => cotizacion.Aporta_por_hijos__c == 'Si'

		};

			//if(!agenciaOpp.isEmpty()){
				//bodyMap.put('agenciaId',Integer.valueOf(agenciaOpp[0].Codigo_de_delegacion__c));
			//}
            if(cotizacion.Grupo_de_Afinidad__c != null){
				bodyMap.put('grupoAfinidadId',Integer.valueOf(cotizacion.Grupo_de_Afinidad__r.Id_Externo_G_Afinidad__c));
			}
            if(cotizacion.Telfono__c != null){
                bodyMap.put('nroTelefono',cotizacion.Telfono__c);
            }

		if(cotizacion.Tipo_de_contacto__c == '2' && (cotizacion.Estado_Civil__c == 'C' || cotizacion.Estado_Civil__c == 'N')){
			bodyMap.put('edadConyuge',cotizacion.Edad_conyuge__c != null ? cotizacion.Edad_conyuge__c : 0);
		}

		String body = JSON.serialize(bodyMap);

       


        WSCotizador.Response wsResponse = WSCotizador.cotizar(body);

        if(!wsResponse.hasError){
            cotizacion.Nro_cotizacion_individual__c = wsResponse.cotizacion.data.id;
            cotizacion.Precio_Titular__c = String.valueOf(wsResponse.cotizacion.data.precioTitular);
            cotizacion.Precio_Conyuge__c =  wsResponse.cotizacion.data.precioConyuge != null ? 
			String.valueOf(wsResponse.cotizacion.data.precioConyuge) : null;
            cotizacion.Precio_hijo_entre_21_y_25_aos__c = wsResponse.cotizacion.data.precioHijosEntre21y25 != null ? 
			String.valueOf(wsResponse.cotizacion.data.precioHijosEntre21y25) : null;
            cotizacion.Precio_total__c =  String.valueOf(wsResponse.cotizacion.data.precioTotal);
            cotizacion.Deduccion_de_aportes__c =  String.valueOf(wsResponse.cotizacion.data.deduccionAportes);
			cotizacion.Deduccin_de_aportes_Monotributo__c = wsResponse.cotizacion.data.deduccionAportesMonotributo != null ?
			String.valueOf(wsResponse.cotizacion.data.deduccionAportesMonotributo) : null;
            cotizacion.Bonif_especial_6_meses__c = wsResponse.cotizacion.data.bonificacionEspecial6Meses != null ? 
			String.valueOf(wsResponse.cotizacion.data.bonificacionEspecial6Meses) : null;
            cotizacion.Diferencia_a_pagar__c = wsResponse.cotizacion.data.diferenciaAPagar != null ? 
			String.valueOf(wsResponse.cotizacion.data.diferenciaAPagar) : null;
            cotizacion.Total_de_capitas_cotizadas__c =  String.valueOf(wsResponse.cotizacion.data.totalCapitas);
            cotizacion.Dto_pago_con_tarjeta_de_credito__c = wsResponse.cotizacion.data.descuentoPorPagoTarjeta != null ? 
			String.valueOf(wsResponse.cotizacion.data.descuentoPorPagoTarjeta) : null;
			cotizacion.Precio_1er_hijo_menor_21_aos__c = wsResponse.cotizacion.data.precioPrimerHijoMenor21 != null ?
			 String.valueOf(wsResponse.cotizacion.data.precioPrimerHijoMenor21) : null;
			cotizacion.Precio_2do_hijo_menor_21_aos__c = wsResponse.cotizacion.data.precioSegundoHijoMenor21 != null ?
			 String.valueOf(wsResponse.cotizacion.data.precioSegundoHijoMenor21) : null;
			cotizacion.Precio_3er_hijo_menor_21_aos__c = wsResponse.cotizacion.data.precioTercerHijoOMasMenores21 != null ? 
			String.valueOf(wsResponse.cotizacion.data.precioTercerHijoOMasMenores21) : null;
			cotizacion.Descuento_pago_debito_cbu__c	 = wsResponse.cotizacion.data.descuentoPorPagoDebitoCBU != null ? 
			String.valueOf(wsResponse.cotizacion.data.descuentoPorPagoDebitoCBU) : null;
			cotizacion.Capital_social_cooperativo__c = wsResponse.cotizacion.data.capitalSocialCooperativo != null ? 
                wsResponse.cotizacion.data.capitalSocialCooperativo : null;
            cotizacion.Bonificacion_por_region__c = wsResponse.cotizacion.data.descuentoZonal != null ? String.valueOf(wsResponse.cotizacion.data.descuentoZonal) : null;
			cotizacion.Bonif_Grupo_potencialidad__c = wsResponse.cotizacion.data.bonificacionGrupoPotencialidad != null ?
                String.valueOf(wsResponse.cotizacion.data.bonificacionGrupoPotencialidad) : null;
            cotizacion.Bonif_Especial_por_Grupo_de_Afinidad__c = wsResponse.cotizacion.data.bonificacionEspecialGrupoAfinidad != null ?
                String.valueOf(wsResponse.cotizacion.data.bonificacionEspecialGrupoAfinidad) : null;
            
            update cotizacion;
            return new Response(false, 'Se realizó correctamente la cotización');
        } else {
			System.debug(wsResponse);
            return new Response(true, wsResponse.message);
        }

    }

	private static String codigoTipoAfiliado(String tipo){
		switch on tipo{
			when 'Voluntario'{
				return '1';
			}
			when 'Relacion de Dependencia'{
				return '2';
			}
			when 'Monotributista'{
				return '3';
			}
			when else{
				return '1';
			}
		}
	}

	@AuraEnabled
	public static void generatePDF(Id cotId){
		Cotizacion__c cot = [
			SELECT Id, Nro_cotizacion_individual__c
			FROM Cotizacion__c
			WHERE Id = :cotId
		];
		List<Id> docsId = new List<Id>();
		List<ContentDocumentLink> linksToDelete = [
			SELECT ContentDocumentId
			FROM ContentDocumentLink
			WHERE LinkedEntityId = :cotId
		];
		for(ContentDocumentLink link : linksToDelete){
			docsId.add(link.ContentDocumentId);
		}

		WSCotizadorGetPDF.Response resp = WSCotizadorGetPDF.getPDF(cot.Nro_cotizacion_individual__c);
		if(!resp.hasError){
			ContentVersion version = new ContentVersion();
			version.PathOnClient = '/cotizacion '+ String.valueOf(Date.today()) +'.pdf';
			version.origin = 'H';
			version.Title = 'cotizacion'+String.valueOf(Date.today())+'.pdf';
			version.VersionData = EncodingUtil.base64Decode(resp.cotizacion.data.base_64.substringAfter(','));
			Database.SaveResult versionResult = Database.insert(version);

			if(versionResult.isSuccess()){
				ContentVersion docId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :version.Id];
				ContentDocumentLink link = new ContentDocumentLink();
				link.LinkedEntityId = cotId;
				link.ContentDocumentId = docId.ContentDocumentId;
				link.ShareType = 'V';
				Database.SaveResult linkResult = Database.insert(link);
				if(!linkResult.isSuccess()){PDFException exep = new PDFException(); exep.setMessage('Error al generar PDF');throw exep;}
				else{
					List<ContentDocument> docsToDelete = [
						SELECT Id
						FROM ContentDocument
						WHERE Id IN :docsId
					];
					delete docsToDelete;
				}
			}
		}
		else{
			PDFException exep = new PDFException(); 
			exep.setMessage(resp.message);
			throw exep;
		}
		//PageReference ref = new PageReference('/apex/cotizacionPDF?id='+cotId);
				
		////ref.getParameters().put('id', cotizacion.Id);
		//ContentVersion version = new ContentVersion();
		//version.PathOnClient = '/cotizacion '+ String.valueOf(Date.today()) +'.pdf';
		//version.origin = 'H';
		//version.Title = 'cotizacion'+String.valueOf(Date.today())+'.pdf';
		//try{
			//version.VersionData = ref.getContentAsPDF();
		//}
		//catch(VisualforceException e){
			//if(Test.isRunningTest()){
				//version.VersionData = Blob.valueOf('test blob');
			//}
			//System.debug(e.getMessage());
		//}
		//Database.SaveResult versionResult = Database.insert(version);

		//if(versionResult.isSuccess()){
			//ContentVersion docId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :version.Id];
			//ContentDocumentLink link = new ContentDocumentLink();
			//link.LinkedEntityId = cotId;
			//link.ContentDocumentId = docId.ContentDocumentId;
			//link.ShareType = 'V';
			//Database.SaveResult linkResult = Database.insert(link);
			//if(!linkResult.isSuccess()){PDFException exep = new PDFException(); exep.setMessage('Error al generar PDF');throw exep;}
		//}


	}

	public class PDFException extends Exception{

	}

    public class Response {
        @AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;

		public Response(Boolean hasError, String message){
			this.hasError = hasError;
			this.message = message;
		}
    }
}