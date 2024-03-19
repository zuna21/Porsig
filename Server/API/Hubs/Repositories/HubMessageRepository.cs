namespace API;

public class HubMessageRepository(
    DataContext dataContext
) : IHubMessageRepository
{
    private readonly DataContext _context = dataContext;


    public void AddMessage(Message message)
    {
        _context.Messages.Add(message);
    }

    public void SaveAllSync()
    {
        _context.SaveChanges();
    }
}
