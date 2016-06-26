using click.hackathon.Domain.Entity;

namespace click.hackathon.Service.Import
{
    public interface IGpxImport
    {
        Track Import(string text);
    }
}