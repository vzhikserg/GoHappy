using System.Collections.Generic;

namespace click.hackathon.Domain.Entity
{
    public class User : BaseEntity
    {
        private ICollection<Trip> _trips;

        public virtual ICollection<Trip> Trips
        {
            get { return _trips ?? (_trips = new List<Trip>()); }
            protected set { _trips = value; }
        }
    }
}