namespace API;

public class MessageDto
{
    public int Id { get; set; }
    public string Content { get; set; }
    public bool IsMine { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class CreateMessageDto
{
    public string Content { get; set; }
}
