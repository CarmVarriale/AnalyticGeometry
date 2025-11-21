function flag = eq(A, B)
arguments (Input)
	A
	B
end
arguments (Output)
	flag logical
end
sizeA = size(A);
sizeB = size(B);
if isscalar(A)
	flag = false(sizeB);
	for i = 1:numel(B)
		flag(i) = eq@handle(A, B(i));
	end
elseif isscalar(B)
	flag = false(sizeA);
	for i = 1:numel(A)
		flag(i) = eq@handle(A(i), B);
	end
elseif isequal(sizeA, sizeB)
	flag = false(sizeA);
	for i = 1:numel(A)
		flag(i) = eq@handle(A(i), B(i));
	end
else
	error(...
		"Frame:eq:sizeMismatch", ...
		"Array dimensions must match or one must be scalar.");
end
end