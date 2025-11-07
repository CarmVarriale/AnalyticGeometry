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
point.coords = point.radius.resolveInChild(frame).coords - frame.origin.coords;
point.ref = frame.ref;
end