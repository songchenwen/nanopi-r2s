include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-r2sflasher
PKG_VERSION:=1.0
PKG_RELEASE:=4
PKG_DATE:=20200416

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI Application to Flash NanoPi R2S ROM
  PKGARCH:=all
  DEPENDS:=+bash +gzip +tar +unzip +pv +losetup +zstd +luci-base +luci-lib-nixio
endef

define Build/Prepare
endef
 
define Build/Configure
endef
 
define Build/Compile
endef

define Package/$(PKG_NAME)/install	
	$(INSTALL_DIR) $(1)/usr/bin
	cp ./root/usr/bin/rom_flash $(1)/usr/bin/rom_flash
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pR ./luasrc/* $(1)/usr/lib/lua/luci/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo ./po/zh-cn/r2sflasher.po $(1)/usr/lib/lua/luci/i18n/r2sflasher.zh-cn.lmo
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
chmod a+x $${IPKG_INSTROOT}/usr/bin/rom_flash >/dev/null 2>&1
exit 0
endef

$(eval $(call BuildPackage,$(PKG_NAME)))