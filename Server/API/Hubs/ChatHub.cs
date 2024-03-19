using Microsoft.AspNetCore.SignalR;

namespace API;

public class ChatHub(
    IHubUserRepository hubUserRepository,
    IHubGroupRepository hubGroupRepository,
    IMessageValidator messageValidator,
    IHubMessageRepository hubMessageRepository
) : Hub
{
    private readonly IHubUserRepository _hubUserRepository = hubUserRepository;
    private readonly IHubGroupRepository _hubGroupRepository = hubGroupRepository;
    private readonly IMessageValidator _messageValidator = messageValidator;
    private readonly IHubMessageRepository _hubMessageRepository = hubMessageRepository;

    public override Task OnConnectedAsync()
    {
        var something = Context;
        return base.OnConnectedAsync();
    }
    public async Task JoinGroup(string groupName)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, groupName);
    }

    public async Task LeaveGroup(string groupName)
    {
        await Groups.RemoveFromGroupAsync(Context.ConnectionId, groupName);
    }

    public async Task SendMessage(int groupId, CreateMessageDto createMessageDto)
    {
        ValidatorResult validatorResult = _messageValidator.Create(createMessageDto);
        if (!validatorResult.IsValidate)
        {
            await Clients.Caller.SendAsync(validatorResult.Message);
            return;
        }
        var username = Context.UserIdentifier;
        var user = _hubUserRepository.GetUserByUsername(username);
        if (user == null)
        {
            await Clients.Caller.SendAsync("Failed to find user");
            return;
        }
        var group = _hubGroupRepository.GetGroup(groupId);
        if (group == null)
        {
            await Clients.Caller.SendAsync("Failed to get group.");
            return;
        }

        Message message = new()
        {
            SenderId = user.Id,
            Sender = user,
            Content = createMessageDto.Content,
            GroupId = group.Id,
            Group = group
        };

        _hubMessageRepository.AddMessage(message);
        _hubMessageRepository.SaveAllSync();
        
        await Clients.OthersInGroup(group.UniqueName).SendAsync("ReceiveMessage", new MessageDto
        {
            Content = message.Content,
            CreatedAt = message.CreatedAt,
            Id = message.Id,
            IsMine = false
        });
        
        await Clients.Caller.SendAsync("ReceiveMyMessage", new MessageDto
        {
            Content = message.Content,
            CreatedAt = message.CreatedAt,
            Id = message.Id,
            IsMine = true
        });

    }

}
