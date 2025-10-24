function frame = translate(frame, displ)
% Translate frame by translating its origin
arguments (Input)
	frame (1,1) Frame
	displ (1,1) Vector
end
arguments (Output)
	frame (1,1) Frame
end
frame.locat = frame.origin.translate(displ).coords;
end