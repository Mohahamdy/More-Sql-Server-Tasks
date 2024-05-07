use sd

sp_addtype loc,'nchar(2)'

create rule r1 as @x in ('NY','DS','KW')

create default def1 as 'NY'

sp_bindrule r1,loc
sp_bindefault def1,loc 

create table Department(
 DeptNo int primary key,
 DeptName varchar(15),
 Location loc
)

insert into Department values (1,'Research','NY'),(2,'Accounting','DS'),(3,'Markiting','KW')
------------------------------------------------------------------------------------------------

create table Employee(
EmpNo int,
Fname varchar(15),
Lname varchar(15),	
DeptNo int,
Salary int,

constraint c1 primary key(EmpNo),
constraint c2 foreign key(DeptNo) references Department(DeptNo)
	on delete set null on update cascade,
constraint c3 unique (Salary),
constraint c4 check(Fname is not null and Lname is not null),
)

create rule r2 as @y<6000

sp_bindrule r2,'Employee.Salary'

insert into Employee values
(25348,'Mathew','Smith',3,2500),
(10102,'Ann','Jones',3,3000),
(18316,'John','Barrimore',1,2400),
(29346,'Lisa','Bertoni',2,2800),
(9031,'Elisa','Hansel',2,3600),
(2581,'Sybl','Moser',1,2900)
----------------------------------------------------------------------------

alter table Employee add TelephoneNumber varchar(11)
alter table Employee drop column TelephoneNumber 
----------------------------------------------------------------------------

create schema Company

alter schema Company transfer dbo.Department


create schema HumanResource 

alter schema HumanResource transfer dbo.Employee
-------------------------------------------------------------------------------

select CONSTRAINT_NAME 
from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
where TABLE_NAME = 'Employee'
--------------------------------------------------------------------------------

create synonym Emp for [HumanResource].Employee 

Select * from Employee --error
Select * from [HumanResource].Employee 
Select * from Emp 
Select * from [HumanResource].Emp --error
-------------------------------------------------------------------------------

select * from Company.Project

update Company.project 
	set Budget = Budget * 1.1
where ProjectNo in (select projectNo from works_on where job = 'manager' and EmpNo =10102)
----------------------------------------------------------------------------------

select * from Company.Department

update Company.Department
	set DeptName = 'Sales'
where DeptName = (
	select DeptName 
	from Company.Department D inner join Emp E
		on D.DeptNo = E.DeptNo
	where E.Fname = 'james'
)
----------------------------------------------------------------------------------

select * from works_on

update works_on
	set Enter_date = '2007-12-12'
from works_on W inner join Emp E
	on E.EmpNo = W.EmpNo
inner join Company.Department D 
	on D.DeptNo = E.DeptNo
where W.ProjectNo = 1 and D.DeptName = 'Sales'
-------------------------------------------------------------------------------------

delete from works_on
where EmpNo in 
(
select EmpNo from
Company.Department D inner join Emp E
	on D.DeptNo = E.DeptNo
where D.Location = 'KW')



