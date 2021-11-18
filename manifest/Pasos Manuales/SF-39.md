## Manual Steps
### Pre Steps: false

### Post Steps: true

#### 1. Borrar las clases inutilizadas:

Ejecutar el siguiente comando:

	sfdx force:mdapi:deploy -d ./data-config/SF-39/destructive --verbose -w -1 -u {{ALIAS}}

Cambiando <code>{{ALIAS}}</code> por el alias de la org en el proyecto de VSCode.

El comando eliminará las siguientes clases:

* WSCaseAPGenerarCentroResp
* WSCaseAPGenerarCentroRespTest
* WSCasoEnviarASS
* WSCasoEnviarASSTest
* CaseReintegroEnviarASSBtnCtrl
* CaseReintegroEnviarASSBtnCtrlTest
* WSSendSSResponsesMock
* WSCaseReintegroEnviarASSMock
* WSCaseReintegroEnviarASS
* WSCaseReintegroEnviarASSResp
* WSCaseReintegroEnviarASSRespTest

--------

## Release Notes

En este apartado se deben anotar cuestiones específicas del release.

`Content Version: xx.
Package Version: xx.
API Version: xx.`