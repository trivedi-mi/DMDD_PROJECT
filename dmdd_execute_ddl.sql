IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Airline_Reservation_System_temp')
DROP DATABASE Airline_Reservation_System_temp
GO
create database Airline_Reservation_System_temp
GO
Use Airline_Reservation_System_temp
GO



CREATE TABLE [dbo].[Agent_T](
	[Agent_ID] [int] NOT NULL,
	[AgentName] [nvarchar](20) NULL,
	[AgentDetails] [varchar](50) NULL,
 CONSTRAINT [agent_PK] PRIMARY KEY CLUSTERED 
(
	[Agent_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Customer_T](
	[Customer_ID] [int] NOT NULL,
	[FirstName] [nvarchar](20) NULL,
	[LastName] [nvarchar](20) NULL,
	[Gender] [char](1) NULL,
	[DOB] [date] NOT NULL,
	[AGE]  AS (datediff(year,[DOB],getdate())),
	[email] [varchar](40) NULL,
	[Password] [varchar](400) NOT NULL,
	[address] [varchar](50) NULL,
 CONSTRAINT [customer_PK] PRIMARY KEY CLUSTERED 
(
	[Customer_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Customer_T]  WITH CHECK ADD CHECK  (([Gender]='T' OR [Gender]='F' OR [Gender]='M'))
GO



CREATE TABLE [dbo].[RESERVATION_T](
	[Reservation_id] [varchar](15) NOT NULL,
	[Customer_id] [int] NOT NULL,
	[Agent_id] [int] NOT NULL,
	[Reservation_status_code] [varchar](30) NOT NULL,
	[Reservation_date] [date] NOT NULL,
	[Travel_class_code] [varchar](30) NOT NULL,
 CONSTRAINT [reservation_PK] PRIMARY KEY CLUSTERED 
(
	[Reservation_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RESERVATION_T]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_RAID] FOREIGN KEY([Agent_id])
REFERENCES [dbo].[Agent_T] ([Agent_ID])
GO

ALTER TABLE [dbo].[RESERVATION_T] CHECK CONSTRAINT [FK_Reservation_RAID]
GO

ALTER TABLE [dbo].[RESERVATION_T]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_RID] FOREIGN KEY([Customer_id])
REFERENCES [dbo].[Customer_T] ([Customer_ID])
GO

ALTER TABLE [dbo].[RESERVATION_T] CHECK CONSTRAINT [FK_Reservation_RID]
GO


CREATE TABLE [dbo].[Transactions_T](
	[TransactionID] [varchar](20) NOT NULL,
	[TransactionStatus] [varchar](15) NOT NULL,
	[TransactionAmount] [decimal](10, 2) NOT NULL,
	[TransactionDate] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[ReservationPayment_T](
	[ReservationID] [varchar](15) NOT NULL,
	[PaymentID] [varchar](20) NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ReservationPayment_T]  WITH CHECK ADD  CONSTRAINT [FK_ReservationPayment_RID] FOREIGN KEY([ReservationID])
REFERENCES [dbo].[RESERVATION_T] ([Reservation_id])
GO

ALTER TABLE [dbo].[ReservationPayment_T] CHECK CONSTRAINT [FK_ReservationPayment_RID]
GO

ALTER TABLE [dbo].[ReservationPayment_T]  WITH CHECK ADD  CONSTRAINT [FK_Transaction_TID] FOREIGN KEY([PaymentID])
REFERENCES [dbo].[Transactions_T] ([TransactionID])
GO

ALTER TABLE [dbo].[ReservationPayment_T] CHECK CONSTRAINT [FK_Transaction_TID]
GO



CREATE TABLE [dbo].[AIRPORT_T](
	[Airport_Code] [varchar](30) NOT NULL,
	[Airport_Name] [varchar](30) NULL,
	[city] [varchar](30) NULL,
	[State] [varchar](30) NULL,
	[Airport_Compliance] [varchar](30) NULL,
 CONSTRAINT [Airport_PK] PRIMARY KEY CLUSTERED 
(
	[Airport_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO





CREATE TABLE [dbo].[FlightSchedule_T](
	[Flight_No] [int] NOT NULL,
	[Airplane_ID] [varchar](15) NULL,
	[Origin_Airport_Code] [varchar](10) NULL,
	[Destination_Airport_Code] [varchar](10) NULL,
	[Arrival_Time] [datetime] NULL,
	[Departure_Time] [datetime] NULL,
 CONSTRAINT [FlightSchedule_PK] PRIMARY KEY CLUSTERED 
(
	[Flight_No] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO




CREATE TABLE [dbo].[ITINERARY_LEGS_T](
	[Reservation_id] [varchar](15) NOT NULL,
	[Flight_No] [int] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ITINERARY_LEGS_T]  WITH CHECK ADD  CONSTRAINT [FK_Itinerary_Leg_IID] FOREIGN KEY([Flight_No])
REFERENCES [dbo].[FlightSchedule_T] ([Flight_No])
GO

ALTER TABLE [dbo].[ITINERARY_LEGS_T] CHECK CONSTRAINT [FK_Itinerary_Leg_IID]
GO

ALTER TABLE [dbo].[ITINERARY_LEGS_T]  WITH CHECK ADD  CONSTRAINT [FK_Itinerary_Leg_ILID] FOREIGN KEY([Reservation_id])
REFERENCES [dbo].[RESERVATION_T] ([Reservation_id])
GO

ALTER TABLE [dbo].[ITINERARY_LEGS_T] CHECK CONSTRAINT [FK_Itinerary_Leg_ILID]
GO




CREATE TABLE [dbo].[FLIGHT_STATUS_T](
	[Flight_Number] [int] NOT NULL,
	[Status] [varchar](30) NULL,
	[Actual_departure_time] [datetime] NOT NULL,
	[Actual_arrival_time] [datetime] NULL,
 CONSTRAINT [Flight_Status_PK] PRIMARY KEY CLUSTERED 
(
	[Flight_Number] ASC,
	[Actual_departure_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



CREATE TABLE [dbo].[AIRLINE_t](
	[Airline_id] [varchar](30) NOT NULL,
	[Name] [varchar](30) NULL,
	[Manufacturer] [varchar](30) NULL,
 CONSTRAINT [Airline_PK] PRIMARY KEY CLUSTERED 
(
	[Airline_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO




CREATE TABLE [dbo].[AIRPLANE_T](
	[Airplane_id] [varchar](30) NOT NULL,
	[Airline_id] [varchar](30) NOT NULL,
	[Number_of_Seats] [int] NULL,
	[ModelNumber] [varchar](30) NULL,
 CONSTRAINT [Airplane_PK] PRIMARY KEY CLUSTERED 
(
	[Airplane_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AIRPLANE_T]  WITH CHECK ADD  CONSTRAINT [FK_Airplane_AID] FOREIGN KEY([Airline_id])
REFERENCES [dbo].[AIRLINE_t] ([Airline_id])
GO

ALTER TABLE [dbo].[AIRPLANE_T] CHECK CONSTRAINT [FK_Airplane_AID]
GO



CREATE TABLE [dbo].[Cost_T](
	[Flight_No] [int] NOT NULL PRIMARY KEY,
	[Price] [decimal](10, 2) NOT NULL,
	[Tax] [decimal](10, 2) NOT NULL,
	[Total_Fare]  AS ([Price]+[Tax])
) ON [PRIMARY]
GO



create view [dbo].[covid19_complaince_flights]
as
select al.airline_id, al.name, ap.airplane_id, ap.number_of_seats, fs.flight_no, a.airport_code, a.airport_name, a.city, state, a.airport_compliance
from airline_t al
join airplane_t ap on al.airline_id = ap.airline_id
join flightschedule_t fs on ap.airplane_id = fs.airplane_id
join airport_t a on fs.origin_airport_code = a.airport_code
where a.airport_compliance like '%yes%'
;
GO

--To run the view
--select * from covid19_complaince_flights

GO
Create view flights_total_fare
as
select al.airline_id, al.name, ap.airplane_id, ap.number_of_seats, ap.modelnumber, ft.flight_no,c.total_fare
from flightschedule_t ft
join cost_t c on ft.flight_no=c.flight_no
join airplane_t ap on ap.airplane_id = ft.airplane_id
join airline_t al on al.airline_id = ap.airline_id
;
GO
--To run
--select * from flights_total_fare


Create view flight_cost_query
as select al.name,sum(c.Total_Fare) as Total, min(c.total_fare) as minimum_fare$, max(c.total_fare) as maxmum_fare$,avg(c.total_fare) as average_fare$ from flightschedule_t ft join cost_t c on ft.flight_no=c.flight_no join airplane_t ap on ap.airplane_id = ft.airplane_id join airline_t al on al.airline_id = ap.airline_id
group by al.name 
;

--To run
--select * from flight_cost_query
GO

Create procedure [dbo].[airportsInState]
@State char(3),
@CountAirport int output 
AS
Begin
	select airport_code, airport_name,city
	from AIRPORT_T
	where TRIM(State) =(@State)

    select @CountAirport=@@ROWCOUNT
END;

--execute
/*declare @Count INT
exec airportsInState
@State='CA',
@CountAirport= @Count output
GO*/
GO

Create procedure [dbo].[findCustomerByTravelClass]
@TravelClass varchar(8),
@CountCustomers int output 
AS
Begin
	select c.FirstName, c.LastName,r.reservation_id,r.reservation_date
	from Customer_T c INNER JOIN RESERVATION_T r ON c.customer_ID=r.Customer_id
	where Travel_class_code=@TravelClass

    select @CountCustomers=@@ROWCOUNT
END;
GO

--execute
/*declare @Count INT
exec findCustomerByTravelClass
@TravelClass='BSC',
@CountCustomers= @Count output*/


Create procedure [dbo].[identifyAirplanesOrigin]
@OriginAirport char(3),
@CountAirline int output
as
Begin
select Flight_No, Airplane_ID
from FlightSchedule_T
where Origin_Airport_Code=@OriginAirport

select @CountAirline=@@ROWCOUNT
END;


/*declare @Count INT
exec identifyAirplanesOrigin
@OriginAirport='bos',
@CountAirline= @Count output

select @Count as NumberOfFlightsFound*/
GO


Create MASTER KEY
ENCRYPTION BY PASSWORD = 'airlines_reservation_system_temp';
SELECT name KeyName,
  symmetric_key_id KeyID,
  key_length KeyLength,
  algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;

CREATE CERTIFICATE EmpPass  
   WITH SUBJECT = 'Employee Sample Password';  

CREATE SYMMETRIC KEY EmpPass_SM 
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE EmpPass;  

OPEN SYMMETRIC KEY EmpPass_SM  
   DECRYPTION BY CERTIFICATE EmpPass;  
   GO


create trigger register
on RESERVATION_T for insert as

declare @customerID varchar(20)
declare @customerFName varchar(20)
declare @customerLName varchar(20)
declare @reservationId varchar(30)
declare @reservationStatusCode varchar(15)
declare @reservationDate date
declare @customerEmail varchar(30)
declare @Subject varchar(50)

select @customerID=c.customer_id,@customerFName =c.FirstName,@customerLName=c.LastName, @reservationId=s.reservation_id, @reservationStatusCode=s.reservation_status_code,@reservationDate=s.reservation_date, @customerEmail=c.email from inserted s INNER JOIN Customer_T C ON s.customer_id=C.Customer_ID
set @Subject = 'Customer ID ' +@customerID + '-Your booking for ' + cast(cast(@reservationDate as date) as varchar(64))
declare @body varchar(500) = 'Hi ' + @customerFName + ' ' + @customerLName + ',

Thank you for your booking. Your Reservation ID is '  + @reservationId+ ' and the status is ' + @reservationStatusCode+ '.

Regards,
FlyHigh'



EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'test',  
    @recipients = @customerEmail,  
    @body = @body,
    @subject = @Subject ;