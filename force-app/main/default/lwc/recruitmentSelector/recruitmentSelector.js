import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCurriculumsBackend from '@salesforce/apex/RecruitmentChatController.getCurriculums';

export default class RecruitmentSelector extends LightningElement {

    displayCandidatesAndChat = false;
    @track curriculums;
    selectedCurriculumId;
    assistantAnalysis;

    onOfferRetrieved() {
        this.displayCandidatesAndChat = true;
        this.getCurriculums();
    }

    candidateSelected(event) {
        this.selectedCurriculumId = event.detail.curriculumId;
    }

    analysisRan(event) {
        this.assistantAnalysis = event.detail.assistantAnalysis;
        this.template.querySelector('c-candidate-list').setAssistantAnalysis(this.assistantAnalysis);
    }

    getCurriculums() {
        getCurriculumsBackend()
        .then(result =>{
            this.curriculums = result;
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