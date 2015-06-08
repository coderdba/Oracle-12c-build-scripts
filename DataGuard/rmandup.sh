#-- DBUNIQUENAME_PRIM - Primary unique name
#-- DBUNIQUENAME_STBY  - Standby unique name

 nohup rman target sys/lhfRL4DB1@rcll04-vip1/DBUNIQUENAME_PRIM auxiliary sys/lhfRL4DB1@rcll05-vip1/DBUNIQUENAME_STBY @rmanduplicateRL4DB1.cmd &
