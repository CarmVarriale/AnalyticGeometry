function curve = resolveIn(curve, frame)
arguments (Input)
	curve (1,1) Curve
	frame (1,1) Frame
end
arguments (Output)
	curve (1,1) Curve
end
curve.points = arrayfun(@(p) p.resolveIn(frame), curve.points);
end