using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace API;

[ApiController]
[Route("api/[controller]")]
public class AccountController(
    IAccountValidator accountValidator,
    ITokenService tokenService,
    UserManager<AppUser> userManager
) : ControllerBase
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
            Id = user.Id,
            Username = user.UserName,
            Token = _tokenService.GenerateAccessToken(claims)
        };
    }
}
