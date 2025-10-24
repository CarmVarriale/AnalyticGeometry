function R = getDirCosMat(angleSeq, seqID)
% Compound Direction Cosine Matrix used to express the coordinates of a
% Vector of the Base frame in the Follower frame. Rotations are assumed
% intrinsic, meaning that they happen over consecutive and intermediate axes.
arguments (Input)
	angleSeq (3,1) double
	seqID string
end
arguments (Output)
	R {Orien.mustBeDirCosMat}
end
switch seqID
	case "321"
		R = ...
			getDirCosMat1(angleSeq(3)) * ...	% phi
			getDirCosMat2(angleSeq(2)) * ...	% tht
			getDirCosMat3(angleSeq(1)); ...	% psi
	otherwise
	error( ...
		"Orien:getDirCosMat", ...
		"Unexpected angle sequence ID")
end
end