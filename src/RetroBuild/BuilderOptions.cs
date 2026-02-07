using System.Runtime.InteropServices;

namespace RetroBuild;

public class BuilderOptions
{
    public string RetrobatVersion { get; set; } = string.Empty;
    public string RetroarchVersion { get; set; } = string.Empty;
    public string Branch { get; set; } = string.Empty;
    public string Architecture { get; set; } = string.Empty;
    public bool GetBatgui { get; set; }
    public bool GetBatoceraPorts { get; set; }
    public bool GetBios { get; set; }
    public bool GetDecorations { get; set; }
    public bool GetDefaultTheme { get; set; }
    public bool GetEmulationstation { get; set; }
    public bool GetEmulators { get; set; }
    public bool GetLrcores { get; set; }
    public bool GetRetroarch { get; set; }
    public bool GetRetrobatBinaries { get; set; }
    public bool GetSystem { get; set; }
    public bool GetWiimotegun { get; set; }
    public string SevenZipPath { get; set; } = string.Empty;
    public string WgetPath { get; set; } = string.Empty;
    public string CurlPath { get; set; } = string.Empty;
    public string RetrobatFTPPath { get; set; } = string.Empty;
    public string RetrobatBinariesBaseUrl { get; set; } = string.Empty;
    public string EmulationstationUrl { get; set; } = string.Empty;
    public string EmulatorlauncherUrl { get; set; } = string.Empty;
    public string BiosGitUrl { get; set; } = string.Empty;
    public string ThemePath { get; set; } = string.Empty;
    public string DecorationsPath { get; set; } = string.Empty;
    public string SystemPath { get; set; } = string.Empty;
    public string RetroArchURL { get; set; } = string.Empty;
    public string WiimoteGunURL { get; set; } = string.Empty;
    public string BatGUIURL { get; set; } = string.Empty;

    public static BuilderOptions LoadBuilderOptions(string iniFile)
    {
        IniParser iniParser = new IniParser(iniFile);
        BuilderOptions builderOptions = new BuilderOptions();
        string section = "BuilderOptions";
        
        builderOptions.RetrobatVersion = iniParser.Get(section, "retrobat_version");
        builderOptions.RetroarchVersion = iniParser.Get(section, "retroarch_version");
        builderOptions.Branch = iniParser.Get(section, "branch", "stable");
        builderOptions.Architecture = iniParser.Get(section, "architecture", GetDefaultArchitecture());
        builderOptions.GetBatgui = iniParser.Get(section, "get_batgui") == "1";
        builderOptions.GetBatoceraPorts = iniParser.Get(section, "get_batocera_ports") == "1";
        builderOptions.GetBios = iniParser.Get(section, "get_bios") == "1";
        builderOptions.GetDecorations = iniParser.Get(section, "get_decorations") == "1";
        builderOptions.GetDefaultTheme = iniParser.Get(section, "get_default_theme") == "1";
        builderOptions.GetEmulationstation = iniParser.Get(section, "get_emulationstation") == "1";
        builderOptions.GetEmulators = iniParser.Get(section, "get_emulators") == "1";
        builderOptions.GetLrcores = iniParser.Get(section, "get_lrcores") == "1";
        builderOptions.GetRetroarch = iniParser.Get(section, "get_retroarch") == "1";
        builderOptions.GetRetrobatBinaries = iniParser.Get(section, "get_retrobat_binaries") == "1";
        builderOptions.GetSystem = iniParser.Get(section, "get_system") == "1";
        builderOptions.GetWiimotegun = iniParser.Get(section, "get_wiimotegun") == "1";
        
        // Platform-specific tool paths
        string sevenZipPathConfig = iniParser.Get(section, "7za_path", GetDefaultSevenZipPath());
        string wgetPathConfig = iniParser.Get(section, "wget_path", GetDefaultWgetPath());
        string curlPathConfig = iniParser.Get(section, "curl_path", GetDefaultCurlPath());
        
        // For system tools (just a command name without path separator), don't combine with exe dir
        builderOptions.SevenZipPath = IsSystemTool(sevenZipPathConfig) 
            ? sevenZipPathConfig 
            : Methods.PathCombineExeDir(sevenZipPathConfig);
        builderOptions.WgetPath = IsSystemTool(wgetPathConfig) 
            ? wgetPathConfig 
            : Methods.PathCombineExeDir(wgetPathConfig);
        builderOptions.CurlPath = IsSystemTool(curlPathConfig) 
            ? curlPathConfig 
            : Methods.PathCombineExeDir(curlPathConfig);
        
        builderOptions.RetrobatFTPPath = iniParser.Get(section, "retrobat_ftp", "http://www.retrobat.ovh/repo/");
        builderOptions.RetrobatBinariesBaseUrl = iniParser.Get(section, "retrobat_binaries_url", "http://www.retrobat.ovh/repo/tools/");
        builderOptions.EmulationstationUrl = iniParser.Get(section, "emulationstation_url", 
            "https://github.com/RetroBat-Official/emulationstation/releases/download/continuous-master/EmulationStation-Win32.zip");
        builderOptions.EmulatorlauncherUrl = iniParser.Get(section, "emulatorlauncher_url", 
            "https://github.com/RetroBat-Official/emulatorlauncher/releases/download/continuous/batocera-ports.zip");
        builderOptions.BiosGitUrl = iniParser.Get(section, "bios_git_url", "https://github.com/RetroBat-Official/retrobat-bios");
        builderOptions.ThemePath = iniParser.Get(section, "theme_path", "https://github.com/fabricecaruso/es-theme-carbon");
        builderOptions.DecorationsPath = iniParser.Get(section, "decorations_path", "https://github.com/RetroBat-Official/retrobat-bezels");
        builderOptions.SystemPath = iniParser.Get(section, "retrobat_system_path", "https://github.com/RetroBat-Official/retrobat-setup/tree/master/system");
        builderOptions.RetroArchURL = iniParser.Get(section, "retroarch_url", "https://buildbot.libretro.com");
        builderOptions.WiimoteGunURL = iniParser.Get(section, "wiimotegun_url", "https://github.com/fabricecaruso/WiimoteGun/releases/download/v1.1/WiimoteGun.zip");
        builderOptions.BatGUIURL = iniParser.Get(section, "batgui_url", "https://github.com/xReppa/rb_gui/releases/download/2.0.56.0/BatGui2056.zip");
        
        return builderOptions;
    }

    private static string GetDefaultArchitecture()
    {
        if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
        {
            return RuntimeInformation.ProcessArchitecture == System.Runtime.InteropServices.Architecture.Arm64 ? "osx-arm64" : "osx-x64";
        }
        else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            return "win64";
        }
        else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
        {
            return "linux-x64";
        }
        return "unknown";
    }

    private static string GetDefaultSevenZipPath()
    {
        if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX) || RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
        {
            return "7z"; // Assumes 7z is in PATH (installed via brew/apt)
        }
        return Path.Combine("system", "tools", "7za.exe");
    }

    private static string GetDefaultWgetPath()
    {
        if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX) || RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
        {
            return "wget"; // Assumes wget is in PATH
        }
        return Path.Combine("system", "tools", "wget.exe");
    }

    private static string GetDefaultCurlPath()
    {
        if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX) || RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
        {
            return "curl"; // curl is built-in on macOS/Linux
        }
        return Path.Combine("system", "tools", "curl.exe");
    }

    private static bool IsSystemTool(string toolPath)
    {
        // System tools are just command names without any path separators
        // e.g., "7z", "wget", "curl" instead of "system/tools/7za.exe"
        return !toolPath.Contains(Path.DirectorySeparatorChar) 
            && !toolPath.Contains(Path.AltDirectorySeparatorChar)
            && !toolPath.Contains('\\')
            && !toolPath.Contains('/');
    }

    public static bool IsComponentEnabled(string key, BuilderOptions options)
    {
        return key switch
        {
            "bios" => options.GetBios,
            "decorations" => options.GetDecorations,
            "default_theme" => options.GetDefaultTheme,
            "emulationstation" => options.GetEmulationstation,
            "retrobat_binaries" => options.GetRetrobatBinaries,
            "batocera_ports" => options.GetBatoceraPorts,
            "retroarch" => options.GetRetroarch,
            "wiimotegun" => options.GetWiimotegun,
            _ => false,
        };
    }
}
