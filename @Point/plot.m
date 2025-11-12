function graphicObj = plot(point, opts, style)
	% Plot the point in a specified reference frame
	arguments (Input)
		point (1,1) Point
		opts.ref (1,1) Frame = point.ref
		opts.ax (1,1) matlab.graphics.axis.Axes = gca
		style.?matlab.graphics.primitive.Line
	end
	coords = point.resolveIn(opts.ref).coords;
	style = namedargs2cell(style);
	graphicObj = plot3( ...
		opts.ax, ...
		coords(1), coords(2), coords(3), ...
		style{:});
	axis(opts.ax, "equal");
end