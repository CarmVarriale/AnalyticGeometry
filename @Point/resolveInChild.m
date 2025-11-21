function point = resolveInChild(point, frame)
% Express the coordinates of the point in its child frame, without
% modifying it in place
arguments (Input)
	point (1,1) Point
	frame (1,1) Frame
end
arguments (Output)
	point (1,1) Point
end
displ = point.radius - frame.origin.radius;
point.coords = displ.resolveInChild(frame).coords;
point.ref = frame.ref;
end