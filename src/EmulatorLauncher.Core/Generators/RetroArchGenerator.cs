using System;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;

namespace EmulatorLauncher.Generators
{
    /// <summary>
    /// RetroArch/Libretro generator - supports all libretro cores
    /// Priority #1 emulator for RetroBat
    /// </summary>
    public class RetroArchGenerator : Generator
    {
        public override ProcessStartInfo Generate()
        {
            Console.WriteLine("Generating RetroArch launch configuration...");
            
            // Find RetroArch executable
            var retroarchPath = FindRetroArch();
            if (string.IsNullOrEmpty(retroarchPath))
            {
                throw new FileNotFoundException("RetroArch executable not found");
            }
            
            Console.WriteLine($"Found RetroArch: {retroarchPath}");
            
            // Build command line arguments
            var args = new List<string>();
            
            // Add core if specified
            if (!string.IsNullOrEmpty(Core))
            {
                var corePath = FindCore(Core);
                if (!string.IsNullOrEmpty(corePath))
                {
                    args.Add("-L");
                    args.Add($"\"{corePath}\"");
                    Console.WriteLine($"Using core: {corePath}");
                }
                else
                {
                    Console.WriteLine($"WARNING: Core '{Core}' not found, RetroArch will use default");
                }
            }
            
            // Add ROM path
            args.Add($"\"{NormalizePath(Rom)}\"");
            
            // Add fullscreen flag
            args.Add("--fullscreen");
            
            // TODO: Add controller configuration
            // TODO: Add save state configuration
            // TODO: Add shader/bezel configuration
            
            var startInfo = new ProcessStartInfo
            {
                FileName = retroarchPath,
                Arguments = string.Join(" ", args),
                UseShellExecute = false,
                RedirectStandardOutput = false,
                RedirectStandardError = false,
                CreateNoWindow = false
            };
            
            Console.WriteLine($"Command: {startInfo.FileName} {startInfo.Arguments}");
            
            return startInfo;
        }
        
        private string? FindRetroArch()
        {
            // Try different RetroArch names based on platform
            var names = new List<string>();
            
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                names.AddRange(new[] { "RetroArch", "RetroArch-Metal" });
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                names.AddRange(new[] { "retroarch", "retroarch_libretro" });
            }
            else
            {
                names.Add("retroarch");
            }
            
            foreach (var name in names)
            {
                var path = FindEmulator(name);
                if (path != null)
                    return path;
            }
            
            // On macOS, also check /Applications directly
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                var appPath = "/Applications/RetroArch.app";
                if (Directory.Exists(appPath))
                {
                    var execPath = Path.Combine(appPath, "Contents", "MacOS", "RetroArch");
                    if (File.Exists(execPath))
                        return execPath;
                }
            }
            
            return null;
        }
        
        private string? FindCore(string coreName)
        {
            // Core file extensions by platform
            string extension;
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
                extension = ".dylib";
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
                extension = ".dll";
            else
                extension = ".so";
            
            // Append _libretro to core name if not present
            if (!coreName.EndsWith("_libretro"))
                coreName += "_libretro";
            
            var coreFileName = coreName + extension;
            
            // Try different core locations
            var corePaths = new List<string>();
            
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                corePaths.AddRange(new[]
                {
                    Path.Combine(GetRetrobatPath(), "emulators", "retroarch", "cores", coreFileName),
                    Path.Combine("/Applications/RetroArch.app/Contents/Resources/cores", coreFileName),
                    Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), 
                        ".config/retroarch/cores", coreFileName)
                });
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                corePaths.AddRange(new[]
                {
                    Path.Combine(GetRetrobatPath(), "emulators", "retroarch", "cores", coreFileName),
                    Path.Combine(GetRetrobatPath(), "emulators", "retroarch", coreFileName)
                });
            }
            else // Linux
            {
                corePaths.AddRange(new[]
                {
                    Path.Combine(GetRetrobatPath(), "emulators", "retroarch", "cores", coreFileName),
                    $"/usr/lib/libretro/{coreFileName}",
                    $"/usr/local/lib/libretro/{coreFileName}"
                });
            }
            
            foreach (var path in corePaths)
            {
                if (File.Exists(path))
                    return path;
            }
            
            return null;
        }
    }
}
