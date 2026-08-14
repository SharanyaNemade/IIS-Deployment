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


