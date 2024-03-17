using Microsoft.AspNetCore.SignalR;

namespace API;

public class ChatHub : Hub
{
    public override Task OnConnectedAsync()
    {
        Console.WriteLine("**********");
        Console.WriteLine(Context);
        return base.OnConnectedAsync();
    }
}
