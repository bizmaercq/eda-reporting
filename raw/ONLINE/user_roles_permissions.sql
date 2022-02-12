
-- Roles and permissions for Digital banking users

select u.user_id, u.first_name||' '||u.middle_name||' '||u.last_name employee_name ,r.role_name,r.role_desc, p.permission_name from
usr_mgmt_user u, usr_mgmt_user_role_mapping rm, usr_mgmt_role r, usr_mgmt_role_permission rp, usr_mgmt_permission p
where rm.user_id = u.user_id
and rm.role_id = r.role_id
and rp.role_id = r.role_id
and rp.permission_id = p.permission_id
order by u.first_name;




---- list of roles and permissions

select r.role_name,r.role_desc, p.permission_name from
 usr_mgmt_role r, usr_mgmt_role_permission rp, usr_mgmt_permission p
where  rp.role_id = r.role_id
and rp.permission_id = p.permission_id
order by r.role_id;

----- All roles

select r.role_name from usr_mgmt_role r;

