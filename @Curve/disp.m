function disp(curve)
% Display information about the Curve
arguments (Input)
	curve Curve
end
if isempty(curve)
	fprintf("Empty Curve\n");
elseif isscalar(curve)
	frames = unique(curve.refs);
	if isscalar(frames)
		fprintf("Curve with %d points in Frame: '%s'\n", ...
			numel(curve.points), ...
			frames.name);
	else
		fprintf("Curve with %d points in various Frames\n", ...
			numel(curve.points));
	end
elseif isvector(curve)
	for i = 1:numel(curve)
		curve(i).disp();
	end
end
end
