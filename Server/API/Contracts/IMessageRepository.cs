namespace API;

public interface IMessageRepository
{
    void Add(Message message);
    Task<ICollection<MessageDto>> GetMessages(int groupId, int userId);
    Task<bool> SaveAllAsync();
}
