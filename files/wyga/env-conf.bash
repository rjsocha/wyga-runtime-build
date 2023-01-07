#!/bin/bash
#
# Robert Socha, public domain
# 2022
#
# This my not be clean POSIX compilant code. It's work in alpine sh (and bash)
# Thats all I care about currently.
#
# ENVCFG (or ENVCONFIG)
# Syntax:
# path:ENVPREFIX[:mode]
# mode: default overwrite/create
#       + - append to file (or create if file dosen't exists)
#
set -eu
env_process() {
local _env _conf
  _env="$1"
  for _conf in $(env | egrep -o "^${_env}[0-9]+" | sort)
  do
    eval echo \"\$${_conf}\"
    unset "${_conf}"
  done
}

if [ -z "${ENVCFG:-}" ]
then
  if [ -n "${ENVCONFIG:-}" ]
  then
    ENVCFG="${ENVCONFIG}"
  fi
fi
if [ -n "${ENVCFG:-}" ]
then
  for _entry in ${ENVCFG//,/ }
  do
    read _file _env _mode < <(echo "${_entry//:/ }")
    if [ -z "${_env}" ]
    then
      continue
    fi
    if [ "${_mode}"x == "+"x ]
    then
      _mode_name="append"
    else
      _mode_name="create"
    fi
    if [ -n "${ENVCFGVERBOSE:-}" ]
    then
      echo "env-conf: processing environment variables ${_env}* as file ${_file} (${_mode_name})"
    fi
    _dir="$(dirname "${_file}")"
    mkdir -p "${_dir}"
    if [ "${_mode}"x == "+"x ]
    then
      env_process "${_env}" >>"${_file}"
    else
      env_process "${_env}" >"${_file}"
    fi
  done
fi
unset ENVCONFIG
unset ENVCFG
exec "$@"
