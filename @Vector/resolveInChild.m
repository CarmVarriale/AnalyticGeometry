function vec = resolveInChild(vec, frame)
% Express the coordinates of the vector in its child frame, without
% modifying it in place
arguments (Input)
	vec (1,1) Vector
	frame (1,1) Frame
end
arguments (Output)
	vec (1,1) Vector
end
vec.coords = frame.orien.coords' * vec.coords;
vec.ref = frame;
end