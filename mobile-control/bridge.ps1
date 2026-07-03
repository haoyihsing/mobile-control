param(
    [int]$Port = 8765,
    [string]$Token = "change-me-now"
)

$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://127.0.0.1:$Port/")

try {
    $listener.Start()
    Write-Host "Listening on http://127.0.0.1:$Port/"
    Write-Host "Waiting for POST /run with token in the JSON body."

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        try {
            if ($request.HttpMethod -ne "POST" -or $request.Url.AbsolutePath -ne "/run") {
                $response.StatusCode = 404
                continue
            }

            $reader = [System.IO.StreamReader]::new($request.InputStream, $request.ContentEncoding)
            $body = $reader.ReadToEnd()
            $reader.Close()

            $payload = $body | ConvertFrom-Json

            if ($payload.token -ne $Token) {
                $response.StatusCode = 401
                $bytes = [System.Text.Encoding]::UTF8.GetBytes('{"ok":false,"error":"unauthorized"}')
                $response.OutputStream.Write($bytes, 0, $bytes.Length)
                continue
            }

            switch ($payload.action) {
                "open-chromium" {
                    Start-Process -WindowStyle Hidden 'D:\Codex\chromium\chrome-win\chrome.exe'
                    $result = @{ ok = $true; action = "open-chromium" }
                }
                default {
                    $result = @{ ok = $false; error = "unknown action" }
                    $response.StatusCode = 400
                }
            }

            $json = $result | ConvertTo-Json -Compress
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
            $response.ContentType = "application/json"
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        }
        finally {
            $response.OutputStream.Close()
        }
    }
}
finally {
    if ($listener.IsListening) {
        $listener.Stop()
    }
    $listener.Close()
}

