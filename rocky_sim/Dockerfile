FROM rockylinux:9

ARG S6_OVERLAY_VERSION=3.2.1.0

RUN dnf -y install epel-release && \
    dnf -y install tar xz slurm slurm-slurmctld slurm-slurmd munge && \
    dnf clean all && \
    mkdir -p /var/log/munge /var/log/slurm/slurmctld /var/log/slurm/slurmd /run/munge /run/slurm /var/spool/slurmctld /var/spool/slurmd /etc/cont-init.d /etc/services.d

RUN curl -fsSL -o /tmp/s6-overlay-noarch.tar.xz \
        https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz && \
    curl -fsSL -o /tmp/s6-overlay-x86_64.tar.xz \
        https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz && \
    rm -f /tmp/s6-overlay-noarch.tar.xz /tmp/s6-overlay-x86_64.tar.xz

COPY rootfs/ /

RUN chmod +x /etc/cont-init.d/*.sh /etc/services.d/*/run /etc/services.d/*/log/run

CMD ["/init"]
