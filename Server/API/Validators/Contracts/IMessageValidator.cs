namespace API;

public interface IMessageValidator
{
    ValidatorResult Create(CreateMessageDto createMessageDto);
}
