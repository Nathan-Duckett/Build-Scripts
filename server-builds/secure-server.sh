#!/bin/sh

# This script is designed to provide and introduce all of the steps to secure your server outlined here:
# https://github.com/imthenachoman/How-To-Secure-A-Linux-Server

# Read user email for configuration of services
read -p "Enter your email address: " EMAIL

# Default subnet where the installation lies
SUBNET="10.0.0.0/8"


# Install and configure fail2ban for SSH support
function install_fail2ban_ssh () {
    sudo apt install fail2ban -y

    cat << EOF | sudo tee /etc/fail2ban/jail.local
[DEFAULT]
# the IP address range we want to ignore
ignoreip = 127.0.0.1/8 $SUBNET

# who to send e-mail to
destemail = $EMAIL

# who is the email from
sender = $EMAIL

# since we're using exim4 to send emails
mta = mail

# get email alerts
action = %(action_mwl)s
EOF

    cat << EOF | sudo tee /etc/fail2ban/jail.d/ssh.local
[sshd]
enabled = true
banaction = ufw
port = ssh
filter = sshd
logpath = %(sshd_log)s
maxretry = 5
EOF

    sudo fail2ban-client start
    sudo fail2ban-client reload
    sudo fail2ban-client add sshd
}
