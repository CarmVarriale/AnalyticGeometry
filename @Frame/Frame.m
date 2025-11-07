classdef Frame < GeomObj & TreeNode
	% Frame: A reference frame in 3D space
	%
	% This class represents a reference frame in 3D space, which can be 
	% organized in a tree structure. Every frame has a parent frame, and can 
	% have 0, 1 or multiple children frame.
	% The parent frame is another frame with respect to which everything in
	% the current frame is defined. The root of the tree is the special World 
	% frame, which is the only frame that cannot have a parent. In this
	% framework, everything is relative to something else, apart from World.
	% 
	% A unique identifier helps ensure that no two frames in the same tree are 
	% the same. The location  array represents the coordinates of the origin 
	% with respect to the parent frame. The orientation sequence describes the 
	% orientation of the frame with respect to the parent frame. These are left
	% as static properties so that they always refer to only one frame. 
	% The displacement vector and orientation tensor (and the resulting triad) 
	% are automatically calculated (and expressed in the parent frame) as 
	% dependent properties. Their values are therefore always consistent with 
	% the aforementioned static properties, and is automatically updated when 
	% the properties change.
	%
	% See also: World, GeomObj, TreeNode, Vector, Orien


	properties	

		uID (1,1) string
		locat (3,1) double
		angles (3,1) double
		seqID string {mustBeMember(seqID, "321")}
		ref Frame {mustBeScalarOrEmpty}
	
	end

	properties (Dependent)
	
		origin (1,1) Point
		orien (1,1) Orien
		triad (3,1) Vector
	
	end
	end

	methods

		%% Constructor
		function frame = Frame(uID, locat, angles, seqID, ref)
			arguments (Input)
				uID (1,1) string = "Default Frame"
				locat (3,1) double = [0; 0; 0]
				angles (3,1) double = [0; 0; 0]
				seqID string {mustBeMember(seqID, "321")} = "321"
				ref = World.getWorld()
			end
			arguments (Output)
				frame Frame {mustBeScalarOrEmpty}
			end
			mustBeNonzeroLengthText(uID)
			frame.uID = uID;				
			frame.locat = locat;
			frame.angles = angles;
			frame.seqID = seqID;
			frame.ref = ref;
		end


		%% Property Management
		function set.uID(frame, uID)
			if frame.uID ~= ""
				error( ...
					"Frame:set:uID", ...
					"Frame uID cannot be changed after creation");
			end
			if ~TreeNode.isPropValueUnique("uID", uID, frame.getTree())
				error( ...
					"Frame:Frame", ...
					"uID is not unique in the Frame tree");
			end
			frame.uID = uID;
		end


		function set.ref(frame, ref)
			arguments
				frame (1,1) Frame
				ref Frame {mustBeScalarOrEmpty}
			end
			if isempty(ref)
				if ~isa(frame, "World")
					error( ...
						"Frame:set:ref", ...
						"Cannot assign empty ref Frame to Frame")
				end
			elseif isa(frame, "World")
				error( ...
					"Frame:set:ref", ...
					"World cannot have a non-empty ref Frame")
			else
				frame.parent = ref;
				frame.ref = ref;
			end
		end


		function origin = get.origin(frame)
			arguments
				frame Frame {mustBeScalarOrEmpty}
			end
			origin = Point(frame.locat, frame.ref);
		end


		function orien = get.orien(frame)
			arguments
				frame Frame {mustBeScalarOrEmpty}
			end
			orien = Orien(frame.angles, frame.seqID, frame.ref);
		end


		function triad = get.triad(frame)
			arguments
				frame Frame {mustBeScalarOrEmpty}
			end
			triad = Vector.empty(3,0);
			for i = 1:3
				triad(i) = Vector(frame.orien.coords(:,i), frame.ref);
			end
		end

	end

	methods (Access = public)

		% Resolution
		newCoords = viewInParent(frame)
		newCoords = viewInChild(frame, ref)
		frame = resolveInParent(frame)
		frame = resolveInChild(frame, refFrame)

		% Transformations
		frame = translate(frame, displ)
		frame = rotate(frame, orien, p0)
		frame = project(frame, dest)
	end

	methods (Sealed)
		
		% Visualization
		disp(frame)

		% Equality
		flag = eq(A, B)
		flag = ne(A, B)

	end

end