 function tens = rotate(tens, orien)
% Rotate tens according to the orientation orien.
arguments (Input)
	tens (1,1) Tensor
	orien (1,1) Orien
end
arguments (Output)
	tens (1,1) Tensor
end
tens = tens * orien;
end