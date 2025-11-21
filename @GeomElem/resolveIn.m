function obj = resolveIn(obj, frame)
% Resolve the object in the specified frame. 
%
% The object is not modified, its representation is.
% The properties of the object that depend on the frame are modified in order 
% to provide the representation of the same object in the new frame.
% Properties of the object that depend on frames will change (coordinates, 
% direction cosines, etc).
% Invariant properties of the object remain unchanged (lengths, areas, volumes).
%
% Because the object variable is passed by value, the function returns a new
% obj variable that represent the same geometric entity as the original obj 
% variable, but expressed in the new frame.
% If you want to overwrite the original variable, you need to assign the 
% output of the function back to the original variable explicitly.
%
% Examples:
% p = Point([1;2;3], F1)
% p.resolveIn(F2) % new Point representing p in F2, does not modify p
% p = p.resolveIn(F2) % overwrites p with its own new representation in F2
%
% See also: resolveInAncestor, resolveInDescendant, resolveInWorld
arguments (Input)
	obj (1,1) GeomObj
	frame (1,1) Frame
end
arguments (Output)
	obj (1,1) GeomObj
end
if obj.ref ~= frame
	if obj.ref.isAncestorOf(frame)
		obj = obj.resolveInDescendant(frame);
	elseif frame.isAncestorOf(obj.ref)
		obj = obj.resolveInAncestor(frame);
	else
		obj = obj.resolveInAncestor(frame).resolveInDescendant(frame);
	end
end
end