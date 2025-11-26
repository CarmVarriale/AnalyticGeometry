classdef Tensor < GeomElem
	% Tensor: a generic 2D tensor in 3D space
	%
	% Its coordinates consist in a 3x3 matrix. It can be expressed and
	% resolved in different frames. It can be rotated by some orientation in
	% the same frame.
	%
	% See also: Orien

	properties

		coords (3,3) double

	end

	methods

		%% Constructor
		function tens = Tensor(coords, ref)
			arguments (Input)
				coords (3,3) double = zeros(3)
				ref Frame {mustBeScalarOrEmpty} = World.getWorld()
			end
			arguments (Output)
				tens (1,1) Tensor
			end
			tens.coords = coords;
			tens.ref = ref;
		end

	end

	%% Methods
	methods (Access = public)

		% Resolution
		tens = resolveInParent(tens)
		tens = resolveInChild(tens, frame)

		% Transformations
		tens = rotate(tens, orien)

		% Operation
		newTens = transpose(tens)
		newTens = mtimes(tens, vec)

		% Visualization
		disp(tens)
		
	end

end