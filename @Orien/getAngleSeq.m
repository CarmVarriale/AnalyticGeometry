function angleSeq = getAngleSeq(dirCosMat, seqID)
% Extract the angular sequence which results in the given orientation
% parameters. If the parameters consist of a Direction Cosine Matrix, it
% factors out the rotation angles according to the specified rotation sequence.
% Note: for the same angle sequence, the Direction Cosine Matrix is the inverse
% of the orientation coordinates.
arguments (Input)
	dirCosMat {Orien.mustBeDirCosMat}
	seqID string
end
arguments (Output)
	angleSeq (3,1) double
end
switch seqID
	case "321"
		theta = asin(-dirCosMat(1,3));
		if theta > -pi/2 && theta < pi/2
			phi = atan2(dirCosMat(2,3), dirCosMat(3,3));
			psi = atan2(dirCosMat(1,2), dirCosMat(1,1));
		else
			if theta == pi/2
				psi = atan2(dirCosMat(2,1), dirCosMat(2,2));
				phi = 0; % not unique
			end
			if theta == -pi/2
				psi = atan2(-dirCosMat(2,1), dirCosMat(2,2));
				phi = 0; % not unique
			end
		end
		angleSeq = [psi, theta, phi];
		return
	case "123"
		theta = asin(-dirCosMat(3,1));
		if theta > -pi/2 && theta < pi/2
			phi = atan2(dirCosMat(3,2), dirCosMat(3,3));
			psi = atan2(dirCosMat(2,1), dirCosMat(1,1));
		else
			if theta == pi/2
				psi = atan2(dirCosMat(1,2), dirCosMat(1,3));
				phi = 0; % not unique
			end
			if theta == -pi/2
				psi = atan2(-dirCosMat(1,2), -dirCosMat(1,3));
				phi = 0; % not unique
			end
		end
		angleSeq = [phi, theta, psi];
		return
	case "312"
		phi = asin(dirCosMat(2,3));
		if phi > -pi/2 && phi < pi/2
			theta = atan2(-dirCosMat(1,3), dirCosMat(3,3));
			psi = atan2(-dirCosMat(2,1), dirCosMat(2,2));
		else
			if phi == pi/2
				theta = 0; % not unique
				psi = atan2(-dirCosMat(1,2), dirCosMat(1,1));
			end
			if phi == -pi/2
				theta = 0; % not unique
				psi = atan2(dirCosMat(1,2), dirCosMat(1,1));
			end
		end
		angleSeq = [psi, phi, theta];
		return
		
	otherwise
		error( ...
			"Orien:getAngleSeq", ...
			"Unexpected angle sequence ID")
end
end
