namespace API;

public class MessageValidator : IMessageValidator
{
    public ValidatorResult Create(CreateMessageDto createMessageDto)
    {
        ValidatorResult validatorResult = new();
        if (createMessageDto == null || string.IsNullOrEmpty(createMessageDto.Content))
        {
            validatorResult.IsValidate = false;
            validatorResult.Message = "Enter valid message";
            return validatorResult;
        }

        validatorResult.IsValidate = true;
        validatorResult.Message = "Valid.";
        return validatorResult;
    }
}
