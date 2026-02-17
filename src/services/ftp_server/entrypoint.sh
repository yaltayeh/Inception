#!/bin/bash
set -e

read_secret() {
    local secret_name="$1"
    local env_var_name="$2"
    local secret_default="$3"

    if [ -f "/run/secrets/${secret_name}" ]; then
        cat "/run/secrets/${secret_name}"
    else
        echo "${env_var_name:-$secret_default}"
    fi
}

FTP_USER=$(read_secret "ftp_user" "$FTP_USER" "ftpuser")
FTP_PASSWORD=$(read_secret "ftp_password" "$FTP_PASSWORD" "ftppassword")
FTP_HOME=$(read_secret "ftp_home" "$FTP_HOME" "/home/${FTP_USER}")


# Create user dynamically
if ! id -u "$FTP_USER" >/dev/null 2>&1; then
    useradd -m -d "$FTP_HOME" -s /bin/bash "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

# Start SSH server
exec "$@"
