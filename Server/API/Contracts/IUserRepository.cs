namespace API;

public interface IUserRepository
{
    Task<AppUser> GetUserByUsername(string username);
}
