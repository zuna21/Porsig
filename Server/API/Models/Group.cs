namespace API;

public class Group
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string UniqueName { get; set; } = Guid.NewGuid().ToString();
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;


    // Navigation properties
    public int AdminId { get; set; }
    public AppUser Admin { get; set; }
    public List<UserGroup> UserGroups { get; set; } = [];
    public List<Message> Messages { get; set; } = [];

}
