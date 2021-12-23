@IsTest
private class XappiaHelperTest {
	@IsTest
	static void testItShouldReturnRightCuits() {
		System.assertEquals('27123412341',XappiaHelper.GenerateCUITFromDNI('12341234', false), 'El CUIT debe venir correctamente');
		System.assertEquals('23123412214',XappiaHelper.GenerateCUITFromDNI('12341221', false), 'El CUIT debe venir correctamente');
		System.assertEquals('20123412223',XappiaHelper.GenerateCUITFromDNI('12341222', true), 'El CUIT debe venir correctamente');
		System.assertEquals('20123411030',XappiaHelper.GenerateCUITFromDNI('12341103', true), 'El CUIT debe venir correctamente');
		System.assertEquals('23123411099',XappiaHelper.GenerateCUITFromDNI('12341109', true), 'El CUIT debe venir correctamente');
	}
	@IsTest
	static void testItShouldReturnNothingWhenDatesAreWrong() {
		System.assertEquals('', XappiaHelper.GenerateCUITFromDNI('',false), 'Debe retornar una cadena vacia');
		System.assertEquals('', XappiaHelper.GenerateCUITFromDNI('1234q341',false), 'Debe retornar una cadena vacia');
		System.assertEquals('', XappiaHelper.GenerateCUITFromDNI('54131234123',true), 'Debe retornar una cadena vacia');
		System.assertEquals('', XappiaHelper.GenerateCUITFromDNI('23-12341109a9',true), 'Debe retornar una cadena vacia');
		System.assertEquals('', XappiaHelper.GenerateCUITFromDNI(null,null), 'Debe retornar una cadena vacia');
	}
	@IsTest
	static void testCUITValidationGiveRightAnswers() {
		//right CUIT
		System.assert(XappiaHelper.IsItValidCUIT('27123412341'), 'El CUIT debe ser válido');
		System.assert(XappiaHelper.IsItValidCUIT('27-12341234-1'), 'El CUIT debe ser válido');
		System.assert(XappiaHelper.IsItValidCUIT('23123412214'), 'El CUIT debe ser válido');
		System.assert(XappiaHelper.IsItValidCUIT('20123412223'), 'El CUIT debe ser válido');
		System.assert(XappiaHelper.IsItValidCUIT('20123411030'), 'El CUIT debe ser válido');
		System.assert(XappiaHelper.IsItValidCUIT('23123411099'), 'El CUIT debe ser válido');
		//wrong CUIT
		System.assert(!XappiaHelper.IsItValidCUIT('1234123'), 'El CUIT debe ser inválido');
		System.assert(!XappiaHelper.IsItValidCUIT(''), 'El CUIT debe ser inválido');
		System.assert(!XappiaHelper.IsItValidCUIT('1234q341'), 'El CUIT debe ser inválido');
		System.assert(!XappiaHelper.IsItValidCUIT('54131234123'), 'El CUIT debe ser inválido');
		System.assert(!XappiaHelper.IsItValidCUIT('20-a123412223'), 'El CUIT debe ser inválido');
		System.assert(!XappiaHelper.IsItValidCUIT(null), 'El CUIT debe ser inválido');
	}
	@IsTest
	static void CBUValidtionGiveRightAnswers() {
		//right cbu
		System.assert(XappiaHelper.isItValidCBU('2850590940090418135201'), 'El CBU debe ser válido');
		System.assert(XappiaHelper.isItValidCBU('2850100640094040123748'), 'El CBU debe ser válido');
		System.assert(XappiaHelper.isItValidCBU('0440053040000160557800'), 'El CBU debe ser válido');
		System.assert(XappiaHelper.isItValidCBU('0440024040000165916790'), 'El CBU debe ser válido');
		System.assert(XappiaHelper.isItValidCBU('044-0024-0400-0016-5916-790'), 'El CBU debe ser válido');
		//wrong cbu
		System.assert(!XappiaHelper.isItValidCBU('0170099220000067797371'), 'El CBU debe ser inválido');
		System.assert(!XappiaHelper.isItValidCBU('0850100640094040123748'), 'El CBU debe ser inválido');
		System.assert(!XappiaHelper.isItValidCBU('0440053040002160557801'), 'El CBU debe ser inválido');
		System.assert(!XappiaHelper.isItValidCBU('04400530400021605'), 'El CBU debe ser inválido');
		System.assert(!XappiaHelper.isItValidCBU(null), 'El CBU debe ser inválido');
		System.assert(!XappiaHelper.isItValidCBU('044005304000216055A801'), 'El CBU debe ser inválido');
	}
	@IsTest
	static void testLuhnValidtionGiveRightAnswers() {
		//right Luhn code
		System.assert(XappiaHelper.isItValidLuhnCode('4398728045218854'), 'La tarjeta debe ser válida');
		System.assert(XappiaHelper.isItValidLuhnCode('4667858768964691'), 'La tarjeta debe ser válida');
		System.assert(XappiaHelper.isItValidLuhnCode('5028276435949634'), 'La tarjeta debe ser válida');
		System.assert(XappiaHelper.isItValidLuhnCode('5980289411573076'), 'La tarjeta debe ser válida');
		System.assert(XappiaHelper.isItValidLuhnCode('4667858768964691'), 'La tarjeta debe ser válida');
		System.assert(XappiaHelper.isItValidLuhnCode('371449635398431'), 'La tarjeta debe ser válida');
		//wrong Luhn code
		System.assert(!XappiaHelper.isItValidLuhnCode('0850100640094040123748'), 'El valor deber ser inválido');
		System.assert(!XappiaHelper.isItValidLuhnCode('0876543210'), 'El valor deber ser inválido');
		System.assert(!XappiaHelper.isItValidLuhnCode(''), 'El valor deber ser inválido');
		System.assert(!XappiaHelper.isItValidLuhnCode(null), 'El valor deber ser inválido');
		System.assert(!XappiaHelper.isItValidLuhnCode('6980289411573076'), 'El valor deber ser inválido');
		System.assert(!XappiaHelper.isItValidLuhnCode('6980289411573076'), 'El valor deber ser inválido');
	}
	@IsTest
	static void testNumericStringGiveRightAnswers() {
		System.assertEquals('1234',XappiaHelper.stringToNumericString('1234'), 'Solo debe devolver los números en la cadena');
		System.assertEquals('1234',XappiaHelper.stringToNumericString('x1a2a3-qw4'), 'Solo debe devolver los números en la cadena');
		System.assertEquals('',XappiaHelper.stringToNumericString('hello world!'), 'Debe devolver una cadena vacía');
		System.assertEquals('',XappiaHelper.stringToNumericString(''), 'Debe devolver una cadena vacía');
		System.assertEquals('',XappiaHelper.stringToNumericString(null), 'Debe devolver una cadena vacía');
	}
	@IsTest
	static void testGetRecordTypeReturnRecordTypeIfExist() {
		List<RecordType> rts = [SELECT id, DeveloperName, SobjectType FROM RecordType LIMIT 1];
		if (rts.size() > 0) {
			System.assertNotEquals(null, XappiaHelper.getRecordType(rts[0].sObjectType, rts[0].DeveloperName), 'Debe retornar info del RT');
		}
	}
	@IsTest
	static void testGetRecordTypeShouldNotUseQuery() {
		List<RecordType> rts = [SELECT id, DeveloperName, SobjectType FROM RecordType LIMIT 1];
        System.debug(Limits.getQueries());
		if (rts.size() > 0) {
			System.assertNotEquals(null, XappiaHelper.getRecordType(rts[0].sObjectType, rts[0].DeveloperName), 'Debe retornar info del RT');
            XappiaHelper.getRecordType(rts[0].sObjectType, rts[0].DeveloperName);
            System.assertEquals(1, Limits.getQueries(), 'Una query debio ser realizada');
		}
	}
	@IsTest
	static void testGetRecordTypeEncodedReturnRecordTypeIfExist() {
		List<RecordType> rts = [SELECT id, DeveloperName, SobjectType FROM RecordType LIMIT 1];
		if (rts.size() > 0) {
			System.assertNotEquals(null, XappiaHelper.getRecordType(rts[0].sObjectType + '-' + rts[0].DeveloperName), 'Debe retornar info del RT');
		}
	}
	@IsTest
	static void testGetRecordTypeEncodedReturnNullIfWasWrongEcnoded() {
		List<RecordType> rts = [SELECT id, DeveloperName, SobjectType FROM RecordType LIMIT 1];
		if (rts.size() > 0) {
			System.assertEquals(null, XappiaHelper.getRecordType(rts[0].sObjectType + '!' + rts[0].DeveloperName), 'Debe retornar info del RT');
		}
	}
	@IsTest
	static void testGetRecordTypeReturnNullIfRecordTypeIDoesntExist() {
		System.assertEquals(null, XappiaHelper.getRecordType(',.!'  ,' '), ' Debe retornar un objeto nulo');
	}
	@IsTest
	static void testCheckIfRoleIsInHierarchy() {
		List<UserRole> orgAmba = [SELECT Id FROM UserRole WHERE DeveloperName = 'Org_AMBA'];
		Set<Id> roleIds = new Set<Id>();
		roleIds.add(orgAmba[0].Id);
		Set<Id> hierarchyIds = XappiaHelper.getAllSubRoleIds(roleIds);
		List<UserRole> comercialAmba = [SELECT Id FROM UserRole WHERE DeveloperName = 'Comercial_AMBA'];
		List<UserRole> supBAC = [SELECT Id FROM UserRole WHERE DeveloperName = 'Supervisor_BAC'];
		System.assertEquals(true, hierarchyIds.contains(comercialAmba[0].Id), 'El rol AMBA debe estar en la respuesta');
		System.assertNotEquals(true, hierarchyIds.contains(supBAC[0].Id), 'El rol subCAB no debe estar en la respuesta');
	}
	@IsTest
	static void testCheckIfRoleIsInTopHierarchy() {
		List<UserRole> orgAmba = [SELECT Id FROM UserRole WHERE DeveloperName = 'Org_AMBA'];
		Set<Id> roleIds = new Set<Id>();
		roleIds.add(orgAmba[0].Id);
		Set<Id> hierarchyIds = XappiaHelper.getParentRoleId(roleIds);
		List<UserRole> comercialAmba = [SELECT Id FROM UserRole WHERE DeveloperName = 'Comercial_AMBA'];
		List<UserRole> ind = [SELECT Id FROM UserRole WHERE DeveloperName = 'Individual'];
		System.assertEquals(false, hierarchyIds.contains(comercialAmba[0].Id), 'El rol AMBA no debe estar en la respuesta');
		System.assertEquals(true, hierarchyIds.contains(ind[0].Id), 'El rol ind debe estar en la respuesta');
	}
	@isTest
	static void testgetRecordTypeNameById() {
		List<RecordType> rts = [SELECT id, DeveloperName, SobjectType FROM RecordType LIMIT 1];
		if (rts.size() > 0) {
			Set<String> setRTs = new Set<String>{rts[0].DeveloperName};
			System.assertNotEquals(null, XappiaHelper.getRecordTypeNameById(rts[0].sObjectType, setRTs), 'Debe retornar info del RT');
		}
	}
	@isTest
	static void testgetRecordTypes() {
		System.assertNotEquals(null, XappiaHelper.getRecordTypes('Case'), 'Debe retornar info del RT');
	}
	@isTest
	static void testgetPicklistFieldValues () {
		System.assertNotEquals(null, XappiaHelper.getPicklistFieldValues('Case', 'Status'), 'Debe retornar info del Campo');
	}
	@isTest
	static void testgetPicklistLabelAndValues () {
		System.assertNotEquals(null, XappiaHelper.getPicklistLabelAndValues('Case', 'Status'), 'Debe retornar info del Campo');
	}
	@isTest
	static void testgetProfileIdByName () {
		System.assertNotEquals(null, XappiaHelper.getProfileIdByName('System Administrator'), 'Debe retornar info del profile');
	}
	@isTest
	static void testgetStaticResource () {
		StaticResource resource = [SELECT Body FROM StaticResource WHERE Name = 'LightningUtils' LIMIT 1];
		System.assertEquals(resource, XappiaHelper.getStaticResource('LightningUtils'), 'Debe retornar el recurso estático esperado');
	}
	@isTest
	static void testisPlatformUser () {
		Boolean isPlatformUser = XappiaHelper.isPlatformUser();
		System.assert(!isPlatformUser, 'El admin no debe ser PlatformUser');
		List<User> platIntUsers = [SELECT Id FROM User WHERE isActive = true AND UserName LIKE 'automatedcase%'];
		System.assertEquals(1, platIntUsers.size(), 'Debe haber un usuario para los casos Email-to-Case');
		System.runAs (platIntUsers[0]) {
			isPlatformUser = XappiaHelper.isPlatformUser();
		}
		System.assert(isPlatformUser, 'Debe ser un platformUser');
	}
}