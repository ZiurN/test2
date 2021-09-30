@IsTest
public class AccountAsociadoMappingTest  {
	//@IsTest
	//private static void whenTheWSIsConsume_mappingAccountWithAsociadoResponse_AccountAsociadoShouldBeInsert(){
		//Test.setMock(HttpCalloutMock.class, getResponseFound);
		//Test.startTest();
		//AccountAsociadoMapping.upsertAccountAsociado('131153');
		//Test.stopTest();

        //List<Account> accountsToAssert = [
			//SELECT
				//Actividad_codigo__c,
				//Actividad_nombre__c,
				//Adherente__c,
				//Afi_Id__c,
				//Afiliacion__c,
				//Agencia_codigo__c,
				//Agencia_nombre__c,
				//Antiguedad_reconocida__c,
				//Aporta__c,
				//CUIT__c,
				//Categoria_Nombre__c,
				//Categoria_codigo__c,
				//Clase_efector__c,
				//Codigo_de_Afiliado__c,
				//Codigo_de_Entidad__c,
				//Codigo_de_empresa__c,
				//Edad__c,
				//Empresa_codigo__c,
				//Empresa_nombre__c,
				//Empresa_sucursal__c,
				//Empresa_sucursal_nombre__c,
				//Estado__c,
				//Estado_civil__c,
				//Fecha_Alta__c,
				//Fecha_alta_Administrativa__c,
				//Fecha_nacimiento_efector__c,
				//Fecha_vigencia__c,
				//FirstName,
				//Gentilicio__c,
				//LastName,
				//Modelo_Plan_Codigo__c,
				//Modelo_Plan_Nombre__c,
				//Monto_excedente__c,
				//Motivo_de_baja__c,
				//Numero_de_documento__c,
				//Obra_social_ant_codigo__c,
				//Obra_social_ant_nombre__c,
				//Obra_social_codigo__c,
				//Obra_social_nombre__c,
				//Parentesco__c,
				//PersonBirthdate,
				//Plan_Codigo__c,
				//Plan_Nombre__c,
				//Sexo__c,
				//Sujeto_facturacion__c,
				//Tipo_de_baja_codigo__c,
				//Tipo_de_baja_nombre__c,
				//Tipo_de_documento__c,
				//Titular_apellidos__c,
				//Titular_codigo__c,
				//Titular_nombres__c,
				//Type
			//FROM Account
		//];
		//Account accountAsociadoToAssert = accountsToAssert[0];

		//System.assertEquals('COM', accountAsociadoToAssert.Actividad_codigo__c);
		//System.assertEquals('COMERCIANTE', accountAsociadoToAssert.Actividad_nombre__c);
		//System.assertEquals(false, accountAsociadoToAssert.Adherente__c);
		//System.assertEquals('134495', accountAsociadoToAssert.Afi_Id__c);
		//System.assertEquals('Sin aportes', accountAsociadoToAssert.Afiliacion__c);
		//System.assertEquals(650008, accountAsociadoToAssert.Agencia_codigo__c);
		//System.assertEquals('650008_AG.BAHIA BLANCA-MUTUAL ASOCIADOS COOP.OBRERA', accountAsociadoToAssert.Agencia_nombre__c);
		//System.assertEquals(false, accountAsociadoToAssert.Aporta__c);
		//System.assertEquals('27231303435', accountAsociadoToAssert.CUIT__c);
		//System.assertEquals('GENERICO', accountAsociadoToAssert.Categoria_Nombre__c);
		//System.assertEquals('GEN', accountAsociadoToAssert.Categoria_codigo__c);
		//System.assertEquals('054', accountAsociadoToAssert.Clase_efector__c);
		//System.assertEquals('60667/18', accountAsociadoToAssert.Codigo_de_Afiliado__c);
		//System.assertEquals('60667', accountAsociadoToAssert.Codigo_de_Entidad__c);
		//System.assertEquals('MUTUAL ASOCIADOS COOPERATIVA OBRERA', accountAsociadoToAssert.Empresa_nombre__c);
		//System.assertEquals('REING 2 DA SEM AS200/204 VOLDIR CBU/TC PC 2017', accountAsociadoToAssert.Empresa_sucursal_nombre__c);
		//System.assertEquals('Activo', accountAsociadoToAssert.Estado__c);
		//System.assertEquals('Soltero', accountAsociadoToAssert.Estado_civil__c);
		//System.assertEquals('VANINA NATALIA', accountAsociadoToAssert.FirstName);
		//System.assertEquals('ARGENTINO', accountAsociadoToAssert.Gentilicio__c);
		//System.assertEquals('OGANDO', accountAsociadoToAssert.LastName);
		//System.assertEquals('AS200', accountAsociadoToAssert.Modelo_Plan_Codigo__c);
		//System.assertEquals('INTEGRAL AS200', accountAsociadoToAssert.Modelo_Plan_Nombre__c);
		//System.assertEquals('Femenino', accountAsociadoToAssert.Sexo__c);
		//System.assertEquals(null, accountAsociadoToAssert.Motivo_de_baja__c);
		//System.assertEquals('23130343', accountAsociadoToAssert.Numero_de_documento__c);
		//System.assertEquals('SPM', accountAsociadoToAssert.Obra_social_ant_nombre__c);
		//System.assertEquals('ACA SALUD', accountAsociadoToAssert.Obra_social_nombre__c);
		//System.assertEquals(null, accountAsociadoToAssert.Parentesco__c);
		//System.assertEquals('AS200', accountAsociadoToAssert.Plan_Codigo__c);
		//System.assertEquals('INTEGRAL AS200', accountAsociadoToAssert.Plan_Nombre__c);
		//System.assertEquals(false, accountAsociadoToAssert.Sujeto_facturacion__c);
		//System.assertEquals(null, accountAsociadoToAssert.Tipo_de_baja_nombre__c);
		//System.assertEquals('DNI', accountAsociadoToAssert.Tipo_de_documento__c);
		//System.assertEquals(null, accountAsociadoToAssert.Tipo_de_baja_codigo__c);
		//System.assertEquals(null, accountAsociadoToAssert.Titular_apellidos__c);
		//System.assertEquals(null, accountAsociadoToAssert.Titular_codigo__c);
		//System.assertEquals(null, accountAsociadoToAssert.Titular_nombres__c);
		//System.assertEquals('Titular', accountAsociadoToAssert.Type);
	//}

	//static XHttpCalloutMock getResponseFound;

	//static {
		//getResponseFound = new XHttpCalloutMock();
		//getResponseFound.buildResponse()
			//.withStatus('OK')
			//.withStatusCode(200)
			//.withBody(WSAuthTokenMock.getTokenSuccess())
			//.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		//getResponseFound.buildResponse()
			//.withStatus('OK')
			//.withStatusCode(200)
			//.withBody(WSAsociadoGetAsociadoMock.getFound())
			//.addForAddress(WSAsociadoGetAsociado.SERVICE_CONFIG.URL__c + '/v1/salud/consultar-afiliado/afi_id/131153');
	//}
}