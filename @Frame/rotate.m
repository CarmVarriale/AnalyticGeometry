function frame = rotate(frame, about, param)
% Rotate the frame origin and orientation coherently about a point or line
% 
% Modifies the frame object in place
arguments (Input)
	frame (1,1) Frame
	about {mustBeA(about, ["Point", "Line"])}
	param {mustBeA(param, ["Orien", "double"])}
end
frame.origin = frame.origin.rotate(about, param);
if isa(about, "Point")
	assert(isa(param, "Orien"), ...
		"Frame:rotate:InvalidParam", ...
		"When rotating about a Point, param must be an Orien");	
	frame.orien = frame.orien.rotate(param);	
elseif isa(about, "Line")
	assert(isa(param, "double"), ...
		"Frame:rotate:InvalidParam", ...
		"When rotating about a Line, param must be a double (angle)");
	axisAngle = about.direc.resolveIn(frame.orien.ref).coords * param;
	quat = quaternion(axisAngle', "rotvec");
	eulerAngles = quat.euler( ...
		frame.orien.seqID ...
			.replace("3","Z").replace("2","Y").replace("1","X"), ...
		"frame")';
	orien = Orien(eulerAngles, frame.orien.seqID, frame.orien.ref);
	frame.orien = frame.orien.rotate(orien);
end
end