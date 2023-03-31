#!/bin/bash

while [ $# -gt 0 ]; do
  case "$1" in
    --p_out=*)
      p_out="${1#*=}"
      ;;
    --arg_1=*)
      arg_1="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done
echo "p_out: ${p_out}"
echo "arg_1: ${arg_1}"
