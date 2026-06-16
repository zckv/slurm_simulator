# Copilot instructions for `slurm_simulator`

## Build and validation

- Build the active image: `docker build -t slurm-rocky-sim .`
- Run the container with hostname `slurm-simulator`: `docker run --rm -h "slurm-simulator" --name ssim slurm-rocky-sim`
- The container bootstrap lives in `rootfs/etc/cont-init.d/`, and long-lived daemons live in `rootfs/etc/s6-overlay/s6-rc.d/`.

## Architecture

- The `Dockerfile` builds a Rocky Linux 9 image with the official Slurm packages, MariaDB, `munge`, and `s6-overlay`.
- `s6-overlay` starts and supervises `mariadb`, `munged`, `slurmctld`, `slurmd`, and `slurmdbd` in one container via `/etc/s6-overlay/s6-rc.d`.
- The Slurm baseline config lives under `rootfs/etc/slurm/*.conf` as static files and is kept in place by `cont-init.d/10-slurm-config.sh`.
- Slurm auth explicitly uses `/run/munge/munge.socket.2` in both `slurm.conf` and `slurmdbd.conf`.
- MariaDB uses the Unix socket at `/run/mariadb/mariadb.sock`, with the client socket set in `rootfs/etc/my.cnf.d/`.

## Key conventions

- Preserve the single-container control-plane model: `s6-overlay` manages the Slurm daemons, so service startup order and logs matter more than wrapper scripts.
- Prefer official Rocky/Slurm package behavior over custom packaging or patched upstream RPM generation.
