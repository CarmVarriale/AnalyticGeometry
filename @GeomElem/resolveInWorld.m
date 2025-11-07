function obj = resolveInWorld(obj)
% Resolve the object in the world frame. 
%
% Recursively resolves the object in parent frames until the world frame is
% reached.
%
% See also: resolveIn, resolveInAncestor, resolveInDescendant
arguments (Input)
	obj (1,1) GeomObj
end
arguments (Output)
	obj (1,1) GeomObj
end
obj = obj.resolveInAncestor(World.getWorld());
end