using System;
using System.Collections.Generic;
using System.IO;

namespace RetroBuild;

internal class IniParser
{
    private Dictionary<string, Dictionary<string, string>> data = new Dictionary<string, Dictionary<string, string>>(StringComparer.OrdinalIgnoreCase);

    public IniParser(string path)
    {
        Load(path);
    }

    private void Load(string path)
    {
        if (!File.Exists(path))
        {
            throw new FileNotFoundException("INI file not found", path);
        }
        string key = "";
        string[] array = File.ReadAllLines(path);
        for (int i = 0; i < array.Length; i++)
        {
            string text = array[i].Trim();
            if (text.StartsWith(";") || text.StartsWith("#") || string.IsNullOrEmpty(text))
            {
                continue;
            }
            if (text.StartsWith("[") && text.EndsWith("]"))
            {
                key = text.Substring(1, text.Length - 2);
                if (!data.ContainsKey(key))
                {
                    data[key] = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                }
            }
            else if (text.Contains("="))
            {
                int num = text.IndexOf('=');
                string key2 = text.Substring(0, num).Trim();
                string value = text.Substring(num + 1).Trim();
                if (!data.ContainsKey(key))
                {
                    data[key] = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                }
                data[key][key2] = value;
            }
        }
    }

    public string Get(string section, string key, string defaultValue = "")
    {
        if (data.ContainsKey(section) && data[section].ContainsKey(key))
        {
            return data[section][key];
        }
        return defaultValue;
    }
}
