
namespace API;

public class MessageRepository(
    DataContext dataContext
) : IMessageRepository
{
    private readonly DataContext _context = dataContext;
    public void Add(Message message)
    {
        _context.Messages.Add(message);
    }

    public async Task<bool> SaveAllAsync()
    {
        return await _context.SaveChangesAsync() > 0;
    }
}
