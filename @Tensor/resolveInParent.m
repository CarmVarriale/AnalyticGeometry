function tens = resolveInParent(tens)
% Express the tensor coordinates in its parent frame, without
% modifying it in place
arguments (Input)
	tens (1,1) Tensor
end
arguments (Output)
	tens (1,1) Tensor
end
tens.coords = tens.ref.orien.coords * tens.coords * tens.ref.orien.coords';
tens.ref = tens.ref.ref;
end