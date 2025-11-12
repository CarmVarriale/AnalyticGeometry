function newFrame = resolveIn(frame, ref)
	% Resolve frame in a different reference frame
	% Returns a NEW frame with origin and orientation resolved independently
	% (Value class - automatic copy-on-write behavior)
	%
	% Since origin and orien can have different reference frames,
	% they are resolved independently to the target frame.
	
	arguments
		frame (1,1) Frame
		ref {mustBeA(ref, ["Frame", "World"])}
	end
	
	% Resolve origin and orientation independently in the target frame
	% Each GeomElem handles its own resolution chain
	newOrigin = frame.origin.resolveIn(ref);
	newOrien = frame.orien.resolveIn(ref);
	
	% Create new frame with resolved components
	newFrame = Frame(frame.uID, newOrigin, newOrien);
end