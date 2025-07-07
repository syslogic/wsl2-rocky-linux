#!/usr/bin/env pwsh
docker build -t syslogic/wsl2-rocky-linux:latest .
docker image ls

$FILENAME="Rocky.x86_64-9.wsl"
If (Test-Path .\$FILENAME) { Remove-Item .\$FILENAME }
If (Test-Path .\rocky96_dist.wsl) { Remove-Item .\rocky96_dist.wsl }


# The inner *.wsl wrap is TAR
docker run --name wsl2-rocky-linux syslogic/wsl2-rocky-linux:latest
$CID=$(docker create syslogic/wsl2-rocky-linux:latest --name wsl2-rocky-linux)
docker export --output $FILENAME $CID


# The outer *.wsl wrap is GZip
gzip --force --best .\$FILENAME
If (Test-Path ".\$FILENAME.gz") {

    Rename-Item ".\$FILENAME.gz" .\rocky96_dist.wsl

    Get-Item -Path .\rocky96_dist.wsl | Select -Property Name, Length | Foreach {
        Write-Host $_.Name $("has `{0:N2} mb" -f ($_.Length/1048576))
    };

    wsl --unregister RockyLinux_9_6
    wsl --import RockyLinux_9_6 "$env:USERPROFILE\AppData\Local\wsl\rocky96" .\rocky96_dist.wsl
    wsl --list --verbose
}
