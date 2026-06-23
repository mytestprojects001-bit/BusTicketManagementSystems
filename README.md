# Bus Ticket Management System

## Project Status: ✅ FRAMEWORK CREATED - READY FOR DEVELOPMENT

### Architecture Overview

**4-Layer Clean Architecture:**
```
BusTicketManagement.API           → REST Controllers & Middleware
BusTicketManagement.Application   → Services, DTOs, Business Logic
BusTicketManagement.Infrastructure → ADO.NET Repositories, Data Access  
BusTicketManagement.Domain        → Entities, Domain Models
```

### Database
✅ SQL Server database schema complete with all tables
✅ All foreign keys and constraints in place
✅ Sample data and configuration ready
✅ Stored procedures framework ready

### Backend Stack
- .NET 6 Web API
- ADO.NET (Raw SQL - No EF Core)
- SQL Server
- JWT Authentication
- Serilog Logging
- Swagger/OpenAPI
- AutoMapper

### Key Features Implemented
✅ Database schema with 12 core tables
✅ Clean architecture project structure  
✅ ADO.NET DbConnectionFactory
✅ Authentication framework
✅ CORS & Security middleware
✅ Swagger documentation
✅ Logging infrastructure
✅ Global exception handling

### Next Steps

**Repositories to Build:**
1. BusRepository (CRUD operations)
2. BookingRepository (Booking management)
3. ScheduleRepository (Schedule operations)
4. PaymentRepository (Payment processing)
5. UserRepository (User management)

**Services to Build:**
1. BusService
2. BookingService
3. ScheduleService
4. PaymentService
5. AuthenticationService

**Controllers to Build:**
1. BusController
2. BookingController
3. ScheduleController
4. PaymentController
5. AuthController
6. AdminController
7. ReportController

**Frontend (Angular 16):**
- Dashboard components
- Bus listing & booking
- User profile management
- Admin panel
- Report generation
- PDF/Excel export

### Database Setup

```sql
-- Execute in SQL Server Management Studio
USE master;
GO
-- Run Database/01_CreateDatabase.sql
```

### Running the Project

**Backend:**
```bash
cd BusTicketManagement.API
dotnet restore
dotnet build
dotnet run
```
API runs at: `https://localhost:5001`
Swagger UI: `https://localhost:5001/swagger`

**Frontend:**
```bash
cd BusTicketManagement.Frontend
npm install
ng serve
```
Frontend runs at: `http://localhost:4200`

### Project Structure
```
BusTicketManagementSystems/
├── BusTicketManagement.API/
│   ├── Controllers/
│   ├── Program.cs
│   └── appsettings.json
├── BusTicketManagement.Application/
│   ├── DTOs/
│   └── Services/
├── BusTicketManagement.Infrastructure/
│   ├── Data/
│   └── Repositories/
├── BusTicketManagement.Domain/
│   └── Entities/
├── BusTicketManagement.Frontend/
│   └── src/app/
└── Database/
    └── SQL scripts
```

### Roles & Permissions

**Default Roles:**
- Admin - Full system access
- Staff - Bus & schedule management
- Customer - Booking & viewing

**Permissions:**
- CreateBus, UpdateBus, DeleteBus, ViewBus
- BookTicket, CancelTicket
- ViewReports
- ManageUsers, ManageRoles, ManagePermissions
- ViewDashboard
- ManageSchedules

### Database Tables Created
✅ AspNetUsers, AspNetRoles, AspNetUserRoles
✅ Permissions, RolePermissions, UserPermissions
✅ Buses, Routes, RouteStops, RouteSegments
✅ Schedules, Seats, SeatAvailability
✅ Bookings, BookingDetails
✅ Payments
✅ AuditLogs, SystemConfiguration

### Configuration Files
✅ appsettings.json - Connection strings & JWT settings
✅ .gitignore - VS/Node exclusions
✅ Project files (.csproj) - NuGet dependencies

---
**Status:** Framework ready. Next phase: Implement repositories and services.
