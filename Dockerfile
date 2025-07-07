FROM rockylinux/rockylinux:9.6
LABEL description="Rocky Linux 9.6"
LABEL version="9.6.0"
LABEL repository="https://github.com/syslogic/wsl2-rocky-linux"
LABEL maintainer="Martin Zeitler"

VOLUME [ "/sys/fs/cgroup" ]
SHELL [ "/bin/bash", "-c" ]
ENTRYPOINT [ "/bin/bash" ]

WORKDIR "/root"
USER "root"

ENV GID=1000
ENV UID=1000

# Install RPM
RUN [ "dnf", "-y", "install", "sudo", "epel-release", "nano", "wget", "systemd", "podman-docker" ]
RUN [ "dnf", "-y", "upgrade" ]
RUN [ "dnf", "clean", "all" ]

# Enable Docker Service
RUN [ "systemctl", "enable", "podman.service" ]

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Adding group `docker`.
RUN groupadd -f -g ${GID} docker

# Adding group `docker` as sudoers drop-in config file ...
# `sudo` must be installed and the filename must not contain a dot.
RUN echo '%docker ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/docker
RUN [ "touch", "/root/.dockerenv" ]

# WSL2 config files.
COPY [ "./src/rocky.ico", "/usr/share/icons/rocky.ico" ]
COPY [ "./src/terminal-profile.json", "/usr/lib/wsl/terminal-profile.json" ]
COPY [ "./src/wsl-distribution.conf", "/etc/wsl-distribution.conf" ]
COPY [ "./src/wsl.conf", "/etc/wsl.conf" ]

# OOBE script.
COPY [ "./src/oobe.sh", "/etc/oobe.sh" ]
RUN [ "chmod", "+x", "/etc/oobe.sh" ]
