classdef GeomObj
	% Derived gemetric object in 3D space
	%
	% A non-fundamental geometric object which can be expressed and resolved in
	% different frames. It relies on fundamental GeomElem objects.
	% 
	% It requires to define its own specific resolveIn method, which relies on 
	% the resolution methods of its constituent GeomElem objects.
	%
	% See also: GeomElem, Curve

	properties
	
	end

	methods (Abstract, Access = public)

		% Resolution
		newObj = resolveIn(obj)

	end

end