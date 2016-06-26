namespace click.hackathon.Domain.Entity
{
    public class Zone : BaseEntity
    {
        public string Name { set; get; }
        public int Number { set; get; }    
        public int X { set; get; }
        public int Y { set; get; }
    }
}