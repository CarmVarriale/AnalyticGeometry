classdef Vector < GeomObj
	% Vector: a vector in 3D space, intended as a 1D tensor
	%
	% It can be expressed and resolved in different frames. It can be 
	% rotated by some orientation in the same frame. Also to create new 
	% vectors.
    
    properties
        coords (3,1) double = [0; 0; 0]
		ref = Frame.empty
    end
    
    properties (Dependent)
        mag (1,1) double {mustBeNonnegative}
    end
    
    methods
        
		%% Constructor
        function vec = Vector(coords, ref)
			arguments (Input)
				coords (3,1) double
				ref Frame {mustBeScalarOrEmpty}
			end
			arguments (Output)
				vec (1,1) Vector
			end
            if nargin > 0
                vec.coords = coords;
                vec.ref = ref;
            end
        end
        
		
		%% Property Management
        function set.coords(vec, coords)
            arguments (Input)
                vec (1,1) Vector
                coords (3,1) double
            end
            coords(abs(coords) < eps) = 0;
            vec.coords = coords(:);
		end


		function set.ref(vec, ref)
			arguments (Input)
				vec (1,1) Vector
				ref Frame {mustBeScalarOrEmpty}
			end
			vec.ref = ref;
		end
        
        
        function mag = get.mag(vec)
            arguments (Input)
                vec (1,1) Vector
            end
            arguments (Output)
                mag (1,1) double {mustBeNonnegative}
            end
            mag = norm(vec.coords);
		end

	end

	%% Methods
	methods (Access = public)

		% Resolution
		vec = resolveInParent(vec)
		vec = resolveInChild(vec, frame)

		% Transformations
		coords = calcRotate(vec, orien)
		vec = rotate(vec, orien)
		newVec = rotateNew(vec, orien)
		        

        % Visualization
		disp(vec)
        
	end

end