; killer_op.ahk

#NoTrayIcon
#SingleInstance force

KillAndRestart(exe := "") {
    Process, WaitClose, % exe, 15
    Run % exe
    WinActivate, % Format("ahk_exe {1}", exe)
    WinMenuSelectItem % Format("ahk_exe {1}", exe),, File, Start Netplay...
    WinMenuSelectItem % Format("ahk_exe {1}", exe),, File, Start Kaillera...
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
