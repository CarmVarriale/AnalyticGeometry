function newFrame = translateNew(frame, name, displ)
% Create a new translated frame without modifying the original
% Returns a new child frame with translated origin
arguments (Input)
	frame (1,1) Frame
	name (1,1) string
	displ (1,1) Vector
end
arguments (Output)
	newFrame (1,1) Frame
end
assert(name ~= frame.name, ...
	"Frame:translateNew:InvalidName", ...
	"The name of the new frame must be different from the original.");
newFrame = frame.copy().translate(displ);
newFrame.name = name;
newFrame.ref = frame;
end