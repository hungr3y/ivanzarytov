#!/bin/bash

CWD=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null || exit 1; pwd -P)
VENV_PATH="${HOME}/.venv/aws"
VENV_REQUIREMENTS="${CWD}/requirements.txt"


DEFAULT_LOCAL_TMP=$(realpath "../tmp")
export DEFAULT_LOCAL_TMP

if [ ! -d $DEFAULT_LOCAL_TMP ]; then
  mkdir $DEFAULT_LOCAL_TMP
  chmod u+w $DEFAULT_LOCAL_TMP
fi


if [[ "$0" = "${BASH_SOURCE[0]}" ]]; then
    echo "Needs to be run using source: . env.sh"
else
    if [[ ! -d ${VENV_PATH} ]]; then
        PIP_SETTINGS=(
            --no-warn-script-location
            --disable-pip-version-check
        )

        python3 -m venv "${VENV_PATH}" --clear
        "${VENV_PATH}/bin/pip" install -r "${VENV_REQUIREMENTS}" "${PIP_SETTINGS[@]}"
    fi

    echo "Activating virtual environment ${VENV_PATH}"
    source "${VENV_PATH}/bin/activate"


    if [[ -f "${HOME}/.ssh/aws" ]]; then
        eval "$(ssh-agent -s)" && ssh-add "${HOME}/.ssh/aws"
    fi
fi
