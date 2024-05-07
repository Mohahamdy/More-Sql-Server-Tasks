--1--
use Company_SD

declare c1 cursor 
for select Salary from Employee
for update 
declare @salary int
open c1
fetch c1 into @salary
while @@FETCH_STATUS = 0 
	begin 
		if @salary >= 3000 
			update Employee 
				set Salary = 1.20 * @salary 
			where current of c1
		else 
			update Employee 
				set Salary = 1.1 * @salary 
			where current of c1 
		fetch c1 into @salary 
	end
close c1
deallocate c1
-----------------------------------------------

--2-
use ITI

declare c1 cursor 
for select Dept_Name , Ins_Name
	from Department D inner join Instructor I 
		on I.Ins_Id = D.Dept_Manager
for read only 
declare @dname varchar(10),@iname varchar(15)
open c1 
fetch c1 into @dname, @iname
while @@FETCH_STATUS = 0 
	begin 
		select @dname,@iname                               
		fetch c1 into @dname,@iname
	end
close c1
deallocate c1
--------------------------------------------------------------------

--3--
declare c1 cursor 
for select distinct St_Fname from Student 
	where St_Fname is not null
for read only 
declare @sname varchar(20),@all varchar(400) = ''
open c1 
fetch c1 into @sname
while @@FETCH_STATUS = 0 
	begin 
		set @all = CONCAT(@all,',',@sname)
		fetch c1 into @sname
	end
select @all 
close c1 
deallocate c1
-------------------------------------------------
--7--

use SD

create table test(
	id int,
	name varchar(15)
)

create sequence s1 
start with 1
increment by 1
minValue 1
maxValue 10
no cycle

select name,minimum_value,maximum_value,current_value,is_cycling
from sys.sequences
where name='s1'

insert into test values
	(next value for s1,'mohamed'),
	(next value for s1,'ali'),
	(next value for s1,'ahmed'),
	(next value for s1,'mona')

select * from test














