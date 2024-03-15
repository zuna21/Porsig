namespace API;

public interface IGroupRepository
{
    void AddGroup(Group group);
    Task<bool> SaveAllAsync();
}
