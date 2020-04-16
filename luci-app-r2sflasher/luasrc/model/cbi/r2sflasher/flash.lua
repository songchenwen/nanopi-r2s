local http = luci.http
local dsp = require 'luci.dispatcher'

romform = SimpleForm("romflash", translate("Flash ROM"), nil)
romform.reset = false
romform.submit = false

section = romform:section(SimpleSection, "", translate("Choose Your NanoPi R2S ROM zip File to Flash"))
fu = section:option(FileUpload, "")
fu.template = "r2sflasher/rom"
um = section:option(DummyValue, "", nil)

local dir, fd
dir = "/tmp/r2sflasher/"
nixio.fs.mkdir(dir)
http.setfilehandler(
	function(meta, chunk, eof)
		if not fd then
			if not meta then return end
            
			if	meta and chunk then fd = nixio.open(dir .. meta.file, "w") end

			if not fd then
				um.value = translate("Create upload file error.")
				return
			end
		end
		if chunk and fd then
			fd:write(chunk)
		end
		if eof and fd then
			fd:close()
            fd = nil
            local keep_config = luci.http.formvalue("keep_config")
            cmd = "/usr/bin/rom_flash " .. dir .. meta.file
            if keep_config == nil then
                cmd = cmd .. " nobackup"
            end
			luci.sys.call(cmd .. " &> /tmp/r2sflasher.log &")
			http.redirect(dsp.build_url("/admin/system/r2sflasher/log"))
		end
	end
)

if luci.http.formvalue("flash") then
	local f = luci.http.formvalue("romfile")
	if #f <= 0 then
		um.value = translate("No Specify ROM File.")
	end
end

if luci.sys.call("pidof rom_flash > /dev/null") == 0 then
    http.redirect(dsp.build_url("/admin/system/r2sflasher/log"))
    return
else
    return romform
end
