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
		function orien = Orien(angles, seqID, ref)
			arguments (Input)
				angles (3,1) double = [0; 0; 0]
				seqID string = "321"
				ref Frame {mustBeScalarOrEmpty} = World.getWorld()
			end
			coords = Orien.getDirCosMat(angles, seqID)';
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
