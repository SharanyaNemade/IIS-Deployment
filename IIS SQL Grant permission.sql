USE Dapper;
GO

SELECT 
    name,
    type_desc
FROM sys.database_principals
WHERE name = 'Dapper';



USE Dapper;
GO

CREATE USER [Dapper] FOR LOGIN [IIS APPPOOL\Dapper_CRUD];
GO



USE Dapper;
GO

SELECT
    dp.name AS DatabaseUser,
    sp.name AS ServerLogin
FROM sys.database_principals dp
INNER JOIN sys.server_principals sp
    ON dp.sid = sp.sid
WHERE sp.name = 'IIS APPPOOL\Dapper_CRUD';




USE Dapper;
GO

GRANT EXECUTE TO Dapper;
GO




USE Dapper;
GO

GRANT EXECUTE ON dbo.sp_GetEmployee TO [IIS APPPOOL\Dapper_CRUD];
GRANT EXECUTE ON dbo.sp_GetEmployeeById TO [IIS APPPOOL\Dapper_CRUD];
GO






USE Dapper;
GO

SELECT
    dp.name AS DatabaseUser,
    p.permission_name,
    p.state_desc
FROM sys.database_principals dp
INNER JOIN sys.database_permissions p
    ON dp.principal_id = p.grantee_principal_id
WHERE dp.name = 'IIS APPPOOL\Dapper_CRUD';




USE Dapper;
GO

SELECT name
FROM sys.procedures
ORDER BY name;






USE Dapper;
GO

GRANT EXECUTE ON dbo.sp_AddEmp TO [IIS APPPOOL\Dapper_CRUD];
GRANT EXECUTE ON dbo.sp_GetEmployee TO [IIS APPPOOL\Dapper_CRUD];
GRANT EXECUTE ON dbo.sp_GetEmployeeById TO [IIS APPPOOL\Dapper_CRUD];
GRANT EXECUTE ON dbo.sp_DeleteEmployee TO [IIS APPPOOL\Dapper_CRUD];
GRANT EXECUTE ON dbo.sp_UpdateEmployee TO [IIS APPPOOL\Dapper_CRUD];
GO




USE Dapper;
GO

GRANT EXECUTE TO [IIS APPPOOL\Dapper_CRUD];
GO


SELECT
    dp.name AS DatabaseUser,
    dp.type_desc,
    p.permission_name,
    p.state_desc
FROM sys.database_principals dp
LEFT JOIN sys.database_permissions p
    ON dp.principal_id = p.grantee_principal_id
WHERE dp.name = 'IIS APPPOOL\Dapper_CRUD';




--      After Connecting IIS



USE Dapper;
GO

SELECT
    dp.name AS DatabaseUser,
    dp.type_desc,
    p.permission_name,
    p.state_desc
FROM sys.database_principals dp
LEFT JOIN sys.database_permissions p
    ON dp.principal_id = p.grantee_principal_id
WHERE dp.name = 'IIS APPPOOL\Dapper_CRUD';






USE Dapper;
GO

SELECT
    dp.name AS DatabaseUser,
    sp.name AS ServerLogin
FROM sys.database_principals dp
LEFT JOIN sys.server_principals sp
    ON dp.sid = sp.sid
WHERE dp.name = 'IIS APPPOOL\Dapper_CRUD'
   OR sp.name = 'IIS APPPOOL\Dapper_CRUD';







   USE Dapper;
GO

EXECUTE AS USER = 'IIS APPPOOL\Dapper_CRUD';
GO

EXEC dbo.sp_GetEmployee;
GO

REVERT;
GO




USE Dapper;
GO

SELECT
    dp.name AS DatabaseUser,
    p.permission_name,
    p.state_desc,
    OBJECT_NAME(p.major_id) AS ObjectName
FROM sys.database_principals dp
JOIN sys.database_permissions p
    ON dp.principal_id = p.grantee_principal_id
WHERE dp.name = 'IIS APPPOOL\Dapper_CRUD';






USE Dapper;
GO

EXECUTE AS USER = 'IIS APPPOOL\Dapper_CRUD';
GO

SELECT USER_NAME() AS CurrentUser;
GO

EXEC dbo.sp_GetEmployee;
GO

REVERT;
GO



SELECT * FROM Employees;