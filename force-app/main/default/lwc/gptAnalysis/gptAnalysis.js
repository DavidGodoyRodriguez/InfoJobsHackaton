import { LightningElement, api } from 'lwc';
import getLLMAnalysisBackend from '@salesforce/apex/RecruitmentChatController.getLLMAnalysis';

export default class GptAnalysis extends LightningElement {
    spinner = false;
    @api curriculums;
    curriculumsCopy;
    requiredCapacities;
    assistantAnalysis;

    updateFields(event) {
        this.requiredCapacities = event.target.value;
    }

    runAnalysis() {
        this.spinner = true;
        this.assistantAnalysis = [];
        this.curriculumsCopy = [...this.curriculums];
        this.getNextAnalysis();
    }

    getNextAnalysis() {
        if (this.curriculumsCopy.length > 0) {
            this.getNextAnalysisFromBackend();
        } else {
            this.spinner = false;
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
            this.spinner = false;
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