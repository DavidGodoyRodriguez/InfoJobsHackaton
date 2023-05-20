public with sharing class LLMFacade {
 
    public static LLMDTO.Message getChatCompletion(List<LLMDTO.Message> messages) {
        ILLMConnector iLLMConnector = OpenAIConnector.getInstance();
        return iLLMConnector.getChatCompletion(messages);
    }

}