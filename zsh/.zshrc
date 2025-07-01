# some more ls aliases
alias ll='ls -alFG'
alias la='ls -AG'
alias l='ls -CFG'
alias ls='ls -G'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias tf='terraform'
alias tree="tree -a -I 'node_modules|.git|dist|build|target|.next|__pycache__|*.log|.DS_Store' \"\$@\""

export PATH=$PATH:/usr/local/go/bin

eval "$(starship init zsh)"
export PATH="/opt/homebrew/bin:$PATH"
