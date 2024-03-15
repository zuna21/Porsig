namespace API;

public interface IAccountValidator
{
    Task<ValidatorResult> RegisterUser(RegisterDto registerDto);
}
