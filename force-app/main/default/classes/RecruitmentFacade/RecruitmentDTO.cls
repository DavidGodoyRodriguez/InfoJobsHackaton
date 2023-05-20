public with sharing class RecruitmentDTO {
    public class Offer {
        public String id;
        @AuraEnabled public String title;
        @AuraEnabled public String city;
        @AuraEnabled public String description;
        @AuraEnabled public Integer applications;
    }

    // Because all below data is not accessible because of privacy restrictions, we are going to mock up the data with test data
    // All the data comes from the "curriculum" endpoints
    public class Curriculum {
        public String name;
        public String surname1;
        public String surname2;
        public String country;
        public String city;
        public String phone;
        public String cvtext;
        public List<SkillExpertiseItem> expertise;
        public List<SkillLanguageItem> language;
        public List<EducationItem> education;
        public List<ExperienceItem> experience;
    }

    public class SkillExpertiseItem {
        public String skill;
        public String level;
    }

    public class SkillLanguageItem {
        public String language;
        public String reading;
        public String speaking;
        public String writing;
    }

    public class EducationItem {
        public String educationLevelCode;
        public String courseName;
        public Date finishingDate;
        public String institutionName;
    }

    public class ExperienceItem {
        public String company;
        public String job;
        public String description;
        public Date startingDate;
        public Date finishingDate;
    }
}