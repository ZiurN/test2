@isTest
private class SegmentoTriggerTest {
	private static final String EVENTO_MEDICO_URL = ConfigUtils.getEndpointsByTipo('eventos-medicos').get('eventos-medicos').Endpoint__c;
	private static XHttpCalloutMock getResponseFound;
	private static XHttpCalloutMock getResponseFoundAlta;
	private static XHttpCalloutMock getResponseFoundActualizacion;
	private static XHttpCalloutMock getErrorResponse;
	private static XHttpCalloutMock getErrorResponseAlta;
	private static XHttpCalloutMock getErrorResponseActualizacion;
	static {
		getResponseFound = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getResponseFound,
			EVENTO_MEDICO_URL + '/275822/segmentos/305715',
			XappiaHelper.getStaticResource('mockEventoMedicoSegmentoActualizarOK').body.toString());
		getErrorResponse = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getResponseFound,
			EVENTO_MEDICO_URL + '/275822/segmentos/305715',
			XappiaHelper.getStaticResource('mockEventoMedicoSegmentoActualizarError').body.toString());
		getResponseFoundActualizacion = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getResponseFoundActualizacion,
			EVENTO_MEDICO_URL + '/275822/segmentos/305715',
			XappiaHelper.getStaticResource('mockEventoMedicoSegmentoActualizarOK').body.toString());
		getErrorResponseActualizacion = new XHttpCalloutMock();
		TestUtils.setMockResponse(
			getErrorResponseActualizacion,
			EVENTO_MEDICO_URL + '/275822/segmentos/305715',
			XappiaHelper.getStaticResource('mockEventoMedicoSegmentoActualizarError').body.toString(),
			404,
			'exception');
		getErrorResponseAlta = new XHttpCalloutMock();
		TestUtils.setAuthToken(
			getErrorResponseAlta,
			XappiaHelper.getStaticResource('mockEventoMedicoSegmentoAltaError').body.toString(),
			404,
			'exception');
	}
	@isTest
	private static void SegmentoActualIsOnlyTheLastSegmento() {
		Evento_medico__c em = new Evento_medico__c(Estado__c = 'Autorizado');
		insert em;
		Segmentos__c segmento1 = new Segmentos__c();
		segmento1.Evento_Medico__c = em.Id;
		segmento1.Solicitante__c = 'NO ENCOLAR';
		Segmentos__c segmento2 = new Segmentos__c();
		segmento2.Evento_Medico__c = em.Id;
		segmento2.Solicitante__c = 'NO ENCOLAR';
		Segmentos__c[] segmentos = new List<Segmentos__c>{segmento1, segmento2};
		Test.startTest();
		insert segmentos;
		Test.stopTest();
		List<Segmentos__c> segmentosQuery = [SELECT Segmento_actual__c, Numero_del_segmento__c
												FROM Segmentos__c
												WHERE Id IN: segmentos];
		for (Segmentos__c segmento : segmentosQuery) {
			if (segmento.Numero_del_segmento__c == 1) {
				System.assert(!segmento.Segmento_actual__c, 'El segmento no debe ser el actual');
			} else if (segmento.Numero_del_segmento__c == 2) {
				System.assert(segmento.Segmento_actual__c, 'El segmento debe ser el actual');
			}
		}
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
		Segmentos__c segToAssert = [SELECT Segmento_actual__c FROM Segmentos__c WHERE Id =: segmento.Id];
		System.assert(segToAssert.Segmento_actual__c, 'El segmento debe ser el actual');
	}
	@isTest
	private static void testBulk() {
		Evento_medico__c em = new Evento_medico__c(Estado__c = 'Autorizado');
		insert em;
		Segmentos__c segmento1 = new Segmentos__c(Evento_Medico__c = em.Id, Solicitante__c = 'NO ENCOLAR');
		Segmentos__c segmento2 = new Segmentos__c(Evento_Medico__c = em.Id, Solicitante__c = 'NO ENCOLAR');
		Segmentos__c segmento3 = new Segmentos__c(Evento_Medico__c = em.Id, Solicitante__c = 'NO ENCOLAR');
		Segmentos__c segmento4 = new Segmentos__c(Evento_Medico__c = em.Id, Solicitante__c = 'NO ENCOLAR');
		Segmentos__c segmento5 = new Segmentos__c(Evento_Medico__c = em.Id, Solicitante__c = 'NO ENCOLAR');
		Segmentos__c segmento6 = new Segmentos__c(Evento_Medico__c = em.Id, Solicitante__c = 'NO ENCOLAR');
		Segmentos__c segmento7 = new Segmentos__c(Evento_Medico__c = em.Id, Solicitante__c = 'NO ENCOLAR');
		Segmentos__c segmento8 = new Segmentos__c(Evento_Medico__c = em.Id, Solicitante__c = 'NO ENCOLAR');
		Segmentos__c segmento9 = new Segmentos__c(Evento_Medico__c = em.Id, Solicitante__c = 'NO ENCOLAR');
		Segmentos__c segmento10 = new Segmentos__c(Evento_Medico__c = em.Id, Solicitante__c = 'NO ENCOLAR');
		Test.startTest();
		insert new List<Segmentos__c>{segmento1, segmento2, segmento3, segmento4, segmento5, segmento6, segmento7, segmento8, segmento9, segmento10};
		Test.stopTest();
		Integer i = 1;
		for(Segmentos__c segmento : [SELECT Id, Numero_del_segmento__c
										FROM Segmentos__c
										WHERE Evento_Medico__c =: em.Id
										ORDER BY Numero_del_segmento__c]) {
			System.assertEquals(i, segmento.Numero_del_segmento__c, 'El contador no corresponde con el número del segmento');
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
		List<TestUtils.mockSettings> mocks = new List<TestUtils.mockSettings>();
		TestUtils.mockSettings mock1 = new TestUtils.mockSettings();
		mock1.statusCode = 200;
		mock1.status = 'OK';
		mock1.body = body;
		mock1.url = EVENTO_MEDICO_URL + '/275822/segmentos';
		mocks.add(mock1);
		TestUtils.mockSettings mock2 = new TestUtils.mockSettings();
		mock2.statusCode = 200;
		mock2.status = 'OK';
		mock2.body = body;
		mock2.url = EVENTO_MEDICO_URL + '/275822/segmentos/305723';
		mocks.add(mock2);
		TestUtils.setMockResponse(getResponseFoundAlta, mocks);
		Test.setMock(HttpCalloutMock.class, getResponseFoundAlta);
		SegmentoQueueable segmentoQueable = new SegmentoQueueable(new List<Segmentos__c>{seg1}, false);
		Test.startTest();
		System.enqueueJob(segmentoQueable);
		Test.stopTest();
		validatePlatformEventFired();
		Segmentos__c segToAssert = [SELECT Fecha_Inicio_real__c, Fecha_Fin_real__c FROM Segmentos__c WHERE Id =: seg1.Id];
		Datetime inicio = Datetime.newInstance(2020, 2, 3, 0, 0, 0);
		Datetime fin = Datetime.newInstance(2020, 2, 4, 0, 0, 0);
		System.assertEquals(inicio, segToAssert.Fecha_Inicio_real__c, 'Las fechas no coinciden');
		System.assertEquals(fin, segToAssert.Fecha_Fin_real__c, 'Las fechas no coinciden');
		System.assert(String.isBlank(seg1.Error_en_SS__c), 'No debe haber un error en SS');
	}
	@IsTest
	private static void createSegmentErrorTest() {
		Test.setMock(HttpCalloutMock.class, getErrorResponseAlta);
		Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
		em.Forma_de_egreso__c = 'FUGA';
		insert em;
		Segmentos__c seg = new Segmentos__c(
			Evento_Medico__c = em.Id,
			Semid__c = '305714',
			Numero_del_segmento__c = 1
		);
		insert seg;
		Segmentos__c seg2 = new Segmentos__c(Evento_Medico__c = em.Id);
		Test.startTest();
		insert seg2;
		Test.stopTest();
		/** Validar que se creó el platform event informando el error en SS */
		validatePlatformEventFired();
		List<Segmentos__c> segsToAssert = [SELECT Id FROM Segmentos__c WHERE Evento_Medico__c =: em.Id];
		System.assertEquals(1, segsToAssert.size(), 'Solo debe haber un segmento médico asociado al evento');
		System.assertEquals(seg.Id, segsToAssert[0].Id, 'Solo debe haber un segmento médico asociado al evento');
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
		validatePlatformEventFired();
		Segmentos__c segToAssert = [SELECT Estado__c, Fecha_Inicio_real__c, Fecha_Fin_real__c
										FROM Segmentos__c
										WHERE Id =: seg1.Id];
		System.assertEquals('Autorizado', segToAssert.Estado__c, 'El estado debe ser Autorizado');
	}
	@IsTest
	private static void updateSegmentErrorTest() {
		Test.setMock(HttpCalloutMock.class, getErrorResponseActualizacion);
		Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
		insert em;
		Segmentos__c seg = new Segmentos__c(
			Semid__c = '305715',
			Evento_Medico__c = em.Id
		);
		insert seg;
		SegmentoQueueable segmentoQueable = new SegmentoQueueable(new List<Segmentos__c>{seg}, true);
		Test.startTest();
		System.enqueueJob(segmentoQueable);
		Test.stopTest();
		validatePlatformEventFired();
		Segmentos__c segToAssert = [SELECT Error_en_SS__c FROM Segmentos__c WHERE Id =: seg.Id];
		System.assertEquals('<p style="color: rgb(228, 10, 10);">El segmento solicitado es inválido.</p>',
							segToAssert.Error_en_SS__c,
							'Debe estar el error de SS');
	}
	@IsTest
	private static void whenTryingToDeleteTheFirstSegmentoOfTheEmItShouldReturnAnError() {
		Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
		insert em;
		Segmentos__c seg = new Segmentos__c(
			Semid__c = '305715',
			Evento_Medico__c = em.Id
		);
		insert seg;
		Test.startTest();
		Database.DeleteResult result = Database.delete(seg, false);
		Test.stopTest();
		System.assert(!result.isSuccess(), 'Debe haber un error');
		System.assertEquals(System.Label.Alerta_Segmento_NoBorrarPrimerSeg,
							result.getErrors()[0].getMessage(),
							'El mensaje no indica el error');
	}
	@isTest
	public static void ifRealDatesAreSettedUpdateEventoMedicoDates () {
		Evento_medico__c em = new Evento_medico__c(
			Nro_de_Evento_Medico_SS__c = '275822',
			Fecha_y_Hora_inicio_EMS__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 01),
			Fecha_y_hora_fin_ems__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 02)
		);
		insert em;
		Segmentos__c seg = new Segmentos__c(
			Semid__c = '305715',
			Fecha_Inicio_tentativa__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 01),
			Fecha_Fin_tentativa__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 02),
			Evento_Medico__c = em.Id
		);
		insert seg;
		seg.Fecha_Inicio_real__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 04);
		seg.Fecha_Fin_real__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 06);
		Test.startTest();
		update seg;
		Test.stopTest();
		em = [SELECT Fecha_y_Hora_inicio_EMS__c, Fecha_y_hora_fin_ems__c FROM Evento_medico__c WHERE Id =: em.Id];
		System.assertEquals(seg.Fecha_Inicio_real__c, em.Fecha_y_Hora_inicio_EMS__c, 'Las fechas no coinciden');
		System.assertEquals(seg.Fecha_Fin_real__c, em.Fecha_y_hora_fin_ems__c, 'Las fechas no coinciden');
	}
	@isTest
	public static void ifInitialDateIsAfterFinalDateThrowErrorMessage () {
		Evento_medico__c em = new Evento_medico__c(
			Nro_de_Evento_Medico_SS__c = '275822',
			Fecha_y_Hora_inicio_EMS__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 01),
			Fecha_y_hora_fin_ems__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 02)
		);
		insert em;
		Segmentos__c seg = new Segmentos__c(
			Semid__c = '305715',
			Fecha_Inicio_tentativa__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 01),
			Fecha_Fin_tentativa__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 02),
			Evento_Medico__c = em.Id
		);
		insert seg;
		seg.Fecha_Fin_real__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 03);
		seg.Fecha_Inicio_real__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 02);
		/** Si alguna fecha es nula, no debería dispararse el error */
		update seg;
		seg.Fecha_Fin_real__c = null;
		seg.Fecha_Inicio_real__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 02);
		update seg;
		seg.Fecha_Fin_real__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 03);
		seg.Fecha_Inicio_real__c = null;
		update seg;
		seg.Fecha_Fin_real__c = null;
		seg.Fecha_Inicio_real__c = null;
		update seg;
		seg.Fecha_Fin_real__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 03);
		seg.Fecha_Inicio_real__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 04);
		Test.startTest();
		Database.SaveResult result = Database.update(seg, false);
		Test.stopTest();
		System.assert(!result.isSuccess(), 'Debe haber un error');
		System.assertEquals(System.Label.Alerta_Segmento_FechasNoConsecutivas,
							result.getErrors()[0].getMessage(),
							'El mensaje no indica el error');
	}
	@IsTest
	public static void ifEventoMedicoHaveStatusClosedDontUpdate () {
		Evento_medico__c em = new Evento_medico__c(
			RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_internacion').Id,
			Nro_de_Evento_Medico_SS__c = '275822',
			Fecha_y_Hora_inicio_EMS__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 01),
			Fecha_y_hora_fin_ems__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 02)
		);
		insert em;
		Segmentos__c seg = new Segmentos__c(
			Semid__c = '305715',
			Fecha_Inicio_tentativa__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 01),
			Fecha_Fin_tentativa__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 02),
			Evento_Medico__c = em.Id
		);
		insert seg;
		em.Estado__c = 'Cerrado';
		update em;
		seg.Fecha_Inicio_real__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 04);
		seg.Fecha_Fin_real__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 06);
		Test.startTest();
		Database.SaveResult result = Database.update(seg, false);
		Test.stopTest();
		System.assert(!result.isSuccess(), 'Debe haber un error');
		System.assertEquals(System.Label.Alerta_Segmento_EventoMedicoCerrado,
							result.getErrors()[0].getMessage(),
							'El mensaje no indica el error');
	}
	@isTest
	public static void ifSSUpdateResponseHasErrorRevertSegmentoInfo () {
		Evento_medico__c em = new Evento_medico__c(
			Nro_de_Evento_Medico_SS__c = '275822',
			Fecha_y_Hora_inicio_EMS__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 01),
			Fecha_y_hora_fin_ems__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 02)
		);
		insert em;
		Datetime fechaInicioReal = DateTime.newInstance(Date.today().year(), Date.today().month(), 04);
		Datetime fechaFinReal = DateTime.newInstance(Date.today().year(), Date.today().month(), 06);
		Segmentos__c oldSeg = new Segmentos__c(
			Semid__c = '305715',
			Fecha_Inicio_tentativa__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 01),
			Fecha_Fin_tentativa__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 02),
			Fecha_Inicio_real__c = fechaInicioReal,
			Fecha_Fin_real__c = fechaFinReal,
			Evento_Medico__c = em.Id
		);
		insert oldSeg;
		oldSeg.Fecha_Inicio_real__c = fechaInicioReal.addDays(3);
		oldSeg.Fecha_Fin_real__c = fechaFinReal.addDays(3);
		Test.setMock(HttpCalloutMock.class, getErrorResponseActualizacion);
		Group fromQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Front'];
		List<GroupMember> fromUsers = [SELECT UserOrGroupId From GroupMember where GroupId =: fromQueue.Id];
		System.runAs (new User(Id = fromUsers[0].UserOrGroupId)) {
			Test.startTest();
			update oldSeg;
			Test.stopTest();
		}
		validatePlatformEventFired();
		oldSeg = [SELECT Fecha_Inicio_real__c, Fecha_Fin_real__c FROM Segmentos__c WHERE Id =: oldSeg.Id];
		System.assert(oldSeg.Fecha_Inicio_real__c == fechaInicioReal, 'Las fechas no coinciden');
		System.assert(oldSeg.Fecha_Fin_real__c == fechaFinReal, 'Las fechas no coinciden');
	}
	@isTest
	public static void ifThereIsPreviewsSegmentoAndNewSegmentHasNotCorrectFechasTentativasSendErrorMessage () {
		Evento_medico__c em = new Evento_medico__c(
			Nro_de_Evento_Medico_SS__c = '275822',
			Fecha_y_Hora_inicio_EMS__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 01),
			Fecha_y_hora_fin_ems__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 02)
		);
		insert em;
		Datetime fechaInicioReal = DateTime.newInstance(Date.today().year(), Date.today().month(), 04);
		Datetime fechaFinReal = DateTime.newInstance(Date.today().year(), Date.today().month(), 06);
		Segmentos__c previewSegmento = new Segmentos__c(
			Semid__c = '305715',
			Fecha_Inicio_tentativa__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 01),
			Fecha_Fin_tentativa__c = DateTime.newInstance(Date.today().year(), Date.today().month(), 02),
			Fecha_Inicio_real__c = fechaInicioReal,
			Fecha_Fin_real__c = fechaFinReal,
			Evento_Medico__c = em.Id,
			Segmento_actual__c = true
		);
		insert previewSegmento;
		Segmentos__c newSegmento = new Segmentos__c(
			Semid__c = '305716',
			Fecha_Inicio_tentativa__c = fechaFinReal.addDays(-1),
			Fecha_Fin_tentativa__c = fechaFinReal.addDays(2),
			Evento_Medico__c = em.Id
		);
		Test.startTest();
		Database.SaveResult result = Database.insert(newSegmento, false);
		Test.stopTest();
		System.assert(!result.isSuccess(), 'El Segmento no se debe guardar');
		System.assertEquals(System.Label.Alerta_Trigger_Seg_FechaTentInicialInvalida,
							result.getErrors()[0].getMessage(),
							'El mensaje no indica el error');
		newSegmento.Fecha_Inicio_tentativa__c = fechaFinReal.addDays(1);
		newSegmento.Fecha_Fin_tentativa__c = fechaFinReal.addDays(3);
		result = Database.insert(newSegmento, false);
		System.assert(result.isSuccess(), 'El Segmento se debe guardar correctamente');
		Integer segmentosNumber = [SELECT count() FROM Segmentos__c WHERE Evento_Medico__c =: em.Id];
		System.assertEquals(2, segmentosNumber, 'Deben haber dos segmentos');
	}
	/** Utils */
	private static void validatePlatformEventFired () {
		EventBusSubscriber[] subscribers =[SELECT Name,
												Type,
												Position,
												Retries,
												LastError
				 							FROM EventBusSubscriber
											WHERE Topic='SS_Segmento_Response__e'];
		System.assertEquals(1, subscribers.size(), 'Debe haber un suscriptor por el trigger del evento');
	}
}