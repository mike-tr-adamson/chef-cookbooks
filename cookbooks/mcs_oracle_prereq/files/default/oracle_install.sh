#!/bin/bash
echo "Installing Oracle 11g"

/vagrant/oracle11g/install/database/runInstaller -silent -force -waitforcompletion -ignorePrereq -responseFile /home/oracle/db.rsp
