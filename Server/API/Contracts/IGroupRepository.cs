namespace API;

public interface IGroupRepository
{
    void AddGroup(Group group);
    void AddGroupParticipants(ICollection<UserGroup> userGroups);
    Task<Group> GetGroup(int id);
    Task<bool> SaveAllAsync();
}
