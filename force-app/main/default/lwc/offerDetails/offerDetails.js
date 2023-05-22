import { LightningElement, track } from 'lwc';
import getOfferBackend from '@salesforce/apex/RecruitmentChatController.getOffer';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class OfferDetails extends LightningElement {
    offerId;
    @track offer;

    inputChange(event) {
        this.offerId = event.target.value;
    }

    getOffer(event) {
        getOfferBackend({offerId: this.offerId})
        .then(result =>{
            this.offer = result;
            this.dispatchEvent(new CustomEvent('retrieve', {
                detail: {}
            }));
        })
        .catch(error =>{
            const evt = new ShowToastEvent({
                title: 'Error on offer component',
                message: 'Check the console for more details',
                variant: 'error',
            });
            this.dispatchEvent(evt);
            console.error(error);
        })
    }

}