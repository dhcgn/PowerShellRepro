param(
    [parameter(Mandatory=$true)][string]$computername,
    [parameter(Mandatory=$true)][int]$port
    )

$tcpsocket = New-Object Net.Sockets.TcpClient($computerName, $port) 

if(!$tcpsocket)
{
    Write-Error "Error Opening Connection: $port on $computername Unreachable"
    Exit -1
}
else
{
    Write-Verbose "Successfully Connected to $computername on $port"
    
    $tcpstream = $tcpsocket.GetStream()
    
    Write-Verbose "Reading SSL Certificate...."
        
    $sslStream = New-Object System.Net.Security.SslStream($tcpstream,$false, {$true})
    
    #Force the SSL Connection to send us the certificate
    $sslStream.AuthenticateAsClient($computerName) 

    $certinfo = New-Object system.security.cryptography.x509certificates.x509certificate2($sslStream.RemoteCertificate)

    Write-Verbose $certinfo.ToString()
} 

$certinfo