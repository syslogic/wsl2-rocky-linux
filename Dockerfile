FROM rockylinux/rockylinux:9.6
LABEL description="Rocky Linux 9.6"
LABEL version="9.6.0"
LABEL repository="https://github.com/syslogic/wsl2-rocky-linux"
LABEL maintainer="Martin Zeitler"

ARG RUNNER_GID="1000"
ARG RUNNER_UID="1000"
ENV GID="${RUNNER_GID}"
ENV UID="${RUNNER_UID}"
ENV container=docker

VOLUME [ "/sys/fs/cgroup" ]
SHELL [ "/bin/bash", "-c" ]
ENTRYPOINT [ "/bin/bash" ]

USER "root"
WORKDIR "/root"

# Configuring further package repositories: https://wiki.rockylinux.org/rocky/repo/#extra-repositories
RUN [ "dnf", "-y", "install", "sudo", "epel-release", "nano", "wget", "systemd", "podman-docker", "wsl-setup" ]
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

# Adding user `runner` provides the home directory.
RUN useradd -g ${GID} -u ${UID} -s /bin/bash runner

RUN [ "touch", "/root/.dockerenv", "/home/runner/.dockerenv" ]
RUN [ "chown", "-R", "runner:docker", "/home/runner" ]

# WSL2 config files.
COPY [ "./usr/share/pixmaps/fedora-logo.ico", "/usr/share/pixmaps/fedora-logo.ico" ]
COPY [ "./usr/lib/wsl/terminal-profile.json", "/usr/lib/wsl/terminal-profile.json" ]
COPY [ "./etc/wsl-distribution.conf", "/etc/wsl-distribution.conf" ]
COPY [ "./etc/wsl.conf", "/etc/wsl.conf" ]

# OOBE script.
COPY [ "./etc/oobe.sh", "/etc/oobe.sh" ]
RUN [ "chmod", "+x", "/etc/oobe.sh" ]

#RUN [ "wsl-setup", "--name", "RockyLinux_9_6" ]

# Run commands as by default as user `runner`.
# USER "runner"
# WORKDIR "/home/runner"
# RUN source ~/.bash_profile
