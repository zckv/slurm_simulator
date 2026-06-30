#!/command/with-contenv sh
set -eu

install -d -m 700 /var/log/munge /run/munge

if [ ! -f /etc/munge/munge.key ]; then
    if [ -n "${MUNGE_KEY_BASE64:-}" ]; then
        echo "$MUNGE_KEY_BASE64" | base64 -d > /etc/munge/munge.key
        chmod 400 /etc/munge/munge.key
    else
        create-munge-key
    fi
fi

chown -R root:root /var/log/munge /var/lib/munge /run/munge /etc/munge
chmod 700 /var/log/munge /run/munge
chmod 711 /run/munge
