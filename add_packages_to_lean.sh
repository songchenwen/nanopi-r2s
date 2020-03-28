#!/bin/bash
cd friendlywrt-rk3328/friendlywrt
cd package/lean/
rm -rf luci-theme-argon
pwd
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git
cd ..

pwd
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git
cd ..

echo "src-git scw https://github.com/songchenwen/openwrt-package" >> feeds.conf.default

echo ""
echo "feeds.conf.default"
cat feeds.conf.default
