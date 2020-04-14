-- Copyright 2020 scw <me@songchenwen.com>
module("luci.controller.r2sflasher", package.seeall)

function index()
    entry({"admin", "system", "r2sflasher"}, form("r2sflasher/flash"), _("R2S Flasher"), 79)
    entry({"admin", "system", "r2sflasher", "log"}, form("r2sflasher/log"))
    entry({"admin", "system", "r2sflasher", "get_log"}, call("get_log")).leaf = true
end

function get_log()
    luci.http.write(luci.sys.exec(
                        "[ -f '/tmp/r2sflasher.log' ] && cat /tmp/r2sflasher.log"))
end
