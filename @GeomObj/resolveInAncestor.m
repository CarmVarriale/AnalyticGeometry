function obj = resolveInAncestor(obj, frame)
% Express the coordinates of the object in the specified ancestor
% frame, and update the object's coordinates and frame to the new
% ones.
arguments (Input)
	obj (1,1) GeomObj
	frame (1,1) Frame
end
arguments (Output)
	obj (1,1) GeomObj
end
while obj.ref ~= frame
	obj.resolveInParent();
end
end