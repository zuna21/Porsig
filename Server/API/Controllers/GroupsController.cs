using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API;

[Authorize]
public class GroupsController(
    IUserRepository userRepository,
    IGroupRepository groupRepository,
    IGroupValidator groupValidator,
    IGlobals globals
) : BaseController
{
    private readonly IUserRepository _userRepository = userRepository;
    private readonly IGroupRepository _groupRepository = groupRepository;
    private readonly IGroupValidator _groupValidator = groupValidator;
    private readonly IGlobals _globals = globals;


    [HttpPost("create")]
    public void Create(CreateGroupDto createGroupDto)
    {
        var user = _globals.GetCurrentUsername();
        Console.WriteLine(user);
        
    }

}
