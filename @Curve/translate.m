function curve = translate(curve, displ)
% Translate all points in the curve by the displacement vector displ,
% resolved in the same frame
arguments (Input)
	curve (1,1) Curve
	displ (1,1) Vector
end
arguments (Output)
	curve (1,1) Curve
end
curve.points = arrayfun(@(p) p.translate(displ), curve.points);
end
