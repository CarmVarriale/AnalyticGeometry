function result = mtimes(arg1, arg2)
% Multiply a vector by a scalar (scalar * vector or vector * scalar)
arguments (Input)
	arg1 (1,1) {mustBeA(arg1, ["Vector", "double"])}
	arg2 (1,1) {mustBeA(arg2, ["Vector", "double"])}
end
if isa(arg1, "Vector") && isa(arg2, "double")
	vec = arg1;
	scalar = arg2;
elseif isa(arg1, "double") && isa(arg2, "Vector")
	scalar = arg1;
	vec = arg2;
else
	error("Vector:mtimes:InvalidArguments", ...
		"One argument must be a Vector and the other must be a scalar double");
end
result = Vector(scalar * vec.coords, vec.ref);
end
