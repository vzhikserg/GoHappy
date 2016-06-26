using click.hackathon.Domain.Entity;

namespace click.hackathon.Service.WorkContexts
{
    public class FakeWorkContext : IWorkContext
    {
        public User CurrentUser { get { return CreateUser(); } }

        private User CreateUser()
        {
            var user = new User();
            var trip = new Trip();
            
            user.Trips.Add(trip);

            var track = new Track();
            trip.Tracks.Add(track);

            return user;
        }
    }
}