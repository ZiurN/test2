@isTest 
private class SegmentoTriggerTest {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseFoundAlta;
	static XHttpCalloutMock getResponseFoundActualizacion;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getErrorResponseAlta;
	static XHttpCalloutMock getErrorResponseActualizacion;

	static {
		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSSegmentoActualizarMock.getFound())
				.addForAddress(WSSegmentoActualizar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos/305715');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
				.withStatus('exception')
				.withStatusCode(404)
				.withBody(WSSegmentoActualizarMock.getError())
				.addForAddress(WSSegmentoActualizar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos/305715');

		getErrorResponseAlta = new XHttpCalloutMock();
		getErrorResponseAlta.buildResponse()
			.withStatus('exception')
			.withStatusCode(404)
			.withBody(WSSegmentoAltaMock.getError())
			.addForAddress(WSSegmentoAlta.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos');

		getResponseFoundActualizacion = new XHttpCalloutMock();
		getResponseFoundActualizacion.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundActualizacion.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSSegmentoActualizarMock.getFound())
				.addForAddress(WSSegmentoActualizar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos/305715');

		getErrorResponseActualizacion = new XHttpCalloutMock();
		getErrorResponseActualizacion.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponseActualizacion.buildResponse()
				.withStatus('exception')
				.withStatusCode(404)
				.withBody(WSSegmentoActualizarMock.getError())
				.addForAddress(WSSegmentoActualizar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos/305715');
	}

	@isTest
	private static void SegmentoActualIsOnlyTheLastSegmento() {
		Evento_medico__c em = new Evento_medico__c(Estado__c = 'Autorizado');
		insert em;
		
		Segmentos__c segmento = new Segmentos__c();
		segmento.Evento_Medico__c = em.Id;
		
		Segmentos__c segmento2 = new Segmentos__c();
		segmento2.Evento_Medico__c = em.Id;
		
		Segmentos__c[] segmentos = new List<Segmentos__c>{segmento, segmento2};

		Test.startTest();
		insert segmentos;
		Test.stopTest();

		Segmentos__c segmentoQuery = [
			SELECT Segmento_actual__c, Numero_del_segmento__c
			FROM Segmentos__c
			WHERE Id =: segmento.Id
		];
		Segmentos__c segmento2Query = [
			SELECT Segmento_actual__c, Numero_del_segmento__c
			FROM Segmentos__c
			WHERE Id =: segmento2.Id
		];
		System.assertEquals(false, segmentoQuery.Segmento_actual__c);
		System.assertEquals(1, segmentoQuery.Numero_del_segmento__c);
		System.assertEquals(true, segmento2Query.Segmento_actual__c);
		System.assertEquals(2, segmento2Query.Numero_del_segmento__c);

	}

	@isTest
	private static void whenDeleteASegmentCheckTheFieldSegmentoActualInTheLastSegmentAndUpdate() {
		Evento_medico__c em = new Evento_medico__c(Estado__c = 'Autorizado');
		insert em;
		Segmentos__c segmento = new Segmentos__c(Evento_Medico__c = em.Id);
		insert segmento;
		Segmentos__c segmento2 = new Segmentos__c(Evento_Medico__c = em.Id);
		insert segmento2;

		Test.startTest();
		delete segmento2;
		Test.stopTest();

		Segmentos__c segToAssert = [
			SELECT Segmento_actual__c 
			FROM Segmentos__c 
			WHERE Id =: segmento.Id
		];

		System.assertEquals(true, segToAssert.Segmento_actual__c);
	}

	@isTest
	private static void testBulk() {
		Evento_medico__c em = new Evento_medico__c(Estado__c = 'Autorizado');
		insert em;
		Segmentos__c segmento1 = new Segmentos__c(Evento_Medico__c = em.Id);
		Segmentos__c segmento2 = new Segmentos__c(Evento_Medico__c = em.Id);
		Segmentos__c segmento3 = new Segmentos__c(Evento_Medico__c = em.Id);
		Segmentos__c segmento4 = new Segmentos__c(Evento_Medico__c = em.Id);
		Segmentos__c segmento5 = new Segmentos__c(Evento_Medico__c = em.Id);
		Segmentos__c segmento6 = new Segmentos__c(Evento_Medico__c = em.Id);
		Segmentos__c segmento7 = new Segmentos__c(Evento_Medico__c = em.Id);
		Segmentos__c segmento8 = new Segmentos__c(Evento_Medico__c = em.Id);
		Segmentos__c segmento9 = new Segmentos__c(Evento_Medico__c = em.Id);
		Segmentos__c segmento10 = new Segmentos__c(Evento_Medico__c = em.Id);

		Test.startTest();
		insert new List<Segmentos__c>{segmento1, segmento2, segmento3, segmento4, segmento5, segmento6, segmento7, segmento8, segmento9, segmento10};
		Test.stopTest();

		Integer i = 1;
		for(Segmentos__c segmento : [
			SELECT Id, Numero_del_segmento__c
			FROM Segmentos__c 
			WHERE Evento_Medico__c =: em.Id
		]) {
			System.assertEquals(i, segmento.Numero_del_segmento__c);
			i++;
		}
	}

	@IsTest
    private static void createSegmentTest() {
        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
		em.RecordTypeId = XappiaHelper.getRecordType('Evento_Medico__c', 'Evento_medico_de_internacion').Id; 
        insert em;

        Datetime actual = System.now();
        Datetime masCincoDias = actual.addDays(5);
        Segmentos__c seg1 = new Segmentos__c(
                Evento_Medico__c = em.Id,
                Fecha_Inicio_tentativa__c = actual,
                Fecha_Fin_tentativa__c = masCincoDias
        );
        insert seg1;

        WSSegmentoAltaMock mock = new WSSegmentoAltaMock();
        String body = mock.getFound(seg1.Id);
        getResponseFoundAlta = new XHttpCalloutMock();
        getResponseFoundAlta.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
				getResponseFoundAlta.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(body)
                .addForAddress(WSSegmentoAlta.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos');
        Test.setMock(HttpCalloutMock.class, getResponseFoundAlta);

		SegmentoQueueable segmentoQueable = new SegmentoQueueable(new List<Segmentos__c>{seg1}, false);
        Test.startTest();
		System.enqueueJob(segmentoQueable);
        Test.stopTest();

        Segmentos__c segToAssert = [SELECT Fecha_Inicio_real__c, Fecha_Fin_real__c FROM Segmentos__c WHERE Id =: seg1.Id];
        Datetime inicio = Datetime.newInstance(2020, 2, 3, 0, 0, 0);
        Datetime fin = Datetime.newInstance(2020, 2, 4, 0, 0, 0);
        System.assertEquals(inicio, segToAssert.Fecha_Inicio_real__c);
        System.assertEquals(fin, segToAssert.Fecha_Fin_real__c);
		System.assertEquals(null, seg1.Error_en_SS__c);
    }

	@IsTest
    private static void createSegmentErrorTest() {
        Test.setMock(HttpCalloutMock.class, getErrorResponseAlta);
        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
		em.Forma_de_egreso__c = 'FUGA';
        insert em;

        Segmentos__c seg = new Segmentos__c(Evento_Medico__c = em.Id);
        insert seg;

		SegmentoQueueable segmentoQueable = new SegmentoQueueable(new List<Segmentos__c>{seg}, false);
        Test.startTest();
		System.enqueueJob(segmentoQueable);
        Test.stopTest();

		Segmentos__c segToAssert = [
			SELECT Error_en_SS__c
            FROM Segmentos__c 
			WHERE Id =: seg.Id
		];
		
		System.assertEquals('<p style="color: rgb(228, 10, 10);">No pudo autorizarse</p>', segToAssert.Error_en_SS__c);
    }

	@IsTest
    private static void updateSegmentTest() {
        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
		em.RecordTypeId = XappiaHelper.getRecordType('Evento_Medico__c', 'Evento_medico_de_internacion').Id;
        insert em;

        Datetime actual = System.now();
        Datetime masCincoDias = actual.addDays(5);
        Segmentos__c seg1 = new Segmentos__c(Semid__c = '305715',
                Evento_Medico__c = em.Id,
                Fecha_Inicio_real__c = actual,
                Fecha_Fin_real__c = masCincoDias
        );
        insert seg1;

        Test.setMock(HttpCalloutMock.class, getResponseFoundActualizacion);
		SegmentoQueueable segmentoQueable = new SegmentoQueueable(new List<Segmentos__c>{seg1}, true);
        Test.startTest();
		System.enqueueJob(segmentoQueable);
        Test.stopTest();

        Segmentos__c segToAssert = [
			SELECT Estado__c, Fecha_Inicio_real__c, Fecha_Fin_real__c
            FROM Segmentos__c 
			WHERE Id =: seg1.Id
		];

        System.assertEquals('Autorizado', segToAssert.Estado__c);
    }

    @IsTest
    private static void updateSegmentErrorTest() {
        Test.setMock(HttpCalloutMock.class, getErrorResponseActualizacion);
        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
        insert em;

        Segmentos__c seg = new Segmentos__c(
			Semid__c = '305715', Evento_Medico__c = em.Id
		);
        insert seg;

		SegmentoQueueable segmentoQueable = new SegmentoQueueable(new List<Segmentos__c>{seg}, true);
        Test.startTest();
		System.enqueueJob(segmentoQueable);
        Test.stopTest();

		Segmentos__c segToAssert = [
			SELECT Error_en_SS__c
            FROM Segmentos__c 
			WHERE Id =: seg.Id
		];

        System.assertEquals('<p style="color: rgb(228, 10, 10);">El segmento solicitado es inválido.</p>', 
			segToAssert.Error_en_SS__c);
    }

	@IsTest
    private static void whenTryingToDeleteTheFirstSegmentoOfTheEmItShouldReturnAnError() {
        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
        insert em;

        Segmentos__c seg = new Segmentos__c(
			Semid__c = '305715', Evento_Medico__c = em.Id
		);
        insert seg;

        Test.startTest();
        Database.DeleteResult result = Database.delete(seg, false);
        Test.stopTest();
        
		System.assertEquals(false, result.isSuccess());
		System.assertEquals('No se puede eliminar el primer segmento del Evento Médico', 
		result.getErrors()[0].getMessage());
    }

	//@IsTest
	//private static void whenInsertASegment_getValidResponseFromWs() {
		//Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
		//insert em;

		//Datetime actual = System.now();
		//Datetime masCincoDias = actual.addDays(5);
		//Segmentos__c seg = new Segmentos__c(
				//Evento_Medico__c = em.Id,
				//Fecha_Inicio_tentativa__c = actual,
				//Fecha_Fin_tentativa__c = masCincoDias
		//);
		//insert seg;

		//WSSegmentoAltaMock mock = new WSSegmentoAltaMock();
		//String body = mock.getFound(seg.Id);
		//XHttpCalloutMock getResponseFoundAlta = new XHttpCalloutMock();
		//getResponseFoundAlta.buildResponse()
				//.withStatus('OK')
				//.withStatusCode(200)
				//.withBody(WSAuthTokenMock.getTokenSuccess())
				//.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		//getResponseFoundAlta.buildResponse()
				//.withStatus('OK')
				//.withStatusCode(200)
				//.withBody(body)
				//.addForAddress(WSSegmentoAlta.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos');
		//Test.setMock(HttpCalloutMock.class, getResponseFoundAlta);
		//Test.startTest();
		//SegmentoHelper.sendSegmentToSS(new List<String>{seg.Id});
		//Test.stopTest();

		//Segmentos__c segToAssert = [
				//SELECT Semid__c, Datetime_Insert_Trigger__c, Result_Insert_Trigger__c, Fecha_Inicio_real__c,
						//Fecha_Fin_real__c
				//FROM Segmentos__c
				//WHERE Id =: seg.Id
		//];
		//Datetime inicio = Datetime.newInstance(2020, 2, 3, 0, 0, 0);
		//Datetime fin = Datetime.newInstance(2020, 2, 4, 0, 0, 0);
		//System.assertEquals(inicio, segToAssert.Fecha_Inicio_real__c);
		//System.assertEquals(fin, segToAssert.Fecha_Fin_real__c);
		//System.assertEquals('ok', segToAssert.Result_Insert_Trigger__c);
		//System.assertEquals(Date.valueOf(System.now()), Date.valueOf(segToAssert.Datetime_Insert_Trigger__c));

	//}

	//@IsTest
	//private static void whenUpdateTheSegment_getValidResponseFromWS() {
		//Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
		//insert em;

		//Datetime actual = System.now();
		//Datetime masCincoDias = actual.addDays(5);
		//Segmentos__c seg1 = new Segmentos__c(Semid__c = '305715', Evento_Medico__c = em.Id);
		//insert seg1;
		//seg1.Fecha_Inicio_real__c = actual;
		//seg1.Fecha_Fin_real__c = masCincoDias;


		//Test.setMock(HttpCalloutMock.class, getResponseFound);
		//Test.startTest();
		//update seg1;
		//Test.stopTest();

		//Segmentos__c segToAssert = [SELECT Estado__c, Datetime_Update_Trigger__c, Result_Update_Trigger__c
			//FROM Segmentos__c WHERE Id =: seg1.Id];
		//System.assertEquals('Autorizado', segToAssert.Estado__c);
		//System.assertEquals(Date.valueOf(System.now()), Date.valueOf(segToAssert.Datetime_Update_Trigger__c));
		//System.assertEquals('ok', segToAssert.Result_Update_Trigger__c);
	//}

	//@IsTest
	//private static void whenUpdateTheSegment_getErrorResponseFromWS() {
		//Test.setMock(HttpCalloutMock.class, getErrorResponse);
		//Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
		//insert em;

		//Segmentos__c seg = new Segmentos__c(Semid__c = '305715', Evento_Medico__c = em.Id);
		//insert seg;
		//seg.Fecha_Inicio_real__c = System.now();
		//seg.Fecha_Fin_real__c = System.now().addDays(5);

		//Test.startTest();
		//update seg;
		//Test.stopTest();

		//Segmentos__c segToAssert = [SELECT Estado__c, Datetime_Update_Trigger__c, Result_Update_Trigger__c
			//FROM Segmentos__c WHERE Id =: seg.Id];
		//System.assertEquals(Date.valueOf(System.now()), Date.valueOf(segToAssert.Datetime_Update_Trigger__c));
		//System.assertEquals('El segmento solicitado es inválido.', segToAssert.Result_Update_Trigger__c);
	//}

	//static XHttpCalloutMock getResponseFoundAlta;
	//static XHttpCalloutMock getErrorResponseAlta;

	//static {
		//getErrorResponseAlta = new XHttpCalloutMock();
		//getErrorResponseAlta.buildResponse()
				//.withStatus('OK')
				//.withStatusCode(200)
				//.withBody(WSAuthTokenMock.getTokenSuccess())
				//.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		//getErrorResponseAlta.buildResponse()
				//.withStatus('exception')
				//.withStatusCode(404)
				//.withBody(WSSegmentoAltaMock.getError())
				//.addForAddress(WSSegmentoAlta.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos');
	//}

	//@IsTest 
	//private static void whenInsertASegment_getErrorResponseFromWs() {
		//Test.setMock(HttpCalloutMock.class, getErrorResponseAlta);
		//Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
		//insert em;
		//Segmentos__c seg = new Segmentos__c(Evento_Medico__c = em.Id);

		//Test.startTest();
		//insert seg;
		//Test.stopTest();

		//Segmentos__c segToAssert = [
				//SELECT Datetime_Insert_Trigger__c, Result_Insert_Trigger__c
				//FROM Segmentos__c
				//WHERE Id =: seg.Id
		//];
		//System.assertEquals('The given data was invalid.', segToAssert.Result_Insert_Trigger__c);
		//System.assertEquals(Date.valueOf(System.now()), Date.valueOf(segToAssert.Datetime_Insert_Trigger__c));
	//}
}