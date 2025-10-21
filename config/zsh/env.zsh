# environment variables & paths
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=hx
export VISUAL=hx
export EZA_CONFIG_DIR="$HOME/.config/eza"

if [ -d "/usr/local/go/bin" ]; then
  export PATH="$PATH:/usr/local/go/bin"
fi
