using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Reflection;
using System.Runtime.InteropServices;

namespace RetroBuild;

internal class Methods
{
    public static string PathCombineExeDir(string relativePath)
    {
        string? assemblyLocation = Assembly.GetExecutingAssembly().Location;
        string assemblyDir = string.IsNullOrEmpty(assemblyLocation)
            ? AppDomain.CurrentDomain.BaseDirectory
            : Path.GetDirectoryName(assemblyLocation) ?? AppDomain.CurrentDomain.BaseDirectory;
        
        // Normalize path separators for cross-platform
        relativePath = NormalizePath(relativePath);
        return Path.GetFullPath(Path.Combine(assemblyDir, relativePath));
    }

    public static void CopyDirectory(string sourceDir, string destDir)
    {
        string[] directories = Directory.GetDirectories(sourceDir, "*", SearchOption.AllDirectories);
        for (int i = 0; i < directories.Length; i++)
        {
            Directory.CreateDirectory(directories[i].Replace(sourceDir, destDir));
        }
        directories = Directory.GetFiles(sourceDir, "*.*", SearchOption.AllDirectories);
        foreach (string obj in directories)
        {
            File.Copy(obj, obj.Replace(sourceDir, destDir), overwrite: true);
        }
    }

    public static int RunProcess(string exe, string args, string workingDir, out string output)
    {
        ProcessStartInfo startInfo = new ProcessStartInfo
        {
            FileName = exe,
            Arguments = args,
            WorkingDirectory = workingDir,
            RedirectStandardOutput = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };
        Process? process = null;
        try
        {
            process = new Process();
            process.StartInfo = startInfo;
            process.Start();
            output = process.StandardOutput.ReadToEnd();
            process.WaitForExit();
            return process.ExitCode;
        }
        catch (Exception ex)
        {
            output = "[ERROR] Failed to run process: " + ex.Message;
            return -1;
        }
        finally
        {
            process?.Dispose();
        }
    }

    public static bool DownloadAndExtractArchive_WebClient(string url, string outputDir, BuilderOptions options)
    {
        string fileName = Path.GetFileName(new Uri(url).AbsolutePath);
        string text = Path.Combine(Path.GetTempPath(), fileName);
        Logger.LogInfo("Downloading (WebClient): " + url);
        try
        {
            using (WebClient webClient = new WebClient())
            {
                webClient.DownloadFile(url, text);
            }
            Logger.LogInfo("Download complete: " + text);
            return ExtractArchive(text, outputDir, options);
        }
        catch (Exception ex)
        {
            Logger.Log("[ERROR] Download or extract failed: " + ex.Message);
            return false;
        }
        finally
        {
            TryDeleteFile(text);
        }
    }

    public static bool DownloadAndExtractArchive_Curl(string url, string outputDir, BuilderOptions options)
    {
        string fileName = Path.GetFileName(new Uri(url).AbsolutePath);
        string text = Path.Combine(Path.GetTempPath(), fileName);
        Logger.LogInfo("Downloading (curl): " + url);
        try
        {
            string arguments = $"--silent --show-error --fail -L \"{url}\" -o \"{text}\"";
            using (Process? process = Process.Start(new ProcessStartInfo
            {
                FileName = options.CurlPath,
                Arguments = arguments,
                UseShellExecute = false,
                CreateNoWindow = true,
                RedirectStandardOutput = true,
                RedirectStandardError = true
            }))
            {
                if (process != null)
                {
                    process.WaitForExit();
                    string text2 = process.StandardError.ReadToEnd();
                    if (process.ExitCode != 0)
                    {
                        Logger.Log("[ERROR] Curl download failed: " + text2);
                        return false;
                    }
                }
            }
            Logger.LogInfo("Download complete: " + text);
            return ExtractArchive(text, outputDir, options);
        }
        catch (Exception ex)
        {
            Logger.Log("[ERROR] Download or extract failed: " + ex.Message);
            return false;
        }
        finally
        {
            TryDeleteFile(text);
        }
    }

    public static bool DownloadAndExtractArchive_Wget(string url, string outputDir, BuilderOptions options)
    {
        string fileName = Path.GetFileName(new Uri(url).AbsolutePath);
        string text = Path.Combine(Path.GetTempPath(), fileName);
        Logger.LogInfo("Downloading (wget): " + url);
        try
        {
            string arguments = $"--quiet --no-check-certificate --read-timeout=20 --timeout=15 -t 3 -O \"{text}\" \"{url}\"";
            using (Process? process = Process.Start(new ProcessStartInfo
            {
                FileName = options.WgetPath,
                Arguments = arguments,
                UseShellExecute = false,
                CreateNoWindow = true,
                RedirectStandardOutput = true,
                RedirectStandardError = true
            }))
            {
                if (process != null)
                {
                    process.WaitForExit();
                    string text2 = process.StandardError.ReadToEnd();
                    if (process.ExitCode != 0)
                    {
                        Logger.Log("[ERROR] Wget download failed: " + text2);
                        return false;
                    }
                }
            }
            Logger.LogInfo("Download complete: " + text);
            return ExtractArchive(text, outputDir, options);
        }
        catch (Exception ex)
        {
            Logger.Log("[ERROR] Download or extract failed: " + ex.Message);
            return false;
        }
        finally
        {
            TryDeleteFile(text);
        }
    }

    private static bool ExtractArchive(string archivePath, string outputDir, BuilderOptions options)
    {
        if (!Directory.Exists(outputDir))
        {
            Directory.CreateDirectory(outputDir);
        }
        
        ProcessStartInfo processStartInfo = new ProcessStartInfo();
        processStartInfo.FileName = options.SevenZipPath;
        processStartInfo.Arguments = $"x \"{archivePath}\" -o\"{outputDir}\" -y";
        processStartInfo.UseShellExecute = false;
        processStartInfo.CreateNoWindow = true;
        processStartInfo.RedirectStandardOutput = true;
        processStartInfo.RedirectStandardError = true;
        
        using Process? process = Process.Start(processStartInfo);
        if (process == null)
        {
            Logger.Log("[ERROR] Failed to start extraction process");
            return false;
        }
        
        process.WaitForExit();
        process.StandardOutput.ReadToEnd();
        string text = process.StandardError.ReadToEnd();
        if (process.ExitCode != 0)
        {
            Logger.Log("[ERROR] Extraction failed: " + text);
            return false;
        }
        Logger.LogInfo("Extraction complete to: " + outputDir);
        return true;
    }

    public static bool CloneOrUpdateGitRepo(string repoUrl, string buildFolder)
    {
        string text = Path.Combine(Path.GetTempPath(), "retrobat_bios_temp");
        try
        {
            Logger.LogInfo("Downloading (git): " + repoUrl);
            string[] files;
            if (Directory.Exists(text))
            {
                files = Directory.GetFiles(text, "*", SearchOption.AllDirectories);
                foreach (string text2 in files)
                {
                    try
                    {
                        File.SetAttributes(text2, FileAttributes.Normal);
                        File.Delete(text2);
                    }
                    catch (UnauthorizedAccessException)
                    {
                        Console.WriteLine("Access denied to file: " + text2);
                    }
                }
                try
                {
                    Directory.Delete(text, recursive: true);
                }
                catch (UnauthorizedAccessException)
                {
                    Console.WriteLine("Access denied to directory: " + text);
                }
            }
            
            ProcessStartInfo processStartInfo = new ProcessStartInfo();
            processStartInfo.FileName = "git";
            processStartInfo.Arguments = $"clone {repoUrl} \"{text}\"";
            processStartInfo.UseShellExecute = false;
            processStartInfo.CreateNoWindow = true;
            processStartInfo.RedirectStandardOutput = true;
            processStartInfo.RedirectStandardError = true;
            
            using (Process? process = Process.Start(processStartInfo))
            {
                if (process != null)
                {
                    process.WaitForExit();
                    string text3 = process.StandardError.ReadToEnd();
                    if (process.ExitCode != 0)
                    {
                        Logger.Log("[ERROR] Git clone failed: " + text3);
                        return false;
                    }
                }
            }
            
            Logger.LogInfo("git downloaded from: " + repoUrl);
            if (!Directory.Exists(buildFolder))
            {
                Directory.CreateDirectory(buildFolder);
            }
            
            files = Directory.GetDirectories(text, "*", SearchOption.AllDirectories);
            foreach (string text4 in files)
            {
                if (!text4.EndsWith(".git", StringComparison.OrdinalIgnoreCase))
                {
                    string path = text4.Replace(text, buildFolder);
                    if (!Directory.Exists(path))
                    {
                        Directory.CreateDirectory(path);
                    }
                }
            }
            
            files = Directory.GetFiles(text, "*.*", SearchOption.AllDirectories);
            foreach (string text5 in files)
            {
                if (!text5.Contains(Path.Combine(".git", "")) && !text5.EndsWith(".git", StringComparison.OrdinalIgnoreCase))
                {
                    string destFileName = text5.Replace(text, buildFolder);
                    File.Copy(text5, destFileName, overwrite: true);
                }
            }
            Logger.LogInfo("Repository copied to " + buildFolder + ".");
            return true;
        }
        catch (Exception ex3)
        {
            Logger.Log("[ERROR] Failed to clone and copy repo: " + ex3.Message);
            return false;
        }
        finally
        {
            try
            {
                if (Directory.Exists(text))
                {
                    Directory.Delete(text, recursive: true);
                }
            }
            catch
            {
            }
        }
    }

    public static void DeleteGitFiles(string path)
    {
        if (!Directory.Exists(path))
        {
            return;
        }
        string path2 = Path.Combine(path, ".git");
        if (!Directory.Exists(path2))
        {
            return;
        }
        try
        {
            Directory.Delete(path2, recursive: true);
            Logger.LogInfo("Deleted .git folder from " + path);
        }
        catch (Exception ex)
        {
            Logger.Log("[ERROR] Failed to delete .git folder: " + ex.Message);
        }
        string[] files = Directory.GetFiles(path, ".git", SearchOption.AllDirectories);
        foreach (string text in files)
        {
            try
            {
                File.SetAttributes(text, FileAttributes.Normal);
                File.Delete(text);
                Console.WriteLine("Deleted file: " + text);
                Logger.LogInfo("Deleted .git files from " + path);
            }
            catch (Exception ex2)
            {
                Logger.Log("[ERROR] Failed to delete .git files: " + ex2.Message);
            }
        }
    }

    private static void TryDeleteFile(string path)
    {
        try
        {
            if (File.Exists(path))
            {
                File.Delete(path);
            }
        }
        catch
        {
        }
    }

    public static void ExtractZipWith7z(string sevenZipExe, string zipFilePath, string outputDir)
    {
        Process? process = null;
        try
        {
            process = new Process();
            process.StartInfo.FileName = sevenZipExe;
            process.StartInfo.Arguments = $"x \"{zipFilePath}\" -o\"{outputDir}\" -y";
            process.StartInfo.CreateNoWindow = true;
            process.StartInfo.UseShellExecute = false;
            process.StartInfo.RedirectStandardOutput = true;
            process.StartInfo.RedirectStandardError = true;
            process.Start();
            process.StandardOutput.ReadToEnd();
            string text = process.StandardError.ReadToEnd();
            process.WaitForExit();
            if (process.ExitCode != 0)
            {
                throw new Exception("7z extraction failed: " + text);
            }
        }
        finally
        {
            process?.Dispose();
        }
    }

    public static string NormalizePath(string path)
    {
        // Replace Windows backslashes with forward slashes, then convert to platform separator
        return path.Trim()
            .TrimStart('\\', '/')
            .Replace('\\', Path.DirectorySeparatorChar)
            .Replace('/', Path.DirectorySeparatorChar);
    }
}
