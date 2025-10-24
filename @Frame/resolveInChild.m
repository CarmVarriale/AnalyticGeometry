function frame = resolveInChild(frame, refFrame)
% Express the coordinates of the frame in its child frame, and
% update the frame's location, angle sequence and ref frame to the new ones.
arguments (Input)
	frame (1,1) Frame
	refFrame (1,1) Frame
end
arguments (Output)
	frame (1,1) Frame
end
[frame.locat, frame.newAngSeq] = frame.viewInChild(refFrame);
frame.ref = refFrame;
end