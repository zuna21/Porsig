
using Microsoft.EntityFrameworkCore;

namespace API;

public class UserRepository(
    DataContext dataContext
) : IUserRepository
{
    private readonly DataContext _context = dataContext;

    public async Task<AppUser> GetUserByUsername(string username)
    {
        return await _context.Users.FirstOrDefaultAsync(x => string.Equals(x.UserName, username.ToLower()));
    }

    public async Task<ICollection<AppUser>> GetUsersById(ICollection<int> ids)
    {
        return await _context.Users
            .Where(x => ids.Contains(x.Id))
            .ToListAsync();
    }

    public async Task<ICollection<UserDto>> GetUsers(int currentUserId, string username)
    {
        return await _context.Users
            .Where(x => x.Id != currentUserId && x.UserName.ToLower().Contains(username.ToLower()))
            .Select(x => new UserDto
            {
                Id = x.Id,
                Username = x.UserName
            })
            .ToListAsync();
    }
}
