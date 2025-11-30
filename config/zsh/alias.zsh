IGNORE='node_modules|.git|dist|build|target|.next|venv|.venv*|__pycache__|*.log|.DS_Store|.terraform|vendor|*.png|*.jpeg|*.jpg|*.svg|*.ttf'

alias ls='eza --group-directories-first --group --icons --git'
alias l='eza -1s type --group-directories-first --group --icons --git'
alias la='eza -F -as type --group-directories-first --group --icons --git'
alias ll='eza -las type --group-directories-first --group --icons --git'
alias ltr='eza -T --level=2 --group-directories-first --group --icons --git'
alias llz='eza -Zlas type --group-directories-first --octal-permissions --group --icons --git'

llr() {
  eza -RZlas type --group --icons --git -I "$IGNORE" "$@"
}

tree() {
  eza --icons --group-directories-first -aTI "$IGNORE" "$@"
}

jsontree() {
  \tree --group-directories-first -aTI "$IGNORE" -J "$@" | jq '.'
}

alias tf='tofu'
alias yz='yazi'
alias k='kubectl'
alias py='python3'
alias ff='fastfetch'
alias cpf='copyfile'
alias docker='podman'
