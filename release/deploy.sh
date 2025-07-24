#!/bin/bash

# Create tmp directory
DEFAULT_LOCAL_TMP=$(realpath "./tmp")
export DEFAULT_LOCAL_TMP

if [ ! -d $DEFAULT_LOCAL_TMP ]; then
  mkdir $DEFAULT_LOCAL_TMP
  chmod u+w $DEFAULT_LOCAL_TMP
fi

CWD=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null || exit 1; pwd -P)
cd $CWD/../ansible || exit 1

environment="$1"
deploy_all_steps="$2"

if [[ -z "$environment" || "$environment" =~ ^(--all|-a)$ ]]; then
  echo "Invalid environment argument. Can't be empty"
  exit 1
fi

if [[ "$deploy_all_steps" =~ ^(--all|-a)$ ]]; then
  AUTO_RELEASE=true
fi

ask_confirmation() {
  local prompt="$1"
  local choice

  read -p "$prompt (y/n): " choice

  if [[ "$choice" =~ ^[Yy](es)?$ ]]; then
    return 0
  elif [[ "$choice" =~ ^[Nn]o?$ ]]; then
    return 1
  else
    echo "Invalid input. We assume it is 'no'."
    return 1
  fi
}

ansible_run() {
  local playbook="$1"
  local message="$2"
  local tags="$3"


  if [[ "$AUTO_RELEASE" == "true" ]] || ask_confirmation "Do you want to start: ${message}?"; then
    echo "Running: ${message}"
    ANSIBLE_CONFIG=ansible.cfg ansible-playbook -i inventory "$playbook" -l "$environment" ${tags:+--tags "$tags"}
  else
    echo "Skipping: ${message}."
  fi
}

# Run ansible playbooks
# playbook path|Name of the job|tags ( tags is unnecessary)
steps=(
  "playbooks/main/upload.yml|Artifact uploading"
  "playbooks/main/stop-all.yml|Containers stopping|stop-all"
  "playbooks/main/maintenance.yml|Images cleaning|clean-images"
  "playbooks/main/prepare.yml|Environment preparation|setup,setup-scripts"
  "playbooks/main/start-all.yml|Environment start|start-all"
  "playbooks/main/start-all.yml|RSS start|start-rss"
)

if ask_confirmation "Do you want to prune all '$DEFAULT_LOCAL_TMP' content?"; then
  rm -rf ${DEFAULT_LOCAL_TMP:?}/**
fi

for step in "${steps[@]}"; do
  IFS='|' read -r playbook message tags <<< "$step"
  ansible_run "$playbook" "$message" "$tags"
done


cd - || exit 1
