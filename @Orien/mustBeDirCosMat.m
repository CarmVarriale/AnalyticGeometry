function mustBeDirCosMat(input)
% Enforce that the input is an orientation matrix
arguments
	input
end
assert( ...
	Orien.isDirCosMat(input), ...
	"Orien:mustBeDirCosMat:notDirCosMat", ...
	"Argument does not represent a Direction Cosine Matrix");
end