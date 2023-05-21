import { LightningElement, track } from 'lwc';
import getCurriculumsBackend from '@salesforce/apex/RecruitmentChatController.getCurriculums';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class RecruitmentSelector extends LightningElement {

    displayCandidatesAndChat = false;
    @track curriculums;
    selectedCurriculumId;

    onOfferRetrieved() {
        this.displayCandidatesAndChat = true;
        this.getCurriculums();
    }

    candidateSelected(event) {
        this.selectedCurriculumId = event.detail.curriculumId;
    }

    getCurriculums() {
        getCurriculumsBackend()
        .then(result =>{
            this.curriculums = result;
            console.log(this.curriculums);
        })
        .catch(error =>{
            const evt = new ShowToastEvent({
                title: 'Error on offer component',
                message: error.body.message,
                variant: 'error',
            });
            this.dispatchEvent(evt);
            console.error(error);
        })
    }

}