namespace API;

public class Message
{
    public int Id { get; set; }
    public int SenderId { get; set; }
    public int RecipientId { get; set; }
    public int GroupId { get; set; }
    public string Content { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;


    // Navigation properties
    public AppUser Sender { get; set; }
    public AppUser Recipient { get; set; }
    public Group Group { get; set; }
}
