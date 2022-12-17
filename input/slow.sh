#! /usr/bin/env bash

count="${1:-50}"

for I in $(seq 1 $count); do
  echo "stderr: $I of $count" >&2
  echo "value: $I of $count"
  sleep 1
done