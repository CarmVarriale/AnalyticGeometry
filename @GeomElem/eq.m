function flag = eq(A, B)
% Compare two GeomElem objects for equality
%
% Two GeomElem objects are considered equal if they have the same 
% coordinates when resolved in the same Frame.
sizeA = size(A);
sizeB = size(B);
if isscalar(A) && isscalar(B)
	flag = all(isapprox(A.coords , B.resolveIn(A.ref).coords, "verytight"));
elseif isscalar(A)
	flag = false(sizeB);
	for i = 1:numel(B)
		flag(i) = eq(A, B(i));
	end
elseif isscalar(B)
	flag = false(sizeA);
	for i = 1:numel(A)
		flag(i) = eq(A(i), B);
	end
elseif isequal(sizeA, sizeB)
	flag = false(sizeA);
	for i = 1:numel(A)
		flag(i) = eq(A(i), B(i));
	end
else
	error(...
		"GeomElem:eq:sizeMismatch", ...
		"Array dimensions must match or one must be scalar.");
end
end