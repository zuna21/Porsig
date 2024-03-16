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
    public async Task<ActionResult<GroupDto>> Create(CreateGroupDto createGroupDto)
    {
        ValidatorResult validatorResult = _groupValidator.Create(createGroupDto);
        if (!validatorResult.IsValidate)
        {
            return BadRequest(validatorResult.Message);
        }

        var user = await _globals.GetCurrentUser();
        if (user == null)
        {
            return BadRequest("Something went wrong.");
        }

        AppUser participant = null;
        try
        {
            participant = await _userRepository.GetUserById(createGroupDto.ParticipantId);
        } 
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
        }

        if (participant == null)
        {
            return BadRequest("Failed to get participant.");
        }


        Group group = new()
        {
            Name = createGroupDto.Name,
            AdminId = user.Id,
            Admin = user
        };

        _groupRepository.AddGroup(group);
        if (!await _groupRepository.SaveAllAsync()) 
        {
            return BadRequest("Failed to create group");
        }

        List<UserGroup> participants =
        [
            new()
            {
                GroupId = group.Id,
                Group = group,
                UserId = user.Id,
                User = user
            },
            new()
            {
                UserId = participant.Id,
                User = participant,
                GroupId = group.Id,
                Group = group
            }
        ];

        _groupRepository.AddGroupParticipants(participants);
        if (!await _groupRepository.SaveAllAsync())
        {
            return BadRequest("Failed to add group participants");
        }

        return new GroupDto
        {
            Id = group.Id,
            Name = group.Name
        };
    }

    [HttpGet("get-groups")]
    public async Task<ActionResult<ICollection<GroupDto>>> GetGroups()
    {
        var user = await _globals.GetCurrentUser();
        if (user == null)
        {
            return BadRequest("Failed to get user.");
        }

        ICollection<GroupDto> groups = [];
        try
        {
            groups = await _groupRepository.GetUserGroups(user.Id);
        }
        catch(Exception ex)
        {
            Console.WriteLine(ex.ToString());
        }

        return Ok(groups);
    }

}
