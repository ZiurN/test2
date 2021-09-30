public class CotizacionTriggerHelper {

    public static void validateCotizacion(Cotizacion__c cot){
        if(cot.Tipo_de_afiliado__c == 'Relacion de dependencia'){
            if(cot.Sueldo_bruto__c == null || cot.Sueldo_bruto__c == 0){
                cot.Sueldo_bruto__c.addError('Campo Sueldo requerido cuando Tipo de afiliado es Relacion de dependencia');
            }
        }
        if(cot.Tipo_de_afiliado__c == 'Voluntario'){
            if(cot.Sueldo_bruto__c != null){
                cot.Sueldo_bruto__c.addError('Campo Sueldo no debe estar completo si tipo de afiliado es Voluntario');
            }
            if(cot.Monotributista_conyuge__c != null){
                cot.Monotributista_conyuge__c.addError('Campo Monotributista conyuge no debe estar completo si tipo de afiliado es Voluntario');
            }
            if(cot.Grupo_de_potencialidad__c != false){
                cot.Grupo_de_potencialidad__c.addError('Campo Potencialidad no debe estar completo si tipo de afiliado es Voluntario');
            }
        }
        if(cot.Tipo_de_afiliado__c == 'Voluntario' && cot.Tipo_de_contacto__c == '1'){


                if(cot.Aporta_por_hijos__c != null){
                    cot.Aporta_por_hijos__c.addError('Campo Aporta por hijos no debe estar completo si tipo de afiliado es Voluntario y Tipo de contacto Individuo');
                }
                if(cot.Hijos_entre_21_y_25_aos__c != null){
                    cot.Hijos_entre_21_y_25_aos__c.addError('Campo Cantidad de hijos no debe estar completo si tipo de afiliado es Voluntario y Tipo de contacto Individuo');
                }
                if(cot.Hijos_hasta_20_aos__c != null){
                    cot.Hijos_hasta_20_aos__c.addError('Campo Cantidad de hijos no debe estar completo si tipo de afiliado es Voluntario y Tipo de contacto Individuo');
                }
                if(cot.Edad_conyuge__c != null){
                    cot.Edad_conyuge__c.addError('Campo Edad conyuge no debe estar completo si tipo de afiliado es Voluntario y Tipo de contacto Individuo');
                }
            }
        if(cot.Tipo_de_afiliado__c == 'Relacion de dependencia' && cot.Tipo_de_contacto__c == '1'){
            	if(cot.Monotributista_conyuge__c != null){
                    cot.Monotributista_conyuge__c.addError('Campo Monotributista conyuge no debe estar completo si tipo de afiliado es Relacion de dependencia y Tipo de contacto Individuo');
                }
                if(cot.Aporta_por_hijos__c != null){
                    cot.Aporta_por_hijos__c.addError('Campo Aporta por hijos no debe estar completo si tipo de afiliado es Relacion de dependencia y Tipo de contacto Individuo');
                }
                if(cot.Hijos_entre_21_y_25_aos__c != null){
                    cot.Hijos_entre_21_y_25_aos__c.addError('Campo Cantidad de hijos no debe estar completo si tipo de afiliado es Relacion de dependencia y Tipo de contacto Individuo');
                }
                if(cot.Hijos_hasta_20_aos__c != null){
                    cot.Hijos_hasta_20_aos__c.addError('Campo Cantidad de hijos no debe estar completo si tipo de afiliado es Relacion de dependencia y Tipo de contacto Individuo');
                }
                if(cot.Edad_conyuge__c != null){
                    cot.Edad_conyuge__c.addError('Campo Edad conyuge no debe estar completo si tipo de afiliado es Relacion de dependencia y Tipo de contacto Individuo');
                }
        }
        if(cot.Tipo_de_afiliado__c == 'Monotributista'){
            if(cot.Sueldo_bruto__c != null){
                cot.Sueldo_bruto__c.addError('Campo Sueldo no debe estar completo si tipo de afiliado es Monotributista');
            }
            if(cot.Grupo_de_potencialidad__c != false){
                cot.Grupo_de_potencialidad__c.addError('Campo Potencialidad no debe estar completo si tipo de afiliado es Monotributista');
            }
        }
        if(cot.Tipo_de_afiliado__c == 'Monotributista' && cot.Tipo_de_contacto__c == '1'){
            	if(cot.Monotributista_conyuge__c != null){
                    cot.Monotributista_conyuge__c.addError('Campo Monotributista conyuge no debe estar completo si tipo de afiliado es Monotributista y Tipo de contacto Individuo');
                }
                if(cot.Aporta_por_hijos__c != null){
                    cot.Aporta_por_hijos__c.addError('Campo Aporta por hijos no debe estar completo si tipo de afiliado es Monotributista y Tipo de contacto Individuo');
                }
                if(cot.Hijos_entre_21_y_25_aos__c != null ){
                    cot.Hijos_entre_21_y_25_aos__c.addError('Campo Cantidad de hijos no debe estar completo si tipo de afiliado es Monotributista y Tipo de contacto Individuo');
                }
                if(cot.Hijos_hasta_20_aos__c != null){
                    cot.Hijos_hasta_20_aos__c.addError('Campo Cantidad de hijos no debe estar completo si tipo de afiliado es Monotributista y Tipo de contacto Individuo');
                }
                if(cot.Edad_conyuge__c != null){
                    cot.Edad_conyuge__c.addError('Campo Edad conyuge no debe estar completo si tipo de afiliado es Monotributista y Tipo de contacto Individuo');
                }

                
        }



    }
}