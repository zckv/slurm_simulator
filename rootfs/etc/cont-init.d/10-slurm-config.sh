#!/command/with-contenv sh
set -eu

install -d -m 755 /var/log/slurm /var/spool/slurmctld /var/spool/slurmd /run/slurm /run/slurmdbd /etc/slurm
chmod 600 /etc/slurm/slurmdbd.conf 

if getent passwd slurm >/dev/null 2>&1; then
    chown -R slurm:slurm /var/log/slurm /var/spool/slurmctld /var/spool/slurmd /run/slurm /run/slurmdbd
fi

upsert_slurm_setting() {
    key="$1"
    value="$2"
    file="/etc/slurm/slurm.conf"

    if grep -Eq "^[[:space:]]*${key}[[:space:]]*=" "$file"; then
        sed -i -E "s|^[[:space:]]*${key}[[:space:]]*=.*$|${key}=${value}|" "$file"
    else
        printf '%s=%s\n' "$key" "$value" >> "$file"
    fi
}

# Keep the simulator in non-cgroup mode to avoid host/container cgroup compatibility issues.
upsert_slurm_setting "ProctrackType" "proctrack/linuxproc"
upsert_slurm_setting "TaskPlugin" "task/none"
upsert_slurm_setting "JobAcctGatherType" "jobacct_gather/none"

if [ -f /etc/slurm/cgroup.conf ]; then
    mv /etc/slurm/cgroup.conf /etc/slurm/cgroup.conf.disabled
fi
