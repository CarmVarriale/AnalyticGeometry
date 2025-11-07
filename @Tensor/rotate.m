 function tens = rotate(tens, orien)
% Rotate tens according to the orientation orien. Both tens and
% orien must be resolved in the same frame.
arguments (Input)
	tens (1,1) Tensor
	orien (1,1) Orien
end
arguments (Output)
	tens (1,1) Tensor
end
assert( ...
	tens.ref == orien.ref, ...
	"Tensor:calcRotate:sameRef", ...
	"Tensor and orientation must be expressed in " + ...
	"the same ref frame")
tens.coords = tens.coords * orien.coords;
end