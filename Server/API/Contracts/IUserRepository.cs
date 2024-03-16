namespace API;

public interface IUserRepository
{
    Task<AppUser> GetUserByUsername(string username);
    Task<ICollection<AppUser>> GetUsersById(ICollection<int> ids);
}
