function newFrame = translateNew(frame, uID, displ)
% Create a new translated frame without modifying the original
% Returns a NEW frame with translated origin
arguments (Input)
	frame (1,1) Frame
	uID (1,1) string
	displ (1,1) Vector
end
arguments (Output)
	newFrame (1,1) Frame
end
assert(uID ~= frame.uID, ...
	"Frame:translateNew:InvalidUId", ...
	"The uID of the new frame must be different from the original.");
newFrame = frame.copy().translate(displ);
newFrame.uID = uID;
end