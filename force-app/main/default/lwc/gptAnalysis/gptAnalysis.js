import { LightningElement, api } from 'lwc';
import getLLMAnalysisBackend from '@salesforce/apex/RecruitmentChatController.getLLMAnalysis';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GptAnalysis extends LightningElement {
    loading = false;
    @api curriculums;
    curriculumsCopy;
    requiredCapacities;
    assistantAnalysis;

    updateFields(event) {
        this.requiredCapacities = event.target.value;
    }

    runAnalysis() {
        this.loading = true;
        this.assistantAnalysis = [];
        this.curriculumsCopy = [...this.curriculums];
        this.getNextAnalysis();
    }

    getNextAnalysis() {
        if (this.curriculumsCopy.length > 0) {
            this.getNextAnalysisFromBackend();
        } else {
            this.loading = false;
            this.dispatchEvent(new CustomEvent('analysisran', {
                detail: {assistantAnalysis: this.assistantAnalysis}
            }));
        }
    }

    getNextAnalysisFromBackend() {
        getLLMAnalysisBackend({ requiredCapacities: this.requiredCapacities, curriculum: this.curriculumsCopy.pop() })
        .then(result =>{
            this.assistantAnalysis.push(result);
            this.getNextAnalysis();
        })
        .catch(error =>{
            this.loading = false;
            const evt = new ShowToastEvent({
                title: 'Error on gpt component',
                message: 'Check the console for more details',
                variant: 'error',
            });
            this.dispatchEvent(evt);
            console.error(error);
        })
    }

}