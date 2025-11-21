function point = resolveInParent(point)
% Express the coordinates of the point in its parent frame, without
% modifying it in place
arguments (Input)
	point (1,1) Point
end
arguments (Output)
	point (1,1) Point
end
displ = point.ref.origin.radius + point.radius;
point.coords = displ.coords;
point.ref = point.ref.ref;
end