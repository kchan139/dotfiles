# environment variables & paths
export EDITOR=hx
export VISUAL=hx

export EZA_CONFIG_DIR="$HOME/.config/eza"
export PODMAN_COMPOSE_WARNING_LOGS=false

export PATH="$HOME/.local/bin:$PATH"

if [ -d "/usr/local/go/bin" ]; then
  export PATH="$PATH:/usr/local/go/bin"
fi
