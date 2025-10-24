function flag = ne(A, B)
% Check if two frames are not equal in value
arguments
	A Frame
	B Frame
end
flag = ~eq(A, B);
end