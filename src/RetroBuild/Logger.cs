using System;
using System.IO;
using System.Reflection;

namespace RetroBuild;

internal class Logger
{
    private static readonly string logFilePath;

    static Logger()
    {
        string? assemblyLocation = Assembly.GetExecutingAssembly().Location;
        string assemblyDir = string.IsNullOrEmpty(assemblyLocation) 
            ? AppDomain.CurrentDomain.BaseDirectory 
            : Path.GetDirectoryName(assemblyLocation) ?? AppDomain.CurrentDomain.BaseDirectory;
        
        logFilePath = Path.Combine(assemblyDir, "build.log");
        if (File.Exists(logFilePath))
        {
            File.Delete(logFilePath);
        }
    }

    public static void Log(string message)
    {
        string text = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff") + " " + message;
        Console.WriteLine(text);
        File.AppendAllText(logFilePath, text + Environment.NewLine);
    }

    public static void LogLabel(string label)
    {
        Log("[LABEL] :" + label);
    }

    public static void LogInfo(string message)
    {
        Log("[INFO] " + message);
    }

    public static void LogExit(int code)
    {
        Log($"[EXIT] {code}");
    }

    public static void LogStart(string scriptName)
    {
        Log("[START] Run: " + scriptName);
    }
}
