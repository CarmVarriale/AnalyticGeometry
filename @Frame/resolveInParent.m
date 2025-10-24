function frame = resolveInParent(frame)
% Express the coordinates of the frame in its parent frame, and
% update the frame's location, angle sequence and ref frame to the new ones.
arguments (Input)
	frame (1,1) Frame
end
arguments (Output)
	frame (1,1) Frame
end
[frame.locat, frame.newAngSeq] = frame.viewInParent();
frame.ref = frame.ref.ref;
end