#Requires -RunAsAdministrator

[cmdletbinding(PositionalBinding = $false)]
param (
    [string]$Flavor = "test-distro",
    [string]$Version = "test-distro-v1",
    [string]$FriendlyName = "Test distribution version 1")

Set-StrictMode -Version latest

$TarPath = Resolve-Path "C:/Home/WSL2/rocky9/rocky9.tar"
$hash = (Get-Filehash $TarPath -Algorithm SHA256).Hash

$manifest= @{
    ModernDistributions=@{
        "$Flavor" = @(
            @{
                "Name" = "$Version"
                Default = $true
                FriendlyName = "$FriendlyName"
                Amd64Url = @{
                    Url = "file://$TarPath"
                    Sha256 = "0x$hash"
                }
            })
    }
}

$manifestFile = "$PSScriptRoot/manifest.json"
$manifest | ConvertTo-Json -Depth 5 | Out-File -encoding ascii $manifestFile

Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss" -Name DistributionListUrl -Value "file://$manifestFile" -Type String -Force
