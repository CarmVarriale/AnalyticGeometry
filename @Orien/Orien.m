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
	function orien = Orien(varargin)
		% Signature 1: Orien(coords, ref)
		% Signature 2: Orien(angles, seqID, ref)
		% Signature 3: Orien(axis, angle)
		arguments (Input, Repeating)
			varargin
		end
		seqID = "321";
		if nargin == 0
			% Default constructor: zero orientation
			coords = eye(3);
			ref = World.getWorld();
		elseif nargin == 1
			% Single argument must be coords (3x3 matrix)
			coords = varargin{1};
			mustBeA(coords, "double");
			assert(isequal(size(coords), [3, 3]), ...
				"Single argument must be a 3x3 matrix");
			ref = World.getWorld();
		elseif nargin == 2
			if isa(varargin{1}, "double") && isequal(size(varargin{1}), [3, 3])
				% Signature 1: coords, ref
				coords = varargin{1};
				ref = varargin{2};
				mustBeA(ref, "Frame");
			elseif isa(varargin{1}, "Vector") && isa(varargin{2}, "double")
				% Signature 3: axis, angle
				axis = varargin{1};
				angle = varargin{2};
				axis = axis / axis.magnitude;
				K = axis.skew;
				R = eye(3) + sin(angle) * K + (1 - cos(angle)) * (K * K);
				coords = R;
				ref = axis.ref;
			else
				error( ...
					"Orien:Orien:InvalidTwoArgumentSignature", ...
					"Invalid two-argument signature");
			end
		elseif nargin == 3
			if isa(varargin{1}, "double") && isa(varargin{2}, "string")
				% Signature 2: angles, seqID, ref
				angles = varargin{1};
				seqID = varargin{2};
				ref = varargin{3};
				mustBeA(ref, "Frame");
				coords = Orien.getDirCosMat(angles, seqID)';
			else
				error( ...
					"Orien:Orien:InvalidTwoArgumentSignature", ...
					"Invalid three-argument signature");
			end
		else
			error( ...
				"Orien:Orien:InvalidTwoArgumentSignature", ...
				"Too many input arguments");
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
		% Avoid recursion: compute quaternion directly from coords
		q = quaternion(orien.coords', "rotmat", "frame");
		seqStr = strrep(strrep(strrep(orien.seqID, "3", "Z"), "2", "Y"), "1", "X");
		angles = q.euler(seqStr, "frame")';
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
