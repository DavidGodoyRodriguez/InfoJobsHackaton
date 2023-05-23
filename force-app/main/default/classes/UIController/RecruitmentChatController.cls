public with sharing class RecruitmentChatController {
    
    public class RecruitmentAssistant {
        @AuraEnabled public Id curriculumId;
        @AuraEnabled public String description;
        @AuraEnabled public Boolean result;
    }

    @AuraEnabled
    public static RecruitmentDTO.Offer getOffer(String offerId){
        try {
            return RecruitmentFacade.getOffer(offerId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Curriculum__c> getCurriculums(){
        try {
            // We are mocking the curriculums
            Set<String> curriculumIds = new Set<String>();
            return RecruitmentFacade.getCurriculum(curriculumIds);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static RecruitmentAssistant getLLMAnalysis(String requiredCapacities, Curriculum__c curriculum){
        try {
            // This would be better placed in a Service class rather than in the Controller, but keeping as is for simplicity
            LLMDTO.Message systemMessage = new LLMDTO.Message();
            systemMessage.content = 'Eres un asistente que ayuda al departamento de RRHH a identificar y valorar curriculums de candidatos ' + 
            'a ofertas de empleo, el representante de RRHH te dará la descripción del Curriculum y además te dirá que Capacidades necesita' + 
            ' que encuentres en el Curriculum. Tu valoración será si el candidato es válido o no. Devuelve tu resultado en formato JSON ' + 
            'incluyendo 2 apartados, uno con tu valoración y con key \'description\' y otro que sea un Boolean de si ha pasado la ' + 
            'valoración con key \'result\'. Asegurate de devolver tu resultado unicamente en JSON.';
            systemMessage.role = 'system';
            
            LLMDTO.Message trainingUserMessage1 = new LLMDTO.Message();
            trainingUserMessage1.content = 'Capacidades: ```Identifica si el candidato tiene experiencia con herramientas software de telecomunicaciones y si ' +
            'tiene experiencia con Python.```. Curriculum:```Desarrollador de Python, con experiencia trabajando con herramientas de configuración de redes móviles 5G```.';
            trainingUserMessage1.role = 'user';
            LLMDTO.Message trainingAssistantMessage1 = new LLMDTO.Message();
            trainingAssistantMessage1.content = '{"description": "El candidato cumple con las capacidades al tener experiencia como desarrollador de Python y ' + 
            'haber trabajado con redes 5G lo cual se considera experiencia con software de telecomunicaciones.", "result": true}';
            trainingAssistantMessage1.role = 'assistant';

            LLMDTO.Message trainingUserMessage2 = new LLMDTO.Message();
            trainingUserMessage2.content = 'Capacidades: ```Identifica si el candidato tiene experiencia habiendo trabajado dando soporte a usuarios y si ' +
            'tiene experiencia con Javascript.```. Curriculum:```Desarrollador React con experiencia diseñando y creando páginas web dinámicas y siempre' + 
            ' poniendo en primer lugar la experiencia de usuario```.';
            trainingUserMessage2.role = 'user';
            LLMDTO.Message trainingAssistantMessage2 = new LLMDTO.Message();
            trainingAssistantMessage2.content = '{"description": "El candidato cumple con experiencia en Javascript al haber trabajado con el framework de Javascript React, ' + 
            'pero no especifica si tiene experiencia trabajando dando soporte a usuarios.", "result": false}';
            trainingAssistantMessage2.role = 'assistant';

            LLMDTO.Message userMessage = new LLMDTO.Message();
            userMessage.content = String.format('Capacidades: ```{0}```. Curriculum:```{1}```.', 
                new List<String>{requiredCapacities, transformCurriculumToText(curriculum)});
            userMessage.role = 'user';

            List<LLMDTO.Message> chatMessages = new List<LLMDTO.Message>{
                systemMessage, 
                trainingUserMessage1,
                trainingAssistantMessage1,
                trainingUserMessage2,
                trainingAssistantMessage2,
                userMessage
            };
            LLMDTO.Message chatCompletion = LLMFacade.getChatCompletion(chatMessages);
            return transformChatCompletionToRecruitmentAssistant(curriculum.Id, chatCompletion);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static String transformCurriculumToText(Curriculum__c curriculum) {
        String curriculumText = 'Descripción: ' + curriculum.CVText__c + '\n';

        curriculumText += 'Experiencia: ';
        List<String> experienceList = new List<String>();
        for (Experience__c experience : curriculum.Experiences__r) {
            experienceList.add(experience.Company__c + ' - ' + experience.Job__c + ' - ' + experience.Description__c);
        }
        curriculumText += String.join(experienceList, ', ') + '\n';

        curriculumText += 'Educación: ';
        List<String> educationsList = new List<String>();
        for (Education__c education : curriculum.Educations__r) {
            educationsList.add(education.Course_Name__c);
        }
        curriculumText += String.join(educationsList, ', ') + '\n';
        
        curriculumText += 'Idiomas: ';
        List<String> languagesList = new List<String>();
        for (Skill_Language__c language : curriculum.Skill_Language__r) {
            languagesList.add(language.Language__c);
        }
        curriculumText += String.join(languagesList, ', ') + '\n';

        curriculumText += 'Habilidades: ';
        List<String> expertisesList = new List<String>();
        for (Skill_Expertise__c expertise : curriculum.Skill_Expertises__r) {
            expertisesList.add(expertise.Skill__c);
        }
        curriculumText += String.join(expertisesList, ', ') + '\n';

        return curriculumText;
    }

    public static RecruitmentAssistant transformChatCompletionToRecruitmentAssistant(Id curriculumId, LLMDTO.Message chatCompletion) {
        String jsonResult = chatCompletion.content;
        Map<String, Object> deserializedResult = (Map<String, Object>) JSON.deserializeUntyped(jsonResult);
        RecruitmentAssistant recruitmentAssistant = new RecruitmentAssistant();
        recruitmentAssistant.curriculumId = curriculumId;
        recruitmentAssistant.description = (String) deserializedResult.get('description');
        recruitmentAssistant.result = (Boolean) deserializedResult.get('result');
        return recruitmentAssistant;
    }
}