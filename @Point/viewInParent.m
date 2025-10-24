function coords = viewInParent(point)
% Express the coordinates of the point in its parent frame, without
% modifying it in place
arguments (Input)
	point (1,1) Point
end
arguments (Output)
	coords (3,1) double
end
coords = point.ref.origin.coords + point.radius.viewInParent();
end