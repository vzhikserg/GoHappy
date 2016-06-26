using System.Collections.Generic;

namespace click.hackathon.Web.Models
{
    public class TrackingResponseModel
    {
        public TrackingResponseModel()
        {
            Zones = new List<ZoneModel>();
        }

        public IList<ZoneModel> Zones { set; get; }

        public bool HasError { set; get; }

        public int Error { set; get; }

        public bool HasNotification { set; get; }

        public int Notification { set; get; }

        public int LastId { set; get; }
    }
}