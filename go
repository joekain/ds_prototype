#!/bin/sh

. .access

if [ "$1" == "iex" ]; then
  iex -S mix
  exit
else
  mix test
  echo "\nQueue based Processor"
  time mix run -e P1.stream_run

  echo "\nPool based processing"
  time mix run -e P1.Pool.run
fi
