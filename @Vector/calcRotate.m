function coords = calcRotate(vec, orien)
% Calculate the coordinates resulting from the rotation of vec
% according to the orientation orien. All geomObjects have to be
% resolved in the same frame.
arguments (Input)
	vec (1,1) Vector
	orien (1,1) Orien
end
arguments (Output)
	coords (3,1) double
end
assert( ...
	vec.ref == orien.ref, ...
	"Vector:calcRotate:sameRef", ...
	"Vector and orientation must be expressed in " + ...
	"the same ref frame")
coords = orien.coords * vec.coords;
end