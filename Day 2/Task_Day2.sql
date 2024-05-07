--1--
create function getmonthname(@date date)
returns varchar(15) 
begin 
declare @name varchar(15) = datename(mm,@date)
return @name
end

select dbo.getmonthname(getdate())
---------------------------------------------------

--2--
create function getvalues(@n1 int,@n2 int)
returns @t table(
				vlaue int
				)
as
begin 
	declare @value int = @n1 + 1
	while @value < @n2 
		begin
			insert into @t values (@value)
			set @value = @value + 1
		end
return
end

select * from getvalues(4,9)
------------------------------------------------------

--3--
create function getsname(@sid int)
returns table
as 
return 
(
	select D.dept_name, S.st_fname+' '+S.st_lname as FullName
	from Student S inner join Department D
		on D.Dept_Id = S.Dept_Id
	where S.St_Id = @sid
)

select * from getsname(1)
-----------------------------------------------

--4--
create function message(@sid int)
returns varchar(50)
begin
declare @mesg varchar(50)
declare @fname varchar(15)
	select @fname = St_Fname from Student where St_Id = @sid
declare @lname varchar(15)
	select @lname= St_Lname from Student where St_Id = @sid
	if(@fname is null and @lname is null)
		set @mesg = 'First name & last name are null'
	else if(@fname is null)
		set @mesg = 'first name is null'
	else if(@lname is null)
		set @mesg = 'last name is null'
	else
		set @mesg = 'First name & last name are not null'
return @mesg
end

select dbo.message(13)
-----------------------------------------------------------------

--5--
create function display(@mid int)
returns table
as
return
(
	select D.Dept_Name ,I.Ins_Name ,D.Manager_hiredate
	from Department D inner join Instructor I
		on I.Ins_Id = D.Dept_Manager
	where I.Ins_Id = @mid
)

select * from display(1)
----------------------------------------------

--6--
create function sname(@formate varchar(50))
returns @t table(
				sid int primary key,
				sname varchar(50)
				)
as
begin
	if @formate = 'firstname'
		insert into @t 
		select St_Id , ISNULL(St_Fname,'')
		from Student
	else if @formate = 'lastname'
		insert into @t 
		select St_Id , ISNULL(St_Lname,'')
		from Student
	else if @formate = 'fullname'
		insert into @t 
		select St_Id , ISNULL(St_Fname,'') + ' '+ ISNULL(St_Lname,'')
		from Student
return 
end

select * from sname('firstname')
select * from sname('lastname')
select * from sname('fullname')
---------------------------------------------------------------------

--7--
select St_Id , SUBSTRING(St_Fname,1,LEN(st_fname)-1)
from Student
---------------------------------------------------------------------

--8--
delete
from Stud_Course
where St_Id in (
	select S.St_Id
	from Student S inner join Department D
		on D.Dept_Id = S.Dept_Id
	where D.Dept_Name = 'SD'
)