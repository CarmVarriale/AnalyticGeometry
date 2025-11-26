function newFrame = rotateNew(frame, name, about, param)
% Create a new rotated frame without modifying the original
% Returns a new child frame with rotated origin and orientation
% 
% Supports two rotation modes:
%   - Rotation about a Point with an Orien: rotateNew(frame, name, point, orien)
%   - Rotation about a Line by an angle: rotateNew(frame, name, line, angle)
arguments (Input)
	frame (1,1) Frame
	name (1,1) string
	about {mustBeA(about, ["Point", "Line"])}
	param {mustBeA(param, ["Orien", "double"])}
end
arguments (Output)
	newFrame (1,1) Frame
end
assert(name ~= frame.name, ...
	"Frame:rotateNew:InvalidName", ...
	"The name of the new frame must be different from the original.");
newFrame = frame.copy().rotate(about, param);
newFrame.name = name;
newFrame.ref = frame;
end