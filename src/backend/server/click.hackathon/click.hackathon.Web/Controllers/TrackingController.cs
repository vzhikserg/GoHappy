using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Runtime.Remoting.Services;
using System.Web.Http;
using click.hackathon.Service.Tracking;
using click.hackathon.Service.Users;
using click.hackathon.Service.Zones;
using click.hackathon.Web.Models;

namespace click.hackathon.Web.Controllers
{
    public class TrackingController : ApiController
    {
        #region Fields

        private readonly ITrackingService _trackingService;
        private readonly IZoneService _zoneService;

        #endregion

        #region Constructors

        public TrackingController(
            ITrackingService trackingService,
            IZoneService zoneService
            )
        {
            _trackingService = trackingService;
            _zoneService = zoneService;
        }

        #endregion

        /// <summary>
        /// Post location and other information for tracking a user.
        /// </summary>
        /// <param name="tracking">Contains location and other information to track a user.</param>
        /// <returns>Relevant information about the user route.</returns>
        public TrackingResponseModel Post([FromBody]TrackingModel tracking)
        {
            /*
            var epoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
            return epoch.AddSeconds(unixTime);
             */

            var response = new TrackingResponseModel(); 

            ZoneResponse zoneResponse = _zoneService.GetZone(11, 11);
            if (zoneResponse.HasError)
            {
                response.HasError = true;
                response.Error = zoneResponse.Error;
            }
            else
            {
                response.Zones.Add(new ZoneModel() {Name = zoneResponse.Name, Number = zoneResponse.Number});
            }
            return response;
        }
    }

    /*
     //// GET api/values
        //public IEnumerable<string> Get()
        //{
        //    return new string[] { "value1", "value2" };
        //}

        //// GET api/values/5
        //public string Get(int id)
        //{
        //    return "value";
        //}

        // POST api/Tracking
        
     * 
     * //// PUT api/values/5
        //public void Put(int id, [FromBody]string value)
        //{
        //}

        //// DELETE api/values/5
        //public void Delete(int id)
        //{
        //} 
     */
}
