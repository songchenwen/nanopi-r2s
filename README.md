# Nanopi R2S 固件自动编译

[![friendlywrt](https://github.com/songchenwen/nanopi-r2s/workflows/friendlywrt/badge.svg)](https://github.com/songchenwen/nanopi-r2s/actions?query=workflow%3Afriendlywrt) 
[![FwF](https://github.com/songchenwen/nanopi-r2s/workflows/FwF/badge.svg)](https://github.com/songchenwen/nanopi-r2s/actions?query=workflow%3AFwF) 
[![lean](https://github.com/songchenwen/nanopi-r2s/workflows/lean/badge.svg)](https://github.com/songchenwen/nanopi-r2s/actions?query=workflow%3Alean) 
[![LOL](https://github.com/songchenwen/nanopi-r2s/workflows/LOL/badge.svg)](https://github.com/songchenwen/nanopi-r2s/actions?query=workflow%3ALOL) 

编译了两种固件，分别是基于 Lean 的和基于官方固件的。

FriendlyWRT 和 FwF 是基于官方固件的版本，主要求稳，没有解锁 CPU 主频，也没添加 Flow Offload，实测性能够用，温度还低，推荐作为家庭主路由拿来长期使用。

点击下方固件名字，可找到对应版本固件的最新下载链接。图形化刷机工具 [luci-app-r2sflasher](luci-app-r2sflasher) 的 ipk 安装包也在下载到的 zip 里。推荐下载 FriendlyWRT 的版本。

| 推荐 | 固件名字 | 改动记录 | 简介 |
| :--- | :------ | :----- | :--- |
| * | [FriendlyWRT](https://github.com/songchenwen/nanopi-r2s/releases/tag/FriendlyWRT-2020-04-15-f666d0b) | [改动记录](FriendlyWRT/CHANGELOG.md) | 以官方固件为基础, 添加 Lean 的包 |
| * | [FwF](https://github.com/songchenwen/nanopi-r2s/releases/tag/FwF-2020-04-14-c5c7214) | [改动记录](FwF/CHANGELOG.md) | FriendlyWRT with Features, 比上面的固件含有更多功能 |
|   | [Lean](https://github.com/songchenwen/nanopi-r2s/releases/tag/Lean-2020-04-14-b7c1390) | [改动记录](Lean/CHANGELOG.md) | 以 Lean 为基础, 增加 FriendlyWRT 对 OpenWRT 的改动 | 
|   | [LOL](https://github.com/songchenwen/nanopi-r2s/releases/tag/LOL-2020-04-14-b7c1390) | [改动记录](LOL/CHANGELOG.md) | 以[Lienol on Lean](https://github.com/Lienol/openwrt/tree/dev-lean-lede)为基础, 增加 FriendlyWRT 对 OpenWRT 的改动 |

默认 LAN 口 IP `192.168.2.1` 默认密码 `password`

4月14日之后的版本加入了 [luci-app-r2sflasher](luci-app-r2sflasher), 可以图形化刷机了。

Fork 自 [klever1988](https://github.com/klever1988/nanopi-openwrt) 和 [soffchen](https://github.com/soffchen/NanoPi-R2S)

主要整合了 [Passwall](https://github.com/songchenwen/openwrt-package) 和 AdguardHome

其中 [Passwall](https://github.com/songchenwen/openwrt-package) 是修改版本，支持 Clash。Passwall 比 OpenClash 的好处是，OpenClash 所有流量都需要经过 Clash 转发，有性能损耗。[Passwall](https://github.com/songchenwen/openwrt-package) 可以设置规则只转发部分流量。

WAN 口 DHCP 时，NAT 性能和温度 ⬇️

![DHCP NAT](images/r2s_dhcp_nat.png)

WAN 口 PPPOE 时，NAT 性能和温度 ⬇️

![PPPOE NAT](images/r2s_pppoe_nat.png)

Fast.com 测速 ⬇️

![fast.com](images/r2s_fastcom.png)

Fast.com 测速 WAN 口 DHCP 时 CPU 占用和温度 （ WAN 口 PPPOE 的话，CPU 占用增加 20% 左右 ） ⬇️

![fast.com](images/r2s_fastcom_nat.png)

