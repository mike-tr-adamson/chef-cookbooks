#!/bin/bash
echo "Completing installation of Oracle 11g"

/etc/init.d/iptables stop
chkconfig iptables off

/u01/app/oraInventory/orainstRoot.sh
/u01/app/oracle/product/11.2.0/db_1/root.sh
cp /root/oracle /etc/init.d
cp /root/oratab /etc
chmod 750 /etc/init.d/oracle
chkconfig --add oracle --level 0356
su - -c "sqlplus sys/Oracle123@MCS11G AS SYSDBA @/home/oracle/create_ccs_tbs.sql" oracle


