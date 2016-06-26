using System.Collections.Generic;

namespace click.hackathon.Domain.Entity
{
    public class Trip
    {
        private ICollection<Zone> _zones;

        private ICollection<Track> _tracks;

        /// <summary>
        /// The zones which the user passed through.
        /// </summary>
        public virtual ICollection<Zone> Zones
        {
            get { return _zones ?? (_zones = new List<Zone>()); }
            protected set { _zones = value; }
        }

        /// <summary>
        /// The tracks of the user.
        /// </summary>
        public virtual ICollection<Track> Tracks
        {
            get { return _tracks ?? (_tracks = new List<Track>()); }
            protected set { _tracks = value; }
        }
    }
}