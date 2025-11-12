function newFrame = rotateNew(frame, orien, p0)
% Create a new rotated frame without modifying the original
% Returns a NEW frame with rotated origin and orientation
arguments (Input)
	frame (1,1) Frame
	orien (1,1) Orien
	p0 (1,1) Point
end
arguments (Output)
	newFrame (1,1) Frame
end
newFrame = frame.copy().rotate(orien, p0);
end