function newFrame = copyElement(frame)
arguments (Input)
	frame (1,1) Frame
end
arguments (Output)
	newFrame (1,1) Frame
end
newFrame = copyElement@matlab.mixin.Copyable(frame);
newFrame.parent = frame.parent;
end