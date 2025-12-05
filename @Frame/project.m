function frame = project(frame, destID)
% Project frame in-place by projecting its origin
% Modifies the frame directly (handle class behavior)
arguments (Input)
	frame (1,1) Frame
	destID (1,1) {mustBeA(destID, ["Line", "Plane", "string"])}
end
frame.origin = frame.origin.project(destID);
end