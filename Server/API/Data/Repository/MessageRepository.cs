

using Microsoft.EntityFrameworkCore;

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

    public async Task<ICollection<MessageDto>> GetMessages(int groupId, int userId)
    {
        return await _context.Messages
            .Where(x => x.GroupId == groupId)
            .Select(x => new MessageDto
            {
                Id = x.Id,
                Content = x.Content,
                CreatedAt = x.CreatedAt,
                IsMine = x.SenderId == userId
            })
            .ToListAsync();
    }

    public async Task<bool> SaveAllAsync()
    {
        return await _context.SaveChangesAsync() > 0;
    }
}
