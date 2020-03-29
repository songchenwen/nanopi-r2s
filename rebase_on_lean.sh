#!/bin/bash
cd friendlywrt-rk3328
find device/ -name distfeeds.conf -delete
cd friendlywrt
git config --global user.email "action@github.com" && git config --global user.name "GitHub Action"
../../set_repo_hash.sh Lean https://github.com/coolsnowwolf/lede.git
git remote add upstream https://github.com/coolsnowwolf/lede.git && git fetch upstream
git rebase adc1a9a3676b8d7be1b48b5aed185a94d8e42728^ --onto upstream/master -X theirs
echo ""
git status
echo ""
git revert --no-edit f092ca098e80c667b10cdd1dba328506a2673c1d
git checkout upstream/master -- feeds.conf.default
echo ""
git status
echo ""
echo "feeds.conf.default"
cat feeds.conf.default
