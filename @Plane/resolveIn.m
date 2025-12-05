function plane = resolveIn(plane, ref)
arguments
    plane (1,1) Plane
    ref (1,1) Frame
end
plane.anchor = plane.anchor.resolveIn(ref);
plane.normal = plane.normal.resolveIn(ref);
end