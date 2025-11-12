classdef Curve < GeomObj
	% A curve in 3D space
	%
	% An ordered collection of Points which can be expressed and resolved in 
	% different Frames.

	properties
		
		points (:,1) Point

	end

	properties (Dependent, Hidden)

		coords (:,1) cell
		refs (:,1)

	end

	methods 
	
		%% Constructor
		function curve = Curve(points, ref)
			arguments (Input)
				points (:,1) Point = Point()
				ref (1,1) Frame = points(1).ref
			end
			arguments (Output)
				curve (1,1) Curve
			end
			curve.points = arrayfun(@(p) p.resolveIn(ref), points);
		end


		%% Property Management
		function coords = get.coords(curve)
			arguments (Output)
				coords (:,1) cell
			end
			coords = {curve.points.coords}';
		end


		function refs = get.refs(curve)
			refs = [curve.points.ref]';
		end

	end

	%% Methods
	methods (Access = public)

		% Resolution
		% coords = resolveInParent(curve)
		coords = resolveIn(curve)
		% coords = resolveInChild(curve, frame)

		% Transformations
		curve = translate(curve, displ)
		curve = rotate(curve, orien, p0)
		curve = project(curve, dest)

		% Visualization
		disp(curve)
		graphicObj = plot(curve, opts, style)

	end

end