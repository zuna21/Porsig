using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;

namespace API;

public class ChatHub(
    IConfiguration configuration
) : Hub
{
    private readonly IConfiguration _configuration = configuration;

    public async Task JoinGroup(string groupName)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, groupName);
    }

    public async Task LeaveGroup(string groupName)
    {
        await Groups.RemoveFromGroupAsync(Context.ConnectionId, groupName);
    }

    public async void SendMessage(string groupName, string message)
    {
        MessageDto messageDto = new()
        {
            Id = -1,
            Content = message,
            CreatedAt = DateTime.UtcNow,
            IsMine = false
        };
        await Clients.OthersInGroup(groupName).SendAsync("ReceiveMessage", messageDto);
    }
}
