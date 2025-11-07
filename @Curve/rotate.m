function curve = rotate(curve, orien, p0)
% Rotate all points in the curve about another point p0, according to the
% orientation orien. All geomObjects have to be resolved in the same frame.
arguments (Input)
	curve (1,1) Curve
	orien (1,1) Orien
	p0 (1,1) Point
end
arguments (Output)
	curve (1,1) Curve
end
curve.points = arrayfun(@(p) p.rotate(orien, p0), curve.points);
end
