namespace API;

public interface IAccountValidator
{
    ValidatorResult RegisterUser(RegisterDto registerDto);
}
