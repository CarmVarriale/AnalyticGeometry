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
		seqID string {mustBeMember(seqID, "321")} = "321"
	end

	properties (Dependent)
		dirCosMat {Orien.mustBeDirCosMat}
		angles (3,1) double
	end

	methods

		%% Constructor
		function orien = Orien(angles, seqID, ref)
			arguments
				angles (3,1) double
				seqID string {mustBeMember(seqID, "321")}
				ref Frame {mustBeScalarOrEmpty}
			end
			if nargin > 0
				coords = Orien.getDirCosMat(angles, seqID)';
			end
			orien = orien@Tensor(coords, ref);
			orien.seqID = seqID;
		end


		%% Property Management
		function dirCosMat = get.dirCosMat(orien)
			arguments (Input)
				orien (1,1) Orien
			end
			arguments (Output)
				dirCosMat {Orien.mustBeDirCosMat}
			end
			dirCosMat = orien.coords';
		end


		function angles = get.angles(orien)
			arguments (Input)
				orien (1,1) Orien
			end
			arguments (Output)
				angles (3,1) double
			end
			angles = Orien.getAngleSeq(orien.dirCosMat, orien.seqID);
		end

	end

	%% Methods
	methods (Static, Access = public)

		% Validation
		flag = isDirCosMat(input)
		mustBeDirCosMat(input)

		% Parametrizations
		dirCosMat = getDirCosMat(angleSeq, seqID)
		angleSeq = getAngleSeq(dirCosMat, seqID)

	end

	methods (Access = public)
		
		% Visualization
		disp(orien)
	end

end
