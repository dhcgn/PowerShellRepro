param(
    [parameter(Mandatory=$true)][string]$Cid,
    [parameter(Mandatory=$true)][PSCredential]$Credential
    )

$PsDriveName = "OneDrive"
$Root = ("\\d.docs.live.net@SSL\DavWWWRoot\{0}" -f $Cid)

New-PSDrive -Name $PsDriveName -Root $Root -PSProvider FileSystem  -Credential $Credential -Scope Global