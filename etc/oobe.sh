#!/bin/bash
set -ue
DEFAULT_GROUPS="adm,cdrom,docker"
DEFAULT_UID="1000"

echo "Please create a default UNIX user account. The username does not need to match your Windows username."
echo "For more information visit: https://aka.ms/wslusers"

if getent passwd "$DEFAULT_UID" > /dev/null ; then
  echo "Default UNIX user account already exists, skipping creation."
  exit 0
fi

while true; do

  # Prompt for the username.
  read -p "Enter new UNIX username: " username

  # Create the user.
  if /usr/sbin/adduser --uid "$DEFAULT_UID" --create-home "$username" ; then
    if /usr/sbin/usermod "$username" -aG "$DEFAULT_GROUPS" ; then
      break
    else
      /usr/sbin/userdel "$username"
    fi
  fi
done
