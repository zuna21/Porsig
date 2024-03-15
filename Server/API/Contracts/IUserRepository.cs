namespace API;

public interface IUserRepository
{
    Task<AppUser> GetUserByUsername(string username);
    Task<AppUser> GetUserById(int id);
}
