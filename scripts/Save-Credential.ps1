param(
    [Parameter(Mandatory=$True)]
    [string]$CredentialName
    )

$path = (([System.IO.Path]::GetDirectoryName($PROFILE.CurrentUserCurrentHost))+ '\Credentials\'+$CredentialName+'.xml')
$dir = ([System.IO.Path]::GetDirectoryName($path))
if((Test-Path ($dir)) -eq $false)
{
    New-Item -Path $dir -ItemType Directory
}

$cred = Get-Credential
$cred | Export-Clixml $path
