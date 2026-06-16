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
- `rootfs/etc/slurm/*.conf` contains the static Slurm configuration files.
- `rootfs/etc/my.cnf.d/` contains the MariaDB client/server socket settings.

## Services

s6-overlay supervises `mariadb`, `munged`, `slurmctld`, `slurmd`, and
`slurmdbd` in the same container.

Slurm authentication uses `/run/munge/munge.socket.2`, and the container runs
with host name `slurm-simulator` so the configured controller host resolves
correctly.

## Local build and run

```bash
docker build -t slurm-rocky-sim .
docker run --rm -h "slurm-simulator" slurm-rocky-sim
```
