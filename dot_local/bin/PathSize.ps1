# [1] User PATH のトータル文字数を表示
$path = [Environment]::GetEnvironmentVariable("Path", "User")
$len  = $path.Length
"User PATH length: $len characters"

