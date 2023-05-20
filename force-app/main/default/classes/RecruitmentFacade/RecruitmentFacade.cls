public with sharing class RecruitmentFacade {

    public static RecruitmentDTO.Offer getOffer(String offerId) {
        IRecruitmentConnector recruitmentConnector = InfoJobsConnector.getInstance();
        return recruitmentConnector.getOffer(offerId);
    }

    public static List<Curriculum__c> getCurriculum(Set<String> curriculumIds) {
        // IRecruitmentConnector recruitmentConnector = InfoJobsConnector.getInstance();
        // return recruitmentConnector.getCurriculums(curriculumIds);
        
        // Instead of returning RecruitmentDTO.Curriculum, I will return Salesforce Objects from the database for simplicity
        // And also because of privacy restrictions in the InfoJobs API
        return [
                SELECT Id, Name__c, Surname1__c, Surname2__c, Phone__c, Country__c, City__c, CVText__c,
                (SELECT Id, Company__c, Job__c, Description__c, Starting_Date__c, Finishing_Date__c FROM Experiences__r),
                (SELECT Id, Education_Level__c, Course_Name__c, Finishing_Date__c, Institution_Name__c FROM Educations__r),
                (SELECT Id, Language__c, Reading__c, Speaking__c, Writing__c FROM Skill_Language__r),
                (SELECT Id, Skill__c, Level__c FROM Skill_Expertises__r)
                FROM Curriculum__c
        ];
    }

}