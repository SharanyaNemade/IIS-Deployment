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



















There is **no fixed official number** of ways to deploy a website to IIS. In practice, for an **ASP.NET Core/.NET application**, there are around **5 common deployment methods**.

The important thing is that IIS ultimately needs the **published application files** and an IIS site configured to serve them. The difference is **how those files get onto the IIS server**.

## 1. Folder / File Copy Deployment — Most Basic

This is the simplest method and the one you should learn first.

```text
Visual Studio
     ↓
Publish
     ↓
Folder
     ↓
C:\Publish\MyWebsite
     ↓
Copy files
     ↓
IIS Server
     ↓
IIS Website
```

### Steps

In Visual Studio:

**Project → Publish → Folder**

For example:

```text
C:\Publish\EmployeeAPI
```

Then copy the published files to the IIS server:

```text
C:\Websites\EmployeeAPI
```

Configure IIS:

```text
Site
 ├── Physical Path
 │    C:\Websites\EmployeeAPI
 │
 ├── Binding
 │    http : 80
 │
 └── Application Pool
      EmployeeAPIPool
```

### Best for

* Learning IIS
* Development
* Internal company applications
* Small deployments
* Manual deployments

**This is the method I recommend you understand first.**

---

# 2. Web Deploy / MSDeploy

Microsoft provides **Web Deploy**, commonly called **MSDeploy**.

Instead of manually copying files, Web Deploy can synchronize your application with IIS.

Conceptually:

```text
Visual Studio
      ↓
Web Deploy
      ↓
IIS Server
```

It can handle things such as:

* Application files
* IIS configuration
* Application pools
* Website configuration
* Deployment synchronization

Visual Studio can publish using a **Web Deploy** publishing profile when the IIS server is configured appropriately.

### Best for

* Windows/IIS environments
* Repeated deployments
* Enterprise applications
* More controlled deployments

---

# 3. FTP Deployment

You can also publish your application and transfer the files through **FTP/FTPS**.

```text
Visual Studio
      ↓
Publish
      ↓
FTP
      ↓
IIS Server
      ↓
Website
```

For example:

```text
Publish files
      ↓
FTP Server
      ↓
wwwroot / Website folder
```

### Best for

* Some hosting providers
* Remote servers where FTP is provided
* Simple file-based deployment

However, for a professional internal/enterprise deployment, **Web Deploy, CI/CD, or another controlled deployment mechanism is generally preferable to plain FTP**.

---

# 4. Command-Line Deployment

You don't necessarily need Visual Studio.

You can publish from the command line:

```bash
dotnet publish
```

For example:

```bash
dotnet publish -c Release -o C:\Publish\EmployeeAPI
```

Then copy the output to the IIS server.

You can also automate deployment with PowerShell, MSDeploy, scripts, etc.

The architecture becomes:

```text
Developer
   ↓
dotnet publish
   ↓
Published files
   ↓
PowerShell / MSDeploy
   ↓
IIS
```

### Best for

* Automation
* Build servers
* CI/CD
* Developers who prefer command line
* Repeatable deployments

---

# 5. CI/CD Deployment

This is the more professional approach for teams.

For example:

```text
Developer
    ↓
GitHub
    ↓
Jenkins
    ↓
Build
    ↓
Test
    ↓
dotnet publish
    ↓
Deploy
    ↓
IIS
```

Jenkins could automatically deploy the published application to IIS.

For example:

```text
git push
    ↓
GitHub
    ↓
Jenkins
    ↓
dotnet restore
    ↓
dotnet build
    ↓
dotnet test
    ↓
dotnet publish
    ↓
Deploy to IIS
```

This is **not really a separate IIS hosting mechanism**; it's an **automation mechanism around deployment**. That's an important distinction.

---

# 6. Container Deployment — Docker + IIS/Windows

There is another architecture where your application is packaged as a Docker container.

For example:

```text
ASP.NET Core
      ↓
Dockerfile
      ↓
Docker Image
      ↓
Docker Container
```

The container can then run on a server.

However, **Docker deployment should not be confused with the normal IIS deployment you are currently learning**.

A typical modern ASP.NET Core container deployment is more like:

```text
Docker
   ↓
ASP.NET Core Container
   ↓
Server / Cloud
```

rather than:

```text
IIS
   ↓
Docker
   ↓
ASP.NET Core
```

You can have IIS as a reverse proxy in front of containers, but that is a different architecture.

---

# So how many methods?

For practical purposes, remember these:

| Method                        | Typical use                     | Difficulty |
| ----------------------------- | ------------------------------- | ---------: |
| **Folder/File Copy**          | Manual/local deployment         |          ⭐ |
| **Web Deploy / MSDeploy**     | Professional IIS deployment     |         ⭐⭐ |
| **FTP/FTPS**                  | Hosting providers               |         ⭐⭐ |
| **Command Line / PowerShell** | Scripted deployment             |        ⭐⭐⭐ |
| **CI/CD → IIS**               | Automated enterprise deployment |       ⭐⭐⭐⭐ |
| **Docker-based deployment**   | Containerized architecture      |       ⭐⭐⭐⭐ |

But there is an important distinction:

### Deployment method vs IIS configuration

Regardless of how you deploy the files, IIS still needs things such as:

```text
Application Pool
       ↓
Website
       ↓
Physical Path
       ↓
Binding
       ↓
Port / IP / Hostname
```

For example, all of these:

```text
Folder Copy ────────┐
Web Deploy ─────────┤
FTP ────────────────┤
PowerShell ─────────┤──→ Published Files → IIS
Jenkins ────────────┤
CI/CD ──────────────┘
```

ultimately result in something like:

```text
IIS
 │
 ├── Site: EmployeeAPI
 │
 ├── Physical Path:
 │      C:\Websites\EmployeeAPI
 │
 ├── Application Pool:
 │      EmployeeAPIPool
 │
 └── Binding:
        http://192.168.1.10:80
```

### For your current learning path

I would learn them in this order:

**1. Folder deployment → 2. Web Deploy → 3. Command-line deployment → 4. Jenkins/CI-CD → 5. Docker**

Once you understand **Folder → IIS** properly, the other methods become much easier because you're only changing **how the published files reach the server**, not the fundamental IIS hosting concept.

