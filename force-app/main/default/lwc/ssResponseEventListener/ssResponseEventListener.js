import { LightningElement, api } from 'lwc';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';

export default class SegmentoResponseListener extends LightningElement {
	@api recordId;
	estado;
	nroSolicitud;
	channelName = '/event/SSResponseEvent__e';
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
		subscribe(this.channelName, -1, (response) => {
			try {
				console.log(JSON.parse(JSON.stringify(response.data.payload)));
				let record_Id = response.data.payload.recordId__c;
				let hasSSError = response.data.payload.isErrorEvent__c;
				let isDelete = response.data.payload.isCreationEvent__c;
				if (isDelete || (record_Id === this.recordId && hasSSError)) {
					this.sendMessageToUser('error', response.data.payload.message__c);
				} else if (!hasSSError && !isDelete) {
					this.sendMessageToUser('success', response.data.payload.message__c);
					this.handleUnsubscribe();
				}
				getRecordNotifyChange([{recordId: this.recordId}]);
			} catch (error) {
				console.log(error);
				this.sendMessageToUser('warning', 'Error al procesar respuesta de SaludSoft, por favor recargue la página');
			}
		}).then(
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