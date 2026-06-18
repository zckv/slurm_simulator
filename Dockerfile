FROM rockylinux:9

ARG S6_OVERLAY_VERSION=3.2.3.0

RUN dnf install -y dnf-plugins-core && \
    dnf config-manager --set-enabled crb && \
    dnf -y install autoconf automake bash-completion mariadb-server mariadb-devel munge munge-devel pam-devel perl perl-devel readline-devel rpmdevtools tar wget xz
 
RUN mkdir /tmp/slurm && cd /tmp/slurm && \
    wget https://github.com/SchedMD/slurm/releases/download/slurm-25-05-8-1/slurm-25.05.8.tar.bz2 && \
    rpmbuild -ta slurm-25.05.8.tar.bz2 && \
    cd /root/rpmbuild/RPMS/x86_64/ && \
    rpm -i slurm-25.05.8*.rpm slurm-slurmd-25.05.8*.rpm slurm-slurmdbd-25.05.8*.rpm slurm-slurmctld-25.05.8*.rpm

RUN curl -fsSL -o /tmp/s6-overlay-noarch.tar.xz \
        https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz && \
    curl -fsSL -o /tmp/s6-overlay-x86_64.tar.xz \
        https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz && \
    rm -f /tmp/s6-overlay-noarch.tar.xz /tmp/s6-overlay-x86_64.tar.xz

RUN dnf remove -y autoconf automake binutils dnf-plugins-core findutils mariadb-devel munge-devel pam-devel perl-devel readline-devel rpmdevtools tar wget xz && \
    dnf autoremove -y && \
    dnf clean all && \
    rm /tmp/slurm /root/rpmbuild -rdf 

#### Shorten image

FROM rockylinux:9

COPY --from=0 / /
COPY rootfs/ /

RUN mkdir -p /var/log/munge /var/log/slurm/slurmctld /var/log/slurm/slurmd /var/log/slurm/slurmdbd /var/log/mariadb /run/munge /run/slurm /run/slurmdbd /run/mariadb /var/lib/mysql /var/spool/slurmctld /var/spool/slurmd /etc/cont-init.d /etc/my.cnf.d /etc/s6-overlay/s6-rc.d/user/contents.d

ENTRYPOINT ["/init"]
