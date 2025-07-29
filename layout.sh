#!/bin/bash

# Define the name for your tmux session
SESSION_NAME="layout"

# --- Define your project paths here ---
# Change these to your actual project directories.
# Using '~' for the home directory is supported.
BACKEND_PATH="$HOME/backend"
FRONTEND_PATH="$HOME/frontend"

# Check if a tmux session with the same name already exists
if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    # If the session does not exist, create it and set up the layout

    echo "Creating new tmux session: $SESSION_NAME"
    # NOTE: Using separate commands like this can sometimes be less reliable
    # than chaining them with ';'. This version is for readability.

    # --- Window 1: term ---
    # Start a new, detached tmux session. This creates the first window named "term".
    tmux new-session -d -s "$SESSION_NAME" -n "term" -c "$HOME" -x $COLUMNS -y $LINES

    # Split the window horizontally. We explicitly target pane 0 of the 'term' window.
    tmux split-window -h -t "$SESSION_NAME:term" -c "$HOME"


    # --- Window 2: backend ---
    # Create a new window and directly run "nvim" in its first pane.
    tmux new-window -t "$SESSION_NAME" -n "backend" -c "$BACKEND_PATH" "nvim"

    # Split the new window vertically, giving the new bottom pane 15% of the height.
    tmux split-window -v -p 15 -t "$SESSION_NAME:backend" -c "$BACKEND_PATH"

    # Reselect the top pane (where nvim is) to make it active.
    tmux select-pane -t "$SESSION_NAME:backend.0"


    # --- Window 3: frontend ---
    # Create a new window and run "nvim".
    tmux new-window -t "$SESSION_NAME" -n "frontend" -c "$FRONTEND_PATH" "nvim"

    # Split it vertically, giving the new bottom pane 15% of the height.
    tmux split-window -v -p 15 -t "$SESSION_NAME:frontend" -c "$FRONTEND_PATH"

    # Reselect the top pane.
    tmux select-pane -t "$SESSION_NAME:frontend.0"

    # --- Final Setup ---
    # Select the first window ("term") and its first pane to be active.
    tmux select-window -t "$SESSION_NAME:backend"
    tmux select-pane -t "$SESSION_NAME:backend.0"

else
    echo "Session '$SESSION_NAME' already exists. Attaching."
fi

# Attach to the session, whether it was new or existing
tmux attach-session -t "$SESSION_NAME"

