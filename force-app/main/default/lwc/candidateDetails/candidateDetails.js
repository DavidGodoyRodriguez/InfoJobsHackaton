import { LightningElement, api, track } from 'lwc';

export default class CandidateDetails extends LightningElement {
    @api curriculums;
    @api selectedCurriculumId;
    @api assistantAnalysis;

    get curriculum() {
        if (this.curriculums) {
            for (let curriculumItem of this.curriculums) {
                if (curriculumItem.Id === this.selectedCurriculumId) {
                    return curriculumItem;
                }
            }
        }
        return undefined;
    }

    get analysis() {
        if (this.assistantAnalysis) {
            for (let assistantAnalysisItem of this.assistantAnalysis) {
                if (assistantAnalysisItem.curriculumId === this.selectedCurriculumId) {
                    return assistantAnalysisItem;
                }
            }
        }
        return undefined;
    }

}