default[:chef_secret_path] = '/vagrant/chef_secret'

default["mq"]["i686_packages"] = [
  "libgcc",
  "glibc",
  "gtk2",
  "alsa-lib",
  "libXScrnSaver",
  "qt",
  "qt-x11",
  "compat-libstdc++-33"
]

default["mq"]["mq_packages"] = [
  "libgcc",
  "glibc",
  "gtk2",
  "alsa-lib",
  "libXScrnSaver",
  "qt",
  "qt-x11"
]

default["mq"]["v7_packages"] = [
  "gsk7bas-7.0-4.23.i386.rpm",
  "gsk7bas64-7.0-4.23.x86_64.rpm",
  "MQSeriesRuntime-7.0.1-0.x86_64.rpm",
  "MQSeriesServer-7.0.1-0.x86_64.rpm",
  "MQSeriesClient-7.0.1-0.x86_64.rpm",
  "MQSeriesSDK-7.0.1-0.x86_64.rpm",
  "MQSeriesJava-7.0.1-0.x86_64.rpm",
  "MQSeriesJRE-7.0.1-0.x86_64.rpm",
  "MQSeriesKeyMan-7.0.1-0.x86_64.rpm",
  "MQSeriesTXClient-7.0.1-0.x86_64.rpm",
  "MQSeriesMan-7.0.1-0.x86_64.rpm",
  "MQSeriesEclipseSDK33-7.0.1-0.x86_64.rpm",
  "MQSeriesConfig-7.0.1-0.x86_64.rpm"
]

default["mq"]["v71_replacement_packages"] = [
  "gsk7bas-7.0-4.33.i386.rpm",
  "gsk7bas64-7.0-4.33.x86_64.rpm"
]

default["mq"]["v71_packages"] = [
  "MQSeriesRuntime-U844095-7.0.1-7.x86_64.rpm",
  "MQSeriesServer-U844095-7.0.1-7.x86_64.rpm",
  "MQSeriesClient-U844095-7.0.1-7.x86_64.rpm",
  "MQSeriesSDK-U844095-7.0.1-7.x86_64.rpm",
  "MQSeriesJava-U844095-7.0.1-7.x86_64.rpm",
  "MQSeriesJRE-U844095-7.0.1-7.x86_64.rpm",
  "MQSeriesKeyMan-U844095-7.0.1-7.x86_64.rpm",
  "MQSeriesTXClient-U844095-7.0.1-7.x86_64.rpm",
  "MQSeriesMan-U844095-7.0.1-7.x86_64.rpm",
  "MQSeriesConfig-U844095-7.0.1-7.x86_64.rpm"
]
