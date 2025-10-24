function frame = project(frame, destID)
% Project frame by projecting its origin
arguments (Input)
	frame (1,1) Frame
	destID (1,1) {mustBeMember(destID,["1","2","3","12","13","23"])}
end
arguments (Output)
	frame (1,1) Frame
end
frame.locat = frame.origin.calcProject(destID);

end