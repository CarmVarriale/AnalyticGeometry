function newFrame = projectNew(frame, uID, destID)
% Create a new projected frame without modifying the original
% Returns a new frame with projected origin
arguments (Input)
	frame (1,1) Frame
	uID (1,1) string
	destID (1,1) {mustBeMember(destID, ["1","2","3","12","13","23"])}
end
arguments (Output)
	newFrame (1,1) Frame
end
assert(uID ~= frame.uID, ...
	"Frame:projectNew:InvalidUId", ...
	"The uID of the new frame must be different from the original.");
newFrame = frame.copy().project(destID);
newFrame.uID = uID;
end
