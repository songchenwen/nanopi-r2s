# Nanopi R2S 固件自动编译

![r2s_lean](https://github.com/songchenwen/nanopi-r2s/workflows/r2s_lean/badge.svg)

[ChangeLog](CHANGELOG.md)

Fork 自 [klever1988](https://github.com/klever1988/nanopi-openwrt)

主要整合了 [Passwall](https://github.com/songchenwen/openwrt-package) 和 AdguardHome

其中 [Passwall](https://github.com/songchenwen/openwrt-package) 是修改版本，支持 Clash。Passwall 比 OpenClash 的好处是，OpenClash 所有流量都需要经过 Clash 转发，有性能损耗。[Passwall](https://github.com/songchenwen/openwrt-package) 可以设置规则只转发部分流量。
