namespace click.hackathon.Domain.Entity
{
    public class TrackPoint
    {
        public decimal Latitude { set; get; }
        public decimal Longitude { set; get; }
        public decimal Heading { set; get; }
        public decimal Speed { set; get; }
        public long Timestamp { set; get; }

        public int X { set; get; }
        public int Y { set; get; }

        public WifiAccessPoint Wifi { set; get; }
    }
}