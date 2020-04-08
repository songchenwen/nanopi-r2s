#!/bin/bash
cd friendlywrt-rk3328
find device/ -name distfeeds.conf -delete
cd friendlywrt
git config --global user.email "action@github.com" && git config --global user.name "GitHub Action"
git remote add upstream https://github.com/Lienol/openwrt.git && git fetch upstream
git checkout upstream/dev-lean-lede -b tmp
../../set_repo_hash.sh Lean
git mv README.md README && git commit -m 'undo rename readme for rebasing'
git checkout origin/master-v19.07.1
git rebase adc1a9a3676b8d7be1b48b5aed185a94d8e42728^ --onto tmp -X ours
echo ""
git status
echo ""
git checkout upstream/dev-lean-lede -- feeds.conf.default
git checkout upstream/dev-lean-lede -- package/kernel/mac80211/files/lib/netifd/mac80211.sh
echo ""
git status
echo ""
echo "feeds.conf.default"
cat feeds.conf.default
