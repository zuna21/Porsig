using Microsoft.EntityFrameworkCore;

namespace API;

public class DataContext(
    IConfiguration configuration
) : DbContext
{
    private readonly IConfiguration _configuration = configuration;

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        base.OnConfiguring(optionsBuilder);
        optionsBuilder.UseNpgsql(_configuration.GetConnectionString("PorsigDatabase"));
    }

    public DbSet<AppUser> Users { get; set; }
}
