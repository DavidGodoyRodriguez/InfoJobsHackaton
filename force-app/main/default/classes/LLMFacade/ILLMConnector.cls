public interface ILLMConnector {
    LLMDTO.Message getChatCompletion(List<LLMDTO.Message> messages);
}