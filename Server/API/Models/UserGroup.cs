namespace API;

public class UserGroup
{
    public int Id { get; set; }
    public int GroupId { get; set; }
    public int UserId { get; set; }


    // Navigation properties
    public AppUser User { get; set; }
    public Group Group { get; set; }
}
