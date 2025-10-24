function obj = resolveIn(obj, frame)
% Express the coordinates of the object in the specified frame, and
% update the object's coordinates and frame to the new ones.
arguments (Input)
	obj (1,1) GeomObj
	frame (1,1) Frame
end
arguments (Output)
	obj (1,1) GeomObj
end
if frame.isAncestorOf(obj.ref)
	obj.resolveInAncestor(frame)
elseif frame.isDescendantOf(obj.ref)
	obj.resolveInDescendant(frame);
elseif obj.ref ~= frame
	obj.resolveInWorld();
	if frame ~= World.getWorld()
		obj.resolveInDescendant(frame);
	end
end
end