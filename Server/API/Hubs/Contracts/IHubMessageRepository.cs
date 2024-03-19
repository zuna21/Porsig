namespace API;

public interface IHubMessageRepository
{
    void AddMessage(Message message);
    void SaveAllSync();
}
