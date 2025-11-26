function point = project(point, dest)
% Project point onto a line or coordinate axis/plane of its frame
arguments (Input)
	point (1,1) Point
	dest {mustBeA(dest, ["Line", "string"])}
end
arguments (Output)
	point (1,1) Point
end
if isa(dest, "Line")
	% Project point onto line by projecting the vector from line anchor to point
	point = dest.anchor + project(point - dest.anchor, dest);
elseif isa(dest, "string")
	% Project onto coordinate plane or axis
	switch dest
		case "1", point.coords = [point.coords(1); 0; 0]; return;
		case "2", point.coords = [0; point.coords(2); 0]; return;
		case "3", point.coords = [0; 0; point.coords(3)]; return;
		case "12", point.coords = [point.coords(1:2); 0]; return;
		case "13", point.coords = [point.coords(1); 0; point.coords(3)]; return;
		case "23", point.coords = [0; point.coords(2:3)]; return;
		otherwise
			error("Point:project:InvalidDestination", ...
				"Destination must be '1', '2', '3', '12', '13', '23' or a Line");
	end
end
end