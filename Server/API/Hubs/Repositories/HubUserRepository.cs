namespace API;

public class HubUserRepository(
    DataContext dataContext
) : IHubUserRepository
{
    private readonly DataContext _context = dataContext;

    public AppUser GetUserByUsername(string username)
    {
        return _context.Users.FirstOrDefault(x => x.UserName == username.ToLower());
    }
}
