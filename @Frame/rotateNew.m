function newFrame = rotateNew(frame, name, orien, p0)
% Create a new rotated frame without modifying the original
% Returns a new child frame with rotated origin and orientation
arguments (Input)
	frame (1,1) Frame
	name (1,1) string
	orien (1,1) Orien
	p0 (1,1) Point
end
arguments (Output)
	newFrame (1,1) Frame
end
assert(name ~= frame.name, ...
	"Frame:rotateNew:InvalidName", ...
	"The name of the new frame must be different from the original.");
newFrame = frame.copy().rotate(orien, p0);
newFrame.name = name;
newFrame.ref = frame;
end