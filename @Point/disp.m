function disp(point)
arguments (Input)
	point Point
end
if isempty(point)
	fprintf("Empty Point\n");
elseif isvector(point)
	for i = 1:numel(point)
		if isempty(point(i).ref)
			fprintf("Point with coords: (%g %g %g) " + ...
				"in empty Frame\n", ...
				point(i).coords);
		else
			fprintf("Point with coords: (%g %g %g) " + ...
				"in Frame: '%s'\n", ...
				point(i).coords, ...
				point(i).ref.uID);
		end
	end
end
end