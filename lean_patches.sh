#!/bin/bash
cd friendlywrt-rk3328/friendlywrt
git apply ../../enable_autocore.diff

git diff -- package/lean/autocore/Makefile

sed -i '/uci commit luci/i\uci set luci.main.mediaurlbase="/luci-static/argon"' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit/i\chown -R root:root /usr/share/netdata/web' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit/i\find /etc/rc.d/ -name *docker* -delete' package/lean/default-settings/files/zzz-default-settings
sed -i 's/option fullcone\t1/option fullcone\t0/' package/network/config/firewall/files/firewall.config

echo ""
echo "package/lean/default-settings/files/zzz-default-settings"
cat package/lean/default-settings/files/zzz-default-settings

echo ""
echo "package/network/config/firewall/files/firewall.config"
cat package/network/config/firewall/files/firewall.config

mv ../../scripts/check_wan4.sh package/base-files/files/usr/bin && sed -i '/exit/i\/bin/sh /usr/bin/check_wan4.sh &' package/base-files/files/etc/rc.local

echo ""
echo "package/base-files/files/etc/rc.local"
cat package/base-files/files/etc/rc.local
