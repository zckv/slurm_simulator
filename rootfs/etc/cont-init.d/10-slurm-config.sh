#!/command/with-contenv sh
set -eu

# Setup slurm env
install -d -m 755 /var/log/slurm /var/spool/slurmctld /var/spool/slurmd /run/slurm /run/slurmdbd /etc/slurm
chmod 600 /etc/slurm/slurmdbd.conf 
if getent passwd slurm >/dev/null 2>&1; then
    chown -R slurm:slurm /var/log/slurm /var/spool/slurmctld /var/spool/slurmd /run/slurm /run/slurmdbd
fi

if ! read -r runtime_hostname< <(hostname); then
    echo "runtime hostname is empty"
    exit 1
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

upsert_slurm_setting "SlurmctldHost" "$runtime_hostname"
# Keep the simulator in non-cgroup mode to avoid host/container cgroup compatibility issues.
# upsert_slurm_setting "ProctrackType" "proctrack/linuxproc"
# upsert_slurm_setting "TaskPlugin" "task/none"
# upsert_slurm_setting "JobAcctGatherType" "jobacct_gather/none"

# Default /etc/slurm/nodes.conf
if (( 0 == 1 )) ; then
    nodes="node[01-10]"
    # TODO: detect env true
    sockets=1
    cores_per_socket=16
    threads_per_core=2
    printf 'NodeName=%s RealMemory=248000 Sockets=%s CoresPerSocket=%s ThreadsPerCore=%s State=UNKNOWN NodeAddr=%s NodeHostName=%s\n' \
        "$nodes" "$sockets" "$cores_per_socket" "$threads_per_core" "$nodes" "$nodes" >> /etc/slurm/nodes.conf
    # Default /etc/slurm/partitions.conf
    if [ ! -f /etc/slurm/partitions.conf ]; then
        printf 'PartitionName=default Nodes=%s Default=YES State=UP OverSubscribe=NO MaxTime=14-00:00:00\n' "$nodes" >> /etc/slurm/partitions.conf
    fi
fi


