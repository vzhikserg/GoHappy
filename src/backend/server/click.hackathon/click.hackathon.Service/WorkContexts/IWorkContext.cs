using click.hackathon.Domain.Entity;

namespace click.hackathon.Service.WorkContexts
{
    public interface IWorkContext
    {
        User CurrentUser { get; }
    }
}