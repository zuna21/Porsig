namespace API;

public class HubGroupRepository(
    DataContext dataContext
) : IHubGroupRepository
{
    private readonly DataContext _context = dataContext;

    public Group GetGroup(int id)
    {
        return _context.Groups.Find(id);
    }
}
