ipconfig /flushdns
regedit /s SG_Vista_TcpIp_Patch.reg
del SG_Vista_TcpIp_Patch.reg
 %Sys32%reg.exe ADD "HKLM\SYSTEM\ControlSet001\Services\Tcpip\Parameters" /v EnableTCPChimney /t REG_DWORD /d 0 /f
 %Sys32%reg.exe ADD "HKLM\SYSTEM\ControlSet001\Services\Tcpip\Parameters" /v EnableTCPA /t REG_DWORD /d 0 /f
 %Sys32%reg.exe ADD "HKLM\SYSTEM\ControlSet001\Services\Tcpip\Parameters" /v DisableTaskOffload /t REG_DWORD /d 1 /f
Sys32%netsh.exe int tcp set global rsc=enabled
%Sys32%netsh.exe int tcp set global ecncapability=disabled
%Sys32%netsh.exe int tcp set global autotuninglevel=disabled
%Sys32%netsh.exe int tcp set heuristics disabled
%Sys32%netsh.exe int tcp set global chimney=disabled
%Sys32%netsh.exe int tcp set global dca=enabled
%Sys32%netsh.exe int tcp set global rss=enabled
%Sys32%netsh.exe int tcp set global netdma=enabled
%Sys32%netsh.exe int tcp set global timestamps=disabled
%Sys32%netsh.exe int tcp set global nonsackrttresiliency=disabled
netsh interface tcp set heuristics disabled
netsh int tcp set global autotuninglevel=normal
goto menu

for /f "usebackq" %%i in (`reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces`) do (
Reg.exe add %%i /v "TCPNoDelay" /d "1" /t REG_DWORD /f
Reg.exe add %%i /v "TcpAckFrequency" /d "1" /t REG_DWORD /f
Reg.exe add %%i /v "TCPDelAckTicks" /d "0" /t REG_DWORD /f
) >nul 2>&1

(
sc config "BITS" start= auto
sc start "BITS"
for /f "tokens=3" %%a in ('sc queryex "BITS" ^| findstr "PID"') do (set pid=%%a)
) >nul 2>&1
wmic process where ProcessId=%pid% CALL setpriority "realtime"
goto :done