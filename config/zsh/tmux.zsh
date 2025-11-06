# Attach or create tmux session automatically
case $- in *i*) interactive=1 ;; *) interactive=0 ;; esac

if command -v tmux >/dev/null 2>&1 && [ "$interactive" -eq 1 ] && [ -z "$TMUX" ] && [ -z "$ZED_TERMINAL" ] && [ -z "$ZED_TERM" ] && [ "$TERM_PROGRAM" != "zed" ]; then
  tmux attach || tmux new
fi
