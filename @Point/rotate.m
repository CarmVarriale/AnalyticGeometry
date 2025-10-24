function point = rotate(point, orien, p0)
% Rotate point about another point p0, according to the orientation
% orien. All geomObjects have to be resolved in the same frame.
arguments (Input)
	point (1,1) Point
	orien (1,1) Orien
	p0 (1,1) Point
end
arguments (Output)
	point (1,1) Point
end
point.coords = calcRotate(point, orien, p0);
end