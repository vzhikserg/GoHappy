using System.Collections.Generic;

namespace click.hackathon.Domain.Entity
{
    public class Track : BaseEntity 
    {
        private ICollection<TrackPoint> _points;
        
        public virtual ICollection<TrackPoint> Points
        {
            get { return _points ?? (_points = new List<TrackPoint>()); }
            protected set { _points = value; }
        }
    }
}