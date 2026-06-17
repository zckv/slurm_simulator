#!/command/with-contenv sh
set -eu

install -d -m 755 /var/lib/mysql /var/log/mariadb /run/mariadb

if [ ! -d /var/lib/mysql/mysql ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/var/log/mariadb/install.log 2>&1
fi

chown -R mysql:mysql /var/lib/mysql /var/log/mariadb /run/mariadb

