namespace API;

public class Group
{
    public int Id { get; set; }
    public string Name { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;


    // Navigation properties
    public int AdminId { get; set; }
    public AppUser Admin { get; set; }
    public List<UserGroup> UserGroups { get; set; } = [];


}
