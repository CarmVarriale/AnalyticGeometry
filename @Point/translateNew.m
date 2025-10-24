function newPoint = translateNew(point, displ)
% Create a newPoint by translating point by the displacement vector
% displ, resolved in the same frame
arguments (Input)
	point (1,1) Point
	displ (1,1) Vector
end
arguments (Output)
	newPoint (1,1) Point
end
newPoint = Point(calcTranslate(point, displ), point.ref);
end