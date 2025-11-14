function frame = project(frame, destID)
% Project frame in-place by projecting its origin
% Modifies the frame directly (handle class behavior)
arguments (Input)
	frame (1,1) Frame
	destID (1,1) {mustBeMember(destID, ["1","2","3","12","13","23"])}
end
frame.origin = frame.origin.project(destID);
end