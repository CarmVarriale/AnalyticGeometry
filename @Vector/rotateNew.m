function newVec = rotateNew(vec, orien)
% Create a newVector by rotating vec according to the orientation
% orien. Both vec and orien must be resolved in the same frame.
arguments (Input)
	vec (1,1) Vector
	orien (1,1) Orien
end
arguments (Output)
	newVec (1,1) Vector
end
newVec = Vector(calcRotate(vec, orien), vec.ref);
end
