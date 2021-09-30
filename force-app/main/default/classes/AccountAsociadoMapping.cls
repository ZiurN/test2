public class AccountAsociadoMapping  {
	
	public static Map<String, String> GETASOCIADOAPIRESPFIELDSBYACCOUNTASOCIADOFIELDS =
		new Map<String, String>{
			'Actividad_codigo__c' => 'actividad_codigo',
			'Actividad_nombre__c' => 'actividad_nombre',
			'Adherente__c' => 'adherente',
			'Afi_Id__c' => 'afi_id',
			'Afiliacion__c' => 'afiliacion',
			'Agencia_codigo__c' => 'agencia_codigo',
			'Agencia_nombre__c' => 'agencia_nombre',
			'Antiguedad_reconocida__c' => 'antiguedad_reconocida',
			'Aporta__c' => 'aporta',
			'CUIT__c' => 'cuit',
			'Categoria_Nombre__c' => 'categoria_nombre',
			'Categoria_codigo__c' => 'categoria_codigo',
			'Clase_efector__c' => 'codigo_1',
			'Codigo_de_Afiliado__c' => 'codigo',
			'Codigo_de_Entidad__c' => 'entidad_codigo',
			'Codigo_de_empresa__c' => 'empresa_codigo',
			'Empresa_codigo__c' => 'empresa_codigo',
			'Empresa_nombre__c' => 'empresa_nombre',
			'Empresa_sucursal__c' => 'empresa_sucursal',
			'Empresa_sucursal_nombre__c' => 'empresa_sucursal_nombre',
			'Estado__c' => 'estado',
			'Estado_civil__c' => 'estado_civil',
			'Fecha_Alta__c' => 'fecha_alta',
			'Fecha_alta_Administrativa__c' => 'fecha_alta_administrativa',
			'Fecha_nacimiento_efector__c' => 'fecha_nacimiento',
			'Fecha_vigencia__c' => 'fecha_vigencia',
			'FirstName' => 'nombres',
			'Gentilicio__c' => 'gentilicio',
			'LastName' => 'apellidos',
			'Modelo_Plan_Codigo__c' => 'modelo_plan_codigo',
			'Modelo_Plan_Nombre__c' => 'modelo_plan_nombre',
			'Monto_excedente__c' => 'excedente',
			'Motivo_de_baja__c' => 'motivo_de_baja',
			'Numero_de_documento__c' => 'numero_documento',
			'Obra_social_ant_codigo__c' => 'obra_social_ant_codigo',
			'Obra_social_ant_nombre__c' => 'obra_social_ant_nombre',
			'Obra_social_codigo__c' => 'obra_social_codigo',
			'Obra_social_nombre__c' => 'obra_social_nombre',
			'Parentesco__c' => 'parentesco',
			'PersonBirthdate' => 'fecha_nacimiento',
			'Plan_Codigo__c' => 'plan_codigo',
			'Plan_Nombre__c' => 'plan_nombre',
			'Sexo__c' => 'sexo',
			'Sujeto_facturacion__c' => 'sujeto_facturacion',
			'Tipo_de_baja_codigo__c' => 'tipo_baja_codigo',
			'Tipo_de_baja_nombre__c' => 'tipo_baja_nombre',
			'Tipo_de_documento__c' => 'tipo_documento',
			'Titular_apellidos__c' => 'titular_apellidos',
			'Titular_codigo__c' => 'afi_id_tit',
			'Titular_nombres__c' => 'titular_nombres',
			'Type' => 'tipo_afiliado'
		};
	
	public static void upsertAccountAsociado(String asociadoId){
		WSAsociadoGetAsociado.Response wsResponse = WSAsociadoGetAsociado.getAsociado(asociadoId);
		
		if(!wsResponse.hasError){
			if(!wsResponse.asociadoApiRespValuesByasociadoApiRespFields.isEmpty()){
				//Get Account Cuenta Personal RecordTypeId
				RecordType cuentaPersonalRecordType = XappiaHelper.getRecordType('Account', 'Cuenta_personal');
				Id cuentaPersonalRecordTypeId = cuentaPersonalRecordType.Id;

				//New cuentaPersonalAccount and assing RecordTypeId
				Account accountCuentaPersonal = new Account();
				accountCuentaPersonal.RecordTypeId = cuentaPersonalRecordTypeId;

				//Mapping
				for(String accountAsociadoField : GETASOCIADOAPIRESPFIELDSBYACCOUNTASOCIADOFIELDS.keySet()){
					Schema.DisplayType fieldType = 
						Schema.SObjectType.Account.fields.getMap().get(accountAsociadoField).getDescribe().getType();
					if(fieldType == Schema.DisplayType.STRING){
						accountCuentaPersonal.put(
							accountAsociadoField,
							String.valueOf(
								wsResponse.asociadoApiRespValuesByasociadoApiRespFields.get(
									GETASOCIADOAPIRESPFIELDSBYACCOUNTASOCIADOFIELDS.get(accountAsociadoField)
								)
							)
						);
					}
					if(fieldType == Schema.DisplayType.PICKLIST){
						accountCuentaPersonal.put(
							accountAsociadoField,
							String.valueOf(
								wsResponse.asociadoApiRespValuesByasociadoApiRespFields.get(
									GETASOCIADOAPIRESPFIELDSBYACCOUNTASOCIADOFIELDS.get(accountAsociadoField)
								)
							)
						);
					}
					if(fieldType == Schema.DisplayType.BOOLEAN){
						accountCuentaPersonal.put(
							accountAsociadoField,
							Boolean.valueOf(
								wsResponse.asociadoApiRespValuesByasociadoApiRespFields.get(
									GETASOCIADOAPIRESPFIELDSBYACCOUNTASOCIADOFIELDS.get(accountAsociadoField)
								)
							)
						);
					}
					if(fieldType == Schema.DisplayType.INTEGER){
						accountCuentaPersonal.put(
							accountAsociadoField,
							Integer.valueOf(
								wsResponse.asociadoApiRespValuesByasociadoApiRespFields.get(
									GETASOCIADOAPIRESPFIELDSBYACCOUNTASOCIADOFIELDS.get(accountAsociadoField)
								)
							)
						);
					}
					if(fieldType == Schema.DisplayType.DOUBLE){
						accountCuentaPersonal.put(
							accountAsociadoField,
							Double.valueOf(
								wsResponse.asociadoApiRespValuesByasociadoApiRespFields.get(
									GETASOCIADOAPIRESPFIELDSBYACCOUNTASOCIADOFIELDS.get(accountAsociadoField)
								)
							)
						);
					}
					if(fieldType == Schema.DisplayType.DATE){
						Date dateToMapping = Date.valueOf(
							String.valueOf(
								wsResponse.asociadoApiRespValuesByasociadoApiRespFields.get(GETASOCIADOAPIRESPFIELDSBYACCOUNTASOCIADOFIELDS.get(accountAsociadoField))
							)
						);
						accountCuentaPersonal.put(
							accountAsociadoField,
							dateToMapping
						);
					}
				}
				Database.UpsertResult accountUpsertResult = Database.upsert(accountCuentaPersonal, Account.Fields.Afi_Id__c);
				if(!accountUpsertResult.isSuccess()){
					for(Database.Error err : accountUpsertResult.getErrors()) {
						System.debug('The following error has occurred.');                    
						System.debug(err.getStatusCode() + ': ' + err.getMessage());
						System.debug('Fields that affected this error: ' + err.getFields());
					}
				}
			}
		}
	} 
}