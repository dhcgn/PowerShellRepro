function Init () {
    $path = $PSScriptRoot
   
    Write-Progress "Import Scripts"

    $ScriptsToImport = Import-Csv -Path $(Join-Path -Path $path "Scripts.csv") -Delimiter ";"

    foreach ($script in $ScriptsToImport)
    {
        $scriptPath = Join-Path -Path $path ("Scripts\{0}" -f $script.Path)
        if(Test-Path $scriptPath)
        {
            Set-Alias -Name $script.Alias -Value $scriptPath
            # Write-Host "Set-Alias -Name $($script.Alias) -Value $($scriptPath)" -ForegroundColor Cyan
        }
        else
        {
            Write-Host "Script path $($scriptPath) not found" -ForegroundColor Red
        }
    }

    Write-Progress "Import Modules"

    $ModulesToImport = Import-Csv -Path $(Join-Path -Path $path "Modules.csv") -Delimiter ";"

    foreach ($module in $ModulesToImport)
    {
        $moduletPath = Join-Path -Path $path ("Modules\{0}" -f $module.Path)
        if(Test-Path $moduletPath)
        {
            Import-Module $moduletPath
            # Import-Module $moduletPath -Verbose
        }
        else
        {
            Write-Host "Module path $($moduletPath) not found" -ForegroundColor Red
        }
    }

    $ScriptsToImport | Format-Table
    $ModulesToImport | Format-Table
}

function Test-ExecutionPolicy()
{
    $ExecutionPolicy = Get-ExecutionPolicy

    if($ExecutionPolicy -ne [Microsoft.PowerShell.ExecutionPolicy]::Unrestricted)
    {
        return $false
    }
    return $true
}

# ExecutionPolicy must set to Unrestricted
if($(Test-ExecutionPolicy) -eq $false)
{
    $ExecutionPolicy = Get-ExecutionPolicy
    Write-Host "ExecutionPolicy is ""$ExecutionPolicy"", you can change this with ""Set-ExecutionPolicy Unrestricted""."  -ForegroundColor Red
    Exit
}

Clear-Host
Write-Host "Run 'Init' to init the powershell repro." -ForegroundColor Yellow

# Init

# Searching for commands with up/down arrow is really handy.  The
# option "moves to end" is useful if you want the cursor at the end
# of the line while cycling through history like it does w/o searching,
# without that option, the cursor will remain at the position it was
# when you used up arrow, which can be useful if you forget the exact
# string you started the search on.
Set-PSReadLineOption -HistorySearchCursorMovesToEnd 
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# CaptureScreen is good for blog posts or email showing a transaction
# of what you did when asking for help or demonstrating a technique.
Set-PSReadlineKeyHandler -Chord 'Ctrl+D,Ctrl+C' -Function CaptureScreen

# The built-in word movement uses character delimiters, but token based word
# movement is also very useful - these are the bindings you'd use if you
# prefer the token based movements bound to the normal emacs word movement
# key bindings.
Set-PSReadlineKeyHandler -Key Alt+D -Function ShellKillWord
Set-PSReadlineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
Set-PSReadlineKeyHandler -Key Alt+B -Function ShellBackwardWord
Set-PSReadlineKeyHandler -Key Alt+F -Function ShellForwardWord
Set-PSReadlineKeyHandler -Key Shift+Alt+B -Function SelectShellBackwardWord
Set-PSReadlineKeyHandler -Key Shift+Alt+F -Function SelectShellForwardWord