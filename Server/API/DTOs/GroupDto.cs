namespace API;

public class GroupDto
{
    public int Id { get; set; }
    public string Name { get; set; }
}

public class CreateGroupDto
{
    public string Name { get; set; }
    public ICollection<int> ParticipantsId { get; set; }
}