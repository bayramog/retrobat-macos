using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Threading;
using System.Xml;
using ICSharpCode.SharpZipLib.Zip;
using ICSharpCode.SharpZipLib.Zip.Compression.Streams;

namespace RetroBuild;

internal class Program
{
    private static void Main()
    {
        Logger.LogStart(AppDomain.CurrentDomain.FriendlyName);
        string iniFile = "build.ini";
        BuilderOptions? builderOptions = null;
        
        try
        {
            Logger.LogInfo("Reading build.ini file for options.");
            builderOptions = BuilderOptions.LoadBuilderOptions(iniFile);
            PropertyInfo[] properties = builderOptions.GetType().GetProperties();
            foreach (PropertyInfo obj in properties)
            {
                string name = obj.Name;
                object? value = obj.GetValue(builderOptions, null);
                Console.WriteLine("{0} = {1}", name, value);
                Logger.LogInfo(name + " = " + value);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error loading config: " + ex.Message);
            Logger.Log("[ERROR] Error loading config file: " + ex.Message);
            return;
        }

        // Check for required tools (platform-specific)
        if (!CheckRequiredTools(builderOptions))
        {
            Console.WriteLine("\nPress any key to exit...");
            Console.ReadKey();
            return;
        }

        Console.Clear();
        Console.WriteLine("RetroBat Builder Menu");
        Console.WriteLine("---------------------------------------------------");
        Console.WriteLine("This executable is made to help download all the required software for RetroBat.");
        Console.WriteLine("Use the 'build.ini' file to set options for building.");
        Console.WriteLine("Option 1 must always be done first, as it will download all the required files.");
        
        // Platform information
        string platform = GetPlatformString();
        Console.WriteLine($"Platform: {platform}");
        Console.WriteLine("---------------------------------------------------\n");
        Console.WriteLine("=====================\n");
        Console.WriteLine("1 - Download and configure");
        Console.WriteLine("2 - Create archive");
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            Console.WriteLine("3 - Create installer (need archive created first)");
        }
        Console.WriteLine("Q - Quit\n");
        Console.Write("Please type your choice here: ");
        
        string? choice = Console.ReadLine()?.Trim().ToUpper();
        switch (choice)
        {
            case "1":
                Logger.Log("Option selected: Download and configure.");
                Logger.Log("Starting log.\n");
                Console.WriteLine("=====================");
                GetPackages(builderOptions);
                Console.WriteLine("=====================");
                CreateTree(builderOptions);
                Console.WriteLine("=====================");
                CreateEmulatorFolders(builderOptions);
                Console.WriteLine("=====================");
                CreateSystemFolders(builderOptions);
                Console.WriteLine("=====================");
                GetLibretroCores(builderOptions);
                Console.WriteLine("=====================");
                GetEmulators(builderOptions);
                Console.WriteLine("=====================");
                CopyESFiles(builderOptions);
                Console.WriteLine("=====================");
                CreateVersionFile(builderOptions);
                Console.WriteLine("=====================");
                CopyTemplateFiles(builderOptions);
                Console.WriteLine("=====================");
                SetVersion(builderOptions);
                break;
            case "2":
                Logger.Log("Option selected: Create archive.");
                Logger.Log("Starting log.\n");
                Console.WriteLine("=====================");
                CreateZipFolderSharpZip(builderOptions);
                break;
            case "3":
                if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
                {
                    Logger.Log("Option selected: Create installer.");
                    Logger.Log("Starting log.\n");
                    Console.WriteLine("=====================");
                    Installer.CreateInstaller(builderOptions);
                }
                else
                {
                    Console.WriteLine("Installer creation is only available on Windows.");
                }
                break;
            case "Q":
                Console.WriteLine("Exiting...");
                return;
        }
        
        Logger.Log("[INFO] Build finished successfully.\n");
        Console.WriteLine("Press any key to exit...");
        Console.ReadKey();
    }

    private static bool CheckRequiredTools(BuilderOptions options)
    {
        bool allToolsPresent = true;
        
        // Check 7-Zip
        if (!IsToolAvailable(options.SevenZipPath))
        {
            Logger.Log($"[ERROR] 7-Zip not found at: {options.SevenZipPath}");
            Console.WriteLine($"ERROR: 7-Zip not found at: {options.SevenZipPath}");
            
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                Console.WriteLine("Install with: brew install p7zip");
            }
            allToolsPresent = false;
        }
        
        // Check wget
        if (!IsToolAvailable(options.WgetPath))
        {
            Logger.Log($"[ERROR] wget not found at: {options.WgetPath}");
            Console.WriteLine($"ERROR: wget not found at: {options.WgetPath}");
            
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                Console.WriteLine("Install with: brew install wget");
            }
            allToolsPresent = false;
        }
        
        // Check curl
        if (!IsToolAvailable(options.CurlPath))
        {
            Logger.Log($"[ERROR] curl not found at: {options.CurlPath}");
            Console.WriteLine($"ERROR: curl not found at: {options.CurlPath}");
            
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                Console.WriteLine("curl should be built-in on macOS");
            }
            allToolsPresent = false;
        }
        
        return allToolsPresent;
    }

    private static bool IsToolAvailable(string toolPath)
    {
        // Check if it's an absolute path to a file
        if (Path.IsPathFullyQualified(toolPath) && File.Exists(toolPath))
        {
            return true;
        }
        
        // Check if it's a command in PATH
        try
        {
            var psi = new System.Diagnostics.ProcessStartInfo
            {
                FileName = RuntimeInformation.IsOSPlatform(OSPlatform.Windows) ? "where" : "which",
                Arguments = Path.GetFileName(toolPath),
                RedirectStandardOutput = true,
                UseShellExecute = false,
                CreateNoWindow = true
            };
            
            using var process = System.Diagnostics.Process.Start(psi);
            if (process != null)
            {
                process.WaitForExit();
                return process.ExitCode == 0;
            }
        }
        catch
        {
            // If which/where fails, try to see if the file exists
        }
        
        return File.Exists(toolPath);
    }

    private static string GetPlatformString()
    {
        if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
        {
            return $"macOS ({RuntimeInformation.ProcessArchitecture})";
        }
        else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            return $"Windows ({RuntimeInformation.ProcessArchitecture})";
        }
        else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
        {
            return $"Linux ({RuntimeInformation.ProcessArchitecture})";
        }
        return "Unknown";
    }

    private static void GetPackages(BuilderOptions options)
    {
        string baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
        string buildPath = Path.Combine(baseDirectory, "build");
        
        if (Directory.Exists(buildPath))
        {
            if (Directory.GetFiles(buildPath).Length != 0 || Directory.GetDirectories(buildPath).Length != 0)
            {
                Logger.Log("[WARNING] Build path was not empty, deleting content.");
                try
                {
                    Directory.Delete(buildPath, recursive: true);
                }
                catch (Exception ex)
                {
                    Logger.Log("[ERROR] Failed to delete content of build path: " + ex.Message);
                    Console.ReadKey();
                    return;
                }
                try
                {
                    Directory.CreateDirectory(buildPath);
                }
                catch (Exception ex2)
                {
                    Logger.Log("[ERROR] Failed to create build directory: " + ex2.Message);
                    Console.ReadKey();
                    return;
                }
            }
        }
        else
        {
            try
            {
                Directory.CreateDirectory(buildPath);
            }
            catch (Exception ex3)
            {
                Logger.Log("[ERROR] Failed to create build directory: " + ex3.Message);
                Console.ReadKey();
                return;
            }
        }
        
        Logger.LogLabel("get_packages");
        Console.WriteLine(":: GETTING REQUIRED PACKAGES...");
        
        if (Methods.RunProcess("git", "submodule update --init", baseDirectory, out var _) != 0)
        {
            Logger.Log("[WARNING] Failed to initialize git submodules");
        }
        
        if (options.GetRetrobatBinaries)
        {
            string[] txtFiles = Directory.GetFiles(baseDirectory, "*.txt");
            foreach (string txtFile in txtFiles)
            {
                string destFileName = Path.Combine(buildPath, Path.GetFileName(txtFile));
                File.Copy(txtFile, destFileName, overwrite: true);
            }
            
            string branch = options.Branch;
            string archiveName = "retrobat_binaries.7z";
            Methods.DownloadAndExtractArchive_WebClient(options.RetrobatBinariesBaseUrl + branch + "/" + archiveName, buildPath, options);
            Logger.LogInfo("retrobat binaries copied to " + buildPath);
        }
        
        if (options.GetEmulationstation)
        {
            string emulationstationUrl = options.EmulationstationUrl;
            string esPath = Path.Combine(buildPath, "emulationstation");
            Methods.DownloadAndExtractArchive_Wget(emulationstationUrl, esPath, options);
            Logger.LogInfo("Emulationstation copied to " + esPath);
        }
        
        if (options.GetBatoceraPorts)
        {
            string emulatorlauncherUrl = options.EmulatorlauncherUrl;
            string esPath = Path.Combine(buildPath, "emulationstation");
            Methods.DownloadAndExtractArchive_Wget(emulatorlauncherUrl, esPath, options);
            Logger.LogInfo("Emulatorlauncher copied to " + esPath);
        }
        
        if (options.GetBios)
        {
            string biosPath = Path.Combine(buildPath, "bios");
            Methods.CloneOrUpdateGitRepo(options.BiosGitUrl, biosPath);
            Methods.DeleteGitFiles(biosPath);
        }
        
        if (options.GetDefaultTheme)
        {
            string themePath = Path.Combine(buildPath, "emulationstation", ".emulationstation", "themes", "es-theme-carbon");
            Methods.CloneOrUpdateGitRepo(options.ThemePath, themePath);
            Methods.DeleteGitFiles(themePath);
        }
        
        if (options.GetDecorations)
        {
            string decorationsPath = Path.Combine(buildPath, "system", "decorations");
            Methods.CloneOrUpdateGitRepo(options.DecorationsPath, decorationsPath);
            Methods.DeleteGitFiles(decorationsPath);
        }
        
        if (options.GetSystem)
        {
            string systemSource = Path.Combine(baseDirectory, "system");
            if (Directory.Exists(systemSource))
            {
                Logger.LogInfo("Copying system folder.");
                string systemDest = Path.Combine(buildPath, "system");
                
                string[] directories = Directory.GetDirectories(systemSource, "*", SearchOption.AllDirectories);
                foreach (string dir in directories)
                {
                    if (!dir.EndsWith(".git", StringComparison.OrdinalIgnoreCase) && 
                        !dir.EndsWith("decorations", StringComparison.OrdinalIgnoreCase))
                    {
                        string destDir = dir.Replace(systemSource, systemDest);
                        if (!Directory.Exists(destDir))
                        {
                            Directory.CreateDirectory(destDir);
                        }
                    }
                }
                
                string[] files = Directory.GetFiles(systemSource, "*.*", SearchOption.AllDirectories);
                foreach (string file in files)
                {
                    if (!file.Contains(Path.Combine(".git", "")) && 
                        !file.EndsWith(".git", StringComparison.OrdinalIgnoreCase) && 
                        !file.Contains(Path.Combine("system", "decorations")))
                    {
                        string destFile = file.Replace(systemSource, systemDest);
                        File.Copy(file, destFile, overwrite: true);
                    }
                }
                Logger.LogInfo("System folder copied.");
            }
            else
            {
                string systemPath = Path.Combine(buildPath, "system");
                Methods.CloneOrUpdateGitRepo(options.SystemPath, systemPath);
                Methods.DeleteGitFiles(systemPath);
            }
        }
        
        if (options.GetRetroarch)
        {
            string retroarchVersion = options.RetroarchVersion;
            string retroarchPath = Path.Combine(buildPath, "emulators", "retroarch");
            
            // Platform-specific RetroArch download
            string retroarchUrl;
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                // Apple Silicon (arm64) support - macOS port is ARM64 only
                retroarchUrl = options.RetroArchURL + "/stable/" + retroarchVersion + "/apple/osx/arm64/RetroArch.dmg";
            }
            else
            {
                retroarchUrl = options.RetroArchURL + "/stable/" + retroarchVersion + "/windows/x86_64/RetroArch.7z";
            }
            
            Methods.DownloadAndExtractArchive_Wget(retroarchUrl, retroarchPath, options);
            
            // Platform-specific subdirectory handling
            string? retroarchSubDir = null;
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                // On macOS, look for RetroArch.app or similar
                retroarchSubDir = Directory.GetDirectories(retroarchPath)
                    .FirstOrDefault(d => Path.GetFileName(d).Contains("RetroArch"));
            }
            else
            {
                // On Windows, look for RetroArch-Win64
                retroarchSubDir = Directory.GetDirectories(retroarchPath)
                    .FirstOrDefault(d => Path.GetFileName(d).Contains("RetroArch-Win64"));
            }
            
            if (retroarchSubDir != null && Directory.Exists(retroarchSubDir))
            {
                string[] files = Directory.GetFiles(retroarchSubDir, "*", SearchOption.AllDirectories);
                foreach (string file in files)
                {
                    string relativePath = file.Substring(retroarchSubDir.Length + 1);
                    string destFile = Path.Combine(retroarchPath, relativePath);
                    Directory.CreateDirectory(Path.GetDirectoryName(destFile)!);
                    File.Copy(file, destFile, overwrite: true);
                }
                Console.WriteLine("All files copied successfully.");
                
                try
                {
                    Directory.Delete(retroarchSubDir, recursive: true);
                    Logger.LogInfo("RetroArch successfully downloaded to " + retroarchPath);
                }
                catch
                {
                    Logger.LogInfo("[ERROR] Not able to delete RetroArch temp folder: " + retroarchSubDir);
                }
            }
            else
            {
                // No nested subdirectory found - files may be directly extracted
                Logger.LogInfo("RetroArch extracted to " + retroarchPath + " (no nested subdirectory found)");
            }
        }
        
        if (options.GetWiimotegun)
        {
            string wiimoteGunURL = options.WiimoteGunURL;
            string esPath = Path.Combine(buildPath, "emulationstation");
            Methods.DownloadAndExtractArchive_Wget(wiimoteGunURL, esPath, options);
            Logger.LogInfo("WiimoteGun copied to " + esPath);
        }
        
        if (options.GetBatgui)
        {
            string batGUIURL = options.BatGUIURL;
            Methods.DownloadAndExtractArchive_Wget(batGUIURL, buildPath, options);
            Logger.LogInfo("BatGui copied to " + buildPath);
        }
    }

    private static void CreateTree(BuilderOptions options)
    {
        string buildPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "build");
        if (!Directory.Exists(buildPath))
        {
            try
            {
                Directory.CreateDirectory(buildPath);
            }
            catch (Exception ex)
            {
                Logger.Log("[ERROR] Failed to create build directory: " + ex.Message);
                Console.ReadKey();
                return;
            }
        }
        
        Logger.LogLabel("build_tree");
        Console.WriteLine(":: BUILDING RETROBAT TREE...");
        
        string treeListPath = Path.Combine(buildPath, "system", "configgen", "retrobat_tree.lst");
        if (!File.Exists(treeListPath))
        {
            Logger.LogInfo("Missing 'retrobat_tree.lst' file.");
            return;
        }
        
        string[] lines = File.ReadAllLines(treeListPath);
        foreach (string line in lines)
        {
            if (string.IsNullOrWhiteSpace(line))
            {
                continue;
            }
            
            string normalizedPath = Methods.NormalizePath(line.Trim());
            string dirPath = Path.Combine(buildPath, normalizedPath);
            
            if (Directory.Exists(dirPath))
            {
                Logger.LogInfo("Directory already exists: " + dirPath);
                continue;
            }
            
            try
            {
                Directory.CreateDirectory(dirPath);
                Logger.LogInfo("Created: " + dirPath);
            }
            catch (Exception ex)
            {
                Logger.LogInfo("Failed to create " + dirPath + ": " + ex.Message);
            }
        }
        Logger.LogInfo("All folders processed.");
    }

    private static void CreateEmulatorFolders(BuilderOptions options)
    {
        string buildPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "build");
        if (!Directory.Exists(buildPath))
        {
            try
            {
                Directory.CreateDirectory(buildPath);
            }
            catch (Exception ex)
            {
                Logger.Log("[ERROR] Failed to create build directory: " + ex.Message);
                Console.ReadKey();
                return;
            }
        }
        
        Logger.LogLabel("emulator_folders");
        Console.WriteLine(":: CREATING EMULATOR FOLDERS...");
        
        string emuListPath = Path.Combine(buildPath, "system", "configgen", "emulators_names.lst");
        if (!File.Exists(emuListPath))
        {
            Logger.LogInfo("Missing 'emulators_names.lst' file.");
            return;
        }
        
        string[] lines = File.ReadAllLines(emuListPath);
        foreach (string line in lines)
        {
            if (string.IsNullOrWhiteSpace(line))
            {
                continue;
            }
            
            string emulatorPath = Path.Combine(buildPath, "emulators", line.Trim());
            if (Directory.Exists(emulatorPath))
            {
                Logger.LogInfo("Directory already exists: " + emulatorPath);
                continue;
            }
            
            try
            {
                Directory.CreateDirectory(emulatorPath);
                Logger.LogInfo("Created: " + emulatorPath);
            }
            catch (Exception ex)
            {
                Logger.LogInfo("Failed to create " + emulatorPath + ": " + ex.Message);
            }
        }
        Logger.LogInfo("All emulator folders processed.");
    }

    private static void CreateSystemFolders(BuilderOptions options)
    {
        string buildPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "build");
        if (!Directory.Exists(buildPath))
        {
            try
            {
                Directory.CreateDirectory(buildPath);
            }
            catch (Exception ex)
            {
                Logger.Log("[ERROR] Failed to create build directory: " + ex.Message);
                Console.ReadKey();
                return;
            }
        }
        
        Logger.LogLabel("system_folders");
        Console.WriteLine(":: CREATING ROMS AND SAVE FOLDERS...");
        
        string systemsListPath = Path.Combine(buildPath, "system", "configgen", "systems_names.lst");
        if (!File.Exists(systemsListPath))
        {
            Logger.LogInfo("Missing 'systems_names.lst' file.");
            return;
        }
        
        string[] lines = File.ReadAllLines(systemsListPath);
        foreach (string line in lines)
        {
            if (string.IsNullOrWhiteSpace(line))
            {
                continue;
            }
            
            string systemName = line.Trim();
            string romsPath = Path.Combine(buildPath, "roms", systemName);
            
            if (!Directory.Exists(romsPath))
            {
                try
                {
                    Directory.CreateDirectory(romsPath);
                    Logger.LogInfo("Created: " + romsPath);
                }
                catch (Exception ex)
                {
                    Logger.LogInfo("Failed to create " + romsPath + ": " + ex.Message);
                }
            }
            else
            {
                Logger.LogInfo("Directory already exists: " + romsPath);
            }
            
            string savesPath = Path.Combine(buildPath, "saves", systemName);
            if (!Directory.Exists(savesPath))
            {
                try
                {
                    Directory.CreateDirectory(savesPath);
                    Logger.LogInfo("Created: " + savesPath);
                }
                catch (Exception ex)
                {
                    Logger.LogInfo("Failed to create " + savesPath + ": " + ex.Message);
                }
            }
            else
            {
                Logger.LogInfo("Directory already exists: " + savesPath);
            }
        }
        Logger.LogInfo("All roms folders processed.");
    }

    private static void CopyESFiles(BuilderOptions options)
    {
        List<string> configFiles = new List<string> 
        { 
            "es_input.cfg", 
            "es_padtokey.cfg", 
            "es_settings.cfg", 
            "es_systems.cfg" 
        };
        
        string buildPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "build");
        if (!Directory.Exists(buildPath))
        {
            try
            {
                Directory.CreateDirectory(buildPath);
            }
            catch (Exception ex)
            {
                Logger.Log("[ERROR] Failed to create build directory: " + ex.Message);
                Console.ReadKey();
                return;
            }
        }
        
        Logger.LogLabel("emulationstation_config");
        Console.WriteLine(":: COPY EMULATIONSTATION FILES...");
        
        string templatesPath = Path.Combine(buildPath, "system", "templates", "emulationstation");
        string esConfigPath = Path.Combine(buildPath, "emulationstation", ".emulationstation");
        
        foreach (string configFile in configFiles)
        {
            string sourceFile = Path.Combine(templatesPath, configFile);
            string destFile = Path.Combine(esConfigPath, configFile);
            
            if (!File.Exists(sourceFile))
            {
                Logger.LogInfo("Source file not found: " + sourceFile);
                continue;
            }
            
            try
            {
                File.Copy(sourceFile, destFile, overwrite: true);
                Logger.LogInfo("Copied " + configFile + " to " + esConfigPath);
            }
            catch (Exception ex)
            {
                Logger.LogInfo("Failed to copy " + configFile + ": " + ex.Message);
            }
        }
        
        string resourcesPath = Path.Combine(buildPath, "system", "resources", "emulationstation");
        string noticeFile = Path.Combine(resourcesPath, "notice.pdf");
        
        if (File.Exists(noticeFile))
        {
            string destNotice = Path.Combine(esConfigPath, "notice.pdf");
            try
            {
                File.Copy(noticeFile, destNotice, overwrite: true);
                Logger.LogInfo("Copied " + noticeFile + " to " + esConfigPath);
            }
            catch (Exception ex)
            {
                Logger.LogInfo("Failed to copy notice file: " + ex.Message);
                return;
            }
        }
        else
        {
            Logger.LogInfo("Source file not found: " + noticeFile);
        }
        
        string musicSourcePath = Path.Combine(resourcesPath, "music");
        string videoSourcePath = Path.Combine(resourcesPath, "video");
        string musicDestPath = Path.Combine(esConfigPath, "music");
        string videoDestPath = Path.Combine(esConfigPath, "video");
        
        if (!Directory.Exists(musicDestPath))
        {
            try
            {
                Directory.CreateDirectory(musicDestPath);
                Logger.LogInfo("Created directory: " + musicDestPath);
            }
            catch (Exception ex)
            {
                Logger.LogInfo("Failed to create music directory: " + ex.Message);
                return;
            }
        }
        
        if (!Directory.Exists(videoDestPath))
        {
            try
            {
                Directory.CreateDirectory(videoDestPath);
                Logger.LogInfo("Created directory: " + videoDestPath);
            }
            catch (Exception ex)
            {
                Logger.LogInfo("Failed to create video directory: " + ex.Message);
                return;
            }
        }
        
        if (Directory.Exists(musicSourcePath))
        {
            string[] musicFiles = Directory.GetFiles(musicSourcePath, "*.*");
            foreach (string musicFile in musicFiles)
            {
                string destFile = Path.Combine(musicDestPath, Path.GetFileName(musicFile));
                try
                {
                    File.Copy(musicFile, destFile, overwrite: true);
                    Logger.LogInfo("Copied music file: " + destFile);
                }
                catch (Exception ex)
                {
                    Logger.LogInfo("Failed to copy music file " + musicFile + " to " + destFile + ": " + ex.Message);
                    return;
                }
            }
        }
        
        if (Directory.Exists(videoSourcePath))
        {
            string[] videoFiles = Directory.GetFiles(videoSourcePath, "*.*");
            foreach (string videoFile in videoFiles)
            {
                string destFile = Path.Combine(videoDestPath, Path.GetFileName(videoFile));
                try
                {
                    File.Copy(videoFile, destFile, overwrite: true);
                    Logger.LogInfo("Copied video file: " + destFile);
                }
                catch (Exception ex)
                {
                    Logger.LogInfo("Failed to copy video file " + videoFile + " to " + destFile + ": " + ex.Message);
                    return;
                }
            }
        }
        
        string localeSourcePath = Path.Combine(templatesPath, "es_features.locale");
        string localeDestPath = Path.Combine(buildPath, "emulationstation", "es_features.locale");
        
        if (!Directory.Exists(localeDestPath))
        {
            try
            {
                Directory.CreateDirectory(localeDestPath);
            }
            catch (Exception ex)
            {
                Logger.Log("[ERROR] Failed to create translations directory: " + ex.Message);
                Console.ReadKey();
                return;
            }
        }
        
        if (Directory.Exists(localeSourcePath))
        {
            string[] directories = Directory.GetDirectories(localeSourcePath, "*", SearchOption.AllDirectories);
            foreach (string dir in directories)
            {
                string destDir = dir.Replace(localeSourcePath, localeDestPath);
                if (!Directory.Exists(destDir))
                {
                    Directory.CreateDirectory(destDir);
                }
            }
            
            string[] localeFiles = Directory.GetFiles(localeSourcePath, "*.*", SearchOption.AllDirectories);
            foreach (string file in localeFiles)
            {
                string destFile = file.Replace(localeSourcePath, localeDestPath);
                File.Copy(file, destFile, overwrite: true);
            }
            Logger.LogInfo("Created locale folder: " + localeDestPath);
        }
    }

    private static void CreateVersionFile(BuilderOptions options)
    {
        Logger.LogLabel("create_version");
        Console.WriteLine(":: CREATE VERSION FILES...");
        
        string buildPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "build");
        string systemVersionFile = Path.Combine(buildPath, "system", "version.info");
        string esVersionFile = Path.Combine(buildPath, "emulationstation", "version.info");
        
        string versionContent = options.RetrobatVersion + "-" + options.Branch + "-" + options.Architecture;
        
        File.WriteAllText(systemVersionFile, versionContent);
        Logger.LogInfo("Created version file: " + systemVersionFile);
        
        File.WriteAllText(esVersionFile, versionContent);
        Logger.LogInfo("Created version file: " + esVersionFile);
    }

    private static void CopyTemplateFiles(BuilderOptions options)
    {
        Logger.LogLabel("copy_template");
        Console.WriteLine(":: COPY TEMPLATE FILES...");
        
        string baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
        string buildPath = Path.Combine(baseDirectory, "build");
        string sevenZipPath = options.SevenZipPath;
        
        if (!File.Exists(sevenZipPath))
        {
            Logger.Log("[ERROR] 7-Zip not found at: " + sevenZipPath);
            return;
        }
        
        string templatesListPath = Path.Combine(buildPath, "system", "configgen", "templates_files.lst");
        if (!File.Exists(templatesListPath))
        {
            Logger.LogInfo("Missing 'templates_files.lst' file.");
            return;
        }
        
        string[] lines = File.ReadAllLines(templatesListPath);
        foreach (string line in lines)
        {
            if (string.IsNullOrWhiteSpace(line) || !line.Contains("|"))
            {
                continue;
            }
            
            string[] parts = line.Split(new char[] { '|' });
            string sourcePath = Path.Combine(buildPath, Methods.NormalizePath(parts[0]));
            string destPath = Path.Combine(buildPath, Methods.NormalizePath(parts[1]));
            
            Logger.LogInfo("\nProcessing: " + sourcePath + " -> " + destPath);
            
            try
            {
                if (File.Exists(sourcePath))
                {
                    if (Path.GetExtension(sourcePath).ToLowerInvariant() == ".zip")
                    {
                        Logger.LogInfo(" - Extracting ZIP using 7z...");
                        string extractPath = Directory.Exists(destPath) ? destPath : Path.GetDirectoryName(destPath)!;
                        Directory.CreateDirectory(extractPath);
                        Methods.ExtractZipWith7z(sevenZipPath, sourcePath, extractPath);
                    }
                    else
                    {
                        Logger.LogInfo(" - Copying file...");
                        Directory.CreateDirectory(Path.GetDirectoryName(destPath)!);
                        File.Copy(sourcePath, destPath, overwrite: true);
                    }
                }
                else if (Directory.Exists(sourcePath))
                {
                    Logger.LogInfo(" - Copying folder contents...");
                    Methods.CopyDirectory(sourcePath, destPath);
                }
                else
                {
                    Logger.Log("[ERROR] Source not found: " + sourcePath);
                }
            }
            catch (Exception ex)
            {
                Logger.Log("[ERROR] Error processing " + sourcePath + ": " + ex.Message);
            }
        }
    }

    private static void GetLibretroCores(BuilderOptions options)
    {
        if (!options.GetLrcores)
        {
            Logger.LogInfo("Skipping Libretro cores download as per options.");
            return;
        }
        
        Logger.LogLabel("get_lrcores");
        Console.WriteLine(":: GETTING LIBRETRO CORES...");
        
        string baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
        string coresPath = Path.Combine(baseDirectory, "build", "emulators", "retroarch", "cores");
        string coresListPath = Path.Combine(baseDirectory, "system", "configgen", "lrcores_names.lst");
        
        if (!File.Exists(coresListPath))
        {
            Logger.LogInfo("Missing 'lrcores_names.lst' file.");
            return;
        }
        
        string retrobatFTPPath = options.RetrobatFTPPath;
        string coresBaseUrl = retrobatFTPPath + options.Architecture + "/" + options.Branch + "/emulators/cores/";
        
        string[] cores = File.ReadAllLines(coresListPath);
        foreach (string core in cores)
        {
            if (string.IsNullOrWhiteSpace(core))
            {
                continue;
            }
            
            // Platform-specific core extension
            string coreExtension;
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                coreExtension = "_libretro.dylib.zip";
            }
            else
            {
                coreExtension = "_libretro.dll.zip";
            }
            
            string coreUrl = coresBaseUrl + core + coreExtension;
            Thread.Sleep(3000);
            
            try
            {
                bool success = false;
                for (int attempt = 0; attempt < 5; attempt++)
                {
                    success = Methods.DownloadAndExtractArchive_Wget(coreUrl, coresPath, options);
                    if (success)
                    {
                        Logger.LogInfo("Libretro Core " + core + " copied to: " + coresPath);
                        break;
                    }
                    Thread.Sleep(4000);
                }
                
                if (!success)
                {
                    Logger.LogInfo("[WARNING] Failed to download or extract core: " + core + " from FTP, looking on RetroArch buildbot");
                    
                    // Platform-specific buildbot URL
                    string buildbotUrl;
                    if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
                    {
                        // Apple Silicon (arm64) support - macOS port is ARM64 only
                        buildbotUrl = options.RetroArchURL + "/nightly/apple/osx/arm64/latest/" + core + "_libretro.dylib.zip";
                    }
                    else
                    {
                        buildbotUrl = options.RetroArchURL + "/nightly/windows/x86_64/latest/" + core + "_libretro.dll.zip";
                    }
                    
                    Methods.DownloadAndExtractArchive_Wget(buildbotUrl, coresPath, options);
                }
            }
            catch
            {
                Logger.Log("[ERROR] Error downloading RetroArch core.");
            }
        }
    }

    private static void GetEmulators(BuilderOptions options)
    {
        if (!options.GetEmulators)
        {
            Logger.LogInfo("Skipping Emulators download as per options.");
            return;
        }
        
        Logger.LogLabel("get_emulators");
        Console.WriteLine(":: GETTING EMULATORS...");
        
        string baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
        string emulatorsPath = Path.Combine(baseDirectory, "build", "emulators");
        string emulatorsListPath = Path.Combine(baseDirectory, "system", "configgen", "emulators_names.lst");
        
        if (!File.Exists(emulatorsListPath))
        {
            Logger.LogInfo("Missing 'emulators_names.lst' file.");
            return;
        }
        
        string retrobatFTPPath = options.RetrobatFTPPath;
        string emulatorsBaseUrl = retrobatFTPPath + options.Architecture + "/" + options.Branch + "/emulators/";
        
        // Platform-specific exclusion list
        List<string> skipList = new List<string>
        {
            "retroarch", "eden", "3dsen", "teknoparrot", "citron", "yuzu", "pico8", 
            "ryujinx", "steam", "sudachi", "suyu", "yuzu-early-access"
        };
        
        // Add Windows-specific emulators to skip list on macOS
        if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
        {
            skipList.AddRange(new[] { "cemu", "pcsx2", "rpcs3", "xemu", "xenia" });
        }
        
        string[] emulators = File.ReadAllLines(emulatorsListPath);
        foreach (string emulator in emulators)
        {
            if (string.IsNullOrWhiteSpace(emulator) || skipList.Contains(emulator))
            {
                continue;
            }
            
            Thread.Sleep(3000);
            string emulatorUrl = emulatorsBaseUrl + emulator + ".7z";
            string emulatorDestPath = Path.Combine(emulatorsPath, emulator);
            
            try
            {
                bool success = false;
                for (int attempt = 0; attempt < 5; attempt++)
                {
                    success = Methods.DownloadAndExtractArchive_Wget(emulatorUrl, emulatorDestPath, options);
                    if (success)
                    {
                        Logger.LogInfo("Emulator " + emulator + " copied to: " + emulatorDestPath);
                        break;
                    }
                    Thread.Sleep(4000);
                }
                
                if (!success)
                {
                    Logger.LogInfo("[WARNING] Failed to download or extract emulator: " + emulator + " from FTP.");
                }
            }
            catch
            {
                Logger.Log("[ERROR] Error downloading Emulator.");
            }
        }
    }

    public static void CreateZipFolderSharpZip(BuilderOptions options)
    {
        Logger.LogLabel("create_ziparchive");
        Console.WriteLine(":: CREATE ZIP ARCHIVE...");
        
        string archiveName = "retrobat-v" + options.RetrobatVersion + "-" + options.Branch + "-" + options.Architecture + ".zip";
        string baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
        string sourcePath = Path.Combine(baseDirectory, "build");
        string zipPath = Path.Combine(baseDirectory, archiveName);
        
        if (!Directory.Exists(sourcePath))
        {
            Logger.LogInfo("[ERROR] Source folder does not exist.");
            return;
        }
        
        if (File.Exists(zipPath))
        {
            try
            {
                File.Delete(zipPath);
            }
            catch (Exception ex)
            {
                Logger.LogInfo("[WARNING] Could not delete existing zip file: " + ex.Message);
            }
        }
        
        using (FileStream zipFileStream = new FileStream(zipPath, FileMode.Create, FileAccess.Write, FileShare.None))
        {
            using (ZipOutputStream zipStream = new ZipOutputStream(zipFileStream))
            {
                zipStream.SetLevel(9);
                zipStream.IsStreamOwner = true;
                
                string[] files = Directory.GetFiles(sourcePath, "*", SearchOption.AllDirectories);
                foreach (string file in files)
                {
                    if (Path.GetFullPath(file) == Path.GetFullPath(zipPath))
                    {
                        continue;
                    }
                    
                    ZipEntry entry = new ZipEntry(GetRelativePath(sourcePath, file).Replace("\\", "/"))
                    {
                        IsUnicodeText = true
                    };
                    
                    zipStream.PutNextEntry(entry);
                    
                    using (FileStream fileStream = File.OpenRead(file))
                    {
                        fileStream.CopyTo(zipStream);
                    }
                    
                    zipStream.CloseEntry();
                }
                
                string[] directories = Directory.GetDirectories(sourcePath, "*", SearchOption.AllDirectories);
                foreach (string directory in directories)
                {
                    if (Directory.GetFiles(directory).Length == 0 && Directory.GetDirectories(directory).Length == 0)
                    {
                        ZipEntry emptyDirEntry = new ZipEntry(GetRelativePath(sourcePath, directory).Replace("\\", "/") + "/");
                        zipStream.PutNextEntry(emptyDirEntry);
                        zipStream.CloseEntry();
                    }
                }
                
                zipStream.Finish();
            }
        }
        
        string checksumPath = zipPath + ".sha256.txt";
        using (FileStream fileStream = File.OpenRead(zipPath))
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                string checksum = BitConverter.ToString(sha256.ComputeHash(fileStream)).Replace("-", "").ToLowerInvariant();
                File.WriteAllText(checksumPath, checksum);
            }
        }
        
        Logger.LogInfo("ZIP created at: " + zipPath);
    }

    public static string GetRelativePath(string basePath, string fullPath)
    {
        if (!basePath.EndsWith(Path.DirectorySeparatorChar.ToString()))
        {
            basePath = basePath + Path.DirectorySeparatorChar;
        }
        
        Uri baseUri = new Uri(basePath);
        Uri fullUri = new Uri(fullPath);
        
        return Uri.UnescapeDataString(baseUri.MakeRelativeUri(fullUri).ToString()).Replace('/', Path.DirectorySeparatorChar);
    }

    private static void SetVersion(BuilderOptions options)
    {
        string branch = options.Branch;
        string esSettingsPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "build", 
            "emulationstation", ".emulationstation", "es_settings.cfg");
        
        if (File.Exists(esSettingsPath))
        {
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.Load(esSettingsPath);
            
            XmlNode? updateNode = xmlDoc.SelectSingleNode("/config/string[@name='updates.type']");
            if (updateNode?.Attributes != null && branch != null)
            {
                XmlAttribute? valueAttr = updateNode.Attributes["value"];
                if (valueAttr != null)
                {
                    valueAttr.Value = branch;
                    xmlDoc.Save(esSettingsPath);
                    Logger.LogInfo("Update type set to: " + branch);
                }
            }
        }
    }
}
