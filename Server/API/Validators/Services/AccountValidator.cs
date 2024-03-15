using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;

namespace API;

public class AccountValidator(
    UserManager<AppUser> userManager
) : IAccountValidator
{
    private readonly UserManager<AppUser> _userManager = userManager;
    public async Task<ValidatorResult> RegisterUser(RegisterDto registerDto)
    {
        ValidatorResult validatorResult = new();
        if (registerDto == null)
        {
            validatorResult.IsValidate = false;
            validatorResult.Message = "Please provide valid information.";
            return validatorResult;
        }

        if (registerDto.Username.IsNullOrEmpty() || registerDto.Username!.Length < 4)
        {
            validatorResult.IsValidate = false;
            validatorResult.Message = "Username need to have at least 4 characters.";
            return validatorResult;
        }

        if (registerDto.Password.IsNullOrEmpty() || registerDto.Password!.Length < 8)
        {
            validatorResult.IsValidate = false;
            validatorResult.Message = "Password need to have at least 8 characters.";
            return validatorResult;
        }

        if (!string.Equals(registerDto.Password, registerDto.RepeatPassword))
        {
            validatorResult.IsValidate = false;
            validatorResult.Message = "Passwords are not the same.";
            return validatorResult;
        }

        if (registerDto.Email.IsNullOrEmpty() || !registerDto.Email!.Contains('@'))
        {
            validatorResult.IsValidate = false;
            validatorResult.Message = "Please enter valid email address.";
            return validatorResult;
        }

        var user = await _userManager.FindByNameAsync(registerDto.Username.ToLower());
        if (user != null)
        {
            validatorResult.IsValidate = false;
            validatorResult.Message = "Username is taken.";
            return validatorResult;
        }

        validatorResult.IsValidate = true;
        validatorResult.Message = "Valid";
        return validatorResult;
    }
}
