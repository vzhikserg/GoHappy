namespace click.hackathon.Web.Models
{
    public class TrackingModel
    {
        public string UserToken { set; get; }
        public decimal Latitude { set; get; }
        public decimal Longitude { set; get; }
        public decimal Heading { set; get; }
        public decimal Speed { set; get; }
        public long Timestamp { set; get; }
        public string WifiId { set; get; }
        public int DemoId { set; get; }
        public int LastId { set; get; }
    }
}