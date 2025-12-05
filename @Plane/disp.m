function disp(plane)
arguments
    plane (1,1) Plane
end
fprintf("Plane with:\n");
fprintf("\t- Anchor: ");
disp(plane.anchor);
fprintf("\t- Normal: ");
disp(plane.normal);
end