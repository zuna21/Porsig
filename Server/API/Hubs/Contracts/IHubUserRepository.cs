namespace API;

public interface IHubUserRepository
{
    AppUser GetUserByUsername(string username);
}
