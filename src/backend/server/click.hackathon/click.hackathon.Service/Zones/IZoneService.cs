namespace click.hackathon.Service.Zones
{
    public interface IZoneService
    {
        ZoneResponse GetZone(decimal latitude, decimal langitude);
    }
}