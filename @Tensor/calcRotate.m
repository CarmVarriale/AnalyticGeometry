function coords = calcRotate(tens, orien)
% Calculate the coordinates resulting from the rotation of tens
% according to the orientation orien. All geomObjects have to be
% resolved in the same frame.
arguments (Input)
	tens (1,1) Tensor
	orien (1,1) Orien
end
arguments (Output)
	coords (3,3) double
end
assert( ...
	tens.ref == orien.ref, ...
	"Tensor:calcRotate:sameRef", ...
	"Tensor and orientation must be expressed in " + ...
	"the same ref frame")
coords = tens.coords * orien.coords;
end