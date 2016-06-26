namespace click.hackathon.Domain.Entity
{
    public class Vehicle : BaseEntity
    {
        public VehicleType Type { set; get; }

        public VehicleProvider Provider { set; get; }
    }
}