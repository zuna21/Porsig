using Microsoft.AspNetCore.SignalR;

namespace API;

public class ChatHub : Hub
{
    public override Task OnConnectedAsync()
    {
        Console.WriteLine("**********");
        var something = Context;
        Console.WriteLine(something);
        return base.OnConnectedAsync();
    }
}
