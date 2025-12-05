classdef Line < GeomObj
	% A line in 3D space
	%
	% A line defined by a point and a direction vector (unit vector).
	% Can be constructed from two points or from one point and a vector.

	properties
		
		anchor (1,1) Point     
		direc (1,1) Vector

	end

	properties (Dependent, Hidden)

		projector (1,1) Tensor

	end

	methods 
	
		%% Constructor
		function line = Line(point, geomElem)
			% Construct a line given two points or a point and a vector
			arguments (Input)
				point (1,1) Point = Point()
				geomElem {mustBeA(geomElem, ["Point", "Vector"])} ...
					= Vector([1;0;0], World.getWorld())
			end
		if isa(geomElem, "Point")
			direc = geomElem - point;
			assert(direc.magnitude >= eps, ...
				"Line:InvalidPoints", ...
				"The two points are too close to define a line.");
			line.anchor = point;
			line.direc = Vector(direc.coords/direc.magnitude, point.ref);
		elseif isa(geomElem, "Vector")
			direc = geomElem.resolveIn(point.ref);
			assert(direc.magnitude >= eps, ...
				"Line:InvalidVector", ...
				"The direction vector has zero magnitude.");
			line.anchor = point;
			line.direc = Vector(direc.coords/direc.magnitude, point.ref);
		end


		%% Property Management
		function projector = get.projector(line)
			projector = Projection(line.direc, "para");
		end

	end

	%% Methods
	methods (Access = public)

		% Resolution
		line = resolveIn(line, frame)

		% Visualization
		disp(line)

	end

end
