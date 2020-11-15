#!/bin/bash


# Install specific requirement file
if [ ! -z "${AVD_REQUIREMENTS}" ]; then
  if [ -f ${AVD_REQUIREMENTS} ]; then
    echo "Install new requirements from ${AVD_REQUIREMENTS}"
    pip3 install --user -r ${AVD_REQUIREMENTS}
  else
    echo "Requirement file not found, skipping..."
  fi
fi

# Install specific ANSIBLE version
if [ ! -z "${AVD_ANSIBLE}" ]; then
    echo "Install ansible with version ${AVD_ANSIBLE}"
    pip3 install --user ansible==${AVD_ANSIBLE}
fi

# Reconfigure AVD User id if set by user
if [ ! -z "${AVD_UID}" ]; then
  echo "Update uid for user avd with ${AVD_UID}"
  usermod -u ${AVD_UID} avd
fi

if [ ! -z "${AVD_GID}" ]; then
  echo "Update gid for group avd with ${AVD_GID}"
  groupmod -g ${AVD_GID} avd
fi

export PATH=$PATH:/home/avd/.local/bin
cd /projects/
su - avd -c "cd /projects && /bin/zsh"
