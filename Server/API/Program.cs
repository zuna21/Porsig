using System.Text;
using API;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);
builder.Services.AddDbContext<DataContext>(opt =>
{
    opt.UseNpgsql(
        builder.Configuration.GetConnectionString("PorsigDatabase")
    );
});

builder.Services.AddHttpContextAccessor();

builder.Services.AddScoped<DataContext>();
builder.Services.AddIdentity<AppUser, IdentityRole<int>>()
        .AddEntityFrameworkStores<DataContext>()
        .AddDefaultTokenProviders();

builder.Services.AddScoped<IAccountRepository, AccountRepository>();
builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<IGroupRepository, GroupRepository>();
builder.Services.AddScoped<IMessageRepository, MessageRepository>();

builder.Services.AddScoped<IGlobals, Globals>();
builder.Services.AddScoped<ITokenService, TokenService>();

builder.Services.AddScoped<IAccountValidator, AccountValidator>();
builder.Services.AddScoped<IGroupValidator, GroupValidator>();
builder.Services.AddScoped<IMessageValidator, MessageValidator>();

builder.Services.AddAuthentication(options => {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;})
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(
                        Encoding.UTF8.GetBytes(builder.Configuration["TokenString"])
                    ),
            ValidateIssuer = false,
            ValidateAudience = false
        };
    });

var app = builder.Build();


// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseAuthorization();

app.MapControllers();

app.Run();
