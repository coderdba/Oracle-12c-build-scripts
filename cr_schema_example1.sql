--
-- cr_schema_example1.sql
--
--
alter session set container=pdb1;
create user user1 identified by user1;
grant resource to user1;
alter user user1 quota unlimited on users;
create table user1.table1 (emp number, dept number);
insert into user1.table1 values(1,1);

alter session set container=cdb$root;
select a.con_id, b.name, a.owner, a.table_name, a.tablespace_name from cdb_tables a, v$pdbs b where a.table_name='TABLE1' and a.con_id = b.con_id;
