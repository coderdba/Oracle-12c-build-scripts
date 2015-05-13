set pages 100
column pdb_name format a30

prompt List from show pdbs command
show pdbs

prompt List from dba_pdbs
select pdb_id, pdb_name, con_id from dba_pdbs order by 1,3,2;

prompt List from gv$pdbs with open-mode info
select con_id, name, inst_id, open_mode from gv$pdbs order by 1,2,3
