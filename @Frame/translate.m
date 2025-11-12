function frame = translate(frame, displ)
% Translate frame in-place by translating its origin
% Modifies the frame directly (handle class behavior)
arguments (Input)
	frame (1,1) Frame
	displ (1,1) Vector
end
frame.origin = frame.origin.translate(displ);
end