using click.hackathon.Domain.Entity;
namespace click.hackathon.Service.WIfi
{
    public interface IWifiService
    {
        WifiAccessPoint FindWifi(string id);
    }
}