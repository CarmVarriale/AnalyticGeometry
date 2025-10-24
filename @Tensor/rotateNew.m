function newTens = rotateNew(tens, orien)
% Create a newTens by rotating tens according to the orientation
% orien. Both vec and orien must be resolved in the same frame.
arguments (Input)
	tens (1,1) Tensor
	orien (1,1) Orien
end
arguments (Output)
	newTens (1,1) Tensor
end
newTens = Tensor(calcRotate(tens, orien), tens.ref);
end