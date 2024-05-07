declare c1 cursor 
for select St_Fname from Student
for read only 

declare @name1 varchar(15) ='',@name2 varchar(15) ,@count int = 0
open c1
fetch c1 into @name2
begin 
	while @@FETCH_STATUS = 0 
	begin 
		if @name1 = 'Ahmed' and @name2 = 'Amr'
			set @count += 1 
		
		 set @name1 = @name2
		fetch c1 into @name2
	end
end
select @count
close c1
deallocate c1