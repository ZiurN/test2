public class WSCaseBajaMock {

    public static string getFound(){
        return '{'+
            '"error": false,' +
            '"data": {' +
              '"caso_id": 79,'+
              '"origen": "W",'+
              '"tipo": "APREVIA",'+
              '"codigo": "234428/65",'+
              '"sf_id": "5008A000008A8qcQAC",'+
              '"nro_caso_sf": "00011999",'+
              '"estado_sf": "Pendiente",'+
              '"fecha_registro": null'+
            '},'+
            '"httpCode": 201,'+
            '"message": "Se generó el caso 00011999.",'+
            '"meta": {'+
              '"allowed_includes": [],'+
              '"default_includes": []'+
            '}'+
            '}';
    }
}