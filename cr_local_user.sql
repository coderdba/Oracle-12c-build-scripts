--
-- Create local users in PDB environment
--

-- Change over to required PDB
alter session set container = PDB1;

-- Create roles 
create role perfdba_role;

-- Create users
create user dbaquery identified by dbaquery ;
select username, default_tablespace, common from cdb_users where con_id=3 and username ='DBAQUERY';
alter user dbaquery default tablespace dbats;
select username, default_tablespace, common from cdb_users where con_id=3 and username ='DBAQUERY';

-- Grant local roles
grant perfdba_role to dbaquery;

-- Grant common roles
grant c##common_for_all_role to dbaquery;

-- Verify roles for the user
select grantee, granted_role, default_role, common, con_id from cdb_role_privs where grantee='DBAQUERY';




