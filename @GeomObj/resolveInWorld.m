function obj = resolveInWorld(obj)
% Express the coordinates of the object in the World frame, and
% update the object's coordinates and frame to the new ones.
arguments (Input)
	obj (1,1) GeomObj
end
arguments (Output)
	obj (1,1) GeomObj
end
obj = resolveInAncestor(obj, World.getWorld());
end