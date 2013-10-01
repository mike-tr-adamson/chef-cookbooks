default[:chef_secret_path] = '/vagrant/chef_secret'

default["oracle"]["db_packages"] = [
  "xorg-x11-server-Xorg",
  "xorg-x11-server-utils",
  "xorg-x11-xauth",
  "libaio-devel",
  "elfutils-libelf-devel",
  "sysstat",
  "unixODBC-devel",
  "compat-libstdc++-33",
  "gtk2",
  "PackageKit-gtk-module",
  "gconf-editor",
  "perl-CPAN",
  "unzip"
]

override["kernel"]["shmall"] = 2097152
override["kernel"]["shmmni"] = 4096
override["net"]["core"]["rmem_default"] = 262144
override["net"]["core"]["wmem_default"] = 262144

# User-tunable attribues, and Oracle recommended
# MINIMUM values for 11g version of Oracle
default["security"]["limits"] = [
    "oracle    soft    nproc   16384",
    "oracle    hard    nproc   16384",
    "oracle    soft    nofile  63536",
    "oracle    hard    nofile  63536",
    "oracle    soft    memlock 3145728",
    "oracle    hard    memlock 3145728"
]
default["fs"]["file_max"] = 6815744
default["fs"]["aio_max_nr"] = 1048576
default["net"]["ipv4"]["ip_local_port_range"] = "9000 65500"
default["net"]["core"]["rmem_max"] = 4194304
default["net"]["core"]["wmem_max"] = 1048576

# Values below are calculated
# Four Gb of RAM expressed in Kb
memory_fourgb = 4194304

# Calculated semaphore settings in accordance with Oracle documentation
override["kernel"]["semmsl"] = 240 + 10 
override["kernel"]["semmni"] = 128
override["kernel"]["semmns"] = node["kernel"]["semmsl"] * node["kernel"]["semmni"]
override["kernel"]["semopm"] = node["kernel"]["semmsl"]

# Calculated shmmax by architecture and amount of RAM
if node["kernel"]["machine"] =~ /^(x|i[3456])86$/i
  # Set shmmax to lower of 2350000000, or half of memory.
  if ( node["memory"]["total"].to_i > memory_fourgb )
    override["kernel"]["shmmax"] = 3000000000
  else
    override["kernel"]["shmmax"] = ( ( node["memory"]["total"].to_i * 1024 ) / 2 )
  end
elsif node["kernel"]["machine"] =~ /^(x86_|amd)64$/i
  # Set shmmax to half of memory.
  override["kernel"]["shmmax"] = ( ( node["memory"]["total"].to_i * 1024 ) / 2 )
end


