classdef Tensor < GeomElem
	% Tensor: a generic 2D tensor in 3D space
	%
	% Its coordinates consist in a 3x3 matrix. It can be expressed and
	% resolved in different frames. It can be rotated by some orientation in
	% the same frame. Also to create new Tensors.
	%
	% See also: Orien

	properties
		coords (3,3) double = [0 0 0; 0 0 0; 0 0 0];
		ref = Frame.empty
	end

	methods

		%% Constructor
		function tens = Tensor(coords, ref)
			arguments (Input)
				coords (3,3) double
				ref Frame {mustBeScalarOrEmpty}
			end
			arguments (Output)
				tens (1,1) Tensor
			end
			if nargin > 0
				tens.coords = coords;
				tens.ref = ref;
			end
		end


		%% Property Management
		function set.ref(tens, ref)
			arguments (Input)
				tens (1,1) Tensor
				ref Frame {mustBeScalarOrEmpty}
			end
			tens.ref = ref;
		end

	end

	%% Methods
	methods (Access = public)

		% Resolution
		tens = resolveInParent(tens)
		tens = resolveInChild(tens, frame)

		% Transformations
		coords = calcRotate(tens, orien)
		tens = rotate(tens, orien)
		newTens = rotateNew(tens, orien)

		% Visualization
		disp(tens)
		
	end

end