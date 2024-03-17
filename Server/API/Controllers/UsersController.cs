using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API;

[Authorize]
public class UsersController(
    IGlobals globals,
    IUserRepository userRepository
) : BaseController
{
    private readonly IGlobals _globals = globals;
    private readonly IUserRepository _userRepository = userRepository;


    [HttpGet("get-users")]
    public async Task<ActionResult<ICollection<UserDto>>> GetUsers([FromQuery] string username)
    {
        var user = await _globals.GetCurrentUser();
        if (user == null)
        {
            return BadRequest("Failed to get user.");
        }
        ICollection<UserDto> users = [];
        try
        {
            users = await _userRepository.GetUsers(user.Id, username);
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
        }

        return Ok(users);
    }
}
