function point = translate(point, displ)
% Translate point by the displacement vector displ
arguments (Input)
	point (1,1) Point
	displ (1,1) Vector
end
arguments (Output)
	point (1,1) Point
end
point = point + displ;
end