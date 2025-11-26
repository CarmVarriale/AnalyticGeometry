function vec = project(vec, dest)
% Project vector onto a line or coordinate axis/plane of its frame
arguments (Input)
	vec (1,1) Vector
	dest {mustBeA(dest, ["Line", "string"])}
end
if isa(dest, "Line")
	% Project: v_proj = (v · u)u
	vec = dot(vec, dest.direc) * dest.direc;
elseif isa(dest, "string")
	% Project onto coordinate plane or axis
	switch dest
		case "1", vec.coords = [vec.coords(1); 0; 0]; return;
		case "2", vec.coords = [0; vec.coords(2); 0]; return;
		case "3", vec.coords = [0; 0; vec.coords(3)]; return;
		case "12", vec.coords = [vec.coords(1:2); 0]; return;
		case "13", vec.coords = [vec.coords(1); 0; vec.coords(3)]; return;
		case "23", vec.coords = [0; vec.coords(2:3)]; return;
		otherwise
			error("Vector:project:InvalidDestination", ...
				"Destination must be '1', '2', '3', '12', '13', or '23'");
	end
end
end