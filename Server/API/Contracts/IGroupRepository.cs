namespace API;

public interface IGroupRepository
{
    void AddGroup(Group group);
    void AddParticipant(UserGroup userGroup);
    Task<bool> SaveAllAsync();
}
