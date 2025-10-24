function coords = viewInChild(point, frame)
% Express the coordinates of the point in its child frame, without
% modifying it in place
arguments (Input)
	point (1,1) Point
	frame (1,1) Frame
end
arguments (Output)
	coords (3,1) double
end
coords = ...
	point.radius.viewInChild(frame) - frame.origin.coords;
end