use ITI

--1--
create view vstudent(sname ,cname ,grade )
as
	select ISNULL(St_Fname,'') +' '+ISNULL(St_Lname,' ') as FullName ,Crs_Name,Grade
	from Student S inner join Stud_Course SC
		on S.St_Id = SC.St_Id
	inner join Course C
		on  C.Crs_Id = SC.Crs_Id
	where Grade > 50

select * from vstudent
--------------------------------------------------

--2--
create view vmanger(Manger,Topic)
with encryption
as
	select distinct Ins_Name,Top_Name
	from Instructor I inner join Ins_Course IC
		on I.Ins_Id = IC.Ins_Id
	inner join Course C
		on C.Crs_Id = IC.Crs_Id
	inner join Topic T
		on T.Top_Id = C.Top_Id
	inner join Department D
		on I.Ins_Id = D.Dept_Manager

select * from vmanger

sp_helptext 'vmanger' 

------------------------------------------------------

--3--
create view vinst(insName,deptName)
with encryption 
as 
	select Ins_Name,Dept_Name
	from Instructor I inner join Department D
		on D.Dept_Id = I.Dept_Id
	where Dept_Name in ('SD','Java')

select * from vinst
---------------------------------------------------------

--4--
create view v1
as
	select *
	from Student
	where St_Address in ('cairo','alex')
with check option

select *
	from v1

Update v1 set st_address='tanta'
Where st_address='alex';
-------------------------------------------------------------------

--5--
use SD

create view vproject(pname,empnumber)
with encryption 
as
	select ProjectName , COUNT(w.EmpNo)
	from Company.Project P inner join Works_on W
		on P.ProjectNo = W.ProjectNo
	group by ProjectName

select * from vproject
--------------------------------------------------------------------------
use ITI

--6--
create clustered index i2 
on Department(manager_hiredate)

-- Cannot create more than one clustered index on table 'Department'
-----------------------------------------------------------------------------

--7--
create unique index i3
on Student(st_age)

--CREATE UNIQUE INDEX statement terminated because a duplicate key was found
------------------------------------------------------------------------------

--8--

create table dailyTransaction(
	userId int primary key,
	tamount int
)

create table lastTransaction(
	userId int primary key,
	tamount int
)

insert into dailyTransaction values (1,1000),(2,2000),(3,1000)

insert into lastTransaction values (1,4000),(4,2000),(2,10000)

merge into lastTransaction as T 
using dailyTransaction as S
on S.userId = T.userId

when matched then 
	update 
	set T.tamount = S.tamount

when not matched then
	insert 
	values(S.userId,S.tamount)
	
Output $action;

select * from dailyTransaction
select * from lastTransaction