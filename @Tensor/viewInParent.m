function coords = viewInParent(tens)
% Express the tensor coordinates in its parent frame, without
% modifying it in place
arguments (Input)
	tens (1,1) Tensor
end
arguments (Output)
	coords (3,3) double
end
coords = tens.ref.orien.coords * tens.coords * tens.ref.orien.coords';
end