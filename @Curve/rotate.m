function curve = rotate(curve, about, param)
% Rotate all points in the curve about a point (using orientation) or about a line (using angle)
arguments (Input)
	curve (1,1) Curve
	about {mustBeA(about, ["Point", "Line"])}
	param {mustBeA(param, ["Orien", "double"])}
end
arguments (Output)
	curve (1,1) Curve
end
curve.points = arrayfun(@(p) p.rotate(about, param), curve.points);
end
