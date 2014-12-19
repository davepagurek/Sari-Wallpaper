Dim WinScriptHost
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & "C:\wp\wallpaper.exe" & Chr(34), 0
Set WinScriptHost = Nothing