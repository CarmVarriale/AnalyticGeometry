function vec = rotate(vec, orien)
% Rotate vec according to the orientation orien
arguments (Input)
	vec (1,1) Vector
	orien (1,1) Orien
end
arguments (Output)
	vec (1,1) Vector
end
vec = orien * vec;
end