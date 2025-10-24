function newCoords = viewInWorld(obj)
% Express the coordinates of the object in the World frame
% without modifying the object in place.
arguments (Input)
	obj (1,1) GeomObj
end
arguments (Output)
	newCoords (3,1) double
end
newCoords = viewInAncestor(obj, FLAME.world);
end