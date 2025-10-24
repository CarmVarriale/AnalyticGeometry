function frame = rotate(frame, orien, p0)
% Rotate frame by rotating its origin and updating its orientation angles.
% Orientation sequence stays the same.
arguments (Input)
	frame (1,1) Frame
	orien (1,1) Orien
	p0 (1,1) Point
end
arguments (Output)
	frame (1,1) Frame
end
frame.locat = frame.origin.rotate(orien, p0).coords;
frame.angles = frame.orien.rotate(orien).angles;
end