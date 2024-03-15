namespace API;

public class GroupValidator : IGroupValidator
{
    public ValidatorResult Create(CreateGroupDto createGroupDto)
    {
        ValidatorResult validatorResult = new();
        if (string.IsNullOrEmpty(createGroupDto.Name) || createGroupDto.Name.Length < 3)
        {
            validatorResult.IsValidate = false;
            validatorResult.Message = "Chat name need to have at least 3 letters.";
            return validatorResult;
        }

        validatorResult.IsValidate = true;
        validatorResult.Message = "Valid.";
        return validatorResult;
    }
}
