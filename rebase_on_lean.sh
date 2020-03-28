#!/bin/bash
cd friendlywrt-rk3328
find device/ -name distfeeds.conf -delete
cd friendlywrt
git config --local user.email "action@github.com" && git config --local user.name "GitHub Action"
git remote add upstream https://github.com/coolsnowwolf/lede && git fetch upstream
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
