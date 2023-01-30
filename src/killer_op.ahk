; killer_op.ahk

#NoTrayIcon
#SingleInstance force

AutoServerQueue(ip, game_keys, want_record := "0") {
    if (ip == "__UNSET__" || game_keys == "__UNSET__") {
        return
    }

    ; window/control text
    change_mode := "Change Mode:"
    create_btn := "Create"
    custom_ip := "Custom IP"
    game_send := Format("{1}{2}", game_keys, "{Enter}")
    mode_box := "ComboBox2"
    record_game := "Record game"

    SetTitleMatchMode, Regex
    SetControlDelay -1
    SetKeyDelay 2

    ; determine current mode
    WinWait,, % change_mode, 3
    if ErrorLevel {
        return
    }

    WinActivate,, % change_mode
    WinWaitActive,, % change_mode, 3
    if ErrorLevel {
        return
    }

    ; set correct mode
    ControlGetText, current_mode, % mode_box
    if ErrorLevel {
        mode_box := "ComboBox1"
        ControlGetText, current_mode, % mode_box
    }
    if (change_mode != "2. Client") {
        Control, Choose, 2, % mode_box
    }

    ; enter server ip
    ControlClick, % custom_ip,, % change_mode
    WinWaitActive,, % custom_ip, 3
    if ErrorLevel {
        return
    }

    ; connect to server
    ControlSetText, Edit1, % ip, % custom_ip
    ControlClick, Button1, % custom_ip
    WinClose, % custom_ip
    Sleep 1000

    WinActivate,, % create_btn
    WinWaitActive,, % create_btn, 5
    if ErrorLevel {
        MsgBox wait create
        return
    }
    Sleep 1000

    ; handle no connection
    WinGetActiveTitle, server_response
    if InStr(server_response, "Connecting") {
        return
    }

    ; start game
    WinWaitActive,, % create_btn, 5
    ControlClick, % create_btn,, % create_btn
    Sleep 500
    ControlSend,, %game_send%,, % create_btn

    create_btn := "Swap"
    WinActivate,, % create_btn
    WinWaitActive,, % create_btn, 3
    if ErrorLevel {
        return
    }

    ; record game
    ControlGet, will_record, Checked,, % record_game,, % create_btn
    if (will_record != want_record) {
        ControlClick, % record_game,, % create_btn
    }
}

Kill(exe := "") {
    Process, Exist, % exe
    If (!ErrorLevel=0) {
        Process, Close, % name
    }
}

KillAndRestart(exe := "") {
    Kill(exe)
    Run % exe
    WinActivate, % Format("ahk_exe {1}", exe)
    Sleep 1000

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
KAILLERA_CONFIG := Format("{1}\Net\cfg", SELF_DIR)

if FileExist(KAILLERA_CONFIG) {
    IniRead, AUTO_SERVER_IP, % KAILLERA_CONFIG, auto_server, ip, __UNSET__
    IniRead, AUTO_SERVER_GAME, % KAILLERA_CONFIG, auto_server, game, __UNSET__
    IniRead, AUTO_SERVER_RECORD, % KAILLERA_CONFIG, auto_server, record, "0"
}

Kill("package-updater.exe")
loop, files, %PROJECT64_FORMAT%
{
    ; never activate on self
    if (A_LoopFileName and A_LoopFileName != A_ScriptName) {
        KillAndRestart(A_LoopFileName)
        AutoServerQueue(AUTO_SERVER_IP, AUTO_SERVER_GAME, AUTO_SERVER_RECORD)
    }
}

ExitApp
