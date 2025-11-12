function newFrame = translateNew(frame, displ)
% Create a new translated frame without modifying the original
% Returns a NEW frame with translated origin
arguments (Input)
	frame (1,1) Frame
	displ (1,1) Vector
end
arguments (Output)
	newFrame (1,1) Frame
end
newFrame = frame.copy().translate(displ);
end