# Attach or create tmux session automatically
if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ]; then
  tmux attach || tmux new
fi
