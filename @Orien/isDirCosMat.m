function flag = isDirCosMat(input)
% Check if the input represents a Direction Cosine Matrix
%
% An Direction Cosine Matrix matrix is a 3x3 orthogonal matrix, and can be used
% to represent both a coordinate transformation matrix or the coordinates of an
% Orientation tensor
arguments (Input)
	input
end
arguments (Output)
	flag (1,1) {mustBeNumericOrLogical}
end
flag = false;
if isnumeric(input) && ...
		ismatrix(input) && ...
		all(size(input) == [3,3])
	flag = ...
		( ...
		isapprox(det(input), 1, "verytight") && ...
		all(isapprox(inv(input), input', "verytight"), "all") ...
		);
end
end