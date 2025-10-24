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
point.coords = calcTranslate(point, displ);
end