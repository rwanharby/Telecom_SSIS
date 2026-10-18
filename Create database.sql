create database SSIS_Telecom_DB


use SSIS_Telecom_DB
go


create table fact_transaction (
	id int not null identity (1,1) primary key, -- surrogate key
	transaction_id int not null , 
	imsi varchar(9) not null,
	subscriber_id int,
	tac varchar(8) not null,
	snr varchar(6) not null,
	imei varchar(14) not null,
	cell int not null,
	lac int not null,
	event_type varchar(1) null,
	event_ts datetime not null,
);



create table error_destination_output (
    id int,
    imsi varchar(9),
    imei varchar(14),
    cell int,
    lac int,
    event_type varchar(1),
    event_ts datetime,
	tac varchar(8),
	snr varchar(8),
    ErrorCode int,
    ErrorColumn int
)

create table err_source_output(
    id int identity(1,1),
	[Flat File Source Error Output Column] varchar(max),
	[ErrorCode] int,
	[ErrorColumn] int
	)
go
alter table err_source_output add audit_id int;


/*
alter table fact_transaction alter column tac varchar(8)null;
alter table fact_transaction alter column snr varchar(6)null;
*/
select * from [dbo].[fact_transaction]
truncate table fact_transaction
select * from error_destination_output

select * from dbo.dim_imsi_reference