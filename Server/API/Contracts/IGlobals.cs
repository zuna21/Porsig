namespace API;

public interface IGlobals
{
    Task<AppUser> GetCurrentUser();
}
