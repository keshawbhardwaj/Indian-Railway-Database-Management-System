--# Indian-Railway-Database-Management-System
--#by using SQL, MS SQL server i created some database objects to retrieve data that is relevent in terms of consumers everday travelling.
                                       --                      #Indian Railway Database Management System                      --

-- Database Creation --

create database IndianRailway;
use IndianRailway;

--created tables Train_info and train_schedule by inserting .csv file in the database--
--First create the table by using create table command and also you can use the sql server import export wizard to load the files in the database
-- by use of syntax i am adding an example how you can add a csv file in a database . 
---so first create table with relevent columns and datatypes then,follow the steps given below in the example

-- truncate the table first
TRUNCATE TABLE dbo.Actors;
GO
 
-- import the file
BULK INSERT dbo.Actors
FROM 'C:\Documents\Skyvia\csv-to-mssql\actor.csv'
WITH
(
        FORMAT='CSV',
        FIRSTROW=2
)
GO
-- view the loaded data as it is correctly loaded or not---

select * from train_info;
select * from train_schedule;

--Created a view(Virtual Table) for Train_info with arrival and departure time--

create view Vw_Train_Information
as
select A.*,B.Station_Code,B.Station_Name,B.Arrival_time,B.Departure_Time,B.Distance 
from train_info as A
inner join train_schedule as B
on A.Train_no = B.Train_no;

select * from Vw_Train_Information;


select * from Vw_Train_Information 
where train_no = 18181;

-- created a Stored procedure for train route with arrival and departure time by passing train number --

create procedure Sp_Train_Route_Info(@trainNo bigint)
as 
select Train_no,Train_Name,Station_Code,Station_name,Arrival_time,Departure_time,Distance 
from Vw_Train_Information 
where Train_no = @trainNo;
go

exec Sp_Train_Route_Info 18181
exec Sp_Train_Route_Info 28181

--create a stored procedure for checking train details between stations by passing the station names --

Create procedure Sp_Train_Info (@Source nvarchar(200), @destination nvarchar(200))
as 
select Train_no, Train_Name, Station_Code,Days,Station_name,Arrival_time, Departure_time
from Vw_Train_Information 
where Source_Station_Name = @Source and Destination_Station_Name = @destination and Station_Name = @Source;
go

exec Sp_Train_Info 'TATANAGAR JN', 'CHHAPRA JN.'

-- created stored procedure for Extracting station code by station name--

Create procedure sp_GetStationCode (@name nvarchar(200))
as
select Top 1 Station_Name,Station_Code from train_schedule
where Station_Name = @name;
go

execute sp_GetStationCode 'Tatanagar Jn'
execute sp_GetStationCode 'Chhapra Jn.'

--Function for getting all trains from a particular station by passing station name--

create function Fn_All_Trains (@StName as nvarchar(200))
returns table
return
select * from Vw_Train_Information 
where Station_Name = @StName;
go

select * from Fn_All_Trains('Tatanagar jn')
