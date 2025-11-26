function newPoint = plus(point, vec)
% Add a vector to a point
arguments (Input)
	point (1,1) Point
	vec (1,1) Vector
end
newPoint = Point(point.coords + vec.resolveIn(point.ref).coords, point.ref);
end
