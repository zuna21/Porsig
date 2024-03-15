using System.Security.Claims;

namespace API;

public interface ITokenService
{
    string GenerateAccessToken(IEnumerable<Claim> claims);
}
