using System.Data.Entity.ModelConfiguration;

namespace click.hackathon.Data.Mapping
{
    public class ClickEntityTypeConfiguration<T> : EntityTypeConfiguration<T> where T : class
    {
        protected ClickEntityTypeConfiguration()
        {
            PostInitialize();
        }

        /// <summary>
        /// Developers can override this method in custom partial classes
        /// in order to add some custom initialization code to constructors
        /// </summary>
        protected virtual void PostInitialize()
        {

        }
    }
}