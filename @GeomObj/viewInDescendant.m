function newCoords = viewInDescendant(obj, frame)
% Express the coordinates of the object in the specified descendant
% frame without modifying the object in place.
arguments (Input)
	obj (1,1) GeomObj
	frame (1,1) Frame
end
arguments (Output)
	newCoords (3,1) double
end
objNew = obj.copy().resolveInDescendant(frame);
newCoords = objNew.coords;
end