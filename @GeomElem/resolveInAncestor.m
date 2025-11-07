function obj = resolveInAncestor(obj, frame)
% Resolve the object in the specified ancestor frame. 
%
% Recursively resolves the object in parent frames until the specified frame, or
% the world frame, is reached.
% Every GeomElem has to implement its own specific resolveInParent method.
%
% See also: resolveIn, resolveInDescendant, resolveInWorld
arguments (Input)
	obj (1,1) GeomObj
	frame (1,1) Frame
end
arguments (Output)
	obj (1,1) GeomObj
end
while obj.ref ~= frame && obj.ref ~= World.getWorld()
	obj = obj.resolveInParent();
end
end