create or replace PROCEDURE                 i2b2_mass_user_import
IS
CURSOR get_i2b2_user_list IS SELECT * FROM ad_user_imports;

BEGIN
FOR user IN get_i2b2_user_list
LOOP

INSERT INTO PM_USER_DATA
(USER_ID,FULL_NAME,PASSWORD,EMAIL,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD)
SELECT user.user_id, user.full_name, '5e543256c480ac577d30f76f9120eb74', user.email, sysdate, sysdate, 'i2b2', 'A'
FROM dual
WHERE not exists (select * from PM_USER_DATA where PM_USER_DATA.USER_ID = user.user_id);
COMMIT;

--commented on 08/25/2016 for Single Signon Imeplementations Comment Begin
/*
INSERT INTO PM_USER_PARAMS
(DATATYPE_CD,USER_ID,PARAM_NAME_CD,VALUE,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD)
SELECT 'T', user.user_id, 'authentication_method', 'NTLM', sysdate, sysdate, 'i2b2', 'A'
FROM dual
WHERE not exists (select * from PM_USER_PARAMS where PM_USER_PARAMS.USER_ID = user.user_id AND PM_USER_PARAMS.PARAM_NAME_CD = 'authentication_method' AND to_char(PM_USER_PARAMS.VALUE) = 'NTLM');
COMMIT;

INSERT INTO PM_USER_PARAMS
(DATATYPE_CD,USER_ID,PARAM_NAME_CD,VALUE,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD)
SELECT 'T', user.user_id, 'domain', 'campus', sysdate, sysdate, 'i2b2', 'A'
FROM dual
WHERE not exists (select * from PM_USER_PARAMS
where PM_USER_PARAMS.USER_ID = user.user_id AND PM_USER_PARAMS.PARAM_NAME_CD = 'domain' AND to_char(PM_USER_PARAMS.VALUE) = 'campus');
COMMIT;

INSERT INTO PM_USER_PARAMS
(DATATYPE_CD,USER_ID,PARAM_NAME_CD,VALUE,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD)
SELECT 'T', user.user_id, 'domain_controller', 'campus.net.ucsf.edu', sysdate, sysdate, 'i2b2', 'A'
FROM dual
WHERE not exists (select * from PM_USER_PARAMS
where PM_USER_PARAMS.USER_ID = user.user_id AND PM_USER_PARAMS.PARAM_NAME_CD = 'domain_controller' AND to_char(PM_USER_PARAMS.VALUE) = 'campus.net.ucsf.edu');
COMMIT;
*/
--commented on 08/25/2016 for Single Signon Imeplementations Comment End

INSERT INTO PM_PROJECT_USER_ROLES
(PROJECT_ID,USER_ID,USER_ROLE_CD,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD)
SELECT user.project_id, user.user_id, user.user_role_cd, sysdate, sysdate, 'i2b2', 'A'
FROM dual
WHERE not exists (select * from PM_PROJECT_USER_ROLES
where PM_PROJECT_USER_ROLES.PROJECT_ID = user.project_id AND PM_PROJECT_USER_ROLES.USER_ID = user.user_id AND PM_PROJECT_USER_ROLES.USER_ROLE_CD = user.user_role_cd);

COMMIT;

INSERT INTO AD_USER_IMPORT_ARCHIVE
(USER_ID, USER_ROLE_CD, FULL_NAME, EMAIL, PROJECT_ID, DATE_IMPORTED)
SELECT user.user_id, user.user_role_cd, user.full_name, user.email, user.project_id, sysdate
FROM dual
WHERE not exists (select * from AD_USER_IMPORT_ARCHIVE
where AD_USER_IMPORT_ARCHIVE.USER_ID = user.user_id AND AD_USER_IMPORT_ARCHIVE.USER_ROLE_CD = user.user_role_cd
AND AD_USER_IMPORT_ARCHIVE.FULL_NAME = user.full_name AND AD_USER_IMPORT_ARCHIVE.EMAIL = user.email
AND AD_USER_IMPORT_ARCHIVE.PROJECT_ID = user.project_id);

COMMIT;

INSERT INTO AD_USER_IMPORTS_STAGE select * from AD_USER_IMPORTS;

COMMIT;

DELETE from AD_USER_IMPORTS;

COMMIT;

END LOOP;

END i2b2_mass_user_import;
create or replace PROCEDURE                 i2b2_som_user_import
IS
CURSOR get_i2b2_user_list IS SELECT * FROM ad_user_imports;

BEGIN
FOR user IN get_i2b2_user_list
LOOP

INSERT INTO PM_USER_DATA
(USER_ID,FULL_NAME,PASSWORD,EMAIL,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD)
SELECT user.user_id, user.full_name, '5e543256c480ac577d30f76f9120eb74', user.email, sysdate, sysdate, 'i2b2', 'A'
FROM dual
WHERE not exists (select * from PM_USER_DATA where PM_USER_DATA.USER_ID = user.user_id);
COMMIT;
--commented on 08/25/2016 for Single Signon Imeplementations Comment Begin
/*

INSERT INTO PM_USER_PARAMS
(DATATYPE_CD,USER_ID,PARAM_NAME_CD,VALUE,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD)
SELECT 'T', user.user_id, 'authentication_method', 'NTLM', sysdate, sysdate, 'i2b2', 'A'
FROM dual
WHERE not exists (select * from PM_USER_PARAMS where PM_USER_PARAMS.USER_ID = user.user_id AND PM_USER_PARAMS.PARAM_NAME_CD = 'authentication_method' AND to_char(PM_USER_PARAMS.VALUE) = 'NTLM');
COMMIT;

INSERT INTO PM_USER_PARAMS
(DATATYPE_CD,USER_ID,PARAM_NAME_CD,VALUE,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD)
SELECT 'T', user.user_id, 'domain', 'som', sysdate, sysdate, 'i2b2', 'A'
FROM dual
WHERE not exists (select * from PM_USER_PARAMS
where PM_USER_PARAMS.USER_ID = user.user_id AND PM_USER_PARAMS.PARAM_NAME_CD = 'domain' AND to_char(PM_USER_PARAMS.VALUE) = 'som');
COMMIT;

INSERT INTO PM_USER_PARAMS
(DATATYPE_CD,USER_ID,PARAM_NAME_CD,VALUE,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD)
SELECT 'T', user.user_id, 'domain_controller', 'som.ucsf.edu', sysdate, sysdate, 'i2b2', 'A'
FROM dual
WHERE not exists (select * from PM_USER_PARAMS
where PM_USER_PARAMS.USER_ID = user.user_id AND PM_USER_PARAMS.PARAM_NAME_CD = 'domain_controller' AND to_char(PM_USER_PARAMS.VALUE) = 'som.ucsf.edu');
COMMIT;

*/
--commented on 08/25/2016 for Single Signon Imeplementations Comment End
INSERT INTO PM_PROJECT_USER_ROLES
(PROJECT_ID,USER_ID,USER_ROLE_CD,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD)
SELECT user.project_id, user.user_id, user.user_role_cd, sysdate, sysdate, 'i2b2', 'A'
FROM dual
WHERE not exists (select * from PM_PROJECT_USER_ROLES
where PM_PROJECT_USER_ROLES.PROJECT_ID = user.project_id AND PM_PROJECT_USER_ROLES.USER_ID = user.user_id AND PM_PROJECT_USER_ROLES.USER_ROLE_CD = user.user_role_cd);

COMMIT;

INSERT INTO AD_USER_IMPORT_ARCHIVE
(USER_ID, USER_ROLE_CD, FULL_NAME, EMAIL, PROJECT_ID, DATE_IMPORTED)
SELECT user.user_id, user.user_role_cd, user.full_name, user.email, user.project_id, sysdate
FROM dual
WHERE not exists (select * from AD_USER_IMPORT_ARCHIVE
where AD_USER_IMPORT_ARCHIVE.USER_ID = user.user_id AND AD_USER_IMPORT_ARCHIVE.USER_ROLE_CD = user.user_role_cd
AND AD_USER_IMPORT_ARCHIVE.FULL_NAME = user.full_name AND AD_USER_IMPORT_ARCHIVE.EMAIL = user.email
AND AD_USER_IMPORT_ARCHIVE.PROJECT_ID = user.project_id);

COMMIT;

INSERT INTO AD_USER_IMPORTS_STAGE select * from AD_USER_IMPORTS;

COMMIT;

DELETE from AD_USER_IMPORTS;

COMMIT;

END LOOP;

END i2b2_som_user_import;
create or replace PROCEDURE                 i2b2_ucsfmc_user_import
IS
CURSOR get_i2b2_user_list IS SELECT * FROM ad_user_imports;

BEGIN
FOR user IN get_i2b2_user_list
LOOP

INSERT INTO PM_USER_DATA
(USER_ID,FULL_NAME,PASSWORD,EMAIL,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD)
SELECT user.user_id, user.full_name, '5e543256c480ac577d30f76f9120eb74', user.email, sysdate, sysdate, 'i2b2', 'A'
FROM dual
WHERE not exists (select * from PM_USER_DATA where PM_USER_DATA.USER_ID = user.user_id);
COMMIT;

--commented on 08/25/2016 for Single Signon Imeplementations Comment Begin
/*
INSERT INTO PM_USER_PARAMS
(DATATYPE_CD,USER_ID,PARAM_NAME_CD,VALUE,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD)
SELECT 'T', user.user_id, 'authentication_method', 'NTLM', sysdate, sysdate, 'i2b2', 'A'
FROM dual
WHERE not exists (select * from PM_USER_PARAMS where PM_USER_PARAMS.USER_ID = user.user_id AND PM_USER_PARAMS.PARAM_NAME_CD = 'authentication_method' AND to_char(PM_USER_PARAMS.VALUE) = 'NTLM');
COMMIT;

INSERT INTO PM_USER_PARAMS
(DATATYPE_CD,USER_ID,PARAM_NAME_CD,VALUE,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD)
SELECT 'T', user.user_id, 'domain', 'ucsfmc', sysdate, sysdate, 'i2b2', 'A'
FROM dual
WHERE not exists (select * from PM_USER_PARAMS
where PM_USER_PARAMS.USER_ID = user.user_id AND PM_USER_PARAMS.PARAM_NAME_CD = 'domain' AND to_char(PM_USER_PARAMS.VALUE) = 'ucsfmc');
COMMIT;

INSERT INTO PM_USER_PARAMS
(DATATYPE_CD,USER_ID,PARAM_NAME_CD,VALUE,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD)
SELECT 'T', user.user_id, 'domain_controller', 'ucsfmedicalcenter.org', sysdate, sysdate, 'i2b2', 'A'
FROM dual
WHERE not exists (select * from PM_USER_PARAMS
where PM_USER_PARAMS.USER_ID = user.user_id AND PM_USER_PARAMS.PARAM_NAME_CD = 'domain_controller' AND to_char(PM_USER_PARAMS.VALUE) = 'ucsfmedicalcenter.org');
COMMIT;

*/

--commented on 08/25/2016 for Single Signon Imeplementations Comment End


INSERT INTO PM_PROJECT_USER_ROLES
(PROJECT_ID,USER_ID,USER_ROLE_CD,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD)
SELECT user.project_id, user.user_id, user.user_role_cd, sysdate, sysdate, 'i2b2', 'A'
FROM dual
WHERE not exists (select * from PM_PROJECT_USER_ROLES
where PM_PROJECT_USER_ROLES.PROJECT_ID = user.project_id AND PM_PROJECT_USER_ROLES.USER_ID = user.user_id AND PM_PROJECT_USER_ROLES.USER_ROLE_CD = user.user_role_cd);

COMMIT;

INSERT INTO AD_USER_IMPORT_ARCHIVE
(USER_ID, USER_ROLE_CD, FULL_NAME, EMAIL, PROJECT_ID, DATE_IMPORTED)
SELECT user.user_id, user.user_role_cd, user.full_name, user.email, user.project_id, sysdate
FROM dual
WHERE not exists (select * from AD_USER_IMPORT_ARCHIVE
where AD_USER_IMPORT_ARCHIVE.USER_ID = user.user_id AND AD_USER_IMPORT_ARCHIVE.USER_ROLE_CD = user.user_role_cd
AND AD_USER_IMPORT_ARCHIVE.FULL_NAME = user.full_name AND AD_USER_IMPORT_ARCHIVE.EMAIL = user.email
AND AD_USER_IMPORT_ARCHIVE.PROJECT_ID = user.project_id);

COMMIT;

INSERT INTO AD_USER_IMPORTS_STAGE select * from AD_USER_IMPORTS;

COMMIT;

DELETE from AD_USER_IMPORTS;

COMMIT;

END LOOP;

END i2b2_ucsfmc_user_import;

