using Microsoft.AspNetCore.Identity;

namespace API;

public class AppUser: IdentityUser<int>
{
    public List<UserGroup> UserGroups { get; set; } = [];
}
