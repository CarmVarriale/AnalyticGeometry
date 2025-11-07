function point = translate(point, displ)
% Translate point by the displacement vector displ, resolved in
% the same frame
arguments (Input)
	point (1,1) Point
	displ (1,1) Vector
end
arguments (Output)
	point (1,1) Point
end
assert( ...
	point.ref == displ.ref, ...
	"Point:translate:sameRef", ...
	"Point and displacement must be expressed in " + ...
	"the same ref frame")
point.coords = point.coords + displ.coords;
end