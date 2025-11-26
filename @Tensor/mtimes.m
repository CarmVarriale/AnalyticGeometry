function newVec = mtimes(tens, vec)
% Multiply a tensor by a vector (tensor * vector)
arguments (Input)
	tens (1,1) Tensor
	vec (1,1) Vector
end
newVec  = Vector(tens.resolveIn(vec.ref).coords * vec.coords, vec.ref);
end