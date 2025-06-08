
# Created by `pipx` on 2024-11-25 08:05:54
export PATH="$PATH:/Users/dkhoa/.local/bin"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/dkhoa/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/dkhoa/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/dkhoa/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/dkhoa/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
export PATH=$PATH:/usr/local/go/bin

