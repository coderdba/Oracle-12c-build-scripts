#!/bin/ksh
#---------------------------------------------------------------------------------------------------
#  To create Oracle RAC Database
#
#  Author: Gowrish Mallipattana
#
#  Disclaimer:  Syntax and other errors may exist in this program.  
#               Author not responsible for the actions of this program, good or bad.
#
#  NOTES:
#  1. Customize password-verify-function as needed in utlpwdmg.sql before running this script
#
#--------------------------------------------------------------------------------------------------

export script=$0

export DBNAME=DB1  #Can be parametrized
export DBNAME_UNIQUE=DB1_P #Can be derived from DBNAME if standardized
export PDBNAME=P1
export ARCHIVELOGMODE=YES

echo "INFO - Starting $script" `date`
echo

echo "INFO - Setting environment and variables"
echo
export ORACLE_HOME=/oracle/db/product/12.1.0.2
export ORACLE_BASE=/oracle/db
export GRID_HOME=/oracle/grid/12.1.0.2
export GRID_BASE=/oracle/grid
export TNS_ADMIN=/usr/local/tns
export oratab=/etc/oratab
export listenerora=$TNS_ADMIN/listener.ora
export tnsnamesora=$TNS_ADMIN/tnsnames.ora
export RACNODES="node1,node2"
export PATH=/bin:/usr/bin:/etc:/usr/etc:/usr/local/bin:/usr/lib:/usr/sbin:/usr/ccs/bin:/usr/ucb:/usr/bin/X11:/sbin:$ORACLE_HOME/bin:.

echo "INFO - Listing environment:"
env |sort

echo
echo "INFO - Creating Database using DBCA command"
echo
dbca -silent -createDatabase -gdbName $DBNAME_UNIQUE -sid $DBNAME -nodelist $RACNODES -databaseType MULTIPURPOSE -characterSet AL32UTF8 -nationalCharacterSet AL16UTF16 -initParams db_name=$DBNAME,db_unique_name=$DBNAME_UNIQUE,blocksize=8192 -templatename General_Purpose.dbc -sysPassword sys123 -systemPassword system123 -createAsContainerDatabase true -numberOfPdbs 1 -pdbName P1 -pdbAdminUserName PDBADMIN -pdbAdminPassword pdbadmin123 -storageType ASM -diskGroupName DATA01 -recoveryGroupName FRA01 -redoLogFileSize 100M -emConfiguration NONE -sampleSchema false 

if [$# -ne 0]
then
echo "ERR - Error while creating database using DBCA command"
exit 1
fi

echo "INFO - Opening the PDB and saving open state"
sqlplus / as sysdba <<EOF
whenever sqlerror exit 1
alter pluggable database $PDBNAME open;
alter pluggable database $PDBNAME save state;
EOF

if [$? -ne 0]
then
echo "ERR - Error while opening PDB"
exit 1
fi

if [$ARCHIVELOGMODE="YES"]
echo "INFO - Setting archivelog mode"

sqlplus / as sysdba <<EOF
whenever sqlerror exit 1
alter database archivelog;
EOF

	if [$? -ne 0]
	then
	echo "ERR - Error while setting archivelog mode"
	#exit 1  #Probably we dont need to exit, instead, fix later
	else
	echo "INFO - Setting archivelog mode successful"
	echo
	fi

else
echo "INFO - Not setting archivelog mode"
echo
fi

echo "INFO - Creating Verify Function"
sqlplus / as sysdba <<EOF
whenever sqlerror exit 1
@$ORACLE_HOME/rdbms/admin/utlpwdmg.sql
EOF

if [$# -ne 0]
then
echo "INFO - Error while creating verify function"
#exit 1  #Probably we dont need to exit, instead, fix later
fi

# apply psu
# create basic profiles - common/local
# create utility users - common/local
# create additional tablespaces
# create additional default users
# create cloud schemas
# create cloud control table
