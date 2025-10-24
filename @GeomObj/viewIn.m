function newCoords = viewIn(obj, frame)
% Express the coordinates of the object in the specified frame
% without modifying the object in place.
arguments (Input)
	obj (1,1) GeomObj
	frame (1,1) Frame
end
arguments (Output)
	newCoords (3,:) double
end
if obj.ref ~= frame
	objNew = obj.copy().resolveIn(frame);
	newCoords = objNew.coords;
else
	newCoords = obj.coords;
end
end