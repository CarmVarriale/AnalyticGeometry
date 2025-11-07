classdef Point < GeomElem
	% Point: a point in 3D space
	%
	% It can be expressed and resolved in different frames. It can be 
	% translated or rotated around another point in the same frame. It can be
	% projected on the coordinate planes and axes of its frame. Also to create
	% new points.

	properties
		coords (3,1) double = [0; 0; 0]
		ref = Frame.empty
	end

	properties (Hidden, Dependent)
		radius (1,1) Vector
	end

	methods 
		%% Constructor
		function point = Point(coords, ref)
			arguments (Input)
				coords (3,1) double
				ref Frame {mustBeScalarOrEmpty}
			end
			arguments (Output)
				point (1,1) Point
			end
			if nargin > 0
				point.coords = coords;
				point.ref = ref;
			end
		end


		%% Property Management
		function set.coords(point, coords)
			arguments (Input)
				point (1,1) Point
				coords (3,1) double
			end
			coords(abs(coords) < eps) = 0;
			point.coords = coords;
		end


		function set.ref(point, ref)
			arguments (Input)
				point (1,1) Point
				ref Frame {mustBeScalarOrEmpty}
			end
			point.ref = ref;
		end


		function coords = get.coords(point)
			arguments (Input)
				point (1,1) Point
			end
			coords = point.coords;
		end


		function radius = get.radius(point)
			arguments (Input)
				point (1,1) Point
			end
			arguments (Output)
				radius (1,1) Vector
			end
			radius = Vector(point.coords, point.ref);
		end

	end

	%% Methods
	methods (Access = public)

		% Resolution
		point = resolveInParent(point)
		point = resolveInChild(point, frame)

		% Transformations
		coords = calcTranslate(point, displ)
		coords = calcRotate(point, orien, p0)
		coords = calcProject(point, dest)

		point = translate(point, displ)
		point = rotate(point, orien, p0)
		point = project(point, dest)

		newPoint = translateNew(point, displ)
		newPoint = rotateNew(point, orien, p0)
		newPoint = projectNew(point, dest)

		% Visualization
		disp(point)

	end

end