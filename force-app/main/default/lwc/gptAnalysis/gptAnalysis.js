import { LightningElement, api } from 'lwc';
import getLLMAnalysisBackend from '@salesforce/apex/RecruitmentChatController.getLLMAnalysis';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GptAnalysis extends LightningElement {
    loading = false;
    buttonDisabled = false;
    showCounter = false;
    @api curriculums;
    curriculumsCopy;
    requiredCapacities;
    assistantAnalysis;
    
    timeVal = '60';
    totalSeconds = 60;

    startCounter() {
        var parentThis = this;
        this.showCounter = true;
        var timeIntervalInstance = setInterval(function() {
            parentThis.timeVal = parentThis.totalSeconds;   
            parentThis.totalSeconds -= 1;

            if (parentThis.totalSeconds === 0) {
                parentThis.timeVal = '60';
                parentThis.totalSeconds = 60;
                parentThis.showCounter = false;
                parentThis.buttonDisabled = false;
                clearInterval(timeIntervalInstance);
            }
        }, 1000);
    }

    updateFields(event) {
        this.requiredCapacities = event.target.value;
    }

    runAnalysis() {
        this.loading = true;
        this.buttonDisabled = true;
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
            this.startCounter();
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
            this.buttonDisabled = false;
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