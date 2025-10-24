function coords = viewInChild(tens, frame)
% Express the tensor coordinates in its child frame, without
% modifying it in place
arguments (Input)
	tens (1,1) Tensor
	frame (1,1) Frame
end
arguments (Output)
	coords (3,3) double
end
coords = frame.orien.coords' * tens.coords * frame.orien.coords;
end