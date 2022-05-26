import { LightningElement, api, wire } from 'lwc';
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
const FIELDS_OPPORTUNITY = [
	'Opportunity.Estado_de_solicitud__c',
	'Opportunity.Nro_de_solicitud__c'
];
export default class SegmentoResponseListener extends LightningElement {
	@api recordId;
	estado;
	nroSolicitud;
	channelName = '/event/SS_Response_Event__e';
	isSubscribeDisabled = false;
	isUnsubscribeDisabled = !this.isSubscribeDisabled;
	subscription = {};
	/** get Data */
	@wire(getRecord, { recordId: '$recordId', fields: FIELDS_OPPORTUNITY })
	processDataFromSF ({data, error}) {
		if (data) {
			this.estado = data.fields.Estado_de_solicitud__c.value;
			this.nroSolicitud = data.fields.Nro_de_solicitud__c.value;
			console.log(this.estado);
			console.log(this.nroSolicitud);
		} else if (error) {
			console.log(error);
		}
	}
	/** Lifecycle methods */
	connectedCallback() {
		this.registerErrorListener();
		this.handleSubscribe();
	}
	disconnectedCallback() {
		this.handleUnsubscribe();
	}
	/** Events handlers */
	handleSubscribe () {
		subscribe(this.channelName, -1, this.messageCallback).then(
			response => {
				this.subscription = response;
				console.log('suscrito: ' + response.channel);
			}
		);
	}
	handleUnsubscribe () {
		unsubscribe(this.subscription, response => {
			console.log('Desuscrito: ' + response);
		});
	}
	messageCallback = (response) => {
		let record_Id = response.recorddata.payload.Id_Registro__c;
		let hasSSError = response.data.payload.error__c;
		let isDelete = response.data.payload.isDelete__c;
		if (isDelete || (record_Id === this.recordId && hasSSError)) {
			this.sendMessageToUser('error', response.data.payload.Response_Error__c);
		} else if (!hasSSError && !isDelete) {
			this.sendMessageToUser('success', response.data.payload.Response_Error__c);
		}
		getRecordNotifyChange([{recordId: this.recordId}]);
		this.handleUnsubscribe();
	}
	registerErrorListener() {
		// Invoke onError empApi method
		onError((error) => {
			console.log('Received error from server: ', JSON.stringify(error));
			// Error contains the server-side error
		});
	}
	sendMessageToUser(status, message){
		const evt = new ShowToastEvent({
			message: message,
			variant: status,
		});
		this.dispatchEvent(evt);
	}
}