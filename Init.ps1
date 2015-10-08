

function Test-ExecutionPolicy()
{
    $ExecutionPolicy = Get-ExecutionPolicy

    if($ExecutionPolicy -ne [Microsoft.PowerShell.ExecutionPolicy]::Unrestricted)
    {
        return $false
    }
    return $true
}

# Testet ob die ExecutionPolicy auf Unrestricted gesetzt ist, sollte dies nicht der Fall sein.
if($(Test-ExecutionPolicy) -eq $false)
{
    $ExecutionPolicy = Get-ExecutionPolicy
    Write-Host "ExecutionPolicy steht auf ""$ExecutionPolicy"", bitte führen Sie als lokaler Admin ""Set-ExecutionPolicy Unrestricted"" aus."  -ForegroundColor Red
    Exit
}

$path = (split-path -parent $MyInvocation.MyCommand.Definition) + "\"

Write-Progress "Import Scripts"

$ScriptsToImport = Import-Csv -Path "$($path)Scripts.csv" -Delimiter ";"

foreach ($script in $ScriptsToImport)
{
    $scriptPath = $path + "Scripts\" + $script.Path
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

Exit 1

Write-Progress "Import Modules"

$ModulesToImport = Import-Csv -Path "$($path)Modules.csv" -Delimiter ";"

foreach ($module in $ModulesToImport)
{
    $moduletPath = $path + "Modules\" + $module.Path
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