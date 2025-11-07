classdef GeomElem < GeomObj
	% Fundamental geometric element in a hierarchical reference frame structure.
	% It is used to represent fundamental geometric entities which can be 
	% assembled to create more complex geometric objects.
	%
	% See also: GeomObj, Point, Vector, Tensor

	properties

		ref Frame {mustBeScalarOrEmpty}

	end

	methods (Abstract, Access = public)

		% Resolution
		newCoords = resolveInParent(obj)
		newCoords = resolveInChild(obj, frame)

	end

	methods (Sealed, Access = public)

		% Resolution
		obj = resolveInAncestor(obj, frame)
		obj = resolveInDescendant(obj, frame)
		obj = resolveInWorld(obj)
		obj = resolveIn(obj, frame)

	end
	
end