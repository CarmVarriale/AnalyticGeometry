function frame = rotate(frame, orien, p0)
% Rotate frame in-place by rotating its origin and updating its orientation
% Modifies the frame directly (handle class behavior)
arguments (Input)
	frame (1,1) Frame
	orien (1,1) Orien
	p0 (1,1) Point
end
frame.origin = frame.origin.rotate(orien, p0);
frame.orien = frame.orien.rotate(orien);
end