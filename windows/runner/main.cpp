#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"
#include <shlwapi.h>
#pragma comment(lib, "shlwapi.lib")

void RegisterCustomUriProtocol() {
  HKEY hKey;
  const wchar_t* protocol = L"com.example.smartconsultor";

  // Kiểm tra xem key đã tồn tại chưa
  if (RegOpenKeyExW(HKEY_CLASSES_ROOT, protocol, 0, KEY_READ, &hKey) != ERROR_SUCCESS) {
    // Nếu chưa, tạo key
    if (RegCreateKeyW(HKEY_CLASSES_ROOT, protocol, &hKey) == ERROR_SUCCESS) {
      RegSetValueW(hKey, nullptr, REG_SZ, L"URL:My Flutter App Protocol", 0);
      RegSetValueW(hKey, L"URL Protocol", REG_SZ, L"", 0);

      HKEY commandKey;
      if (RegCreateKeyW(hKey, L"shell\\open\\command", &commandKey) == ERROR_SUCCESS) {
        WCHAR path[MAX_PATH];
        GetModuleFileNameW(nullptr, path, MAX_PATH);
        std::wstring command = L"\"" + std::wstring(path) + L"\" \"%1\"";
        RegSetValueW(commandKey, nullptr, REG_SZ, command.c_str(), 0);
        RegCloseKey(commandKey);
      }

      RegCloseKey(hKey);
    }
  }
}


int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  RegisterCustomUriProtocol();

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"smartconsultor", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
