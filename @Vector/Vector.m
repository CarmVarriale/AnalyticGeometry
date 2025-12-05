classdef Vector < GeomElem
	% Vector: a vector in 3D space, intended as a 1D tensor
	%
	% It can be expressed and resolved in different frames. It can be 
	% rotated by some orientation in the same frame.
    
    properties
    
		coords (3,1) double

	end

	properties (Dependent, Hidden)

		magnitude (1,1) double {mustBeNonnegative}
		unit (1,1) Vector
		skew (3,3) double
	
	end
    
    methods
        
		%% Constructor
        function vec = Vector(coords, ref)
			arguments (Input)
				coords (3,1) double = [0; 0; 0]
				ref Frame {mustBeScalarOrEmpty} = World.getWorld()
			end
			arguments (Output)
				vec (1,1) Vector
			end
			vec.coords = coords;
			vec.ref = ref;
        end
        
		
		%% Property Management        
        function mag = get.magnitude(vec)
            mag = norm(vec.coords);
		end


		function unitVec = get.unit(vec)
			assert(vec.magnitude > eps, ...
				"Vector:GetUnit:ZeroMagnitude", ...
				"Cannot compute unit vector of a zero-magnitude vector.");
			unitVec = Vector(vec.coords / vec.magnitude, vec.ref);
		end


		function skewMat = get.skew(vec)
			skewMat = [  0       -vec.coords(3)  vec.coords(2);
						vec.coords(3)   0       -vec.coords(1);
					   -vec.coords(2)  vec.coords(1)   0      ];
		end

	end

	%% Methods
	methods (Access = public)

		% Resolution
		vec = resolveInParent(vec)
		vec = resolveInChild(vec, frame)

		% Transformation
		vec = project(vec, dest)
		vec = rotate(vec, orien)	      

		% Operation
		newVec = uminus(vec)
		newVec = plus(vec1, vec2)
		newVec = minus(vec1, vec2)
		newVec = mtimes(arg1, arg2)
		newVec = mrdivide(vec1, scalar)
		scalar = dot(vec1, vec2)
		newVec = cross(vec1, vec2)
		tens = outer(vec1, vec2)

        % Visualization
		disp(vec)
        
	end

end