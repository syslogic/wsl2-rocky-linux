docker save --platform linux/amd64 -o rocky9.tar syslogic/wsl2-rocky-linux:latest
# wsl --unregister RockyLinux_9_6
gzip --keep --force --best .\rocky9.tar > .\install.tar.gz
wsl --import RockyLinux_9_6 C:\Users\marti\AppData\Local\wsl\rocky9 .\install.tar.gz
