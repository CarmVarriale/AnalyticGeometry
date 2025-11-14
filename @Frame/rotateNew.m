function newFrame = rotateNew(frame, uID, orien, p0)
% Create a new rotated frame without modifying the original
% Returns a new frame with rotated origin and orientation
arguments (Input)
	frame (1,1) Frame
	uID (1,1) string
	orien (1,1) Orien
	p0 (1,1) Point
end
arguments (Output)
	newFrame (1,1) Frame
end
assert(uID ~= frame.uID, ...
	"Frame:rotateNew:InvalidUId", ...
	"The uID of the new frame must be different from the original.");
newFrame = frame.copy().rotate(orien, p0);
newFrame.uID = uID;
end