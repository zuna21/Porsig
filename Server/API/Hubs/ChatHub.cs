using Microsoft.AspNetCore.SignalR;

namespace API;

public class ChatHub : Hub
{

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
