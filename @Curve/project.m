function curve = project(curve, dest)
% Project all points in the curve to the coordinated plane or axis
% of their frame
arguments (Input)
	curve (1,1) Curve
	dest (1,1) {mustBeMember(dest,["1","2","3","12","13","23"])}
end
arguments (Output)
	curve (1,1) Curve
end
curve.points = arrayfun(@(p) p.project(dest), curve.points);
end
