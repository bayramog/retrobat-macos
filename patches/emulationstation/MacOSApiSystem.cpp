#ifdef __APPLE__

#include "MacOSApiSystem.h"
#include "Log.h"
#include "Settings.h"
#include "utils/FileSystemUtil.h"
#include "utils/StringUtil.h"

#include <cstdio>
#include <cstring>
#include <array>
#include <memory>
#include <sstream>
#include <fstream>
#include <unistd.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/statvfs.h>
#include <sys/mount.h>
#include <mach/mach.h>
#include <mach/machine.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/network/IOEthernetInterface.h>
#include <IOKit/network/IONetworkInterface.h>
#include <IOKit/network/IOEthernetController.h>
#include <CoreFoundation/CoreFoundation.h>
#include <SystemConfiguration/SystemConfiguration.h>
#include <ifaddrs.h>
#include <netinet/in.h>
#include <arpa/inet.h>

MacOSApiSystem::MacOSApiSystem()
{
	m_readyFlag = false;
	LOG(LogInfo) << "MacOSApiSystem initialized";
}

MacOSApiSystem::~MacOSApiSystem()
{
	deinit();
}

void MacOSApiSystem::deinit()
{
	LOG(LogInfo) << "MacOSApiSystem deinitialized";
}

bool MacOSApiSystem::isScriptingSupported(ScriptId script)
{
	// Most scripts are not supported on macOS
	// RetroBat uses Windows scripts
	switch (script)
	{
		case GAMESETTINGS:
		case DECORATIONS:
		case SHADERS:
			return true;  // These can work with file-based configuration
		default:
			return false;
	}
}

std::vector<std::string> MacOSApiSystem::getSystemInformations()
{
	std::vector<std::string> info;
	
	// macOS version
	std::string osVersion = executeCommand("sw_vers -productVersion");
	if (!osVersion.empty())
		info.push_back("OS: macOS " + osVersion);
	
	// Build version
	std::string buildVersion = executeCommand("sw_vers -buildVersion");
	if (!buildVersion.empty())
		info.push_back("Build: " + buildVersion);
	
	// Architecture
	info.push_back("Architecture: " + getRunningArchitecture());
	
	// Hostname
	info.push_back("Hostname: " + getHostsName());
	
	// CPU information
	char cpuBrand[256];
	size_t size = sizeof(cpuBrand);
	if (sysctlbyname("machdep.cpu.brand_string", cpuBrand, &size, NULL, 0) == 0)
	{
		info.push_back("CPU: " + std::string(cpuBrand));
	}
	
	// CPU core count
	int cpuCount = 0;
	size = sizeof(cpuCount);
	if (sysctlbyname("hw.ncpu", &cpuCount, &size, NULL, 0) == 0)
	{
		info.push_back("CPU Cores: " + std::to_string(cpuCount));
	}
	
	// Memory
	int64_t memSize = 0;
	size = sizeof(memSize);
	if (sysctlbyname("hw.memsize", &memSize, &size, NULL, 0) == 0)
	{
		double memGB = memSize / (1024.0 * 1024.0 * 1024.0);
		char buffer[64];
		snprintf(buffer, sizeof(buffer), "Memory: %.2f GB", memGB);
		info.push_back(std::string(buffer));
	}
	
	// Disk space
	info.push_back("Free Space: " + getFreeSpaceUserInfo());
	
	return info;
}

std::vector<std::string> MacOSApiSystem::getAvailableStorageDevices()
{
	std::vector<std::string> devices;
	
	// On macOS, list mounted volumes
	struct statfs *mounts;
	int count = getmntinfo(&mounts, MNT_NOWAIT);
	
	for (int i = 0; i < count; i++)
	{
		std::string fsType = mounts[i].f_fstypename;
		std::string mountPoint = mounts[i].f_mntonname;
		std::string device = mounts[i].f_mntfromname;
		
		// Skip system volumes and special file systems
		if (fsType == "devfs" || fsType == "autofs" || mountPoint == "/")
			continue;
			
		// Add volume info
		devices.push_back(device + " on " + mountPoint + " (" + fsType + ")");
	}
	
	return devices;
}

std::string MacOSApiSystem::getHostsName()
{
	char hostname[256];
	if (gethostname(hostname, sizeof(hostname)) == 0)
	{
		return std::string(hostname);
	}
	return "unknown";
}

std::string MacOSApiSystem::getRunningArchitecture()
{
#if defined(__arm64__) || defined(__aarch64__)
	return "arm64 (Apple Silicon)";
#elif defined(__x86_64__) || defined(__amd64__)
	return "x86_64 (Intel)";
#else
	return "unknown";
#endif
}

unsigned long MacOSApiSystem::getFreeSpaceGB(std::string mountpoint)
{
	struct statvfs stat;
	if (statvfs(mountpoint.c_str(), &stat) == 0)
	{
		unsigned long freeSpace = (stat.f_bavail * stat.f_bsize) / (1024 * 1024 * 1024);
		return freeSpace;
	}
	return 0;
}

std::string MacOSApiSystem::getFreeSpaceInfo(const std::string dir)
{
	struct statvfs stat;
	if (statvfs(dir.c_str(), &stat) == 0)
	{
		unsigned long long freeSpace = stat.f_bavail * stat.f_bsize;
		unsigned long long totalSpace = stat.f_blocks * stat.f_bsize;
		
		double freeGB = freeSpace / (1024.0 * 1024.0 * 1024.0);
		double totalGB = totalSpace / (1024.0 * 1024.0 * 1024.0);
		
		char buffer[128];
		snprintf(buffer, sizeof(buffer), "%.2f GB / %.2f GB", freeGB, totalGB);
		return std::string(buffer);
	}
	return "Unknown";
}

std::string MacOSApiSystem::getFreeSpaceUserInfo()
{
	const char* homeDir = getenv("HOME");
	if (homeDir != nullptr)
	{
		return getFreeSpaceInfo(homeDir);
	}
	return "Unknown";
}

std::string MacOSApiSystem::getFreeSpaceSystemInfo()
{
	return getFreeSpaceInfo("/");
}

std::vector<std::string> MacOSApiSystem::getVideoModes(const std::string output)
{
	std::vector<std::string> modes;
	
	// For macOS, we could query display modes using CoreGraphics
	// For now, return some common resolutions
	modes.push_back("1920x1080");
	modes.push_back("2560x1440");
	modes.push_back("3840x2160");
	
	// TODO: Implement proper display mode enumeration using CGDisplay APIs
	
	return modes;
}

std::vector<BatoceraBezel> MacOSApiSystem::getBatoceraBezelsList()
{
	// Bezels are stored in the decorations directory
	// This is a simplified implementation
	std::vector<BatoceraBezel> bezels;
	return bezels;
}

std::pair<std::string, int> MacOSApiSystem::installBatoceraBezel(std::string bezelsystem, const std::function<void(const std::string)>& func)
{
	// Stub implementation
	return std::make_pair("Bezel installation not implemented on macOS", 1);
}

std::pair<std::string, int> MacOSApiSystem::uninstallBatoceraBezel(std::string bezelsystem, const std::function<void(const std::string)>& func)
{
	// Stub implementation
	return std::make_pair("Bezel uninstallation not implemented on macOS", 1);
}

std::pair<std::string, int> MacOSApiSystem::updateSystem(const std::function<void(const std::string)>& func)
{
	// On macOS, system updates are handled by the App Store
	return std::make_pair("System updates not implemented on macOS", 1);
}

bool MacOSApiSystem::canUpdate(std::vector<std::string>& output)
{
	// Check for RetroBat updates (not OS updates)
	output.push_back("Update check not implemented");
	return false;
}

bool MacOSApiSystem::ping()
{
	// Test internet connectivity
	int result = system("ping -c 1 -W 1 8.8.8.8 > /dev/null 2>&1");
	return (result == 0);
}

std::string MacOSApiSystem::getIpAddress()
{
	struct ifaddrs *interfaces = nullptr;
	struct ifaddrs *temp_addr = nullptr;
	std::string ipAddress = "127.0.0.1";
	
	if (getifaddrs(&interfaces) == 0)
	{
		temp_addr = interfaces;
		while (temp_addr != nullptr)
		{
			if (temp_addr->ifa_addr->sa_family == AF_INET)
			{
				// Check for non-loopback IPv4 address
				std::string ifName = temp_addr->ifa_name;
				if (ifName != "lo0" && ifName.find("en") == 0)  // en0, en1, etc.
				{
					char addressBuffer[INET_ADDRSTRLEN];
					inet_ntop(AF_INET, &((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr, 
						addressBuffer, INET_ADDRSTRLEN);
					ipAddress = addressBuffer;
					break;
				}
			}
			temp_addr = temp_addr->ifa_next;
		}
		freeifaddrs(interfaces);
	}
	
	return ipAddress;
}

bool MacOSApiSystem::launchKodi(Window *window)
{
	// Try to launch Kodi using the 'open' command
	int result = system("open -a Kodi");
	return (result == 0);
}

std::vector<std::string> MacOSApiSystem::getShaderList(const std::string& systemName, const std::string& emulator, const std::string& core)
{
	// Shaders are stored in the shaders directory
	std::vector<std::string> shaders;
	
	// TODO: Enumerate shader files from system/shaders
	
	return shaders;
}

std::string MacOSApiSystem::getSevenZipCommand()
{
	// On macOS with Homebrew, 7z is available
	return "7z";
}

bool MacOSApiSystem::canSuspend()
{
	// macOS supports sleep
	return true;
}

void MacOSApiSystem::suspend()
{
	// Put macOS to sleep using pmset
	system("pmset sleepnow");
}

bool MacOSApiSystem::isPlaneMode()
{
	// Plane mode (Airplane mode) is not easily accessible on macOS
	return false;
}

bool MacOSApiSystem::setPlaneMode(bool enable)
{
	// Not implemented on macOS
	return false;
}

bool MacOSApiSystem::forgetBluetoothControllers()
{
	// Not implemented on macOS
	return false;
}

void MacOSApiSystem::setReadyFlag(bool ready)
{
	m_readyFlag = ready;
}

bool MacOSApiSystem::isReadyFlagSet()
{
	return m_readyFlag;
}

bool MacOSApiSystem::executeScript(const std::string command)
{
	int result = system(command.c_str());
	return (result == 0);
}

std::pair<std::string, int> MacOSApiSystem::executeScript(const std::string command, const std::function<void(const std::string)>& func)
{
	int exitCode = executeCommandWithCallback(command.c_str(), func);
	return std::make_pair("", exitCode);
}

std::vector<std::string> MacOSApiSystem::executeEnumerationScript(const std::string command)
{
	std::vector<std::string> result;
	std::string output = executeCommand(command.c_str());
	
	// Split output by newlines
	std::istringstream stream(output);
	std::string line;
	while (std::getline(stream, line))
	{
		if (!line.empty())
			result.push_back(line);
	}
	
	return result;
}

std::string MacOSApiSystem::executeCommand(const char* cmd)
{
	std::array<char, 128> buffer;
	std::string result;
	
	FILE* pipe = popen(cmd, "r");
	if (!pipe)
	{
		LOG(LogError) << "Failed to execute command: " << cmd;
		return "";
	}
	
	while (fgets(buffer.data(), buffer.size(), pipe) != nullptr)
	{
		result += buffer.data();
	}
	
	pclose(pipe);
	
	// Remove trailing newline
	if (!result.empty() && result.back() == '\n')
		result.pop_back();
	
	return result;
}

int MacOSApiSystem::executeCommandWithCallback(const char* cmd, const std::function<void(const std::string)>& func)
{
	FILE* pipe = popen(cmd, "r");
	if (!pipe)
	{
		LOG(LogError) << "Failed to execute command: " << cmd;
		return -1;
	}
	
	std::array<char, 256> buffer;
	while (fgets(buffer.data(), buffer.size(), pipe) != nullptr)
	{
		if (func)
		{
			std::string line = buffer.data();
			// Remove trailing newline
			if (!line.empty() && line.back() == '\n')
				line.pop_back();
			func(line);
		}
	}
	
	int exitCode = pclose(pipe);
	return WEXITSTATUS(exitCode);
}

#endif // __APPLE__
