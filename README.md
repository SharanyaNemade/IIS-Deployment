# IIS-Deployment
Stepd to Deploy on IIS


Yes. If your Employee Management System is an ASP.NET Core Web API/MVC application with SQL Server, the IIS deployment process is essentially:



Visual Studio
     ↓
Build / Publish
     ↓
Published Files
     ↓
IIS Server
     ↓
Application Pool
     ↓
Website
     ↓
Browser / Postman
     ↓
ASP.NET Core Application
     ↓
SQL Server



1. Prerequisites on the IIS machine

On the Windows machine where IIS will host your application, you need:

IIS

Open:

Control Panel
→ Programs
→ Turn Windows features on or off

Enable:

Internet Information Services
    ├── Web Management Tools
    │     └── IIS Management Console
    │
    └── World Wide Web Services
          ├── Application Development Features
          ├── Common HTTP Features
          └── Security

Or use Server Manager → Add Roles and Features if this is Windows Server.






2. Install ASP.NET Core Hosting Bundle

This is very important.

IIS itself does not directly run an ASP.NET Core application. The ASP.NET Core Hosting Bundle installs the components needed for IIS to forward requests to your ASP.NET Core application.

For example:

Browser
   ↓
IIS
   ↓
ASP.NET Core Module
   ↓
Your .NET Application

Install the Hosting Bundle corresponding to your application's .NET version.

For example, if your project targets:

<TargetFramework>net8.0</TargetFramework>

make sure the IIS server has the appropriate .NET 8 hosting components installed.

After installing, restart IIS:    iisreset





3. Make sure your application works locally

Before touching IIS, run the application from Visual Studio.

For example:

https://localhost:7228

Test your API using Swagger/Postman.

For example:

GET https://localhost:7228/api/Employee

Make sure:

API works
Database connection works
CRUD works
Stored procedures work
Authentication works
No major exceptions occur

Do not troubleshoot IIS and application bugs simultaneously. First establish that the application itself works.






4. Check your database connection

This is one of the most common deployment problems.

Your local application might have:

{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=EmployeeDB;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}

But on the IIS server, localhost means:

the IIS server itself, not your development PC.

So if SQL Server is on another machine, you need the appropriate SQL Server name/IP.

For example:

{
  "ConnectionStrings": {
    "DefaultConnection": "Server=192.168.1.100;Database=EmployeeDB;User Id=sa;Password=yourpassword;TrustServerCertificate=True;"
  }
}

Or preferably use a proper SQL Server/service account rather than sa.







5. Publish the application from Visual Studio

Right-click your ASP.NET Core project.

Choose:

Right Click Project
        ↓
Publish

Select:

Folder

For example:

C:\Publish\EmployeeManagement

Then select:

Configuration: Release

and click:

Publish

Visual Studio will generate something similar to:

C:\Publish\EmployeeManagement


    EmployeeManagement.dll
    EmployeeManagement.deps.json
    EmployeeManagement.runtimeconfig.json
    web.config
    appsettings.json
    appsettings.Development.json
    wwwroot\
    ...

The important thing is:

Deploy the published output, not your Visual Studio project folder.







IF YOU HAVEN'T PUBLISHED THE WEBSITE THEN :-



Correct. Stop at the SQL Server Login step for now. Since you haven't published or created the IIS application yet, you don't have an Application Pool name to use.

Let's do this in the correct order. Don't configure SQL Server permissions prematurely.

Your deployment sequence

For your Employee Management backend:

1. Verify application locally
        ↓
2. Publish ASP.NET Core backend
        ↓
3. Create IIS Application Pool
        ↓
4. Create IIS Website
        ↓
5. Configure folder permissions
        ↓
6. Configure SQL Server permission
        ↓
7. Test API through IIS
Step 1 — First verify your project

Before publishing, run your project from Visual Studio and make sure this works:

GET /api/Employee
POST /api/Employee
PUT /api/Employee/{id}
DELETE /api/Employee/{id}

Also make sure your current connection string works:

"ConnectionStrings": {
  "DbConn": "Server=localhost\\SQLEXPRESS;Database=Dapper;Trusted_Connection=True;TrustServerCertificate=True;"
}

If it works locally, move on.

Step 2 — Publish your backend

In Visual Studio:

Solution Explorer
    ↓
Right-click your ASP.NET Core backend project
    ↓
Publish...

You should get the Publish screen.

Select:

Target
   ↓
Folder

Then choose a folder such as:

C:\Publish\EmployeeManagement

Set:

Configuration: Release

Then click:

Publish

You should eventually get something like:

C:\Publish\EmployeeManagement
│
├── EmployeeManagement.dll
├── EmployeeManagement.deps.json
├── EmployeeManagement.runtimeconfig.json
├── web.config
├── appsettings.json
├── appsettings.Development.json
└── wwwroot

The exact files depend on your project.

Step 3 — After publishing, create the IIS Application Pool

Only after publishing, go to:

IIS Manager
    ↓
Application Pools
    ↓
Add Application Pool...

Give it a clear name, for example:

EmployeeManagementPool

Set:

.NET CLR Version: No Managed Code
Managed pipeline mode: Integrated

Click OK.

Now you have an actual Application Pool.

Step 4 — Then create the IIS Website

Go to:

IIS
    ↓
Sites
    ↓
Right-click
    ↓
Add Website...

For example:

Site name:
EmployeeManagement


Physical path:
C:\Publish\EmployeeManagement


Application Pool:
EmployeeManagementPool


Type:
http


IP:
All Unassigned


Port:
8080

Now your architecture becomes:

EmployeeManagement Project
          ↓
       Publish
          ↓
C:\Publish\EmployeeManagement
          ↓
     IIS Website
          ↓
EmployeeManagementPool
          ↓
   ASP.NET Core API
Step 5 — Only NOW configure SQL Server

Once the pool exists and you've named it:

EmployeeManagementPool

then come back to SSMS:

SQL Server
 ↓
Security
 ↓
Logins
 ↓
New Login

and create:

IIS APPPOOL\EmployeeManagementPool

Then map it to:

Dapper

with the appropriate database permissions.

So what should you do right now?

Don't touch SSMS anymore for the moment.

Your immediate next task is:

Publish your ASP.NET Core backend from Visual Studio.

Once the Publish window opens, send me a screenshot of that Publish screen. I'll tell you exactly what to select and what folder to use.
