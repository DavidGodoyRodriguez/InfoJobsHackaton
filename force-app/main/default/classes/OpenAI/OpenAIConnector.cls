public with sharing class OpenAIConnector implements ILLMConnector {
    private static ILLMConnector openAIConnectorInstance;

    public class OpenAIConnectorException extends Exception {}

    private static final String BASIC_ENDPOINT = 'https://api.openai.com/';
    private static final String VERSION_API = 'v1/';
    private static final String CHAT_COMPLETIONS = 'chat/completions';

    private static final String CHAT_MODEL = 'gpt-3.5-turbo';

    public static ILLMConnector getInstance() {
        if (openAIConnectorInstance == null) {
            openAIConnectorInstance = new OpenAIConnector();
        }
        return openAIConnectorInstance;
    }

    public LLMDTO.Message getChatCompletion(List<LLMDTO.Message> messages) {
        HttpRequest httpRequest = getHttpRequest();
        httpRequest.setEndpoint(BASIC_ENDPOINT + VERSION_API + CHAT_COMPLETIONS);
        httpRequest.setMethod('POST');
        httpRequest.setBody(buildBodyChatMessages(messages));
        Http http = new Http();
        HTTPResponse httpResponse = http.send(httpRequest);
        validateHttpResponse(httpResponse);
        return trasformIntoLLMMessage(httpResponse.getBody());
    }

    private HttpRequest getHttpRequest() {
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setHeader('Authorization', getToken());
        return httpRequest;
    }

    private String getToken() {
        return Token__mdt.getInstance('OpenAI').Token__c;
    }

    private String buildBodyChatMessages(List<LLMDTO.Message> messages) {
        Map<String, Object> bodyMap = new Map<String, Object>();
        bodyMap.put('model', CHAT_MODEL);
        bodyMap.put('messages', messages);
        return JSON.serialize(bodyMap);
    }

    private void validateHttpResponse(HTTPResponse httpResponse) {
        if (httpResponse.getStatusCode() != 200) {
            throw new OpenAIConnectorException('OpenAI callout failed with code: ' + httpResponse.getStatusCode() + ', message: ' + httpResponse.getBody());
        }
    }

    /**
     * {
     *   "id": "chatcmpl-7IHbzNU1FG8yF6zEwn7re8zK8xrDE",
     *   "object": "chat.completion",
     *   "created": 1684591959,
     *   "model": "gpt-3.5-turbo-0301",
     *   "usage": {
     *       "prompt_tokens": 392,
     *       "completion_tokens": 31,
     *       "total_tokens": 423
     *   },
     *   "choices": [
     *       {
     *           "message": {
     *               "role": "assistant",
     *               "content": "{\n\"description\": \"El candidato tiene experiencia como desarrollador en Salesforce pero no se menciona experiencia en proyectos de Marketing\",\n\"result\": false\n}"
     *           },
     *           "finish_reason": "stop",
     *           "index": 0
     *       }
     *   ]
     * }
     */
    private LLMDTO.Message trasformIntoLLMMessage(String responseBody) {
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        List<Object> choices = (List<Object>) responseMap.get('choices');
        Map<String, Object> firstChoiceMap = (Map<String, Object>) choices.get(0);
        Map<String, Object> messageMap = (Map<String, Object>) firstChoiceMap.get('message');
        LLMDTO.Message message = new LLMDTO.Message();
        message.content = (String) messageMap.get('content');
        message.role = (String) messageMap.get('role');
        return message;
    }

}