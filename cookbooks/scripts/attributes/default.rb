default["scripts"]["mike"] = [
	"backup",
	"backup_exclusions",
	"rsync_quota",
	"mount_rsync",
	"dbcreate",
	"dbicreate",
	"dbiedit",
	"rolecreate",
	"roleedit",
    "fetchtradingdata"
]
default["scripts"]["datastax"] = [
	"dbcreate",
	"dbicreate",
	"dbiedit",
	"rolecreate",
	"roleedit",
    "sunnyvale-vpn",
    "java_debug",
	"create_solr_core",
	"fw_off",
	"load_solr_core"
]
default["scripts"]["trading"] = [
	"dbcreate",
	"dbicreate",
	"dbiedit",
	"rolecreate",
	"roleedit"
]
default["scripts"]["bskyb"] = [
	"dbcreate",
	"dbicreate",
	"dbiedit",
	"rolecreate",
	"roleedit"
]
default["scripts"]["assemblade"] = [
	"dbcreate",
	"dbicreate",
	"dbiedit",
	"rolecreate",
	"roleedit"
]

