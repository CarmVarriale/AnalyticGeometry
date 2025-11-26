function scalar = dot(vec1, vec2)
% Compute the scalar product of two vectors
arguments (Input)
	vec1 (1,1) Vector
	vec2 (1,1) Vector
end
scalar = dot(vec1.coords, vec2.resolveIn(vec1.ref).coords);
end
