#!/bin/bash

while getopts n:a:g: flag
do
    case "${flag}" in
        n) name=${OPTARG};;
        a) age=${OPTARG};;
        g) gender=${OPTARG};;
        \?) echo "Invalid option -$OPTARG" >&2
        exit 1
        ;;
    esac
done
echo "Name: ${name}"
echo "Age: ${age}"
echo "Gender: ${gender}"