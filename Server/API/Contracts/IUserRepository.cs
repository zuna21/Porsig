namespace API;

public interface IUserRepository
{
    Task<AppUser> GetUserByUsername(string username);
    Task<ICollection<AppUser>> GetUsersById(ICollection<int> ids);
    Task<ICollection<UserDto>> GetUsers(int currentUserId, string username);
}
