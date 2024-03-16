using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API;

[Authorize]
public class MessagesController(
    IMessageValidator messageValidator,
    IGlobals globals,
    IMessageRepository messageRepository,
    IGroupRepository groupRepository
) : BaseController
{
    private readonly IMessageValidator _messageValidator = messageValidator;
    private readonly IGlobals _globals = globals;
    private readonly IMessageRepository _messageRepository = messageRepository;
    private readonly IGroupRepository _groupRepository = groupRepository;

    [HttpPost("create/{groupId}")]
    public async Task<ActionResult<MessageDto>> Create(int groupId, CreateMessageDto createMessageDto)
    {
        ValidatorResult validatorResult = _messageValidator.Create(createMessageDto);
        if (!validatorResult.IsValidate)
        {
            return BadRequest(validatorResult.Message);
        }

        var user = await _globals.GetCurrentUser();
        if (user == null)
        {
            return BadRequest("Failed to get user");
        }

        Group group = null;
        try
        {
            group = await _groupRepository.GetGroup(groupId);
        }
        catch(Exception ex)
        {
            Console.WriteLine(ex.ToString());
        }

        if (group == null)
        {
            return BadRequest("Failed to get group.");
        }

        Message message = new()
        {
            SenderId = user.Id,
            Sender = user,
            GroupId = group.Id,
            Group = group,
            Content = createMessageDto.Content
        };

        _messageRepository.Add(message);
        if (!await _messageRepository.SaveAllAsync())
        {
            return BadRequest("Failed to create message.");
        }

        return new MessageDto
        {
            Id = message.Id,
            Content = message.Content,
            CreatedAt = message.CreatedAt,
            IsMine = true,
        };
    }

    [HttpGet("get-messages/{groupId}")]
    public async Task<ActionResult<MessageDto>> GetMessages(int groupId)
    {
        var user = await _globals.GetCurrentUser();
        if (user == null)
        {
            return BadRequest("Failed to get user.");
        }

        ICollection<MessageDto> messages = [];
        try
        {
            messages = await _messageRepository.GetMessages(groupId, user.Id);
        }
        catch(Exception ex)
        {
            Console.WriteLine(ex.ToString());
        }

        return Ok(messages);
    }

}
