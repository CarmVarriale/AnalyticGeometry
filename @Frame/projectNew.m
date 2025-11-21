function newFrame = projectNew(frame, name, destID)
% Create a new projected frame without modifying the original
% Returns a new child frame with projected origin
arguments (Input)
	frame (1,1) Frame
	name (1,1) string
	destID (1,1) {mustBeMember(destID, ["1","2","3","12","13","23"])}
end
arguments (Output)
	newFrame (1,1) Frame
end
assert(name ~= frame.name, ...
	"Frame:projectNew:InvalidName", ...
	"The name of the new frame must be different from the original.");
newFrame = frame.copy().project(destID);
newFrame.name = name;
newFrame.ref = frame;
end
