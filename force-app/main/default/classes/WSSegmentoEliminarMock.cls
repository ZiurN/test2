/**
 * Created by xappia on 18/2/20.
 */

public class WSSegmentoEliminarMock {

    public static String getFound(){
        return '{'+
                '  "error": false,'+
                '  "data": {'+
                '    "em": {'+
                '      "em_id": "275822",'+
                '      "fecha_inicio": "20-02-0011 20:00",'+
                '      "estado": "AUTORIZADO",'+
                '      "emitido": "NO EMITIDO",'+
                '      "alerta": null,'+
                '      "fecha_emision": null,'+
                '      "segmento": ['+
                '        {'+
                '          "em_em_id": "275822",'+
                '          "sem_id": "305720",'+
                '          "fecha": "2020-02-18 00:00:00",'+
                '          "solicitante": "708375",'+
                '          "nom_solicitante": "AREVALO JORGE OSCAR",'+
                '          "fecha_desde_tentativa": "06-02-2020 01:00",'+
                '          "fecha_hasta_tentativa": "08-02-2020 00:00",'+
                '          "cant_dias": "5114",'+
                '          "estado": "AUTORIZADO",'+
                '          "cod_auditor": null,'+
                '          "ape_auditor": null,'+
                '          "nom_auditor": null,'+
                '          "fecha_real_desde": "0011-02-20 20:00:00",'+
                '          "fecha_real_hasta": "0025-02-20 20:00:00",'+
                '          "orig_fecha_real": "MESA CENSO",'+
                '          "cod_audito2": null,'+
                '          "ape_auditor2": null,'+
                '          "nom_auditor2": null,'+
                '          "prestador": null,'+
                '          "pres_nombre": " ",'+
                '          "presentacion": null,'+
                '          "lote": null,'+
                '          "obs": null'+
                '        },'+
                '        {'+
                '          "em_em_id": "275822",'+
                '          "sem_id": "305715",'+
                '          "fecha": "2020-02-18 00:00:00",'+
                '          "solicitante": "758415",'+
                '          "nom_solicitante": "ZAPATA AGUILA BENJAMIN",'+
                '          "fecha_desde_tentativa": "01-02-2020 00:00",'+
                '          "fecha_hasta_tentativa": "02-02-2020 00:00",'+
                '          "cant_dias": "1",'+
                '          "estado": "AUTORIZADO",'+
                '          "cod_auditor": null,'+
                '          "ape_auditor": null,'+
                '          "nom_auditor": null,'+
                '          "fecha_real_desde": "2020-02-01 00:00:00",'+
                '          "fecha_real_hasta": "2020-02-02 00:00:00",'+
                '          "orig_fecha_real": "MESA CENSO",'+
                '          "cod_audito2": null,'+
                '          "ape_auditor2": null,'+
                '          "nom_auditor2": null,'+
                '          "prestador": null,'+
                '          "pres_nombre": " ",'+
                '          "presentacion": null,'+
                '          "lote": null,'+
                '          "obs": null'+
                '        }'+
                '      ],'+
                '      "efe_codigo_lugar": "700616",'+
                '      "cons_lugar": "1",'+
                '      "nom_lugar": "SANATORIO PARQUE",'+
                '      "nom_cons": "CONSULTORIO PPAL PRESTADOR :700616",'+
                '      "efe_codigo_resp": "758415",'+
                '      "nom_resp": "ZAPATA AGUILA BENJAMIN",'+
                '      "efe_codigo_solic": "758415",'+
                '      "nom_solic": "ZAPATA AGUILA BENJAMIN",'+
                '      "tem_codigo": "IA",'+
                '      "nom_tipo": "INTERNACION",'+
                '      "contexto": "INTERNACION",'+
                '      "de_seguimiento": "F",'+
                '      "recupero": "F",'+
                '      "diferido": "F",'+
                '      "suspendido": "F",'+
                '      "fec_vto_certif": null,'+
                '      "cod_motivo": "CLINICO",'+
                '      "nom_motivo": "CLINICO",'+
                '      "mail": null,'+
                '      "diag_codigo": "F10",'+
                '      "diag_nombre": "TRASTORNOS MENTALES Y DEL COMPORTAMIENTO DEBIDOS AL USO DE A",'+
                '      "complicaciones": "SIN COMPLICACIONES",'+
                '      "grup_pres": null,'+
                '      "gpres_nombre": null,'+
                '      "nro_prestacion": "02430199",'+
                '      "nom_prestacion": "INTERNACION CLINICA (FACTURAR CODIGO PENSION)",'+
                '      "aut_previa": "1014010046",'+
                '      "feem_codigo": null,'+
                '      "feem_nombre": null,'+
                '      "domi_entrega": null,'+
                '      "agenia": null,'+
                '      "otro_domi": null,'+
                '      "via_entrega": null,'+
                '      "domicilio": null,'+
                '      "em_de_seguimiento": null,'+
                '      "tipo_seg": null,'+
                '      "nom_tipo_seg": null,'+
                '      "estado_seg": null,'+
                '      "desc_seg": null,'+
                '      "cod_regla": "INT_CLINICA",'+
                '      "nom_regla": "INTERNACION CLINICA",'+
                '      "sistema": "ABIERTO",'+
                '      "descr_em": ".",'+
                '      "nom_delegacion": "650098_ACA SALUD SUC. ROSARIO",'+
                '      "obs_em": null,'+
                '      "afi_afi_id": "274762",'+
                '      "apr_apr_id": "1014010046",'+
                '      "check_mat": null,'+
                '      "check_presu": null,'+
                '      "importe_presu": null,'+
                '      "nro_sf": null,'+
				'      "link_em": "http://www.extranet.acasalud.com.ar/SF/EM_275822.pdf"'+
                '    }'+
                '  },'+
                '  "httpCode": 200,'+
                '  "message": "Se eliminó correctamente el segmento",'+
                '  "meta": {'+
                '    "allowed_includes": [],'+
                '    "default_includes": []'+
                '  }'+
                '}';
    }

    public static String getError(){
        return '{'+
                '"data": {'+
                '"error": true,'+
                '"errors": [],'+
                '"errorType": "exception",'+
                '"httpCode": 404,'+
                '"message": "El segmento solicitado es inválido.",'+
                '"debug_message": [],'+
                '"exception": "NotFoundHttpException",'+
//                '"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php",'+
                '"line": 964'+
                '}'+
                '}';
    }

}