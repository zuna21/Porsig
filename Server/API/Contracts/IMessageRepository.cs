namespace API;

public interface IMessageRepository
{
    void Add(Message message);
    Task<bool> SaveAllAsync();
}
