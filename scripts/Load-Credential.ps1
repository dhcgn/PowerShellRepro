param(
    [Parameter(Mandatory=$True)]
    [string]$CredentialName
    )

$path = (([System.IO.Path]::GetDirectoryName($PROFILE.CurrentUserCurrentHost))+ '\Credentials\'+$CredentialName+'.xml')
if(Test-Path ($path ))
{
	Import-Clixml $path
}else
{
	Write-Host "Datei $path nicht vorhanden."
}
