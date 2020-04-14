#!/bin/bash
cd friendlywrt-rk3328/friendlywrt
cd package/lean/
rm -rf luci-theme-argon
pwd
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git
cd luci-theme-argon
../../../../../set_repo_hash.sh Argon
cd ../..

pwd
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git
cd luci-app-adguardhome
../../../../set_repo_hash.sh AdguardHome
cd ..

pwd
git clone https://github.com/tty228/luci-app-serverchan.git
../../../set_repo_hash.sh ServerChan
cd ..

pwd
echo "src-git scw https://github.com/songchenwen/openwrt-package" >> feeds.conf.default
../../set_repo_hash.sh ScwPackage https://github.com/songchenwen/openwrt-package.git

echo ""
echo "feeds.conf.default"
cat feeds.conf.default

cp -r ../../luci-app-r2sflasher package/
