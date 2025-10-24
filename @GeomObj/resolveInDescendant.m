function obj = resolveInDescendant(obj, frame)
% Express the coordinates of the object in the specified descendant
% frame, and update the object's coordinates and frame to the new
% ones.
arguments (Input)
	obj (1,1) GeomObj
	frame (1,1) Frame
end
arguments (Output)
	obj (1,1) GeomObj
end
if obj.ref ~= frame
	treeLine = [frame; frame.getAncestors();];
	treeLine = treeLine(1:find(obj.ref == treeLine)-1);
	for j = numel(treeLine):-1:1
		obj.resolveInChild(treeLine(j));
	end
end
end