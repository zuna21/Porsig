﻿using Microsoft.AspNetCore.Identity;

namespace API;

public class AccountValidator(
    UserManager<AppUser> userManager
) : IAccountValidator
{
    private readonly UserManager<AppUser> _userManager = userManager;

    public ValidatorResult LoginUser(LoginDto loginDto)
    {
        ValidatorResult validatorResult = new();
        if (loginDto == null)
        {
            validatorResult.IsValidate = false;
            validatorResult.Message = "Please enter valid information.";
            return validatorResult;
        }

        if (string.IsNullOrEmpty(loginDto.Username))
        {
            validatorResult.IsValidate = false;
            validatorResult.Message = "Please enter valid username.";
            return validatorResult;
        }

        if (string.IsNullOrEmpty(loginDto.Password))
        {
            validatorResult.IsValidate = false;
            validatorResult.Message = "Please enter valid password.";
            return validatorResult;
        }

        validatorResult.IsValidate = true;
        validatorResult.Message = "Valid.";
        return validatorResult;
    }

    public async Task<ValidatorResult> RegisterUser(RegisterDto registerDto)
    {
        ValidatorResult validatorResult = new();
        if (registerDto == null)
        {
            validatorResult.IsValidate = false;
            validatorResult.Message = "Please provide valid information.";
            return validatorResult;
        }

        if (string.IsNullOrEmpty(registerDto.Username) || registerDto.Username!.Length < 4)
        {
            validatorResult.IsValidate = false;
            validatorResult.Message = "Username need to have at least 4 characters.";
            return validatorResult;
        }

        if (string.IsNullOrEmpty(registerDto.Password) || registerDto.Password!.Length < 8)
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

        if (string.IsNullOrEmpty(registerDto.Email) || !registerDto.Email!.Contains('@'))
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
