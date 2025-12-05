#!/usr/bin/env bash
set -euo pipefail
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl gnupg software-properties-common openssh-server
