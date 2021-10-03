@IsTest
public class IntegranteCasoTriggerTest {
    public static final Account cuenta = build.anAccount()
                        .withAfiIddelTitular(182701)
                        .withType('TIT')
                        .withCodigodeAfiliado('70332/34')
                        .withLastName('Testing182701')
                        .withEstado('A')
                        .build();
    public static final Account familiar = build.anAccount()
                        .withAfiIddelTitular(182700)
                        .withCodigodeAfiliado('70331/34')
                        .withLastName('Testingx')
                        .withEstado('A')
                        .build();     
    @IsTest
    private static void casoConTodosSusIntegrantesConEstadoTransformadoDebeCerrarse(){
        insert new List<SObject>{familiar, cuenta};
        Case caso = Build.aCaseSolicitudDeBaja()
                                        .withAccountId(cuenta.Id)
                                        .withType('Baja parcial')
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .withMotivoDeLaBaja('2')
                                        .build();
        insert caso;

        Integrante_caso__c integrante1 = Build.anIntegranteCasoBajas()
                                                .withFamiliar(familiar.Id)
                                                .withMotivoDeLaBaja('2')
                                                .withCase(caso.Id)
                                                .build();
        integrante1.Estado_solicitud__c = 'TRANSFORMADA';
        insert integrante1;

        Integrante_caso__c integrante2 = Build.anIntegranteCasoBajas()
                                                .withFamiliar(familiar.Id)
                                                .withMotivoDeLaBaja('2')
                                                .withCase(caso.Id)
                                                .build();
        insert integrante2;

        System.assertEquals(null, caso.Estado_de_solicitud__c);
        
        Test.startTest();
        integrante2.Estado_solicitud__c = 'TRANSFORMADA';
        update integrante2;
        Test.stopTest();
        
        caso = [SELECT Id,Estado_de_solicitud__c,Status FROM Case WHERE Id = :caso.Id];
        
        System.assertEquals('TRANSFORMADA',caso.Estado_de_solicitud__c);
        System.assertEquals('Cerrado', caso.Status);
    }
    
    @IsTest
    private static void casoConAlgunIntegranteConEstadoIncompletaDebeTenerEstadoIncompleta(){
        insert new List<SObject>{familiar, cuenta};
        Case caso = Build.aCaseSolicitudDeBaja()
                                        .withAccountId(cuenta.Id)
                                        .withType('Baja parcial')
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .withMotivoDeLaBaja('2')
                                        .build();
        insert caso;

        Integrante_caso__c integrante1 = Build.anIntegranteCasoBajas()
                                                .withFamiliar(familiar.Id)
                                                .withMotivoDeLaBaja('2')
                                                .withCase(caso.Id)
                                                .build();
        integrante1.Estado_solicitud__c = 'TRANSFORMADA';
        insert integrante1;

        Integrante_caso__c integrante2 = Build.anIntegranteCasoBajas()
                                                .withFamiliar(familiar.Id)
                                                .withMotivoDeLaBaja('2')
                                                .withCase(caso.Id)
                                                .build();
        insert integrante2;

        System.assertEquals(null, caso.Estado_de_solicitud__c);
        
        Test.startTest();
        integrante2.Estado_solicitud__c = 'INCOMPLETA';
        update integrante2;
        Test.stopTest();
        
        caso = [SELECT Id,Estado_de_solicitud__c,Status FROM Case WHERE Id = :caso.Id];
        
        System.assertEquals('INCOMPLETA',caso.Estado_de_solicitud__c);
        System.assertEquals('Pendiente', caso.Status);
    }

    
    @IsTest
    private static void casoConAlgunIntegranteConEstadoCompletaYNingunoConEstadoIncompletaDebeTenerEstadoCompleta(){
        insert new List<SObject>{familiar, cuenta};
        Case caso = Build.aCaseSolicitudDeBaja()
                                        .withAccountId(cuenta.Id)
                                        .withType('Baja parcial')
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .withMotivoDeLaBaja('2')
                                        .build();
        insert caso;

        Integrante_caso__c integrante1 = Build.anIntegranteCasoBajas()
                                                .withFamiliar(familiar.Id)
                                                .withMotivoDeLaBaja('2')
                                                .withCase(caso.Id)
                                                .build();
        integrante1.Estado_solicitud__c = 'TRANSFORMADA';
        insert integrante1;

        Integrante_caso__c integrante2 = Build.anIntegranteCasoBajas()
                                                .withFamiliar(familiar.Id)
                                                .withMotivoDeLaBaja('2')
                                                .withCase(caso.Id)
                                                .build();
        insert integrante2;

        
        System.assertEquals(null, caso.Estado_de_solicitud__c);
        
        Test.startTest();
        integrante2.Estado_solicitud__c = 'COMPLETA';
        update integrante2;
        Test.stopTest();
        
        caso = [SELECT Id,Estado_de_solicitud__c,Status FROM Case WHERE Id = :caso.Id];
        
        System.assertEquals('COMPLETA',caso.Estado_de_solicitud__c);
        System.assertEquals('Pendiente', caso.Status);
    }
    
    
    @IsTest
    private static void casoConAlgunIntegranteConEstadoCompletaYUnoConEstadoIncompletaDebeTenerElMismoEstado(){
        insert new List<SObject>{familiar, cuenta};
        Case caso = Build.aCaseSolicitudDeBaja()
                                        .withAccountId(cuenta.Id)
                                        .withType('Baja parcial')
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .withMotivoDeLaBaja('2')
                                        .build();
        insert caso;

        Integrante_caso__c integrante1 = Build.anIntegranteCasoBajas()
                                                .withFamiliar(familiar.Id)
                                                .withMotivoDeLaBaja('2')
                                                .withCase(caso.Id)
                                                .build();
        integrante1.Estado_solicitud__c = 'INCOMPLETA';
        insert integrante1;

        Integrante_caso__c integrante2 = Build.anIntegranteCasoBajas()
                                                .withFamiliar(familiar.Id)
                                                .withMotivoDeLaBaja('2')
                                                .withCase(caso.Id)
                                                .build();
        insert integrante2;
        
        System.assertEquals(null, caso.Estado_de_solicitud__c);
        
        Test.startTest();
        integrante2.Estado_solicitud__c = 'COMPLETA';
        update integrante2;
        Test.stopTest();
        
        caso = [SELECT Id,Estado_de_solicitud__c,Status FROM Case WHERE Id = :caso.Id];
        
        System.assertEquals(null,caso.Estado_de_solicitud__c);
        System.assertEquals('Pendiente', caso.Status);
    }

    @IsTest
    private static void casoNoFueEnviadoASSEntoncesElIntegrantePuedeSerEliminado(){
        insert new List<SObject>{familiar, cuenta};
        Case caso = Build.aCaseSolicitudDeBaja()
                                        .withAccountId(cuenta.Id)
                                        .withType('Baja parcial')
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .withMotivoDeLaBaja('2')
                                        .build();
        insert caso;

        Integrante_caso__c integrante1 = Build.anIntegranteCasoBajas()
                                                .withFamiliar(familiar.Id)
                                                .withMotivoDeLaBaja('2')
                                                .withCase(caso.Id)
                                                .build();
        insert integrante1;

        Test.startTest();
        Database.DeleteResult integranteDeleteResult = Database.delete(integrante1);
        Test.stopTest();
        
        System.assert(String.isBlank(caso.Nro_de_solicitud_SS__c));
        System.assert(integranteDeleteResult.isSuccess());
    }

    @IsTest 
    private static void casoEnviadoASSEntoncesElIntegranteNoPuedeSerEliminado(){
        insert new List<SObject>{familiar, cuenta};
        Case caso = Build.aCaseSolicitudDeBaja()
                                        .withAccountId(cuenta.Id)
                                        .withType('Baja parcial')
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .withMotivoDeLaBaja('2')
                                        .build();
        insert caso;

        Integrante_caso__c integrante1 = Build.anIntegranteCasoBajas()
                                                .withFamiliar(familiar.Id)
                                                .withMotivoDeLaBaja('2')
                                                .withCase(caso.Id)
                                                .build();
        insert integrante1;

        caso.Nro_de_solicitud_SS__c = '123456';
        update caso;

        Test.startTest();
        Database.DeleteResult integranteDeleteResult = Database.delete(integrante1, false);
        Test.stopTest();
        
        System.assert(String.isNotBlank(caso.Nro_de_solicitud_SS__c));
        System.assertEquals(false, integranteDeleteResult.isSuccess());
        System.assertEquals('No se puede eliminar porque el caso ya fue enviado a Salud Soft', integranteDeleteResult.getErrors()[0].getMessage());
    }
}