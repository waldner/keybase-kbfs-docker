#!/bin/bash

echo "Starting with UID : $UID"

mkdir -p "$KEYBASE_KBFS_MOUNT"

if [ "$UID" != 0 ]; then
  usermod -u "$UID" keybase
  export HOME=/home/keybase
  #chown -R keybase:keybase "$KEYBASE_KBFS_MOUNT"
  exec gosu keybase "$@"
else
  usermod -u "1000" keybase
  export HOME=/root
  exec "$@"
fi

