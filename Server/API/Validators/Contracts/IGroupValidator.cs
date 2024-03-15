namespace API;

public interface IGroupValidator
{
    ValidatorResult CreateGroup(CreateGroupDto createGroupDto);
}
