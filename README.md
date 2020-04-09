# Nanopi R2S 固件自动编译

编译了两种固件，分别是基于 Lean 的和基于官方固件的。

| 推荐 | 固件名字 | 状态 | 改动记录 | 简介 |
| :--- | :------ | :--- | :----- | :--- |
| * | FriendlyWRT | [![friendlywrt](https://github.com/songchenwen/nanopi-r2s/workflows/friendlywrt/badge.svg)](https://github.com/songchenwen/nanopi-r2s/actions?query=workflow%3Afriendlywrt) | [Change Log](FriendlyWRT/CHANGELOG.md) | 以 FriendlyWRT 为基础, 添加 Lean 的包 |
|   | Lean | [![lean](https://github.com/songchenwen/nanopi-r2s/workflows/lean/badge.svg)](https://github.com/songchenwen/nanopi-r2s/actions?query=workflow%3Alean) | [Change Log](Lean/CHANGELOG.md) | 以 Lean 为基础, 增加 FriendlyWRT 对 OpenWRT 的改动 | 
|   | LOL | [![LOL](https://github.com/songchenwen/nanopi-r2s/workflows/LOL/badge.svg)](https://github.com/songchenwen/nanopi-r2s/actions?query=workflow%3ALOL) | [Change Log](LOL/CHANGELOG.md) | 以[Lienol on Lean](https://github.com/Lienol/openwrt/tree/dev-lean-lede)为基础, 增加 FriendlyWRT 对 OpenWRT 的改动 |

Fork 自 [klever1988](https://github.com/klever1988/nanopi-openwrt) 和 [soffchen](https://github.com/soffchen/NanoPi-R2S)

主要整合了 [Passwall](https://github.com/songchenwen/openwrt-package) 和 AdguardHome

其中 [Passwall](https://github.com/songchenwen/openwrt-package) 是修改版本，支持 Clash。Passwall 比 OpenClash 的好处是，OpenClash 所有流量都需要经过 Clash 转发，有性能损耗。[Passwall](https://github.com/songchenwen/openwrt-package) 可以设置规则只转发部分流量。

推荐使用 FriendlyWRT, CPU 1.2GHz 时温度更低，稳定性更好，性能也够用。

WAN 口 DHCP 时，NAT 性能和温度

![DHCP NAT](images/r2s_dhcp_nat.png)

WAN 口 PPPOE 时，NAT 性能和温度

![PPPOE NAT](images/r2s_pppoe_nat.png)

Fast.com 测速

![fast.com](images/r2s_fastcom.png)

