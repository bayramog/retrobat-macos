using System;
using System.Runtime.InteropServices;

namespace EmulatorLauncher.Controllers
{
    /// <summary>
    /// SDL3 P/Invoke wrapper for controller support on macOS and Linux
    /// Based on SDL3 GameController API: https://wiki.libsdl.org/SDL3/CategoryGamepad
    /// </summary>
    public static class SDL3
    {
        // Platform-specific library names
        private const string LibraryName = "SDL3";
        
        #region SDL Init/Quit
        
        [Flags]
        public enum SDL_InitFlags : uint
        {
            SDL_INIT_GAMEPAD = 0x00000020,
            SDL_INIT_JOYSTICK = 0x00000200,
        }
        
        [DllImport(LibraryName, CallingConvention = CallingConvention.Cdecl)]
        public static extern int SDL_Init(SDL_InitFlags flags);
        
        [DllImport(LibraryName, CallingConvention = CallingConvention.Cdecl)]
        public static extern void SDL_Quit();
        
        #endregion
        
        #region SDL Gamepad
        
        [DllImport(LibraryName, CallingConvention = CallingConvention.Cdecl)]
        public static extern IntPtr SDL_GetGamepads(out int count);
        
        [DllImport(LibraryName, CallingConvention = CallingConvention.Cdecl)]
        public static extern IntPtr SDL_OpenGamepad(int instance_id);
        
        [DllImport(LibraryName, CallingConvention = CallingConvention.Cdecl)]
        public static extern void SDL_CloseGamepad(IntPtr gamepad);
        
        [DllImport(LibraryName, CallingConvention = CallingConvention.Cdecl)]
        public static extern IntPtr SDL_GetGamepadName(IntPtr gamepad);
        
        [DllImport(LibraryName, CallingConvention = CallingConvention.Cdecl)]
        public static extern short SDL_GetGamepadButton(IntPtr gamepad, SDL_GamepadButton button);
        
        [DllImport(LibraryName, CallingConvention = CallingConvention.Cdecl)]
        public static extern short SDL_GetGamepadAxis(IntPtr gamepad, SDL_GamepadAxis axis);
        
        #endregion
        
        #region SDL Joystick
        
        [DllImport(LibraryName, CallingConvention = CallingConvention.Cdecl)]
        public static extern IntPtr SDL_GetJoystickGUID(IntPtr joystick);
        
        [DllImport(LibraryName, CallingConvention = CallingConvention.Cdecl)]
        public static extern int SDL_GetJoystickGUIDString(IntPtr guid, IntPtr pszGUID, int cbGUID);
        
        #endregion
        
        #region Enums
        
        public enum SDL_GamepadButton
        {
            SDL_GAMEPAD_BUTTON_INVALID = -1,
            SDL_GAMEPAD_BUTTON_SOUTH = 0,
            SDL_GAMEPAD_BUTTON_EAST = 1,
            SDL_GAMEPAD_BUTTON_WEST = 2,
            SDL_GAMEPAD_BUTTON_NORTH = 3,
            SDL_GAMEPAD_BUTTON_BACK = 4,
            SDL_GAMEPAD_BUTTON_GUIDE = 5,
            SDL_GAMEPAD_BUTTON_START = 6,
            SDL_GAMEPAD_BUTTON_LEFT_STICK = 7,
            SDL_GAMEPAD_BUTTON_RIGHT_STICK = 8,
            SDL_GAMEPAD_BUTTON_LEFT_SHOULDER = 9,
            SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER = 10,
            SDL_GAMEPAD_BUTTON_DPAD_UP = 11,
            SDL_GAMEPAD_BUTTON_DPAD_DOWN = 12,
            SDL_GAMEPAD_BUTTON_DPAD_LEFT = 13,
            SDL_GAMEPAD_BUTTON_DPAD_RIGHT = 14,
            SDL_GAMEPAD_BUTTON_MISC1 = 15,
            SDL_GAMEPAD_BUTTON_PADDLE1 = 16,
            SDL_GAMEPAD_BUTTON_PADDLE2 = 17,
            SDL_GAMEPAD_BUTTON_PADDLE3 = 18,
            SDL_GAMEPAD_BUTTON_PADDLE4 = 19,
            SDL_GAMEPAD_BUTTON_TOUCHPAD = 20,
            SDL_GAMEPAD_BUTTON_MAX = 21
        }
        
        public enum SDL_GamepadAxis
        {
            SDL_GAMEPAD_AXIS_INVALID = -1,
            SDL_GAMEPAD_AXIS_LEFTX = 0,
            SDL_GAMEPAD_AXIS_LEFTY = 1,
            SDL_GAMEPAD_AXIS_RIGHTX = 2,
            SDL_GAMEPAD_AXIS_RIGHTY = 3,
            SDL_GAMEPAD_AXIS_LEFT_TRIGGER = 4,
            SDL_GAMEPAD_AXIS_RIGHT_TRIGGER = 5,
            SDL_GAMEPAD_AXIS_MAX = 6
        }
        
        #endregion
        
        #region Helper Methods
        
        public static string? GetGamepadNameString(IntPtr gamepad)
        {
            IntPtr namePtr = SDL_GetGamepadName(gamepad);
            return namePtr != IntPtr.Zero ? Marshal.PtrToStringAnsi(namePtr) : null;
        }
        
        #endregion
    }
    
    /// <summary>
    /// High-level controller manager using SDL3
    /// </summary>
    public class SDLControllerManager : IDisposable
    {
        private readonly List<IntPtr> _openGamepads = new();
        private bool _initialized = false;
        
        public bool Initialize()
        {
            try
            {
                int result = SDL3.SDL_Init(SDL3.SDL_InitFlags.SDL_INIT_GAMEPAD | SDL3.SDL_InitFlags.SDL_INIT_JOYSTICK);
                _initialized = (result == 0);
                return _initialized;
            }
            catch (DllNotFoundException)
            {
                Console.WriteLine("ERROR: SDL3 library not found. Controller support disabled.");
                Console.WriteLine("On macOS: brew install sdl3 (when available)");
                Console.WriteLine("On Linux: Install SDL3 development package");
                return false;
            }
        }
        
        public List<ControllerInfo> DetectControllers()
        {
            var controllers = new List<ControllerInfo>();
            
            if (!_initialized)
                return controllers;
            
            try
            {
                IntPtr gamepadsPtr = SDL3.SDL_GetGamepads(out int count);
                Console.WriteLine($"Detected {count} gamepad(s)");
                
                // TODO: Parse gamepad array and populate controllers list
                
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error detecting controllers: {ex.Message}");
            }
            
            return controllers;
        }
        
        public void Dispose()
        {
            foreach (var gamepad in _openGamepads)
            {
                SDL3.SDL_CloseGamepad(gamepad);
            }
            _openGamepads.Clear();
            
            if (_initialized)
            {
                SDL3.SDL_Quit();
                _initialized = false;
            }
        }
    }
    
    /// <summary>
    /// Controller information
    /// </summary>
    public class ControllerInfo
    {
        public int Index { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Guid { get; set; } = string.Empty;
        public int ButtonCount { get; set; }
        public int AxisCount { get; set; }
    }
}
