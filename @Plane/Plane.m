classdef Plane < GeomObj
    % A plane in 3D space defined by a point and a normal vector.

    properties

        anchor (1,1) Point
        normal (1,1) Vector

    end

    properties (Dependent, Hidden)

        projector (1,1) Tensor

    end

    methods

        %% Constructor
        function pln = Plane(varargin)
            % Signature 1: Plane(point, normal)
            % Signature 2: Plane(points)
            arguments (Input, Repeating)
                varargin
            end
            if nargin == 0
                % Default constructor: XY plane at origin
                anchor = Point(0, 0, 0);
                nrm = Vector(0, 0, 1);
            elseif nargin == 1
                % Signature 2: points
                points = varargin{1};
                mustBeA(points, "Point");
                assert(numel(points) == 3, ...
                    "Plane:Plane:InvalidNumberOfPoints", ...
                    "Exactly three points are required to define a plane.");
                nrm = cross(points(1) - points(2), points(1) - points(3));
                anchor = points(1);
            elseif nargin == 2
                % Signature 1: point, normal
                anchor = varargin{1};
                nrm = varargin{2};
                mustBeA(anchor, "Point");
                mustBeA(nrm, "Vector");
            else
                error( ...
                    "Plane:Plane:InvalidNumberOfArguments", ...
                    "Invalid number of arguments");
            end
            pln.anchor = anchor;
            pln.normal = nrm.unit;
        end


        %% Property Management
		function normal = get.normal(pln)
			normal = pln.normal.unit;
		end


        function projector = get.projector(pln)
            projector = Projection(pln.normal, "perp");
        end

    end

    methods (Access = public)

		% Resolution
		plane = resolveIn(plane, frame)

		% Visualization
		disp(plane)

	end

end