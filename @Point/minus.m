function vec = minus(point2, point1)
% Returns the vector from point1 to point2
arguments (Input)
    point2 (1,1) Point
    point1 (1,1) Point
end
vec = Vector(point2.coords - point1.resolveIn(point2.ref).coords, point2.ref);
end
