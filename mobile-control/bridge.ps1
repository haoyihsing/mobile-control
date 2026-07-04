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
                "open-codex" {
                    $codex = 'C:\Program Files\WindowsApps\OpenAI.Codex_26.623.13972.0_x64__2p2nqsd0c76g0\app\Codex.exe'
                    if (Test-Path $codex) {
                        Start-Process $codex
                        $result = @{ ok = $true; action = "open-codex" }
                    } else {
                        $result = @{ ok = $false; error = "codex-not-found" }
                        $response.StatusCode = 500
                    }
                }
                "status-check" {
                    $result = @{ ok = $true; action = "status-check" }
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
