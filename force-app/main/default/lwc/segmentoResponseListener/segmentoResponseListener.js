import { LightningElement, api, wire } from 'lwc';
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
const FIELDS = [
	'Segmentos__c.Error_en_SS__c',
	'Segmentos__c.Semid__c'
];
export default class SegmentoResponseListener extends LightningElement {
	@api recordId;
	semid;
	channelName = '/event/SS_Segmento_Response__e';
	isSubscribeDisabled = false;
	isUnsubscribeDisabled = !this.isSubscribeDisabled;
	subscription = {};
	/** get Data */
	@wire(getRecord, { recordId: '$recordId', fields: FIELDS })
	processDataFromSF ({data, error}) {
		if (data) {
			this.semid = data.fields.Semid__c.value;
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
		let segmentoId = response.data.payload.Id_Segmento__c;
		let hasSSError = response.data.payload.error__c;
		let isDelete = response.data.payload.isDelete__c;
		if (isDelete || (segmentoId === this.semid && hasSSError)) {
			this.sendMessageToUser('error', response.data.payload.Response_Error__c);
		} else if (!hasSSError && !isDelete) {
			this.sendMessageToUser('success', 'Segmento actualizado en SS');
		}
		getRecordNotifyChange([{recordId: this.recordId}]);
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