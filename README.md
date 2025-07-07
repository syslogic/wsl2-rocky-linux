### WSL2 Distro Builder: Rocky Linux

The official base-images could also be obtained from `rockylinux.org`.

- [`Rocky-9-WSL-Base-9.6-20250531.0.x86_64.wsl`](https://dl.rockylinux.org/pub/rocky/9.6/images/x86_64/Rocky-9-WSL-Base-9.6-20250531.0.x86_64.wsl)
- [`Rocky-10-WSL-Base-10.0-20250611.0.x86_64.wsl`](https://dl.rockylinux.org/pub/rocky/10.0/images/x86_64/Rocky-10-WSL-Base-10.0-20250611.0.x86_64.wsl)

 ---

### Development

There's just one [`Dockerfile`](https://github.com/syslogic/wsl2-rocky-linux/blob/master/Dockerfile) and a build-script called [`.\refresh.ps1`](https://github.com/syslogic/wsl2-rocky-linux/blob/master/refresh.ps1)<br/>
which builds a Rocky RHEL image and then converts it to [WSL](https://github.com/microsoft/WSL) engine.

![Screenshot 01](https://raw.githubusercontent.com/syslogic/wsl2-rocky-linux/master/screenshots/screenshot_01.png)
 