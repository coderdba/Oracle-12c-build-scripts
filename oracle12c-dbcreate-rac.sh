#!/bin/ksh
#
#
#  To create Oracle RAC Database
#
#

export DBNAME=DB1
export DBNAME_UNIQUE=DB1_P

export ORACLE_HOME=/oracle/db/product/12.1.0.2
export ORACLE_BASE=/oracle/db
export GRID_HOME=/oracle/grid/12.1.0.2
export GRID_BASE=/oracle/grid

export PATH=/bin:/usr/bin:/etc:/usr/etc:/usr/local/bin:/usr/lib:/usr/sbin:/usr/ccs/bin:/usr/ucb:/usr/bin/X11:/sbin:$ORACLE_HOME/bin:.

dbca -silent -createDatabase -gdbName $DBNAME_UNIQUE -sid $DBNAME -characterSet AL32UTF8 -nationalCharacterSet AL16UTF16 -templatename General_Purpose.dbc -sysPassword sys123 -systemPassword system123 -createAsContainerDatabase true -numberOfPdbs 1 -pdbName P1 -pdbAdminUserName PDBADMIN -pdbAdminPassword pdbadmin123 -storageType ASM -diskGroupName DATA01 -recoveryGroupName FRA01 -redoLogFileSize 100M -emConfiguration NONE -sampleSchema false 
