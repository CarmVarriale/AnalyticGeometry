function tens = resolveInChild(tens, frame)
% Express the tensor coordinates in its child frame, without
% modifying it in place
arguments (Input)
	tens (1,1) Tensor
	frame (1,1) Frame
end
arguments (Output)
	tens (1,1) Tensor
end
tens.coords = frame.orien.coords' * tens.coords * frame.orien.coords;
tens.ref = frame;
end