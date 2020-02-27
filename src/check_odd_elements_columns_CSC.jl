function check_odd_elements_columns_CSC(A::SparseMatrixCSC)#test HOMEWORK2
	sleep_time = 5 #seconds
	temp = 0
	result = []
	for i in range(1,length=size(A,2))
		push!(result, temp)
		temp = 0
		for j in range(1, length=size(A,1))
	        temp+=abs(A[j,i])
		end
	#println(temp)#show column sums
	end
	count = 0
	for k in result
		if isodd(k)
			count+=1
		end
	end
	if count!=0
		println("//////////////////////////////////////////////////////////////////////////////////////////////////////////")
		println("CHECKING COLUMNS WITH AN ODD NUMBER OF ELEMENTS")
		println("WARNING, THE MATRIX CONTAINS $count COLUMNS WITH AN ODD NUMBER OF ELEMENTS")
		println("the execution will sleep for $sleep_time seconds")
		println("//////////////////////////////////////////////////////////////////////////////////////////////////////////")
		sleep(sleep_time)
	end
end
