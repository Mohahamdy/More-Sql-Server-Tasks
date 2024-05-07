use SD

--1--
create view v_clerk
as 
	select E.Fname, ProjectName , W.Enter_Date
	from HumanResource.Employee E inner join Works_on W
		on E.EmpNo = W.EmpNo
	inner join Company.Project P
		on P.ProjectNo = W.ProjectNo
	where job = 'clerk'

select * from v_clerk

---empNo and ProjectNo

select EmpNo,ProjectNo,Enter_Date
from Works_on
-------------------------------------------------------

--2--
create view v_without_budget(projectid,projectname,budget)
with encryption 
as 
	select *
	from Company.Project
	where Budget is null

select * from v_without_budget
-------------------------------------------------------------

--3--
create view v_count (pname,jobcount)
with encryption 
as
	select ProjectName ,COUNT(Job)
	from Company.Project P inner join Works_on W
		on P.ProjectNo = W.ProjectNo
	group by ProjectName

select * from v_count
------------------------------------------------------------------

--4--
create view v_project_p2
as 
	select Fname
	from v_clerk 
	where ProjectName = (select ProjectName from Company.Project where ProjectNo = 2)

select * from v_project_p2

-- empNo and projectNo

select EmpNo 
from v_clerk  
where projectNo=2
--------------------------------------------------------------------------

--5--
alter view v_without_budget(projectid,projectname,budget)
with encryption 
as 
	select *
	from Company.Project
	where ProjectNo in (1,2)

select * from v_without_budget 
----------------------------------------------------------------------------

--6--
drop view v_clerk

drop view v_count
------------------------------------------------------------------------------

--7--
create view vemp
as 
	select EmpNo ,Lname 
	from HumanResource.Employee 
	where DeptNo = 2

select * from vemp
---------------------------------------------------------------------------------

--8--
select Lname
from vemp
where Lname like '%j%'
--------------------------------------------------------------------------

--9--
create view v_dept(departmentname,departmentnunmber)
as 
	select DeptName,DeptNo
	from Company.Department

select * from v_dept
--------------------------------------------------------------------------

--10--
insert into v_dept
	values('Development',4)

select * from v_dept
---------------------------------------------------------------------------

--11--
create view v_2006_check
with encryption
as 
	select EmpNo,ProjectNo,Enter_Date
	from Works_on 
	where Enter_Date between '2006-01-01' AND '2006-12-31'

select * from v_2006_check







