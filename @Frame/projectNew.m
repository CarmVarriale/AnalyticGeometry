function newFrame = projectNew(frame, destID)
% Create a new projected frame without modifying the original
% Returns a NEW frame with projected origin
arguments (Input)
	frame (1,1) Frame
	destID (1,1) {mustBeMember(destID, ["1","2","3","12","13","23"])}
end
arguments (Output)
	newFrame (1,1) Frame
end
newFrame = frame.copy().project(destID);
end
