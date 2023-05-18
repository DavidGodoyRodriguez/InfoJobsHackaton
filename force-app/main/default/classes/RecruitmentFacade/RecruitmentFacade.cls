public with sharing class RecruitmentFacade {

    public static RecruitmentDTO.Offer getOffer(String offerId) {
        IRecruitmentConnector recruitmentConnector = InfoJobsConnector.getInstance();
        return recruitmentConnector.getOffer(offerId);
    }

    public static List<Curriculum__c> getCurriculum(Set<String> curriculumIds) {
        //IRecruitmentConnector recruitmentConnector = InfoJobsConnector.getInstance();
        //return recruitmentConnector.getCurriculums(curriculumIds);
        // Instead of returning RecruitmentDTO.Curriculum, I will return Salesforce Objects from the database for simplicity
        // And also because of privacy restrictions in the InfoJobs API
        
        

        return null;
    }

}