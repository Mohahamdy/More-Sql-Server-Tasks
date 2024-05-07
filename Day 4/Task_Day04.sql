use ITI

--1--
create proc getnumstd
as 
	select Dept_Name ,COUNT(St_Id) as stnums
	from Student S inner join Department D
		on D.Dept_Id = S.Dept_Id
	group by(Dept_Name)

getnumstd
------------------------------------------------------

--2--
use Company_SD

alter proc checknums
with encryption
as
	declare @num int = (select count(ESSn) from Works_for where Pno = 300)
	if @num > 3
		select 'The number of employees in the project p300 is 3 or more'
	else 
		begin
			select 'The following employees work for the project p300'
			select Fname ,Lname
				from Employee E inner join Works_for W 
					on E.SSN = W.ESSn
				where Pno = 300
		end

checknums
--------------------------------------------------------------

--3--
alter proc addnewemp @oldemp int ,@newemp int, @projnum int
as	
	update Works_for
	set ESSn = @newemp
	where ESSn = @oldemp and Pno = @projnum

addnewemp 521634,512463, 300
-------------------------------------------------------------------

--4--
alter table Project add budget int 

create table Audit(
	pno int,
	username varchar(40),
	modifieddate date,
	budgetOld int,
	budgetNew int
)

create trigger t_2
on Project
after update
as
	if UPDATE(budget)
		begin 
			declare @old int,@new int,@pno int
				select @old = budget from deleted
				select @new = budget from inserted
				select @pno = Pnumber from inserted
			insert into Audit 
			values(@pno,USER_NAME(),GETDATE(),@old,@new)
		end

update Project 
set budget = 90000000
where Pnumber = 100

update Project 
set Dnum = 20 
where Pnumber = 100

select * from Audit
----------------------------------------------------------------------------

--5--
use ITI

create trigger t_3
on Department
instead of insert 
as
	select 'insert is not allowed for Department'

insert into Department(Dept_Id,Dept_Name)
	values(77,'ay 7aga')
--------------------------------------------------------------------------------

--6--
use Company_SD

alter trigger t_4
on  Employee 
instead of insert 
as 
	if DATENAME(MONTH,GETDATE()) = 'March'
		select 'insert is not allowed for Department in March'
	else 
		insert into Employee
		select * from inserted
		
insert into Employee (SSN,Fname)
	values(151434,'ali')

------------------------------------------------------------------------------------

--7--
use ITI

create table Student_Audit(server_name varchar(50),Date_action date, Note varchar(100))

alter trigger t_7
on student 
after insert 
as 
	declare @id int
		select @id= st_id from inserted
	insert into Student_Audit
	values(@@SERVERNAME,GETDATE(),USER_NAME()+' Insert New Row with Key=' +CONVERT(varchar(6),@id)+' in table student')

insert into Student(St_Id,St_Fname,St_Address)
	 values(300,'ali','alex')

select * from Student_Audit

------------------------------------------------------------------------------------------

--8--
alter trigger t_10
on Student 
instead of delete 
as 
	declare @id int		
		select @id=st_id from deleted
	insert into Student_Audit
	values(@@SERVERNAME,GETDATE(),USER_NAME()+' try to delete row with Key=' +CONVERT(varchar(6),@id)+' in table student')

delete from Student
where St_Id = 1

select * from Student_Audit
-------------------------------------------------------------------------------------------------

--9--
use AdventureWorks2012

select * from HumanResources.Employee
for xml raw('Employee'),root('Employees')

select * from HumanResources.Employee
for xml raw('Employee'),elements,root('Employees')

------------------------------------------------------------------------------------------------------

--10--
use ITI

select Dept_Name , Ins_Name
from Instructor I inner join Department D
	on D.Dept_Id = I.Dept_Id
for xml auto,root('ITI')

select Dept_Name "@departName" , Ins_Name "instName"
from Instructor I inner join Department D
	on D.Dept_Id = I.Dept_Id
for xml path('Deapart'),root('ITI')
--------------------------------------------------------------------------------------------------------------

--11--
use Company_SD

declare @docs xml ='<customers>
              <customer FirstName="Bob" Zipcode="91126">
                     <order ID="12221">Laptop</order>
              </customer>
              <customer FirstName="Judy" Zipcode="23235">
                     <order ID="12221">Workstation</order>
              </customer>
              <customer FirstName="Howard" Zipcode="20009">
                     <order ID="3331122">Laptop</order>
              </customer>
              <customer FirstName="Mary" Zipcode="12345">
                     <order ID="555555">Server</order>
              </customer>
       </customers>'

declare @handler int 

Exec sp_xml_preparedocument @handler output, @docs

select * into customers 
from openxml(@handler,'//customer')
with(
	fname varchar(30) '@FirstName',
	zipcode int '@Zipcode',
	orderid int 'order/@ID',
	oreder varchar(30) 'order'
)


Exec sp_xml_removedocument @handler


select * from customers







