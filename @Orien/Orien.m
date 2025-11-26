classdef Orien < Tensor
	% Orien: a tensor to describe an orientation in 3D space
	%
	% An orientation is always relative to something else, exactly in the same
	% way as a position is. An orientation can be described in different ways,
	% using different sets of parameters, or parameterizations: Euler angles
	% sequences, angle-axis pairs, quaterions, 3x3 matrices. The angle sequences
	% are easily interpretable. The orientation matrices are easily
	% implementable in calculations. 
	% 
	% It is important to note that the 3x3 matrix representing the Orientation 
	% of a Follower frame with respect to a Base frame is the inverse (and 
	% transpose) of the 3x3 Direction Cosine Matrix that expresses the
	% coordinates of the Follower triad in the Base frame.
	%
	% See also: Tensor, DirCosMat1, DirCosMat2, DirCosMat3

	properties

		seqID string

	end

	properties (Dependent, Hidden)

		quat quaternion
		dirCosMat {Orien.mustBeDirCosMat}
		angles (3,1) double

	end

	methods

	%% Constructor
	function orien = Orien(param1, param2, ref)
		arguments (Input)
			param1 {mustBeA(param1, ["double", "Vector"])} = [0; 0; 0]
			param2 {mustBeA(param2, ["string", "double"])} = "321"
			ref Frame {mustBeScalarOrEmpty} = World.getWorld()
		end
		if isa(param1, "double") && isa(param2, "string")
			% Euler angles representation
			angles = param1;
			seqID = param2;
			coords = Orien.getDirCosMat(angles, seqID)';
		elseif isa(param1, "Vector") && isa(param2, "double")
			% Axis-angle representation
			axis = param1.resolveIn(ref) / param1.magnitude;
			angle = param2;
			% Rodrigues' rotation formula for rotation matrix
			% R = I + sin(θ)K + (1-cos(θ))K²
			% where K is the skew-symmetric matrix of the axis
			K = axis.getSkew();
			R = eye(3) + sin(angle) * K + (1 - cos(angle)) * (K * K);
			coords = R;
			seqID = "321";
		end
		orien = orien@Tensor(coords, ref);
		orien.seqID = seqID;
	end


	%% Property Management
	function quat = get.quat(orien)
		quat = quaternion(orien.coords', "rotmat", "frame");
	end


	function dirCosMat = get.dirCosMat(orien)
		dirCosMat = orien.coords';
	end


	function angles = get.angles(orien)
		angles = orien.quat.euler( ...
			orien.seqID ...
				.replace("3","Z").replace("2","Y").replace("1","X"), ...
			"frame")';
	end


	function orien = set.angles(orien, angles)
		arguments (Input)
			orien (1,1) Orien
			angles (3,1) double
		end
		orien.coords = Orien.getDirCosMat(angles, orien.seqID)';
	end

	end

	methods (Static, Access = public)		

		% Parametrizations
		dirCosMat = getDirCosMat(angleSeq, seqID)

	end

	methods (Access = public)

		% Parametrizations
		orien = convertSeqID(orien, newSeqID)
		
		% Visualization
		disp(orien)
	end

end
