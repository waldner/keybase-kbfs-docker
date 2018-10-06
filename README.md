# keybase-kbfs-docker
Docker image for keybase's KBFS

### What's this?

This is a [Docker](https://www.docker.com/) image for [Keybase client](https://keybase.io) focused on getting access to [KBFS](https://keybase.io/docs/kbfs). The KBFS mount can optionally be seen from the host.

### Getting started

- Create an account on [Keybase](https://keybase.io)
- Generate a _paper key_ using the keybase CLI (you should use another device to do this). The paper key is just a series of words, that counts as a device in Keybase, and can be used for the "oneshot" feature used by the docker container.
- The recommended way to run the container is by using [docker-compose](https://docs.docker.com/compose/). But before, you must create an `.env` file with the following contents:


```
# where the KBFS is mounted inside the container.
# If you change this, you have to change it in the Dockerfile as well and rebuild the image
KEYBASE_KBFS_MOUNT=/home/keybase/kbfs

KEYBASE_USER=your_keybase_user
KEYBASE_PAPERKEY=your keybase paper key
```

After that, you can run `docker-compose up -d`. It uses the prebuilt image at [the Docker hub](https://hub.docker.com/r/waldner/keybase/). The KBFS is mounted at `${KEYBASE_KBFS_MOUNT}` (`/home/keybase/kbfs`) inside the container.

### How to get the KBFS mount on the host

Create a file `docker-compose.override.yml` with the follwing contents:

```
version: '3'

services:
  keybase:
    volumes:
      - "/home/you/kbfs:${KEYBASE_KBFS_MOUNT}:shared"
```
**NOTE: you have to create `/home/you/kbfs` on the host beforehand with your user's permissions, otherwise docker will create it with root ownership which, in turn, will make the KBFS mount in the container fail.**

With this you'll have the KBFS exposed at `/home/you/kbfs` on the host.

### Caveats

To use a FUSE mount inside the container, the device `/dev/fuse` is exposed to the container, which also needs to have the `SYS_ADMIN` capability (and needs the `apparmor:unconfined` security option under Ubuntu). If you're exporting the KBFS mount back to the host and the container crashes without cleaning up, you might have to manually umount (ie `fusermount -u /home/you/kbfs`) the host mount point.

