
namespace API;

public class AccountRepository(
    DataContext dataContext
) : IAccountRepository
{
    private readonly DataContext _context = dataContext;

    public void AddUser(AppUser user)
    {
        _context.Users.Add(user);
    }

    public async Task<bool> SaveAllAsync()
    {
        return await _context.SaveChangesAsync() > 0;
    }
}
