using System.Security.Claims;

namespace API;

public interface ITokenService
{
    string GenerateAccessToken(AppUser user);
}
