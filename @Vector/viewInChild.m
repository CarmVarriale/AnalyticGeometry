function newCoords = viewInChild(vec, frame)
% Express the coordinates of the vector in its child frame, without
% modifying it in place
arguments (Input)
	vec (1,1) Vector
	frame (1,1) Frame
end
arguments (Output)
	newCoords (3,1) double
end
newCoords = frame.orien.coords' * vec.coords;
end