function newCoords = viewInAncestor(obj, frame)
% Express the coordinates of the object in the specified ancestor
% frame without modifying the object in place.
arguments (Input)
	obj (1,1) GeomObj
	frame (1,1) Frame
end
arguments (Output)
	newCoords (3,1) double
end
objNew = obj.copy().resolveInAncestor(frame);
newCoords = objNew.coords;
end