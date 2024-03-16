

using Microsoft.EntityFrameworkCore;

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

    public void AddGroupParticipants(ICollection<UserGroup> userGroups)
    {
        _context.UserGroups.AddRange(userGroups);
    }

    public async Task<Group> GetGroup(int id)
    {
        return await _context.Groups.FindAsync(id);
    }

    public async Task<ICollection<GroupDto>> GetUserGroups(int userId)
    {
        return await _context.UserGroups
            .Where(x => x.UserId == userId)
            .OrderByDescending(x => x.Group.CreatedAt)
            .Select(x => new GroupDto
            {
                Id = x.GroupId,
                Name = x.Group.Name
            })
            .ToListAsync();
    }

    public async Task<bool> SaveAllAsync()
    {
        return await _context.SaveChangesAsync() > 0;
    }
}
