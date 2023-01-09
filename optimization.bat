@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------  

echo .
echo ################################################################
echo #       Do you want disable mouse acceleration (Y/[N]) ?       #
echo #                                                              #
echo # For most users, it is not necessarily useful or even         #
echo # recommended to disable it if you use your computer with      #
echo # the trackpad.                                                #
echo #                                                              #
echo # However, it is highly recommended to disable it if you use   #
echo # your PC for gaming, as it can cause many problems in game.   #
echo ################################################################
SET /P AREYOUSURE=Type "Y" to disable mouse acceleration, or "N" to skip this step: 
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

Powershell.exe -executionpolicy remotesigned -File para\toggle_mouse_acc.ps1
cecho {9F}Successful !{#}{\n}

echo Do you want to check (Y/[N]) ?
echo The "Enhance pointer precision" box must be unchecked.
SET /P AREYOUSURE=Type "Y" to check, or "N" to skip this step: 
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

start "" "shortcuts\mouse_acc_check.lnk"

:END
endlocal

:END
endlocal

echo .
echo ################################################################
echo # Do you want to restore the Windows 10 context menu (Y/[N]) ? #
echo #                                                              #
echo # By far the most annoying new "feature" of Windows 11 is      # 
echo # the truncated context menu you get when right-clicking       # 
echo # on anything. Where prior versions of Windows showed all of   #
echo # your options, including different programs that could open   #
echo # a file, the new menus are limited to just a handful          #
echo # of choices, and not necessarily the ones you want.           #
echo ################################################################
SET /P AREYOUSURE=Type "Y" to restore the Windows 10 context menu, or "N" to skip this step: 
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

cecho {9F}Delete context menu{#}{\n}
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

:END
endlocal

echo .
echo ################################################################
echo #          Restart the Windows interface (necessary)           #
echo #                                                              #
echo # A restart of the Windows interface is necessary to confirm   #
echo # all changes made. This will make your screen blink,          #
echo # it's normal don't worry!                                     #
echo ################################################################
pause
echo Restarting explorer.exe
taskkill /F /IM explorer.exe & start explorer

echo .
echo ################################################################
echo #                      Made by Maxence                         #
echo #                                                              #
echo #     To support me, you can put a star on the GitHub repo     # 
echo #                           or/and                             # 
echo #                     follow me on GitHub                      #
echo ################################################################
SET /P AREYOUSURE=Type "Y" to get to the project's GitHub page, or "N" to skip this step: 
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

start "" "https://github.com/WaxenSs/auto-install-software"
echo Thanks !
goto END

:END
endlocal

cecho {9F}Everything went very well! You can now close this page. We hope to have been useful for you !{#}{\n}

goto END

:err
echo "Error : %errorlevel%"

:END
pause