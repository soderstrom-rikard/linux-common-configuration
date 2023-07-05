#!/bin/env bash

# Installation

if [[ "$1" = *"install"* ]]; then
  echo ecryptfs-utils installation
  sudo pacman -S ecryptfs-utils
else
  echo skipped ecryptfs-utils installation
fi

# Initialization
ECRYPTFS_ROOT_DIR=$HOME/.ecryptfs
ENC_DIR=/data/private.encrypted
DEC_DIR=/data/private.plain

mkdir -p ${ECRYPTFS_ROOT_DIR} ${ENC_DIR} ${DEC_DIR}

if [[ "$1" = *"modprobe"* ]]; then
  echo loading ecryptfs kernel modules
  modprobe ecryptfs
else
  echo skipped loading ecryptfs kernel modules
fi

# Create passphrase(s)

if [[ "$1" = *"create-passphrase"* ]]; then
  echo creating keys
  if [ -f $ECRYPTFS_ROOT_DIR/wrapped-data-passphrase ]; then
    echo warning, attempted to overwrite encrypted data passphrase, aborting..
    exit 1
  else
    ( stty -echo; printf "Data Passphrase: " 1>&2; read PASSWORD; stty echo; echo $PASSWORD; ) |\
      xargs printf "%s\n%s" $(od -x -N 100 --width=30 /dev/random | head -n 1 | sed "s/^0000000//" | sed "s/\s*//g") |\
      ecryptfs-wrap-passphrase $ECRYPTFS_ROOT_DIR/wrapped-data-passphrase
  fi

  if [ -f $ECRYPTFS_ROOT_DIR/wrapped-tree-passphrase ]; then
    echo warning, attempted to overwrite encrypted tree passphrase, aborting..
    exit 1
  else
    ( stty -echo; printf "Tree Passphrase: " 1>&2; read PASSWORD; stty echo; echo $PASSWORD; ) |\
      xargs printf "%s\n%s" $(od -x -N 100 --width=30 /dev/random | head -n 1 | sed "s/^0000000//" | sed "s/\s*//g") |\
      ecryptfs-wrap-passphrase $ECRYPTFS_ROOT_DIR/wrapped-tree-passphrase
  fi
else
  echo skipped creating keys
fi

# Update passphrase(s)

if [[ "$1" = *"update-passphrase"* ]]; then
  echo update keys
  if [ -f $ECRYPTFS_ROOT_DIR/wrapped-data-passphrase ]; then
    ecryptfs-rewrap-passphrase $ECRYPTFS_ROOT_DIR/wrapped-data-passphrase
  else
    echo warning, no data key to update, aborting..
    exit 1
  fi

  if [ -f $ECRYPTFS_ROOT_DIR/wrapped-tree-passphrase ]; then
    ecryptfs-rewrap-passphrase $ECRYPTFS_ROOT_DIR/wrapped-tree-passphrase
  else
    echo warning, no tree key to update, aborting..
    exit 1
  fi
else
  echo skipped updating keys
fi

# Load key(s) into keyring

if [[ "$1" = *"load-keys"* ]]; then
  (stty -echo; printf "loading keys" 1>&2)
  (stty -echo; printf "Data Passphrase: " 1>&2; read PASSWORD; stty echo; echo $PASSWORD; ) | ecryptfs-insert-wrapped-passphrase-into-keyring $ECRYPTFS_ROOT_DIR/wrapped-data-passphrase -
  (stty -echo; printf "Tree Passphrase: " 1>&2; read PASSWORD; stty echo; echo $PASSWORD; ) | ecryptfs-insert-wrapped-passphrase-into-keyring $ECRYPTFS_ROOT_DIR/wrapped-tree-passphrase -
else
  echo skipped loading keys
fi

# Mount/Unmount
if [[ "$1" = *"umount"* ]]; then
  echo unmounting ecryptfs
  sudo umount ${DEC_DIR}
elif [[ "$1" = *"mount"* ]]; then
  echo mounting ecryptfs
  sudo mount -t ecryptfs ${ENC_DIR} ${DEC_DIR} -o ecryptfs_sig=e3850930fa5ead3d,ecryptfs_fnek_sig=3e28c12ce475b979,ecryptfs_cipher=aes,ecryptfs_key_bytes=32,ecryptfs_unlink_sigs
else
  echo skipped mounting/unmounting ecryptfs
fi
