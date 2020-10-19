use master
go

create database IB160103_BI_DW
go


use IB160103_BI_DW
go

--Creating tables
create table DimLocations
(
	LocationKey					int					not null	identity,
	LocationAltKey				int					not null,
	CountryCode					nvarchar(5)			not null,
	Region						nvarchar(30)		not null,
	City						nvarchar(30)		not null
)
go

create table DimAge
(
	AgeKey			int			not null,
)

create table DimDateTime
(
	DateTimeKey					int					not null	identity,
	DateTimeAltKey				datetime			not null,
	[Minute]					tinyint				check([Minute]>=0 and [Minute]<=59),
	[Hour]						tinyint				check([Hour]>=0 and [Hour]<=23),
	[Day]						tinyint				check([Day]>=1 and [Day]<=31),
	[DayOfWeek]					tinyint				check([DayOfWeek]>=1 and [DayOfWeek]<=7),
	[Month]						tinyint				check([Month]>=1 and [Month]<=12),
	[Year]						int					check([Year]>=1900 and [Year]<=2100),
	[YearQuarter]				tinyint				check([YearQuarter]>=1 and [YearQuarter]<=4)
)
go    

create table DimClients
(
	ClientKey					int					not null	identity,
	ClientAltKey				int					not null,
	[Name]						nvarchar(50)		not null,
	PhoneNumber					nvarchar(50)		not null,
	Email						nvarchar(50)
)
go

create table DimClientSatisfaction
(
	ClientSatisfactionKey		int			not null
)
go



create table DimProducts
(
	ProductKey					int					not null	identity,
	ProductAltKey				int					not null,
	[Name]						nvarchar(50)		not null
)
go


create table DimDeliveryTimePercentage
(
	DeliveryTimePercentageKey		 int			not null
)

create table FactSales
(
	Id									int					not null	identity,
	ProductKey							int					not null,
	ClientKey							int					not null,
	DateTimeCreatedKey					int					not null,
	LocationKey							int					not null,
	AgeKey								int					not null,
	ClientSatisfactionKey				int,
	DeliveryTimePercentageKey			int,
	Amount								int					not null,
	ProductPrice						decimal(6,2)		not null,
	Total								decimal(10,2)		not null,
	OrderNumber							int,						
	Discount							decimal(6,2)
)
go

alter table DimAge						add constraint PK_DimAge								primary key(AgeKey)
alter table DimLocations				add constraint PK_DimLocations							primary key(LocationKey)
alter table DimDateTime					add constraint PK_DimDateTime							primary key(DateTimeKey)
alter table DimClients					add constraint PK_DimClients							primary key(ClientKey)
alter table DimClientSatisfaction		add constraint PK_DimClientSatisfaction					primary key(ClientSatisfactionKey)
alter table DimDeliveryTimePercentage	add constraint PK_DimDeliveryTimePercentage				primary key(DeliveryTimePercentageKey)
alter table DimProducts					add constraint PK_DimProducts							primary key(ProductKey)
alter table FactSales					add constraint PK_FactSales								primary key(Id)
													   
alter table FactSales					add constraint FK_FactSales_DimAge						foreign key (AgeKey)						references DimAge
alter table FactSales					add constraint FK_FactSales_DimProducts					foreign key (ProductKey)					references DimProducts
alter table FactSales					add constraint FK_FactSales_DimClients					foreign key (ClientKey)						references DimClients
alter table FactSales					add constraint FK_FactSales_DimClientSatisfaction		foreign key (ClientSatisfactionKey)			references DimClientSatisfaction
alter table FactSales					add constraint FK_FactSales_DimDeliveryTimePercentage	foreign key (DeliveryTimePercentageKey)		references DimDeliveryTimePercentage
alter table FactSales					add constraint FK_FactSales_DimDateTimeCreatedKey		foreign key (DateTimeCreatedKey)			references DimDateTime
alter table FactSales					add constraint FK_FactSales_DimLocations				foreign key (LocationKey)					references DimLocations

