function newPoint = uminus(point)
% Returns symmetric Point with respect to the origin in the same Frame
arguments (Input)
    point (1,1) Point
end
newPoint = Point(-point.coords, point.ref);
end
