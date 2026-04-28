#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  SUDO="sudo"
else
  SUDO=""
fi

log() {
  echo "[INFO] $1"
}

warn() {
  echo "[WARN] $1"
}

error() {
  echo "[ERROR] $1" >&2
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

version_ge() {
  [[ "$(printf '%s\n' "$2" "$1" | sort -V | head -n1)" == "$2" ]]
}

detect_package_manager() {
  if command_exists apt-get; then
    echo "apt"
  elif command_exists dnf; then
    echo "dnf"
  elif command_exists yum; then
    echo "yum"
  else
    error "Unsupported package manager. Use apt, dnf, or yum."
  fi
}

install_packages() {
  local package_manager="$1"
  shift

  case "$package_manager" in
    apt)
      $SUDO apt-get update
      $SUDO apt-get install -y "$@"
      ;;
    dnf)
      $SUDO dnf install -y "$@"
      ;;
    yum)
      $SUDO yum install -y "$@"
      ;;
  esac
}

ensure_curl() {
  if command_exists curl; then
    return
  fi

  log "Installing curl"
  install_packages "$(detect_package_manager)" curl
}

install_docker() {
  if command_exists docker; then
    log "Docker is already installed: $(docker --version)"
    return
  fi

  ensure_curl
  log "Installing Docker"
  curl -fsSL https://get.docker.com | sh

  if ! command_exists docker; then
    error "Docker installation failed"
  fi

  log "Docker installed successfully: $(docker --version)"
}

install_docker_compose() {
  if docker compose version >/dev/null 2>&1; then
    log "Docker Compose is already available as a Docker plugin"
    return
  fi

  if command_exists docker-compose; then
    log "Docker Compose is already installed: $(docker-compose --version)"
    return
  fi

  local package_manager
  package_manager="$(detect_package_manager)"

  log "Installing Docker Compose"
  case "$package_manager" in
    apt)
      install_packages "$package_manager" docker-compose-plugin
      ;;
    dnf|yum)
      install_packages "$package_manager" docker-compose-plugin || install_packages "$package_manager" docker-compose
      ;;
  esac

  if docker compose version >/dev/null 2>&1; then
    log "Docker Compose installed successfully as plugin"
  elif command_exists docker-compose; then
    log "Docker Compose installed successfully as standalone binary"
  else
    error "Docker Compose installation failed"
  fi
}

python_major_minor() {
  "$1" -c 'import sys; print(f"{sys.version_info[0]}.{sys.version_info[1]}")'
}

install_python() {
  if command_exists python3; then
    local current_version
    current_version="$(python_major_minor python3)"
    if version_ge "$current_version" "3.9"; then
      log "Python is already installed: $(python3 --version)"
      return
    fi
    warn "Found Python ${current_version}, but version 3.9+ is required"
  fi

  local package_manager
  package_manager="$(detect_package_manager)"

  log "Installing Python 3.9+ and pip"
  case "$package_manager" in
    apt)
      install_packages "$package_manager" python3 python3-pip python3-venv
      ;;
    dnf|yum)
      install_packages "$package_manager" python3 python3-pip
      ;;
  esac

  if ! command_exists python3; then
    error "Python installation failed"
  fi

  local installed_version
  installed_version="$(python_major_minor python3)"
  if ! version_ge "$installed_version" "3.9"; then
    error "Installed Python version ${installed_version} is lower than 3.9"
  fi

  log "Python installed successfully: $(python3 --version)"
}

install_with_pip() {
  local package="$1"

  if python3 -m pip install --upgrade pip; then
    :
  elif python3 -m pip install --upgrade pip --break-system-packages; then
    :
  else
    warn "Could not upgrade pip automatically; continuing with current version"
  fi

  if python3 -m pip install "$package"; then
    return
  fi

  if python3 -m pip install "$package" --break-system-packages; then
    return
  fi

  if python3 -m pip install --user "$package"; then
    return
  fi

  error "pip could not install $package"
}

install_django() {
  if python3 -m pip show Django >/dev/null 2>&1; then
    log "Django is already installed: $(python3 -m pip show Django | awk -F': ' '/^Version/ {print $2}')"
    return
  fi

  log "Installing Django with pip"
  install_with_pip Django

  if ! python3 -m pip show Django >/dev/null 2>&1; then
    error "Django installation failed"
  fi

  log "Django installed successfully: $(python3 -m django --version)"
}

main() {
  if [[ "$(uname -s)" != "Linux" ]]; then
    error "This script supports Linux only"
  fi

  install_docker
  install_docker_compose
  install_python
  install_django

  log "All requested DevOps tools are installed"
}

main "$@"
