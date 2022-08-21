#!/bin/bash

trap 'fusermount -u ${KEYBASE_KBFS_MOUNT}' SIGINT SIGTERM

echo "Logging in with paper key..."
keybase oneshot -u "${KEYBASE_USER}" --paperkey "${KEYBASE_PAPERKEY}"

echo "Setting KBFS config..."
keybase config set mountdir "${KEYBASE_KBFS_MOUNT}"

#chown keybase:keybase "${KEYBASE_KBFS_MOUNT}"

echo "Mounting KBFS..."
kbfsfuse &

#sleep 5
#chown root:root "${KEYBASE_KBFS_MOUNT}"

pid="$!"

while true; do
  sleep 1
done

