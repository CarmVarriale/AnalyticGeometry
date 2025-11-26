function point = rotate(point, about, param)
% Rotate point about a point (using orientation) or about a line (using angle)
arguments (Input)
	point (1,1) Point
	about {mustBeA(about, ["Point", "Line"])}
	param (1,1) {mustBeA(param, ["Orien", "double"])}
end
if isa(about, "Point")
	% Rotate about a point using orientation
	assert(isa(param, "Orien"), ...
		"Point:rotate:InvalidParam", ...
		"When rotating about a Point, param must be an Orien");
	p0 = about;
	orien = param;
	point = p0 + orien * (point - p0);
elseif isa(about, "Line")
	% Rotate about a line using angle
	assert(isa(param, "double"), ...
		"Point:rotate:InvalidParam", ...
		"When rotating about a Line, param must be a double (angle)");
	line = about;
	angle = param;
	relPos = point - line.anchor;
	relPosParallel = relPos.project(line);
	relPosPerpend = relPos - relPosParallel;
	
	% Rodrigues' formula: v_rot = v*cos(angle) + (u × v)*sin(angle)
	relPosPerpRotated = ...
		relPosPerpend * cos(angle) + ...
		cross(line.direc, relPosPerpend) * sin(angle);
	point = line.anchor + relPosParallel + relPosPerpRotated;
end
end