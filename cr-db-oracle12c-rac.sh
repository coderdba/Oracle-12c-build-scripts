#!/bin/ksh
#---------------------------------------------------------------------------------------------------
#  To create Oracle RAC Database
#
#  Author: Gowrish Mallipattana
#
#  Disclaimer:  Syntax and other errors may exist in this program.  
#               Author not responsible for the actions of this program, good or bad.
#
#  TODO and CHECK:  Search for TODO and CHECK for incomplete sections 
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
export PATH=/bin:/usr/bin:/etc:/usr/etc:/usr/local/bin:/usr/lib:/usr/sbin:/usr/ccs/bin:/usr/ucb:/usr/bin/X11:/sbin:$ORACLE_HOME/bin:.
export oratab=/etc/oratab
export listenerora=$TNS_ADMIN/listener.ora
export tnsnamesora=$TNS_ADMIN/tnsnames.ora
export RACNODES=`$GRID_HOME/bin/onsnodes`  #This gives space-delimited list
export RACNODES=`echo $RACNODES | sed 's/ /,/g'`  #Change space to comma delimited
export RACCLUSTERNAME=`$GRID_HOME/bin/cemutlo -n`
export RACSCANNAME=`srvctl config scan |grep "SCAN name:" | cut -d: -f2 |cut -d, -f1 |sed 's/ //g'`

echo "INFO - Listing environment:"
env |sort

echo
echo "INFO - Creating Database using DBCA command"
echo
dbca -silent -createDatabase -gdbName $DBNAME_UNIQUE -sid $DBNAME -nodelist $RACNODES -databaseType MULTIPURPOSE -characterSet AL32UTF8 -nationalCharacterSet AL16UTF16 -initParams db_name=$DBNAME,db_unique_name=$DBNAME_UNIQUE,db_block_size=8 -templatename General_Purpose.dbc -sysPassword sys123 -systemPassword system123 -createAsContainerDatabase true -numberOfPdbs 1 -pdbName P1 -pdbAdminUserName PDBADMIN -pdbAdminPassword pdbadmin123 -storageType ASM -diskGroupName DATA01 -recoveryGroupName FRA01 -redoLogFileSize 100M -emConfiguration NONE -sampleSchema false 

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

echo "INFO - Listing DB configuration using srvctl config database -d $DBNAME_UNIQUE"
srvctl config database -d $DBNAME_UNIQUE

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

# CHECK - check if verify function should be common or local to PDB
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


# TODO - apply psu
# TODO - custom init.ora settings
# TODO - Install additional packages - like Java etc
# TODO - create a tns entry for DB and its PDBs
# TODO - verify srvctl configuration
# TODO - create basic profiles - common/local
# TODO - create utility users - common/local
# TODO - create additional tablespaces
# TODO - create additional default users
# TODO - create cloud schemas
# TODO - create cloud control table
# TODO - register with RMAN
# TODO - register with OEM
