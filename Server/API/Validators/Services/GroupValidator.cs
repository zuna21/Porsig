using Microsoft.IdentityModel.Tokens;

namespace API;

public class GroupValidator : IGroupValidator
{
    public ValidatorResult CreateGroup(CreateGroupDto createGroupDto)
    {
        ValidatorResult validatorResult = new();
        if (createGroupDto == null)
        {
            validatorResult.IsValidate = false;
            validatorResult.Message = "Please enter valid information.";
            return validatorResult;
        }

        if (createGroupDto.Name.IsNullOrEmpty() || createGroupDto.Name!.Length < 3)
        {
            validatorResult.IsValidate = false;
            validatorResult.Message = "Group name need to have at least 3 letters";
            return validatorResult;
        }

        validatorResult.IsValidate = true;
        validatorResult.Message  = "Valid.";
        return validatorResult;
    }
}
