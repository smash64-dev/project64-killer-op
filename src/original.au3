#Region
	#AutoIt3Wrapper_Icon=C:\Users\JaimeHR\Downloads\JandsomeHR.ico
	#AutoIt3Wrapper_OutFile=Project64killerOPv3.exe
#EndRegion

Func project64k()
	ProcessClose("project64k.exe")
	Run("project64k.exe")
	Sleep(50)
	ProcessWait("project64k.exe", 30)
	WinActivate("Project64K 0.13 Core 1.4")
	SendKeepActive("Project64K 0.13 Core 1.4")
	Sleep(50)
	Send("{ALTDOWN}{ALTUP}fn")
	Sleep(1000)
	SendKeepActive("")
EndFunc

Func project64kve()
	ProcessClose("project64kve.exe")
	Run("project64kve.exe")
	Sleep(50)
	ProcessWait("project64kve.exe", 30)
	WinActivate("Project64KVE 0.13 Core 1.4")
	SendKeepActive("Project64KVE 0.13 Core 1.4")
	Sleep(50)
	Send("{ALTDOWN}{ALTUP}fn")
	Sleep(1000)
	SendKeepActive("")
EndFunc

If FileExists("project64k.exe") Then project64k()
If FileExists("project64kve.exe") Then project64kve()
