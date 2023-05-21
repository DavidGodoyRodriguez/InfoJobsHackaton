import { LightningElement, api } from 'lwc';

export default class CandidateList extends LightningElement {

    @api curriculums;

    candidateSelected(event) {
        if (event.target.checked) {
            const boxes = this.template.querySelectorAll('lightning-input');
            boxes.forEach(box =>
                box.checked = event.target.name === box.name
            );
            this.dispatchEvent(new CustomEvent('candidateselected', {
                detail: {curriculumId: event.target.name}
            }));
        }
    }

}