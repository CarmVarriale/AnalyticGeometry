function obj = resolveInParent(obj)
% Express the coordinates of the object in its parent frame, and
% update the object's coordinates and frame to the new ones.
arguments (Input)
	obj (1,1) GeomObj
end
arguments (Output)
	obj (1,1) GeomObj
end
obj.coords = obj.viewInParent();
obj.ref = obj.ref.ref;
end