public class ConsultoriosEfectorProcessor implements IMasterBuilder{
    public Boolean hasNext = false;
    public String next;
    public String followUpEndpoint;
    public Datetime runTime;
    public Datetime lastUpdateForConsultorios;

    public Integer pageSize;
    public Integer currentPage;
    public Integer lastPage;


    public ConsultoriosEfectorProcessor(Integer pageSize, Datetime runTime) {
        this(pageSize, 1, 1, runTime, Datetime.now());
    }

    public ConsultoriosEfectorProcessor(Integer pageSize, Datetime runTime, Datetime lastUpdateForAsociado) {
        this(pageSize, 1, 1, runTime, lastUpdateForAsociado);
    }

    public ConsultoriosEfectorProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime) {
        this(pageSize, currentPage, lastPage, runTime, Datetime.now());
    }

    public ConsultoriosEfectorProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime, Datetime lastUpdateForEfectores) {
        this.pageSize = pageSize;
        this.currentPage = currentPage;
        this.lastPage = lastPage;
        this.runTime = runTime;
        this.lastUpdateForConsultorios = lastUpdateForEfectores;

    }

    public List<WSBatchConsultoriosResp.Data> callWebService() {
        List<WSBatchConsultoriosResp.Data> wsData = new List<WSBatchConsultoriosResp.Data>();
        WSBatchConsultorios.Response result;


        if (currentPage <= lastPage) {
            String fecha = runTime.format('yyyy-MM-dd');
            result = WSBatchConsultorios.getBatchConsultorios(fecha, this.pageSize, this.currentPage);
        }

        if(!result.hasError) {
            hasNext = result.consultorios.links.next != null;
            currentPage = result.consultorios.meta.current_page +1;
            lastPage = result.consultorios.meta.last_page;

            wsData = result.consultorios.data;
        }

        return wsData;
    }

    public void processResponse(List<Object> wsResponses) {
        List<Consultorio__c> consultorioList = new List<Consultorio__c>();
		List<String> ids = new List<String>();

        for(Object res : wsResponses) {
            WSBatchConsultoriosResp.Data consultorio = (WSBatchConsultoriosResp.Data) res;

            Consultorio__c con = new Consultorio__c();
            con.Efector_Prestador__r = new Account(Codigo_de_efector__c = consultorio.pres_efe_codigo);
            con.Secuencia__c = consultorio.secuencia != null ? Decimal.valueOf(consultorio.secuencia) : null;
            con.Name = consultorio.nombre;
            con.Username__c = consultorio.username;
            con.Id_Externo__c = consultorio.pres_efe_codigo + '-' + consultorio.secuencia;
            con.Principal__c = consultorio.principal == 'V' ? true : false;
            con.Fecha_vigencia__c = consultorio.fecha_vigencia != null ? Date.valueOf(consultorio.fecha_vigencia) : null;
            con.Estado__c = consultorio.estado;
            con.Descripcion__c = consultorio.descripcion;
            con.Consultorio_Diabetes__c = consultorio.consultorio_diabetes;
            con.Matri__c = consultorio.matri;
            con.Mail__c = Utils.isAValidEmail(consultorio.mail) ? consultorio.mail : null;
            con.Codigo_externo__c = consultorio.codigo_externo;
            con.Cod_Pami__c = consultorio.cod_pami;
            con.Fecha_desde_Usuario__c = consultorio.fecha_desde_usr != null ? Date.valueOf(consultorio.fecha_desde_usr) : null;
            con.Fecha_hasta_Usuario__c = consultorio.fecha_hasta_usr != null ? Date.valueOf(consultorio.fecha_hasta_usr) : null;
            con.Horarios__c = consultorio.horario;
            con.Farmacia_Leches__c = consultorio.farmacias_leches == 'V' ? true : false;
            con.Tipo_Mat__c = consultorio.tipo_matricula;
            con.Cuit__c = consultorio.cuit;
            con.Cons__c = consultorio.cons_cia;
            con.Firma__c = consultorio.firma;

            consultorioList.add(con);
			ids.add(con.Id_Externo__c);
        }

        Database.UpsertResult[] results = Database.upsert(
                consultorioList, Consultorio__c.Fields.Id_Externo__c,false
        );

        System.debug(results);
		//EmailUtils.sendErrorMail(results, null, null, ids, 'Consultorios');

		Utils.insertBatchLogs(results, null, null, ids, 'Consultorios');


    }



    public void updateDate() {


        if (!hasNext) {

            ConveniosEfectorProcessor convProcessor = new ConveniosEfectorProcessor(100,runTime);
            Database.executeBatch(new MasterBatch(convProcessor));

        } else {

            ConsultoriosEfectorProcessor nextProcessor = new ConsultoriosEfectorProcessor(pageSize, currentPage, lastPage, runTime);
            Database.executeBatch(new MasterBatch(nextProcessor));
        }
    }
}