function dirCosMat = getDirCosMat(angleSeq, seqID)
% Compound Direction Cosine Matrix used to express the coordinates of a
% Vector of the Base frame in the Follower frame. Rotations are assumed
% intrinsic, meaning that they happen over consecutive and intermediate axes.
arguments (Input)
	angleSeq (3,1) double
	seqID string
end
dirCosMat = eye(3);
ids = char(seqID);
for i = 1:3
	dirCosMat = ...
		feval("getDirCosMat" + string(ids(i)), angleSeq(i)) * ...
		dirCosMat;
end
end