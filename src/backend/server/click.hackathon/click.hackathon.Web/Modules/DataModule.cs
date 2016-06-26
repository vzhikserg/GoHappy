using System.Web;
using Autofac;
using click.hackathon.Core.Fakes;
using click.hackathon.Core.Repository;
using click.hackathon.Data;
using click.hackathon.Mapping;
using click.hackathon.Service.Import;
using click.hackathon.Service.Tracking;
using click.hackathon.Service.Users;
using click.hackathon.Service.WIfi;
using click.hackathon.Service.Zones;

namespace click.hackathon.Web.Modules
{
    public class DataModule : Module
    {
        #region Methords

        protected override void Load(ContainerBuilder builder)
        {
            //HTTP context and other related stuff
            builder.Register(c =>
                //register FakeHttpContext when HttpContext is not available
                HttpContext.Current != null ?
                (new HttpContextWrapper(HttpContext.Current) as HttpContextBase) :
                (new FakeHttpContext("~/") as HttpContextBase))
                .As<HttpContextBase>()
                .InstancePerLifetimeScope();
            builder.Register(c => c.Resolve<HttpContextBase>().Request)
                .As<HttpRequestBase>()
                .InstancePerLifetimeScope();
            builder.Register(c => c.Resolve<HttpContextBase>().Response)
                .As<HttpResponseBase>()
                .InstancePerLifetimeScope();
            builder.Register(c => c.Resolve<HttpContextBase>().Server)
                .As<HttpServerUtilityBase>()
                .InstancePerLifetimeScope();
            builder.Register(c => c.Resolve<HttpContextBase>().Session)
                .As<HttpSessionStateBase>()
                .InstancePerLifetimeScope();


            builder.RegisterType<TrackingService>().As<ITrackingService>().InstancePerLifetimeScope();
            builder.RegisterType<FakeZoneService>().As<IZoneService>().InstancePerLifetimeScope();

            builder.RegisterType<FakeWifiService>().As<IWifiService>().InstancePerLifetimeScope();

            builder.RegisterType<GpxImport>().As<IGpxImport>().InstancePerLifetimeScope();

            builder.Register<IDbContext>(c => new ClickObjectContext("name=DefaultConnection")).InstancePerLifetimeScope();
            builder.RegisterGeneric(typeof(EfRepository<>)).As(typeof(IRepository<>)).InstancePerLifetimeScope();

            base.Load(builder);
        }

        #endregion
    
    }
}