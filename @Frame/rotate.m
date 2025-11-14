function frame = rotate(frame, orien, p0)
% Rotate the frame origin and orientation coherently
% 
% Modifies the frame object in place
arguments (Input)
	frame (1,1) Frame
	orien (1,1) Orien
	p0 (1,1) Point
end
frame.origin = frame.origin.rotate(orien, p0);
frame.orien = frame.orien.rotate(orien);
end