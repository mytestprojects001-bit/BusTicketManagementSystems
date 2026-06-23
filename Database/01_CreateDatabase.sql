USE master;
GO
IF DB_ID('BusTicketManagementDB') IS NOT NULL
BEGIN
    ALTER DATABASE BusTicketManagementDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BusTicketManagementDB;
END
GO
CREATE DATABASE BusTicketManagementDB;
GO
USE BusTicketManagementDB;
GO
CREATE TABLE AspNetRoles (Id NVARCHAR(450) PRIMARY KEY, Name NVARCHAR(256) NOT NULL, NormalizedName NVARCHAR(256), ConcurrencyStamp NVARCHAR(MAX), Description NVARCHAR(500), IsActive BIT DEFAULT 1, CreatedDate DATETIME2 DEFAULT GETUTCDATE(), UNIQUE(NormalizedName));
GO
CREATE TABLE AspNetUsers (Id NVARCHAR(450) PRIMARY KEY, UserName NVARCHAR(256) NOT NULL, NormalizedUserName NVARCHAR(256), Email NVARCHAR(256), NormalizedEmail NVARCHAR(256), EmailConfirmed BIT DEFAULT 0, PasswordHash NVARCHAR(MAX), SecurityStamp NVARCHAR(MAX), ConcurrencyStamp NVARCHAR(MAX), PhoneNumber NVARCHAR(20), PhoneNumberConfirmed BIT DEFAULT 0, TwoFactorEnabled BIT DEFAULT 0, LockoutEnd DATETIMEOFFSET, LockoutEnabled BIT DEFAULT 0, AccessFailedCount INT DEFAULT 0, FirstName NVARCHAR(100), LastName NVARCHAR(100), IsActive BIT DEFAULT 1, CreatedDate DATETIME2 DEFAULT GETUTCDATE(), ModifiedDate DATETIME2, UNIQUE(NormalizedUserName));
GO
CREATE TABLE AspNetUserRoles (UserId NVARCHAR(450), RoleId NVARCHAR(450), PRIMARY KEY (UserId, RoleId), FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE, FOREIGN KEY (RoleId) REFERENCES AspNetRoles(Id) ON DELETE CASCADE);
GO
CREATE TABLE AspNetUserClaims (Id INT PRIMARY KEY IDENTITY(1,1), UserId NVARCHAR(450), ClaimType NVARCHAR(MAX), ClaimValue NVARCHAR(MAX), FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE);
GO
CREATE TABLE AspNetRoleClaims (Id INT PRIMARY KEY IDENTITY(1,1), RoleId NVARCHAR(450), ClaimType NVARCHAR(MAX), ClaimValue NVARCHAR(MAX), FOREIGN KEY (RoleId) REFERENCES AspNetRoles(Id) ON DELETE CASCADE);
GO
CREATE TABLE Permissions (PermissionId INT PRIMARY KEY IDENTITY(1,1), PermissionName NVARCHAR(100) NOT NULL UNIQUE, Description NVARCHAR(500), Module NVARCHAR(50), IsActive BIT DEFAULT 1, CreatedDate DATETIME2 DEFAULT GETUTCDATE());
GO
CREATE TABLE RolePermissions (RolePermissionId INT PRIMARY KEY IDENTITY(1,1), RoleId NVARCHAR(450), PermissionId INT, CreatedDate DATETIME2 DEFAULT GETUTCDATE(), FOREIGN KEY (RoleId) REFERENCES AspNetRoles(Id) ON DELETE CASCADE, FOREIGN KEY (PermissionId) REFERENCES Permissions(PermissionId) ON DELETE CASCADE, UNIQUE(RoleId, PermissionId));
GO
CREATE TABLE UserPermissions (UserPermissionId INT PRIMARY KEY IDENTITY(1,1), UserId NVARCHAR(450), PermissionId INT, CreatedDate DATETIME2 DEFAULT GETUTCDATE(), FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE, FOREIGN KEY (PermissionId) REFERENCES Permissions(PermissionId) ON DELETE CASCADE, UNIQUE(UserId, PermissionId));
GO
CREATE TABLE Buses (BusId INT PRIMARY KEY IDENTITY(1,1), BusNo NVARCHAR(50) NOT NULL UNIQUE, BusType NVARCHAR(20), Capacity INT NOT NULL, CurrentStatus NVARCHAR(20) DEFAULT 'Active', ManufacturerName NVARCHAR(100), RegistrationDate DATETIME2, CreatedDate DATETIME2 DEFAULT GETUTCDATE(), ModifiedDate DATETIME2, CreatedBy NVARCHAR(450), ModifiedBy NVARCHAR(450), IsActive BIT DEFAULT 1, FOREIGN KEY (CreatedBy) REFERENCES AspNetUsers(Id), FOREIGN KEY (ModifiedBy) REFERENCES AspNetUsers(Id));
GO
CREATE TABLE Routes (RouteId INT PRIMARY KEY IDENTITY(1,1), RouteName NVARCHAR(100) NOT NULL, Source NVARCHAR(100) NOT NULL, Destination NVARCHAR(100) NOT NULL, Distance DECIMAL(10,2), DurationMinutes INT, CreatedDate DATETIME2 DEFAULT GETUTCDATE(), ModifiedDate DATETIME2, IsActive BIT DEFAULT 1);
GO
CREATE TABLE RouteStops (StopId INT PRIMARY KEY IDENTITY(1,1), RouteId INT NOT NULL, StopName NVARCHAR(100) NOT NULL, StopOrder INT NOT NULL, DistanceFromSource DECIMAL(10,2), ArrivalTimeOffset INT, DepartureTimeOffset INT, FOREIGN KEY (RouteId) REFERENCES Routes(RouteId) ON DELETE CASCADE, UNIQUE(RouteId, StopOrder));
GO
CREATE TABLE RouteSegments (SegmentId INT PRIMARY KEY IDENTITY(1,1), RouteId INT NOT NULL, FromStopId INT NOT NULL, ToStopId INT NOT NULL, Distance DECIMAL(10,2), DurationMinutes INT, FOREIGN KEY (RouteId) REFERENCES Routes(RouteId) ON DELETE CASCADE, FOREIGN KEY (FromStopId) REFERENCES RouteStops(StopId), FOREIGN KEY (ToStopId) REFERENCES RouteStops(StopId), UNIQUE(RouteId, FromStopId, ToStopId));
GO
CREATE TABLE Schedules (ScheduleId INT PRIMARY KEY IDENTITY(1,1), BusId INT NOT NULL, RouteId INT NOT NULL, DepartureTime DATETIME2 NOT NULL, ArrivalTime DATETIME2 NOT NULL, AvailableSeats INT NOT NULL, FarePerSeat DECIMAL(10,2) NOT NULL, ScheduleStatus NVARCHAR(20) DEFAULT 'Scheduled', CreatedDate DATETIME2 DEFAULT GETUTCDATE(), ModifiedDate DATETIME2, IsActive BIT DEFAULT 1, FOREIGN KEY (BusId) REFERENCES Buses(BusId), FOREIGN KEY (RouteId) REFERENCES Routes(RouteId));
GO
CREATE TABLE Seats (SeatId INT PRIMARY KEY IDENTITY(1,1), BusId INT NOT NULL, SeatNumber NVARCHAR(10) NOT NULL, SeatType NVARCHAR(20), IsActive BIT DEFAULT 1, FOREIGN KEY (BusId) REFERENCES Buses(BusId) ON DELETE CASCADE, UNIQUE(BusId, SeatNumber));
GO
CREATE TABLE SeatAvailability (SeatAvailabilityId INT PRIMARY KEY IDENTITY(1,1), ScheduleId INT NOT NULL, SeatId INT NOT NULL, FromSegmentId INT NOT NULL, ToSegmentId INT NOT NULL, IsAvailable BIT DEFAULT 1, FOREIGN KEY (ScheduleId) REFERENCES Schedules(ScheduleId) ON DELETE CASCADE, FOREIGN KEY (SeatId) REFERENCES Seats(SeatId), FOREIGN KEY (FromSegmentId) REFERENCES RouteSegments(SegmentId), FOREIGN KEY (ToSegmentId) REFERENCES RouteSegments(SegmentId), UNIQUE(ScheduleId, SeatId, FromSegmentId, ToSegmentId));
GO
CREATE TABLE Bookings (BookingId INT PRIMARY KEY IDENTITY(1,1), BookingNumber NVARCHAR(50) NOT NULL UNIQUE, UserId NVARCHAR(450) NOT NULL, ScheduleId INT NOT NULL, FromSegmentId INT NOT NULL, ToSegmentId INT NOT NULL, BookingDate DATETIME2 DEFAULT GETUTCDATE(), BookingStatus NVARCHAR(20) DEFAULT 'Confirmed', PassengerName NVARCHAR(100) NOT NULL, PassengerEmail NVARCHAR(256), PassengerPhone NVARCHAR(20), TotalFare DECIMAL(10,2) NOT NULL, DiscountAmount DECIMAL(10,2) DEFAULT 0, FinalFare DECIMAL(10,2) NOT NULL, CancellationDate DATETIME2, RefundAmount DECIMAL(10,2) DEFAULT 0, CancellationReason NVARCHAR(500), CreatedDate DATETIME2 DEFAULT GETUTCDATE(), ModifiedDate DATETIME2, FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id), FOREIGN KEY (ScheduleId) REFERENCES Schedules(ScheduleId), FOREIGN KEY (FromSegmentId) REFERENCES RouteSegments(SegmentId), FOREIGN KEY (ToSegmentId) REFERENCES RouteSegments(SegmentId));
GO
CREATE TABLE BookingDetails (BookingDetailId INT PRIMARY KEY IDENTITY(1,1), BookingId INT NOT NULL, SeatId INT NOT NULL, SeatNumber NVARCHAR(10), FOREIGN KEY (BookingId) REFERENCES Bookings(BookingId) ON DELETE CASCADE, FOREIGN KEY (SeatId) REFERENCES Seats(SeatId), UNIQUE(BookingId, SeatId));
GO
CREATE TABLE Payments (PaymentId INT PRIMARY KEY IDENTITY(1,1), PaymentNumber NVARCHAR(50) NOT NULL UNIQUE, BookingId INT NOT NULL, Amount DECIMAL(10,2) NOT NULL, PaymentMethod NVARCHAR(50), PaymentStatus NVARCHAR(20) DEFAULT 'Pending', TransactionId NVARCHAR(100), PaymentDate DATETIME2, CreatedDate DATETIME2 DEFAULT GETUTCDATE(), ModifiedDate DATETIME2, FOREIGN KEY (BookingId) REFERENCES Bookings(BookingId) ON DELETE CASCADE);
GO
CREATE TABLE AuditLogs (AuditLogId INT PRIMARY KEY IDENTITY(1,1), UserId NVARCHAR(450), Action NVARCHAR(100), TableName NVARCHAR(100), RecordId NVARCHAR(50), OldValues NVARCHAR(MAX), NewValues NVARCHAR(MAX), Timestamp DATETIME2 DEFAULT GETUTCDATE(), IPAddress NVARCHAR(50));
GO
CREATE TABLE SystemConfiguration (ConfigId INT PRIMARY KEY IDENTITY(1,1), ConfigKey NVARCHAR(100) NOT NULL UNIQUE, ConfigValue NVARCHAR(MAX), Description NVARCHAR(500), ModifiedDate DATETIME2 DEFAULT GETUTCDATE());
GO
INSERT INTO AspNetRoles (Id, Name, NormalizedName, Description, IsActive) VALUES ('admin-role', 'Admin', 'ADMIN', 'System Administrator', 1), ('staff-role', 'Staff', 'STAFF', 'Staff Member', 1), ('customer-role', 'Customer', 'CUSTOMER', 'Customer User', 1);
GO
INSERT INTO Permissions (PermissionName, Description, Module, IsActive) VALUES ('CreateBus', 'Create new bus', 'Bus', 1), ('UpdateBus', 'Update bus details', 'Bus', 1), ('DeleteBus', 'Delete bus', 'Bus', 1), ('ViewBus', 'View bus list', 'Bus', 1), ('BookTicket', 'Book ticket', 'Booking', 1), ('CancelTicket', 'Cancel ticket', 'Booking', 1), ('ViewReports', 'View reports', 'Reports', 1), ('ManageUsers', 'Manage users', 'Admin', 1), ('ManageRoles', 'Manage roles', 'Admin', 1), ('ManagePermissions', 'Manage permissions', 'Admin', 1), ('ViewDashboard', 'View dashboard', 'Dashboard', 1), ('ManageSchedules', 'Manage schedules', 'Schedule', 1);
GO
INSERT INTO SystemConfiguration (ConfigKey, ConfigValue, Description) VALUES ('CancellationChargePercentage', '30', 'Charge percentage for cancellation within 48 hours'), ('CancellationAllowedHours', '48', 'Hours before departure to allow cancellation'), ('JWTExpiryMinutes', '60', 'JWT token expiry time in minutes'), ('RefreshTokenExpiryDays', '7', 'Refresh token expiry time in days'), ('CompanyName', 'Bus Ticket Management System', 'Company name'), ('Version', '1.0.0', 'Application version');
GO
PRINT 'Database created successfully!';
