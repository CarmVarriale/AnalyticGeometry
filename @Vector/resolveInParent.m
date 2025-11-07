function vec = resolveInParent(vec)
% Express the coordinates of the vector in its parent frame,
% without modifying it in place
arguments (Input)
	vec (1,1) Vector
end
arguments (Output)
	vec (1,1) Vector
end
vec.coords = vec.ref.orien.coords * vec.coords;
vec.ref = vec.ref.ref;
end
