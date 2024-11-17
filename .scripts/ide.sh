#!/bin/bash

# set tmux panes for ide

if [ "$#" -eq 0 ]; then
  tmux split-window -v
  tmux split-window -h
  tmux resize-pane -D 15
  tmux select-pane -t 0
  #tmux set-window-option synchronize-panes
else
  case $1 in
    1)
      tmux split-window -v
      tmux split-window -h
      tmux resize-pane -D 15
      tmux select-pane -t 0
      #tmux set-window-option synchronize-panes
      clear
      ;;
    *)
      echo [ERROR] "$1" は設定されていない引数です。
      ;;
  esac
fi
