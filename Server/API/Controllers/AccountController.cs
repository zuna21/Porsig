using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace API;

public class AccountController(
    IAccountValidator accountValidator,
    ITokenService tokenService,
    UserManager<AppUser> userManager
) : BaseController
{
    private readonly IAccountValidator _accountValidator = accountValidator;
    private readonly UserManager<AppUser> _userManager = userManager;
    private readonly ITokenService _tokenService = tokenService;

    [HttpPost("register")]
    public async Task<ActionResult<AccountDto>> Register(RegisterDto registerDto)
    {
        ValidatorResult validatorResult = await _accountValidator.RegisterUser(registerDto);
        if (!validatorResult.IsValidate)
        {
            return BadRequest(validatorResult.Message);
        }

        AppUser user = new()
        {
            UserName = registerDto.Username!.ToLower(),
            Email = registerDto.Email
        };

        var result = await _userManager.CreateAsync(user, registerDto.Password!);
        if (!result.Succeeded)
        {
            return BadRequest("Failed to create an account.");
        }

        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.NameId, user.UserName),
        };

        return new AccountDto
        {
            Username = user.UserName,
            Token = _tokenService.GenerateAccessToken(user)
        };
    }

    [HttpPost("login")]
    public async Task<ActionResult<AccountDto>> Login(LoginDto loginDto)
    {
        ValidatorResult validatorResult = _accountValidator.LoginUser(loginDto);
        if (!validatorResult.IsValidate)
        {
            return BadRequest(validatorResult.Message);
        }

        var user = await _userManager.FindByNameAsync(loginDto.Username!.ToLower());
        if (user == null)
        {
            return Unauthorized("Invalid username or password.");
        }

        var isPasswordCorrect = await _userManager.CheckPasswordAsync(user, loginDto.Password!);
        if (!isPasswordCorrect)
        {
            return Unauthorized("Invalid username or password.");
        }

        List<Claim> claims = new()
        {
            new(JwtRegisteredClaimNames.NameId, user.UserName!)
        };

        return new AccountDto
        {
            Token = _tokenService.GenerateAccessToken(user),
            Username = user.UserName
        };
    }
}
