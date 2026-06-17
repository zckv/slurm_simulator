# slurm_simulator

Single-container Slurm simulator built on Rocky Linux 9 with the official
Slurm packages, MariaDB, Munge, and s6-overlay.

The image is meant to provide a lightweight Slurm environment that is good
enough for CI/CD and local testing.

## Current layout

- `Dockerfile` installs the runtime packages and s6-overlay, then copies
  `rootfs/` into the image.
- `rootfs/etc/cont-init.d/` contains bootstrap scripts for Munge, MariaDB,
  and Slurm configuration.
- `rootfs/etc/s6-overlay/s6-rc.d/` defines the supervised services and their
  log pipelines.
- `rootfs/etc/slurm/*.conf` contains the Slurm configuration templates that are
rewritten at startup.
- `rootfs/etc/my.cnf.d/` contains the MariaDB client/server socket settings.

## Services

s6-overlay supervises `mariadb`, `munged`, `slurmctld`, `slurmd`, and
`slurmdbd` in the same container.

Slurm authentication uses `/run/munge/munge.socket.2`, and
`cont-init.d/10-slurm-config.sh` rewrites `slurm.conf`, `nodes.conf`, and
`partitions.conf` from the hostname defined at launch.

By default the image simulates about ten nodes and exposes a `debug`
partition plus a `long` partition, so you can exercise partition creation
without starting ten `slurmd` instances.

Set `SLURM_SIM_NODE_COUNT` if you want to change the number of simulated
nodes.

## Local build and run

```bash
docker build -t slurm-small-sim .
docker run --rm slurm-small-sim
```
