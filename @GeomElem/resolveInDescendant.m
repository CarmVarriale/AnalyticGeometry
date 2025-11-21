function obj = resolveInDescendant(obj, frame)
% Resolve the object in the specified descendant frame. 
%
% Recursively resolves the object in child frames until the specified frame 
% is reached.
% Every GeomElem has to implement its own specific resolveInChild method.
%
% See also: resolveIn, resolveInAncestor, resolveInWorld
arguments (Input)
	obj (1,1) GeomObj
	frame (1,1) Frame
end
arguments (Output)
	obj (1,1) GeomObj
end
ancestors = frame.getAncestors(upTo = obj.ref);
descendants = [flip(ancestors(1:end-1)); frame];
for i = 1:numel(descendants)
	obj = obj.resolveInChild(descendants(i));
end
end