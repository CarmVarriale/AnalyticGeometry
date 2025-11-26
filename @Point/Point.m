classdef Point < GeomElem
	% Point: a point in 3D space
	%
	% It can be expressed and resolved in different frames. It can be 
	% translated or rotated around another point in the same frame. It can be
	% projected on the coordinate planes and axes of its frame.

	properties
		
		coords (3,1) double

	end

	properties (Dependent, Hidden)
		
		radius (1,1) Vector
		
	end

	methods 

		%% Constructor
		function point = Point(coords, ref)
			arguments (Input)
				coords (3,1) double = [0; 0; 0]
				ref Frame {mustBeScalarOrEmpty} = World.getWorld()
			end
			arguments (Output)
				point (1,1) Point
			end
			point.coords = coords;
			point.ref = ref;
		end


		%% Property Management
		function radius = get.radius(point)
			radius = Vector(point.coords, point.ref);
		end

	end

	%% Methods
	methods (Access = public)

		% Resolution
		point = resolveInParent(point)
		point = resolveInChild(point, frame)

		% Transformation
		point = translate(point, displ)
		point = rotate(point, orien, p0)
		point = project(point, dest)

		% Operation
		newPoint = uminus(point)
		newPoint = plus(point1, vec)
		vec = minus(point1, point2)

		% Visualization
		disp(point)
		graphicObj = plot(curve, opts, style)

	end

end