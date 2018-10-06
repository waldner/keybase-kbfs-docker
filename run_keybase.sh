#!/bin/bash

trap 'fusermount -u ${KEYBASE_KBFS_MOUNT}' SIGINT SIGTERM

keybase oneshot -u "${KEYBASE_USER}" -p "${KEYBASE_PAPERKEY}"

keybase config set mountdir "${KEYBASE_KBFS_MOUNT}"

kbfsfuse &

pid="$!"

while true; do
  sleep 1
done

