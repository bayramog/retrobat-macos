using System;
using System.Runtime.InteropServices;

namespace RetroBuild;

internal class Installer
{
    public static void CreateInstaller(BuilderOptions options)
    {
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            Logger.Log("[INFO] Windows installer creation not yet implemented in .NET 8 version.");
            Logger.Log("[INFO] This would create a Windows .exe installer from the zip file.");
        }
        else
        {
            Logger.Log("[INFO] Installer creation is only available on Windows platform.");
            Logger.Log("[INFO] For macOS, use the ZIP archive or create a .dmg manually.");
        }
    }
}
