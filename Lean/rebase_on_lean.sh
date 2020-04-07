#!/bin/bash
cd friendlywrt-rk3328
find device/ -name distfeeds.conf -delete
cd friendlywrt
git config --global user.email "action@github.com" && git config --global user.name "GitHub Action"
../../set_repo_hash.sh Lean https://github.com/coolsnowwolf/lede.git
git remote add upstream https://github.com/coolsnowwolf/lede.git && git fetch upstream
git rebase adc1a9a3676b8d7be1b48b5aed185a94d8e42728^ --onto upstream/master -X ours
echo ""
git status
echo ""
git checkout upstream/master -- feeds.conf.default
git checkout upstream/master -- package/kernel/mac80211/files/lib/netifd/mac80211.sh
echo ""
git status
echo ""
echo "feeds.conf.default"
cat feeds.conf.default
