#!/bin/sh

. .access

if [ "$1" == "iex" ]; then
  iex -S mix
  exit
else
  mix test
fi
