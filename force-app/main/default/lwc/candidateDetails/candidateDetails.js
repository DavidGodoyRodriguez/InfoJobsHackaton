import { LightningElement, api, track } from 'lwc';

export default class CandidateDetails extends LightningElement {
    @api curriculums;
    @api selectedCurriculumId;

    get curriculum() {
        for (let curriculumItem of this.curriculums) {
            console.log(curriculumItem.Id);
            if (curriculumItem.Id === this.selectedCurriculumId) {
                return curriculumItem;
            }
        }
        return undefined;
    }

}