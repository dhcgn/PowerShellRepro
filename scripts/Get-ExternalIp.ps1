$urls = @("http://ipinfo.io/json","http://www.telize.com/geoip","http://ip-api.com/json")

foreach ($url in $urls)
{
    Try
    {
        $request = Invoke-WebRequest $url -UseDefaultCredentials -Proxy ([System.Net.WebRequest]::GetSystemWebProxy().GetProxy($url)) -ProxyUseDefaultCredentials
        $content = $request.Content       

        $ipRequest = ConvertFrom-Json $content
        if($ipRequest.ip -ne $null)
        {
            Write-Host $url
            $ipRequest.ip
            exit
        }
        if($ipRequest.query -ne $null)
        {
            Write-Host $url
            $ipRequest.query
            exit
        }       
    }
    Catch
    {
        # Try next url   
    }
}