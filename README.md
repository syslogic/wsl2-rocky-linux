## WSL2 Distro Builder

There's one [`Dockerfile`](https://github.com/syslogic/wsl2-rocky-linux/blob/master/Dockerfile) and the build-script is being called: [`.\refresh.ps1`](https://github.com/syslogic/wsl2-rocky-linux/blob/master/refresh.ps1)<br/>
which builds a Rocky Linux image and converts it into a [WSL](https://github.com/microsoft/WSL) Linux distribution.

### Prerequisites
- [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install) 
- [GZip for Windows](https://gnuwin32.sourceforge.net/packages/gzip.htm) on `$PATH`
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [PowerShell Core](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.5#install-powershell-using-winget-recommended)

### Installation

a) The script ultimately runs `wsl --import`, which means the distribution is being installed.<br/>
b) When double-clicking `Rocky.x86_64-9.6.wsl`, it will install it with distribution-name `runner`.

![Screenshot 01](https://raw.githubusercontent.com/syslogic/wsl2-rocky-linux/master/screenshots/screenshot_01.png)

### Uninstall

The command would be:

 - `wsl --unregister RockyLinux_9_6`
 - `wsl --unregister runner`

 ---

The official base-images could also be obtained directly from [`rockylinux.org`](https://rockylinux.org).

- [`Rocky-9-WSL-Base-9.6-20250531.0.x86_64.wsl`](https://dl.rockylinux.org/pub/rocky/9.6/images/x86_64/Rocky-9-WSL-Base-9.6-20250531.0.x86_64.wsl)
- [`Rocky-10-WSL-Base-10.0-20250611.0.x86_64.wsl`](https://dl.rockylinux.org/pub/rocky/10.0/images/x86_64/Rocky-10-WSL-Base-10.0-20250611.0.x86_64.wsl)
