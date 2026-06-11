#!/command/with-contenv sh
set -eu

install -d -m 755 /var/log/slurm /var/spool/slurmctld /var/spool/slurmd /run/slurm /run/slurmdbd /etc/slurm
chmod 600 /etc/slurm/slurmdbd.conf 

if getent passwd slurm >/dev/null 2>&1; then
    chown -R slurm:slurm /var/log/slurm /var/spool/slurmctld /var/spool/slurmd /run/slurm /run/slurmdbd
fi
