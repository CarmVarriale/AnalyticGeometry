function coords = calcTranslate(point, displ)
% Calculate the coordinates resulting from the translation of point
% by the displacement vector displ, resolved in the same frame
arguments (Input)
	point (1,1) Point
	displ (1,1) Vector
end
arguments (Output)
	coords (3,1) double
end
assert( ...
	point.ref == displ.ref, ...
	"Point:translate:sameRef", ...
	"Point and displacement must be expressed in " + ...
	"the same ref frame")
coords = point.coords + displ.coords;
end