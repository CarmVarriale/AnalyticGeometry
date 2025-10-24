function [newLocat, newAngSeq] = viewInParent(frame)
% Express the location and orientation sequence of the frame in its
% parent frame, without modifying it in place
arguments (Input)
	frame (1,1) Frame
end
arguments (Output)
	newLocat (3,1) double
	newAngSeq Orien.mustBeAngSeq
end
assert( ...
	~isempty(frame.ref.ref), ...
	"Frame:viewInParent:emptyRef", ...
	"Frame's ref frame must have a non-empty parent");
newLocat = frame.origin.viewInParent();
newAngSeq = Orien.getAngleSeq(frame.orien.viewInParent());
end