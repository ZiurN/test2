import { LightningElement, api, wire } from 'lwc';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';

export default class SegmentoResponseListener extends LightningElement {
	@api recordId;
	estado;
	nroSolicitud;
	channelName = '/event/SS_Response_Event__e';
	isSubscribeDisabled = false;
	isUnsubscribeDisabled = !this.isSubscribeDisabled;
	subscription = {};
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
		const messageCallback = (response) => {
			console.log(JSON.parse(JSON.stringify(response.recorddata.payload)));
			let record_Id = response.recorddata.payload.Id_Registro__c;
			let hasSSError = response.data.payload.error__c;
			let isDelete = response.data.payload.isDelete__c;
			if (isDelete || (record_Id === this.recordId && hasSSError)) {
				this.sendMessageToUser('error', response.data.payload.Response_Error__c);
			} else if (!hasSSError && !isDelete) {
				this.sendMessageToUser('success', response.data.payload.Response_Error__c);
				this.handleUnsubscribe();
			}
			getRecordNotifyChange([{recordId: this.recordId}]);
		}
		subscribe(this.channelName, -1, messageCallback).then(
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