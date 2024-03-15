namespace API;

public interface IGroupValidator
{
    ValidatorResult Create(CreateGroupDto createGroupDto);
}
