using System;
using System.Linq;
using System.Xml.Linq;
using click.hackathon.Domain.Entity;

namespace click.hackathon.Service.Import
{
    public class GpxImport : IGpxImport
    {
        public Track Import(string text)
        {
            var track = new Track();

            XDocument doc = XDocument.Parse(text);
            foreach (var point in doc.Descendants("rtept"))
            {
                XElement timeElement = point.Descendants("time").FirstOrDefault();
                if (point.Attribute("lat") == null || 
                    point.Attribute("lon") == null ||
                    timeElement == null )
                    continue;

                var trackPoint = new TrackPoint()
                {
                    Longitude = Convert.ToDecimal(point.Attribute("lon").Value) ,
                    Latitude = Convert.ToDecimal(point.Attribute("lat").Value),
                    Timestamp = Convert.ToInt64(timeElement.Value)
                };

                track.Points.Add(trackPoint);
            }

            return track;

            //string appDataPath = Server.MapPath("~/app_data");   
        }
    }
}