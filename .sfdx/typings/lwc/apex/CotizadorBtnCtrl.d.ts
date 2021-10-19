declare module "@salesforce/apex/CotizadorBtnCtrl.sendToWSCotizadorCorp" {
  export default function sendToWSCotizadorCorp(param: {opportunityId: any, fileId: any}): Promise<any>;
}
declare module "@salesforce/apex/CotizadorBtnCtrl.sendToWSCotizadorInd" {
  export default function sendToWSCotizadorInd(param: {cotizacionId: any}): Promise<any>;
}
declare module "@salesforce/apex/CotizadorBtnCtrl.generatePDF" {
  export default function generatePDF(param: {cotId: any}): Promise<any>;
}
