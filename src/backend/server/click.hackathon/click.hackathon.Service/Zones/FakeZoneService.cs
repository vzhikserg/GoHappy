using System;

namespace click.hackathon.Service.Zones
{
    public class FakeZoneService : IZoneService
    {
        private readonly Random _random = new Random();

        public ZoneResponse GetZone(decimal latitude, decimal langitude)
        {
            if (_random.NextDouble() > 0.98)    
                return new ZoneResponse() {HasError = true, Error = 1};

            if (DateTime.Now.Minute%2 == 0)
            {
                return new ZoneResponse() { Number = 34555, Name = "Klagenfurt" };
            }
            else
            {
                return new ZoneResponse() { Number = 36751, Name = "Villach" };
            }
        }
    }
}