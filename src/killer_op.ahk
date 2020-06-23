; killer_op.ahk

#NoTrayIcon
#SingleInstance force

KillAndRestart(exe := "") {
    Process, Exist, % exe
    If (!ErrorLevel=0) {
        Process, Close, % exe
    }

    Run % exe
    WinActivate, % Format("ahk_exe {1}", exe)
    Sleep 500

    in_wine := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str", "ntdll", "Ptr"), "AStr", "wine_get_version", "Ptr")

    if in_wine {
        Sleep 500
        Send "{Alt down}{Alt up}fn"
    } else {
        WinMenuSelectItem % Format("ahk_exe {1}", exe),, File, % Format("{1}", "Start Kaillera...")
        WinMenuSelectItem % Format("ahk_exe {1}", exe),, File, % Format("{1}", "Start Netplay...")
    }
}

; entry point
SplitPath, A_ScriptFullPath,, SELF_DIR
PROJECT64_FORMAT := Format("{1}\Project64*.exe", SELF_DIR)

loop, files, %PROJECT64_FORMAT%
{
    ; never activate on self
    if (A_LoopFileName and A_LoopFileName != A_ScriptName) {
        KillAndRestart(A_LoopFileName)
    }
}

ExitApp
