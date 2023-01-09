# Check registry for mouse acc enabled/disabled and toggle the registry entries
# Note:
#   Updating the registry entries does not result in a change in the running system,
#   the change will probably only come to effect once the system is restarted.
#   We use the registry for state tracking and for completeness (if the system gets restarted)

$RegConnect = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]"CurrentUser","$env:COMPUTERNAME")
$RegMouse = $RegConnect.OpenSubKey("Control Panel\Mouse",$true)

$acc_enabled = $RegMouse.GetValue("MouseSpeed")

if ( $acc_enabled -eq 1 ) {
    # mouse acc is enabled -> disable mouse acc

    $RegMouse.SetValue("MouseSpeed","0")
    $RegMouse.SetValue("MouseThreshold1","0")
    $RegMouse.SetValue("MouseThreshold2","0")

    $sys_pvParam = @(0,0,0)

    echo "Mouse acceleration has been successfully disabled."
} else {
    echo "Mouse acceleration is already disabled."
}

$RegMouse.Close()
$RegConnect.Close()


# Updates the actual system settings for mouse acceleration
# and propagates the changes to the running system

$code = @'
[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
 public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, int[] pvParam, uint fWinIni);
'@

Add-Type $code -name Win32 -NameSpace System

[System.Win32]::SystemParametersInfo(4,0,$sys_pvParam,2)  # last parameter (2) is used to propagate the changes to the running system
