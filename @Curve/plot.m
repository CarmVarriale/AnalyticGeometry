function graphicObj = plot(curve, opts, style)
	% Plot the curve in a specified reference frame
	arguments (Input)
		curve (1,1) Curve
		opts.ref (1,1) Frame = curve.ref
		opts.ax (1,1) matlab.graphics.axis.Axes = gca
		style.?matlab.graphics.primitive.Line
	end
	coords = [curve.resolveIn(opts.ref).coords{:}];
	style = namedargs2cell(style);
	graphicObj = plot3( ...
		opts.ax, ...
		coords(1,:), coords(2,:), coords(3,:), ...
		style{:});
	axis(opts.ax, "equal");
	if all(coords(2,:) == 0)
		view(0, 0);
	elseif all(coords(1,:) == 0)
		view(90, 0);
	end
end