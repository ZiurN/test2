public class EfectorSearchController  {

	@AuraEnabled
	public static Response search(String matricula, String provincia, String localidad) {
		System.debug(matricula);
		System.debug(provincia);
		System.debug(localidad);
		//String query = 'SELECT Name FROM Account WHERE RecordType.DeveloperName = \'Efector\'';
		//List<Account> efectores = Database.query(query);
		//Medico[] medicos = new List<Medico>();
		String query = 'SELECT Id, Matricula__c, Efector__c, Provincia_codigo__c, Efector__r.Codigo_de_efector__c, ' +
							'Efector__r.Autonumerico__c, Efector__r.Name ' +
						'FROM Matricula__c ' +
						'WHERE Matricula__c LIKE \'%' + matricula + '%\' ' +
							'AND Efector__r.Localidad_Nombre__c LIKE \'%' + localidad + '%\'';
						//'%\' AND Provincia_codigo__c LIKE \'%' + provincia + 
		query += String.isNotEmpty(provincia) ? ' AND Provincia_codigo__c = \'' + provincia + '\'' : '';
		List<Matricula__c> matriculas = Database.query(query);

		for(Matricula__c mat : matriculas) {
			String provinciaNombre = XappiaHelper.getPicklistLabelAndValues('Matricula__c','Provincia_codigo__c')
										.get(mat.Provincia_codigo__c);
			
			mat.Provincia_nombre__c = provinciaNombre;			
			
		}

		//return new Response(false, efectores);
		return new Response(false, matriculas);
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		//@AuraEnabled public String[] efectores;
		@AuraEnabled public Matricula__c[] efectores;

		//public Response(Boolean hasError, String[] efectores) {
		public Response(Boolean hasError, Matricula__c[] efectores) {
            this.hasError = hasError;
            this.efectores = efectores;
        }
	}

	//public class Medico {
		//@AuraEnabled public String nombre;
		//@AuraEnabled public String matricula;
		//@AuraEnabled public String provincia;
		//@AuraEnabled public String autonumerico;

		//public Response(String nombre, String matricula, String provincia, String autonumerico) {
            //this.nombre = nombre;
            //this.matricula = matricula;
			//this.provincia = provincia;
			//this.autonumerico = autonumerico;
			//this.medicos = medicos;
        //}
	//}
}