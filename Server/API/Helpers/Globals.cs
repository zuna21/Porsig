namespace API;

public class Globals(
    IHttpContextAccessor httpContextAccessor
) : IGlobals
{
    private readonly IHttpContextAccessor _httpAccessor = httpContextAccessor;

    public string GetCurrentUsername()
    {
        return _httpAccessor.HttpContext.User.Identity.Name;
    }
}
