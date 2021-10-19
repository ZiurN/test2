public class WSPrestacionActualizarImporteMock {
        public static String getFound() {
            return
            '{' +
                '"error": false,' +
                '"data": [' +
                    '{' +
                        '"apr_id": null,' +
                        '"estado_prestacion": "C1-----A",' +
                        '"estado_descripcion": "EN AUDITORIA",' +
                        '"contexto": "Ambulatorio",' +
                        '"cantidad": "1",' +
                        '"prestacion": "02170101",' +
                        '"nombre_prestacion": "ELECTROCARDIOGRAMA EN CONSULTORIO",' +
                        '"tipo_prestacion": "N",' +
                        '"troquel": null,' +
                        '"grupo_prestacion": null,' +
                        '"pca_id": "74043157",' +
                        '"alerta": "800",' +
                        '"texto_aclarativo": null,' +
                        '"importe_plan_sys": "176.68",' +
                        '"importe_plan_aud": "800",' +
                        '"importe_convenio_sys": "0",' +
                        '"importe_convenio_aud": "0",' +
                        '"importe_cargo_al_socio_sys": "0",' +
                        '"importe_cargo_al_socio_aud": "500",' +
                        '"importe_rein_sys": "176.68",' +
                        '"importe_rein_aud": "1000"' +
                    '}' +
                '],' +
                '"httpCode": 200,' +
                '"message": "Se ha cargado correctamente el importe de la prestación.",' +
                '"meta": {' +
                    '"allowed_includes": [],' +
                    '"default_includes": []' +
                '}' +
            '}' ;
        }
    
        public static String getError() {
            
            return
            '{' +
                '"data": {' +
                    '"error": true,' +
                    '"errors": [],' +
                    '"errorType": "exception",' +
                    '"httpCode": 404,' +
                    '"message": "El reintegro solicitado es inválido.",' +
                    '"debug_message": [],' +
                    '"exception": "NotFoundHttpException",' +
                    '"file": "",' +
                    '"line": 964' +
                '}' +
            '}';
        }
}