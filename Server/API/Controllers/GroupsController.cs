using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class GroupsController(
    IGroupValidator groupValidator,
    IUserRepository userRepository
) : ControllerBase
{
    private readonly IGroupValidator _groupValidator = groupValidator;
    private readonly IUserRepository _userRepository = userRepository;
    
    [HttpPost("create")]
    public async Task<ActionResult<GroupDto>> Create(CreateGroupDto createGroupDto)
    {
        string username = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

        ValidatorResult validatorResult = _groupValidator.CreateGroup(createGroupDto);
        if (!validatorResult.IsValidate)
        {
            return BadRequest(validatorResult.Message);
        }
        AppUser user = null;
        try
        {
            user = await _userRepository.GetUserByUsername(username);
        } catch(Exception ex)
        {
            Console.Write(ex.ToString());
            return BadRequest("Something went wrong.");
        }

        if (user == null)
        {
            return BadRequest("Username not found");
        }

    }
}
