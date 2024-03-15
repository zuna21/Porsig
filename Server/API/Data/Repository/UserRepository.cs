
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
}
