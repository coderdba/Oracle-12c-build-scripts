CREATE PLUGGABLE DATABASE pdb2 FROM pdb1;
alter pluggable database pdb2 open instances=all;
select con_id, name, open_mode from v$pdbs order by 1,2;
