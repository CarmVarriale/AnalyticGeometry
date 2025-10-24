function newPoint = rotateNew(point, orien, p0)
% Create a newPoint by rotating point about another point p0,
% according to the orientation orien. All geomObjects have to be
% resolved in the same frame.
arguments (Input)
	point (1,1) Point
	orien (1,1) Orien
	p0 (1,1) Point
end
arguments (Output)
	newPoint (1,1) Point
end
newPoint = Point(calcRotate(point, orien, p0), point.ref);
end