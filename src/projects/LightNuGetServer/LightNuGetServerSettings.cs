namespace LightNuGetServer
{
    public class LightNuGetServerSettings
    {
        public LightNuGetServerRepositorySettings[] Repositories { get; set; } = new LightNuGetServerRepositorySettings[0];
    }

    public class LightNuGetServerRepositorySettings
    {
        public string PackagesDirPath { get; set; } = "Packages";
        public LightNuGetFeedSettings[] Feeds { get; set; } = new LightNuGetFeedSettings[0];
    }
}