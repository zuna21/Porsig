using System.Security.Claims;

namespace API;

public class Globals(
    IHttpContextAccessor httpContextAccessor,
    IUserRepository userRepository
) : IGlobals
{
    private readonly IHttpContextAccessor _httpAccessor = httpContextAccessor;
    private readonly IUserRepository _userRepository = userRepository;
    

    public async Task<AppUser> GetCurrentUser()
    {
        var username = _httpAccessor.HttpContext.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        AppUser user = null;
        try
        {
            user = await _userRepository.GetUserByUsername(username);
        }
        catch(Exception ex)
        {
            Console.WriteLine(ex.ToString());
        }
        return user;
    }
}
