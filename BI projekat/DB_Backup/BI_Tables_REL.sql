use master
go


create database IB160103_BI
on
(
	name = IB160103_BI_full, 
	filename='C:\DB_Backup\IB160103_BI_dat.ndf', 
	size=100MB, 
	maxsize=unlimited, 
	filegrowth=20%
)
log on
(
	name = IB160103_BI_log, 
	filename='C:\DB_Backup\IB160103_BI_log.ldf', 
	size=10MB, 
	maxsize=unlimited, 
	filegrowth=20%
)

go
use IB160103_BI
go

create schema Users

create table Users.Persons
(
	Id				int					not null	identity,
	CityId			int					not null,
	FirstName		nvarchar(10)		not null,
	LastName		nvarchar(10)		not null,
	BirthDate		datetime			not null,
	PhoneNumber		nvarchar(15),
	Email			nvarchar(50),
	Gender			nvarchar(1)
)
go

create table Users.Clients
(
	Id				int					not null
)
go

 
create table Users.DeliveryPersons
(
	Id				int					not null,
	WorkStatusId	int					not null
)
go

 
 
create table Users.WorkStatuses
(
	Id				int					not null	identity,
	[Name]			nvarchar(15)		not null
)
go

 
 
create table Users.Vehicles
(
	Id					int					not null	identity,
	DeliveryPersonId	int					not null,
	VehicleTypeId		int					not null,
	[Name]				nvarchar(40)		not null,
	Speedkph			int	
)

 
create table Users.VehicleTypes
(
	Id				int					not null	identity,
	[Name]			nvarchar(20)		not null
)
go


create schema Regional

 
create table Regional.Countries
(
	Id				int					not null	identity,
	[Name]			nvarchar(20)		not null,
	Code			nvarchar(5)			not null,
	Tax				decimal(6,2)		not null
)
go

 
create table Regional.Regions
(
	Id				int					not null	identity,
	CountryId		int					not null,
	[Name]			nvarchar(20)		not null
)
go

 
create table Regional.Cities
(
	Id				int					not null	identity,
	RegionId		int					not null,
	[Name]			nvarchar(20)		not null
)
go

create schema Sales

 
create table Sales.Orders
(
	Id						int					not null	identity,
	DateCreated				datetime			not null,
	ClientId				int					not null,
	DeliveryLocationId		int					not null,
	ClientSatisfaction		int					check(ClientSatisfaction >= 0 and ClientSatisfaction <= 10),
	DeliveryPersonId		int,
	DeliveredTimeMinutes	int
)
go

create table Sales.OrderDetails
(
	ProductId		int					not null,
	OrderId			int					not null,
	Amount			int					not null,
	ProductPrice	decimal(6,2)		not null
)
go

create schema Products

 
create table Products.Products
(
	Id					int					not null	identity,
	ProductCategoryId	int					not null,
	Price				decimal(6,2)		not null,
	[Name]				nvarchar(40)		not null,
	[Description]		nvarchar(100),
)
go

 
create table Products.ProductCategories
(
	Id				int					not null	identity,
	[Name]			nvarchar(20)		not null
)
go


use IB160103_BI

--PKs
alter table Users.Persons						add constraint PK_Persons						primary key(Id)
alter table Users.Clients						add constraint PK_Clients						primary key(Id)
alter table Users.DeliveryPersons				add constraint PK_DeliveryPersons				primary key(Id)
alter table Users.WorkStatuses					add constraint PK_WorkStatuses					primary key(Id)
alter table Users.Vehicles						add constraint PK_Vehicles						primary key(Id)
alter table Users.VehicleTypes					add constraint PK_VehicleTypes					primary key(Id)
alter table Regional.Countries					add constraint PK_Countries						primary key(Id)
alter table Regional.Regions					add constraint PK_Regions						primary key(Id)
alter table Regional.Cities						add constraint PK_Cities						primary key(Id)
alter table Sales.Orders						add constraint PK_Orders						primary key(Id)
alter table Sales.OrderDetails					add constraint PK_OrderDetails					primary key(ProductId, OrderId)
alter table Products.Products					add constraint PK_Products						primary key(Id)
alter table Products.ProductCategories			add constraint PK_ProductCategories				primary key(Id)

--FKs
alter table Users.Persons						add constraint FK_Persons_Cities								foreign key (CityId)				references Regional.Cities 
alter table Users.Clients						add constraint FK_Clients_Persons								foreign key (Id)					references Users.Persons 
alter table Users.DeliveryPersons				add constraint FK_DeliveryPersons_Persons						foreign key (Id)					references Users.Persons 
alter table Users.DeliveryPersons				add constraint FK_DeliveryPersons_WorkStatuses					foreign key (WorkStatusId)			references Users.WorkStatuses 
alter table Users.Vehicles						add constraint FK_Vehicles_DeliveryPersons						foreign key (DeliveryPersonId)		references Users.DeliveryPersons
alter table Users.Vehicles						add constraint FK_Vehicles_VehicleTypes							foreign key (VehicleTypeId)			references Users.VehicleTypes

alter table Regional.Regions					add constraint FK_Regions_Countries								foreign key (CountryId)				references Regional.Countries
alter table Regional.Cities						add constraint FK_Cities_Regions								foreign key (RegionId)				references Regional.Regions

alter table Sales.Orders						add constraint FK_Orders_Clients								foreign key (ClientId)				references Users.Clients	
alter table Sales.Orders						add constraint FK_Orders_DeliveryPersons						foreign key (DeliveryPersonId)		references Users.DeliveryPersons
alter table Sales.Orders						add constraint FK_Orders_DeliveryLocations						foreign key (DeliveryLocationId)	references Regional.Cities
alter table Sales.OrderDetails					add constraint FK_OrderDetails_Products							foreign key (ProductId)				references Products.Products	
alter table Sales.OrderDetails					add constraint FK_OrderDetails_Orders							foreign key (OrderId)				references Sales.Orders		

alter table Products.Products					add constraint FK_Products_ProductCategories					foreign key (ProductCategoryId)		references Products.ProductCategories	

