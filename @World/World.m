classdef (Sealed) World < Frame
	% World: the global reference frame
	%
	% This class provides a singleton instance of a global reference frame,
	% which can be accessed via the static method getWorld(). The World frame
	% is defined with an arbitrary origin and axes, and serves as the root
	% of all other frames in the system.

	methods (Access = private)

		%% Constructor
		function world = World(~)
			world = world@Frame( ...
				"World", ...
				Point([0; 0; 0], Frame.empty), ...
				Orien([0; 0; 0], "321", Frame.empty), ...
				Frame.empty ...
				);
		end

	end

	methods (Access = public, Static)

		uniqueWorld = getWorld(~)

	end

end