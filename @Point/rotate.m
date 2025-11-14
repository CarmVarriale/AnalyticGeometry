function point = rotate(point, orien, p0)
% Rotate point about another point p0, according to the orientation
% orien
arguments (Input)
	point (1,1) Point
	orien (1,1) Orien
	p0 (1,1) Point
end
arguments (Output)
	point (1,1) Point
end
p0r = p0.resolveIn(point.ref);
point.coords =  ...
	p0r.coords + ...
	orien.resolveIn(point.ref).coords * (point.coords - p0r.coords);
end