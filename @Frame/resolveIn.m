function frame = resolveIn(frame, ref)
% Resolve frame in a different reference frame
%
% Modifies the frame object in place by resolving its origin and orientation
% independently
arguments
	frame (1,1) Frame
	ref {mustBeA(ref, ["Frame", "World"])}
end
frame.origin = frame.origin.resolveIn(ref);
frame.orien = frame.orien.resolveIn(ref);
frame.ref = ref;
end