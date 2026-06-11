# Copilot instructions for `slurm_simulator`

## Build and validation

- Build the active image: `docker build -t slurm-rocky-sim ./rocky_sim`
- Run the container with the official Slurm packages and the `s6-overlay` entrypoint from `rocky_sim/Dockerfile`.
- The container bootstrap lives in `rocky_sim/rootfs/etc/cont-init.d/`, and long-lived daemons live in `rocky_sim/rootfs/etc/services.d/`.

## Architecture

- `rocky_sim/` is the active simulator implementation. It builds a Rocky Linux 9 image with the official Slurm packages, MariaDB, `munge`, and `s6-overlay`.
- `s6-overlay` starts and supervises `mariadb`, `munged`, `slurmctld`, `slurmd`, and `slurmdbd` in one container via `/etc/s6-overlay/s6-rc.d`.
- The Slurm baseline config lives under `rocky_sim/rootfs/etc/slurm/*.conf` as static files and is kept in place by `cont-init.d/10-slurm-config.sh`.
- Slurm auth explicitly uses `/run/munge/munge.socket.2` in both `slurm.conf` and `slurmdbd.conf`.
- MariaDB uses the Unix socket at `/run/mariadb/mariadb.sock`, with the client socket set in `rocky_sim/rootfs/etc/my.cnf.d/`.
- The rest of the repository is historical/reference material from the older simulator approach and should not be treated as production code unless you are explicitly porting useful pieces from it.

## Key conventions

- Keep changes focused on `rocky_sim/`; do not carry over the old CentOS-based builder/simulator flow unless the user is explicitly reviving it.
- Preserve the single-container control-plane model: `s6-overlay` manages the Slurm daemons, so service startup order and logs matter more than wrapper scripts.
- Prefer official Rocky/Slurm package behavior over custom packaging or patched upstream RPM generation.
- Treat old configs and scripts outside `rocky_sim/` as reference for ideas only; do not assume they are functional or in sync with the current image.
