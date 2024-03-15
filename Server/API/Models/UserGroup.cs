namespace API;

public class UserGroup
{
    public int Id { get; set; }

    // Navigation properties
    public int UserId { get; set; }
    public int GroupId { get; set; }

    public AppUser User { get; set; }
    public Group Group { get; set; }
}
