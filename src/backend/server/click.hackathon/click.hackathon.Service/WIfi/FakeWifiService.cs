using click.hackathon.Domain.Entity;

namespace click.hackathon.Service.WIfi
{
    public class FakeWifiService : IWifiService
    {
        public WifiAccessPoint FindWifi(string id)
        {
            return null;
        }
    }
}