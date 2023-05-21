import { LightningElement, api } from 'lwc';

export default class CandidateList extends LightningElement {
    @api curriculums;
    assistantAnalysis;

    @api setAssistantAnalysis(assistantAnalysis) {
        this.assistantAnalysis = assistantAnalysis;
        this.updateCandidatesStyle();
    }

    updateCandidatesStyle() {
        if (this.curriculums) {
            for (let curriculumItem of this.curriculums) {
                const candidateAssistanceAnalysis = this.getCandidateAssistantAnalysis(curriculumItem.Id); 
                console.log('Analysis result ' + candidateAssistanceAnalysis);
                if (candidateAssistanceAnalysis) {
                    this.template.querySelector('[data-id="' + curriculumItem.Id + '"]').className = 'slds-list_horizontal custom-slds-green';
                } else if (candidateAssistanceAnalysis === false) {
                    this.template.querySelector('[data-id="' + curriculumItem.Id + '"]').className = 'slds-list_horizontal custom-slds-red';
                } else {
                    this.template.querySelector('[data-id="' + curriculumItem.Id + '"]').className = 'slds-list_horizontal';
                }
            }
        }
    }

    getCandidateAssistantAnalysis(curriculumId) {
        for (let assistantAnalysisItem of this.assistantAnalysis) {
            if (assistantAnalysisItem.curriculumId === curriculumId) {
                return assistantAnalysisItem.result;
            }
        }
        return undefined;
    }

    candidateSelected(event) {
        if (event.target.checked) {
            const elements = this.template.querySelectorAll('lightning-input');
            elements.forEach(element =>
                element.checked = event.target.name === element.name
            );
            this.dispatchEvent(new CustomEvent('candidateselected', {
                detail: {curriculumId: event.target.name}
            }));
        }
    }

}