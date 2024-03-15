namespace API;

public interface IAccountRepository
{
    void AddUser(AppUser user);
    Task<bool> SaveAllAsync();
}
