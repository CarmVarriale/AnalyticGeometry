function newVec = mrdivide(vec, scalar)
% Divide a vector by a scalar (vector / scalar)
arguments (Input)
	vec (1,1) Vector
	scalar (1,1) double
end
newVec = Vector(vec.coords / scalar, vec.ref);
end
