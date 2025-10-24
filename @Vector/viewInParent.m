function newCoords = viewInParent(vec)
% Express the coordinates of the vector in its parent frame,
% without modifying it in place
arguments (Input)
	vec (1,1) Vector
end
arguments (Output)
	newCoords (3,1) double
end
newCoords = vec.ref.orien.coords * vec.coords;
end
