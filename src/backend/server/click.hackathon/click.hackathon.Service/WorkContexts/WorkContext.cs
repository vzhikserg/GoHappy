using click.hackathon.Domain.Entity;

namespace click.hackathon.Service.WorkContexts
{
    public class WorkContext : IWorkContext
    {
        public User CurrentUser { get; private set; }
    }
}