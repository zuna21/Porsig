namespace API;

public interface IAccountValidator
{
    Task<ValidatorResult> RegisterUser(RegisterDto registerDto);
    ValidatorResult LoginUser(LoginDto loginDto);
}
