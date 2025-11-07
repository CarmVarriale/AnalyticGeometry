function vec = rotate(vec, orien)
% Rotate vec according to the orientation orien. Both vec and
% orien must be resolved in the same frame.
arguments (Input)
	vec (1,1) Vector
	orien (1,1) Orien
end
arguments (Output)
	vec (1,1) Vector
end
vec.coords = orien.coords * vec.coords;
end