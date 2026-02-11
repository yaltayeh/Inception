
DATA_DIR="/var/lib/mysql"

if [ ! -d "$DATA_DIR" ]; then
    echo "Initializing MariaDB data directory..."
    mkdir -p "$DATA_DIR"
    chown -R mysql:mysql "$DATA_DIR"

fi

mysql_install_db --user=mysql --datadir="$DATA_DIR" > /dev/null
echo "Data directory initialized."