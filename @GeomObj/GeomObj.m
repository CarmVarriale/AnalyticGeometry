classdef GeomObj < matlab.mixin.Copyable
	% GeomObj: an abstract geometric object in 3D space
	%
	% A geometric object must be defined with respect to some reference frame,
	% its coordinates must be able to be expressed in different reference
	% frames, and the object itself should be able to be resolved in different
	% reference frames. While expressing an object's coordinates in its parent
	% or child reference frame is left to the specific object, iterating this
	% operation through the tree of reference frame is abstracted here using
	% recursion.
	%
	% See also: Frame, TreeNode

	properties (Abstract)
		ref Frame {mustBeScalarOrEmpty} 
	end

	methods (Abstract, Access = public)

		% Resolution
		newCoords = viewInParent(obj)
		newCoords = viewInChild(obj, frame)

	end

	methods (Access = public)

		% Resolution
		newCoords = viewInAncestor(obj, frame)
		newCoords = viewInDescendant(obj, frame)
		newCoords = viewInWorld(obj)
		newCoords = viewIn(obj, frame)
		obj = resolveInParent(obj)
		obj = resolveInChild(obj, frame)
		obj = resolveInAncestor(obj, frame)
		obj = resolveInDescendant(obj, frame)
		obj = resolveInWorld(obj)
		obj = resolveIn(obj, frame)

	end

end