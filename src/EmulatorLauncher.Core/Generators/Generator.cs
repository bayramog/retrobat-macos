using System;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;

namespace EmulatorLauncher.Generators
{
    /// <summary>
    /// Base class for all emulator generators
    /// Handles emulator-specific configuration and launch logic
    /// </summary>
    public abstract class Generator
    {
        protected string System { get; set; } = string.Empty;
        protected string Emulator { get; set; } = string.Empty;
        protected string Core { get; set; } = string.Empty;
        protected string Rom { get; set; } = string.Empty;
        protected List<Controller> Controllers { get; set; } = new();
        
        /// <summary>
        /// Generate the ProcessStartInfo for launching the emulator
        /// </summary>
        public abstract ProcessStartInfo Generate();
        
        /// <summary>
        /// Run the emulator and wait for it to exit
        /// </summary>
        public virtual int RunAndWait(ProcessStartInfo startInfo)
        {
            try
            {
                using var process = Process.Start(startInfo);
                if (process == null)
                {
                    Console.WriteLine("ERROR: Failed to start process");
                    return -1;
                }
                
                Console.WriteLine($"Started process: PID {process.Id}");
                process.WaitForExit();
                
                Console.WriteLine($"Process exited with code: {process.ExitCode}");
                return process.ExitCode;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"ERROR launching process: {ex.Message}");
                return -1;
            }
        }
        
        /// <summary>
        /// Cleanup after emulator exits
        /// </summary>
        public virtual void Cleanup()
        {
            // Override in derived classes if cleanup is needed
        }
        
        /// <summary>
        /// Find emulator executable path with platform-specific logic
        /// </summary>
        protected string? FindEmulator(string emulatorName)
        {
            // macOS: Check for .app bundles
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                // Try common paths for .app bundles
                var appPaths = new[]
                {
                    $"/Applications/{emulatorName}.app",
                    Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), 
                        $"Applications/{emulatorName}.app"),
                    // RetroBat-specific path
                    Path.Combine(GetRetrobatPath(), $"emulators/{emulatorName}/{emulatorName}.app")
                };
                
                foreach (var appPath in appPaths)
                {
                    if (Directory.Exists(appPath))
                    {
                        // Return path to executable inside .app bundle
                        var execPath = Path.Combine(appPath, "Contents", "MacOS", 
                            Path.GetFileNameWithoutExtension(appPath));
                        if (File.Exists(execPath))
                            return execPath;
                    }
                }
            }
            
            // Windows: Check for .exe
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                var exePaths = new[]
                {
                    Path.Combine(GetRetrobatPath(), $"emulators\\{emulatorName}\\{emulatorName}.exe"),
                    Path.Combine(GetRetrobatPath(), $"emulators\\{emulatorName}\\{emulatorName}_libretro.exe")
                };
                
                foreach (var exePath in exePaths)
                {
                    if (File.Exists(exePath))
                        return exePath;
                }
            }
            
            // Linux: Check for binary
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            {
                var binPaths = new[]
                {
                    Path.Combine(GetRetrobatPath(), $"emulators/{emulatorName}/{emulatorName}"),
                    $"/usr/bin/{emulatorName}",
                    $"/usr/local/bin/{emulatorName}"
                };
                
                foreach (var binPath in binPaths)
                {
                    if (File.Exists(binPath))
                        return binPath;
                }
            }
            
            return null;
        }
        
        /// <summary>
        /// Get the RetroBat installation path
        /// </summary>
        protected string GetRetrobatPath()
        {
            // Check environment variable first
            var retrobatPath = Environment.GetEnvironmentVariable("RETROBAT_PATH");
            if (!string.IsNullOrEmpty(retrobatPath) && Directory.Exists(retrobatPath))
                return retrobatPath;
            
            // Try to detect based on current executable location
            var exePath = AppContext.BaseDirectory;
            
            // Go up directories to find RetroBat root
            var dir = new DirectoryInfo(exePath);
            while (dir != null && dir.Parent != null)
            {
                // Look for distinctive RetroBat files
                if (Directory.Exists(Path.Combine(dir.FullName, "emulators")) &&
                    Directory.Exists(Path.Combine(dir.FullName, "roms")))
                {
                    return dir.FullName;
                }
                dir = dir.Parent;
            }
            
            // Default to current directory
            return Directory.GetCurrentDirectory();
        }
        
        /// <summary>
        /// Normalize path separators for current platform
        /// </summary>
        protected string NormalizePath(string path)
        {
            if (string.IsNullOrEmpty(path))
                return path;
            
            // Replace backslashes with forward slashes on Unix
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX) || 
                RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            {
                return path.Replace('\\', '/');
            }
            
            return path;
        }
    }
    
    /// <summary>
    /// Controller representation
    /// </summary>
    public class Controller
    {
        public int PlayerIndex { get; set; }
        public int DeviceIndex { get; set; }
        public string Guid { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public int ButtonCount { get; set; }
        public int HatCount { get; set; }
        public int AxisCount { get; set; }
    }
}
