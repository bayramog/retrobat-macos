#ifdef __APPLE__
#pragma once

#include "ApiSystem.h"

class MacOSApiSystem : public ApiSystem
{
public:
	MacOSApiSystem();
	virtual ~MacOSApiSystem();
	
	virtual void deinit() override;

	bool isScriptingSupported(ScriptId script) override;

	// System information
	std::vector<std::string> getSystemInformations() override;
	std::vector<std::string> getAvailableStorageDevices() override;
	std::string getHostsName() override;
	std::string getRunningArchitecture() override;

	// Storage and disk space
	unsigned long getFreeSpaceGB(std::string mountpoint) override;
	std::string getFreeSpaceInfo(const std::string dir);
	std::string getFreeSpaceUserInfo() override;
	std::string getFreeSpaceSystemInfo() override;
	
	// Display and video
	std::vector<std::string> getVideoModes(const std::string output = "") override;

	// Bezels (decoration system)
	std::vector<BatoceraBezel> getBatoceraBezelsList() override;
	std::pair<std::string, int> installBatoceraBezel(std::string bezelsystem, const std::function<void(const std::string)>& func = nullptr) override;
	std::pair<std::string, int> uninstallBatoceraBezel(std::string bezelsystem, const std::function<void(const std::string)>& func = nullptr) override;

	// System updates
	std::pair<std::string, int> updateSystem(const std::function<void(const std::string)>& func) override;
	bool canUpdate(std::vector<std::string>& output) override;

	// Network
	bool ping() override;
	std::string getIpAddress() override;

	// External applications
	bool launchKodi(Window *window) override;

	// Shaders and filters
	std::vector<std::string> getShaderList(const std::string& systemName, const std::string& emulator, const std::string& core) override;
	std::string getSevenZipCommand() override;

	// Power management
	bool canSuspend();
	void suspend() override;

	// Bluetooth (stub implementations for macOS)
	bool isPlaneMode() override;
	bool setPlaneMode(bool enable) override;
	bool forgetBluetoothControllers() override;

	// Ready flag (for system initialization)
	void setReadyFlag(bool ready = true) override;
	bool isReadyFlagSet() override;

protected:
	// Script execution
	bool executeScript(const std::string command) override;
	std::pair<std::string, int> executeScript(const std::string command, const std::function<void(const std::string)>& func) override;
	std::vector<std::string> executeEnumerationScript(const std::string command) override;

private:
	// Helper methods
	std::string executeCommand(const char* cmd);
	int executeCommandWithCallback(const char* cmd, const std::function<void(const std::string)>& func);
	
	// System state
	bool m_readyFlag;
};

#endif // __APPLE__
