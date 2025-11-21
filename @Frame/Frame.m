classdef Frame < TreeNode & matlab.mixin.Heterogeneous & matlab.mixin.Copyable
	% Frame: A reference frame in 3D space
	%
	% Represents a reference frame in 3D space. Every frame has an origin
	% (Point) and orientation (Orien) which define its position and rotation
	% with respect to another frame. The root of all frames is the special
	% Frame World, which is the only frame defined with respect to an empty
	% reference frame.
	% In this framework, everything is relative to something else, apart
	% from World.
	%
	% See also: World, Point, Orien, Vector

	properties

		name (1,1) string

	end

	properties (Dependent)

		origin Point {mustBeScalarOrEmpty}
		orien Orien {mustBeScalarOrEmpty}
		ref Frame {mustBeScalarOrEmpty}

	end

	properties (Access = private, Hidden)

		origin_ Point {mustBeScalarOrEmpty}
		orien_ Orien {mustBeScalarOrEmpty}
		ref_ Frame {mustBeScalarOrEmpty}

	end

	properties (Dependent)

		triad (3,1) Vector

	end

	methods

		%% Constructor
		function frame = Frame(name, origin, orien, ref)
			arguments (Input)
				name (1,1) string {mustBeNonzeroLengthText} = "Default Frame"
				origin Point {mustBeScalarOrEmpty} = Point()
				orien Orien  {mustBeScalarOrEmpty} = Orien()
				ref Frame {mustBeScalarOrEmpty} = World.getWorld()
			end
			frame.name = name;
			frame.origin = origin;
			frame.orien = orien;
			frame.ref = ref;
		end


		%% Property Management

		% origin
		function set.origin(frame, origin)
			if isa(frame, "World")
				if isempty(origin.ref)
					frame.origin_ = origin;
				else
					error("Frame:set:origin", ...
						"Cannot assign origin with non-empty ref to World")
				end
			else
				if ~isempty(origin.ref)
					if isempty(frame.ref_)
						frame.origin_ = origin;
						frame.ref_ = origin.ref;
					else
						frame.origin_ = origin.resolveIn(frame.ref_);
					end
				else
					error("Frame:set:origin", ...
						"Cannot assign origin with empty ref to frame")
				end
			end
		end


		function value = get.origin(frame)
			value = frame.origin_;
		end


		% orien
		function set.orien(frame, orien)
			if isa(frame, "World")
				if isempty(orien.ref)
					frame.orien_ = orien;
				else
					error("Frame:set:orien", ...
						"Cannot assign orien with non-empty ref to World")
				end
			else
				if ~isempty(orien.ref)
					if isempty(frame.ref_)
						frame.orien_ = orien;
						frame.ref_ = orien.ref;
					else
						frame.orien_ = orien.resolveIn(frame.ref_);
					end
				else
					error("Frame:set:orien", ...
						"Cannot assign orien with empty ref to frame")
				end
			end
		end


		function value = get.orien(frame)
			value = frame.orien_;
		end


		% ref
		function set.ref(frame, ref)
			if isa(frame, "World") && ~isempty(ref)
				error("Frame:set:ref", ...
					"World cannot have a non-empty ref Frame");
			elseif ~isa(frame, "World") && isempty(ref)
				error("Frame:set:ref", ...
					"Cannot assign empty ref Frame to Frame");
			else
				frame.parent = ref;
				frame.ref_ = ref;
				frame.origin_.ref = ref;
				frame.orien_.ref = ref;
			end
		end


		function value = get.ref(frame)
			value = frame.ref_;
		end


		% triad
		function triad = get.triad(frame)
			for i = 3:-1:1
				triad(i) = Vector(frame.orien_.coords(:,i), frame.orien_.ref);
			end
		end

	end

	methods (Access = public)

		% Resolution
		frame = resolveIn(frame, ref)

		% Transformations
		frame = translate(frame, displ)
		newFrame = translateNew(frame, displ)
		frame = rotate(frame, orien, p0)
		newFrame = rotateNew(frame, orien, p0)
		frame = project(frame, dest)
		newFrame = projectNew(frame, dest)

	end

	methods (Access = protected)

		newFrame = copyElement(frame)
		
	end

	methods (Sealed)

		% Visualization
		disp(frame)
		flag = eq(A, B)

	end

end