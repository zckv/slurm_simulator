FROM rockylinux:9

RUN dnf -y install epel-release && \
    dnf -y install slurm slurm-slurmctld munge supervisor

# Créer et sécuriser les répertoires munge
RUN mkdir -p /var/log/munge /run/munge && \
    create-munge-key && \
    chown -R root:root /var/log/munge /run/munge /etc/munge && \
    chmod 700 /var/log/munge /run/munge && \
    chmod 711 /run/munge 

# Configuration supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf


CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
