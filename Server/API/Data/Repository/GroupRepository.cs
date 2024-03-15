
namespace API;

public class GroupRepository(
    DataContext dataContext
) : IGroupRepository
{
    private readonly DataContext _context = dataContext;

    public void AddGroup(Group group)
    {
        _context.Groups.Add(group);
    }

    public async Task<bool> SaveAllAsync()
    {
        return await _context.SaveChangesAsync() > 0;
    }
}
