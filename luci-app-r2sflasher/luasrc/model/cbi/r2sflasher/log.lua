log = SimpleForm("log")
log.reset = false
log.submit = false
log:append(Template("r2sflasher/log"))
return log