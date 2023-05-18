public with sharing class RecruitmentFacade {

    public static RecruitmentDTO.Offer getOffer(String offerId) {
        IRecruitmentConnector recruitmentConnector = InfoJobsConnector.getInstance();
        return recruitmentConnector.getOffer(offerId);
    }

    public static List<RecruitmentDTO.Curriculum> getCurriculum(Set<String> curriculumIds) {
        //IRecruitmentConnector recruitmentConnector = InfoJobsConnector.getInstance();
        //return recruitmentConnector.getCurriculums(curriculumIds);
        


    }

}