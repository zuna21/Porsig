namespace API;

public interface IGroupRepository
{
    void AddGroup(Group group);
    void AddGroupParticipants(ICollection<UserGroup> userGroups);
    Task<Group> GetGroup(int id);
    Task<ICollection<GroupDto>> GetUserGroups(int userId);
    Task<bool> SaveAllAsync();
}
