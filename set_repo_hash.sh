#!/bin/bash
name=$1
if [ "$#" -gt 1 ]; then
    repo=$2
    echo "::set-env name=${name}Hash::$(git ls-remote ${repo} HEAD | awk '{ print $1}' | cut -c -7)"
else
    git log --invert-grep --author="action@github.com" -n 1
    echo "::set-env name=${name}Hash::$(git log --invert-grep --author="action@github.com" -n 1 --pretty=format:%H | cut -c -7)"
fi
