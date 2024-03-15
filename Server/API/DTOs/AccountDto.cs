namespace API;

public class AccountDto
{
    public int Id { get; set; }
    public string? Username { get; set; }
    public string? Token { get; set; }
}

public class RegisterDto 
{
    public string? Username { get; set; }
    public string? Email { get; set; }
    public string? Password { get; set; }
    public string? RepeatPassword { get; set; }
}