#!/usr/bin/env pwsh
$IMAGE="syslogic/wsl2-rocky-linux:latest"
$FILENAME_A="Rocky.x86_64.wsl"
$FILENAME_B="Rocky.x86_64-9.6.wsl"

# Remove previous *.wsl files
If (Test-Path .\$FILENAME_A) { Remove-Item .\$FILENAME_A }
If (Test-Path .\$FILENAME_B) { Remove-Item .\$FILENAME_B }

# Build image
docker build -t $IMAGE .
docker image ls
Write-Host ""

# Inner TAR wrap, containing rootfs.
docker run $IMAGE
$CID=$(docker create $IMAGE)
docker export --output $FILENAME_A $CID

# Outer GZip wrap
gzip --force --best .\$FILENAME_A
If (Test-Path ".\$FILENAME_A.gz") {

    Rename-Item ".\$FILENAME_A.gz" .\$FILENAME_B
    Get-Item -Path .\$FILENAME_B | Select -Property Name, Length | Foreach {
        Write-Host $_.Name $("has `{0:N2} mb" -f ($_.Length/1048576))
    };

    wsl --unregister RockyLinux_9_6
    wsl --import RockyLinux_9_6 "$env:USERPROFILE\AppData\Local\wsl\rocky96" .\$FILENAME_B
    # wsl --set-default RockyLinux_9_6
    wsl --list --verbose
}
