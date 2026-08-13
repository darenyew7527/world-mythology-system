param(
    [ValidateRange(1024, 65535)]
    [int]$Port = 8765
)

$ErrorActionPreference = 'Stop'
$WebRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot 'web\dist'))
$IndexPath = Join-Path $WebRoot 'index.html'

if (-not (Test-Path -LiteralPath $IndexPath -PathType Leaf)) {
    Write-Error 'The prebuilt website is missing: web\dist\index.html'
    exit 1
}

$MimeTypes = @{
    '.html' = 'text/html; charset=utf-8'
    '.js' = 'text/javascript; charset=utf-8'
    '.css' = 'text/css; charset=utf-8'
    '.json' = 'application/json; charset=utf-8'
    '.svg' = 'image/svg+xml'
    '.png' = 'image/png'
    '.jpg' = 'image/jpeg'
    '.jpeg' = 'image/jpeg'
    '.woff2' = 'font/woff2'
    '.map' = 'application/json; charset=utf-8'
}

function Write-HttpResponse {
    param(
        [Net.Sockets.NetworkStream]$Stream,
        [int]$StatusCode,
        [string]$StatusText,
        [string]$ContentType,
        [byte[]]$Body,
        [bool]$HeadOnly = $false
    )
    $Header = "HTTP/1.1 $StatusCode $StatusText`r`nContent-Type: $ContentType`r`nContent-Length: $($Body.Length)`r`nCache-Control: no-cache`r`nConnection: close`r`n`r`n"
    $HeaderBytes = [Text.Encoding]::ASCII.GetBytes($Header)
    $Stream.Write($HeaderBytes, 0, $HeaderBytes.Length)
    if (-not $HeadOnly -and $Body.Length -gt 0) {
        $Stream.Write($Body, 0, $Body.Length)
    }
}

$Listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback, $Port)
try {
    $Listener.Start()
    $Url = "http://127.0.0.1:$Port/"
    Write-Host "World Mythology System is running at $Url"
    Write-Host 'Close this window or press Ctrl+C to stop.'
    Start-Process $Url

    while ($true) {
        $Client = $Listener.AcceptTcpClient()
        $Stream = $null
        $Reader = $null
        try {
            $Stream = $Client.GetStream()
            $Reader = [IO.StreamReader]::new($Stream, [Text.Encoding]::ASCII, $false, 1024, $true)
            $RequestLine = $Reader.ReadLine()
            if ([string]::IsNullOrWhiteSpace($RequestLine)) { continue }
            while (-not [string]::IsNullOrEmpty($Reader.ReadLine())) { }

            $Parts = $RequestLine.Split(' ')
            if ($Parts.Length -lt 2 -or $Parts[0] -notin @('GET', 'HEAD')) {
                Write-HttpResponse $Stream 405 'Method Not Allowed' 'text/plain; charset=utf-8' ([Text.Encoding]::UTF8.GetBytes('Method Not Allowed'))
                continue
            }

            $RequestUri = [Uri]("http://127.0.0.1" + $Parts[1])
            $RelativePath = [Uri]::UnescapeDataString($RequestUri.AbsolutePath).TrimStart('/')
            if ([string]::IsNullOrWhiteSpace($RelativePath)) { $RelativePath = 'index.html' }
            $Candidate = [IO.Path]::GetFullPath((Join-Path $WebRoot $RelativePath))
            $AllowedPrefix = $WebRoot.TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
            if (-not $Candidate.StartsWith($AllowedPrefix, [StringComparison]::OrdinalIgnoreCase)) {
                Write-HttpResponse $Stream 403 'Forbidden' 'text/plain; charset=utf-8' ([Text.Encoding]::UTF8.GetBytes('Forbidden'))
                continue
            }
            if (-not (Test-Path -LiteralPath $Candidate -PathType Leaf)) {
                Write-HttpResponse $Stream 404 'Not Found' 'text/plain; charset=utf-8' ([Text.Encoding]::UTF8.GetBytes('Not Found'))
                continue
            }

            $Body = [IO.File]::ReadAllBytes($Candidate)
            $Extension = [IO.Path]::GetExtension($Candidate).ToLowerInvariant()
            $ContentType = if ($MimeTypes.ContainsKey($Extension)) { $MimeTypes[$Extension] } else { 'application/octet-stream' }
            Write-HttpResponse $Stream 200 'OK' $ContentType $Body ($Parts[0] -eq 'HEAD')
        }
        catch {
            Write-Warning $_.Exception.Message
        }
        finally {
            if ($null -ne $Reader) { $Reader.Dispose() }
            if ($null -ne $Stream) { $Stream.Dispose() }
            $Client.Dispose()
        }
    }
}
finally {
    $Listener.Stop()
}
