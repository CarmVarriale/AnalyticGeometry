function frame = translate(frame, displ)
% Translate the frame origin
% 
% Modifies the frame object in place
arguments (Input)
	frame (1,1) Frame
	displ (1,1) Vector
end
frame.origin = frame.origin.translate(displ);
end