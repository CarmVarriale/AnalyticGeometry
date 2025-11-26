function newVec = cross(vec1, vec2)
% Compute the cross product of two vectors
arguments (Input)
	vec1 (1,1) Vector
	vec2 (1,1) Vector
end
result_coords = cross(vec1.coords, vec2.resolveIn(vec1.ref).coords);
newVec = Vector(result_coords, vec1.ref);
end