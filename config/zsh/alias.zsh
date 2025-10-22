IGNORE='node_modules|.git|dist|build|target|.next|venv|__pycache__|*.log|.DS_Store'

alias l='eza -1s type --group --icons --git'
alias la='eza -as type --group --icons --git'
alias ll='eza -las type --group --icons --git'
alias ls='eza -F --group-directories-first --group --icons --git'
alias llz='eza -Zlas type --octal-permissions --group --icons --git'
alias ltr='eza -T --level=2 --group-directories-first --group --icons --git'

llr() {
  eza -RZlas type --group --icons --git -I "$IGNORE" "$@"
}

tree() {
  eza --icons -aTI "$IGNORE" "$@"
}

jsontree() {
  eza --icons -aTI "$IGNORE" -J "$@" | jq '.'
}

alias tf='tofu'
alias yz='yazi'
alias k='kubectl'
alias ff='fastfetch'
alias cpf='copyfile'
alias docker='podman'
